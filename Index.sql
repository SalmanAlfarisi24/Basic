-- ==========================================
-- A. DDL - STRUKTUR DATABASE (Soal 1-5)
-- ==========================================

-- 1. Buat database
CREATE DATABASE iot_monitoring;
USE iot_monitoring;

-- 2. Buat tabel ruangan
CREATE TABLE ruangan (
    id_ruangan INT AUTO_INCREMENT PRIMARY KEY,
    nama_ruangan VARCHAR(50) NOT NULL,
    lokasi VARCHAR(100),
    keterangan VARCHAR(100)
);

-- 3. Buat tabel sensor dengan foreign key ke ruangan
CREATE TABLE sensor (
    id_sensor INT AUTO_INCREMENT PRIMARY KEY,
    kode_sensor VARCHAR(30) NOT NULL UNIQUE,
    tipe_sensor VARCHAR(30),
    id_ruangan INT NOT NULL,
    status ENUM('aktif','nonaktif') DEFAULT 'aktif',
    FOREIGN KEY (id_ruangan) REFERENCES ruangan (id_ruangan)
);

-- 4. Buat tabel data_sensor dengan foreign key ke sensor
CREATE TABLE data_sensor (
    id_data INT AUTO_INCREMENT PRIMARY KEY,
    id_sensor INT NOT NULL,
    suhu DECIMAL(5,2) NOT NULL,
    kelembapan DECIMAL(5,2) NOT NULL,
    waktu TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_sensor) REFERENCES sensor(id_sensor)
);

-- 5. Tampilkan struktur tabel data_sensor
DESCRIBE data_sensor;

-- ==========================================
-- B. DML - MANIPULASI DATA (Soal 6-10)
-- ==========================================

-- 6. Masukkan data ke tabel ruangan
INSERT INTO ruangan (nama_ruangan, lokasi, keterangan) VALUES
('Lab Komputer', 'Gedung A Lantai 1', 'Ruang praktikum'),
('Ruang Server', 'Gedung A Lantai 2', 'Ruang server'),
('Ruang Dosen', 'Gedung B Lantai 1', 'Ruang kerja dosen'),
('Perpustakaan', 'Gedung C Lantai 1', 'Ruang baca'); [cite: 32]

[cite_start]-- 7. Masukkan data ke tabel sensor
INSERT INTO sensor (kode_sensor, tipe_sensor, id_ruangan, status) VALUES
('DHT-001', 'DHT22', 1, 'aktif'),
('DHT-002', 'DHT22', 1, 'aktif'),
('DHT-003', 'DHT22', 2, 'aktif'),
('DHT-004', 'DHT11', 3, 'aktif'),
('DHT-005', 'DHT11', 4, 'nonaktif'); [cite: 33]

[cite_start]-- 8. Masukkan data pembacaan sensor ke tabel data_sensor
INSERT INTO data_sensor (id_sensor, suhu, kelembapan) VALUES
(1, 25.5, 60.2),
(1, 26.1, 58.7),
(2, 25.9, 59.3),
(2, 26.4, 57.8),
(3, 22.3, 45.5),
(3, 23.1, 44.8),
(4, 27.0, 65.0),
(4, 27.6, 63.4),
(5, 26.2, 61.8),
(5, 26.0, 62.1); [cite: 34]

[cite_start]-- 9. Tambahkan 1 data sensor baru
INSERT INTO sensor (kode_sensor, tipe_sensor, id_ruangan, status) VALUES 
('DHT-007', 'DHT22', 3, 'aktif'); [cite: 36]

[cite_start]-- 10. Ubah status sensor tertentu menjadi nonaktif
UPDATE sensor SET status = 'nonaktif' WHERE id_sensor = 4;

-- ==========================================
-- C. DQL DASAR - SELECT & WHERE (Soal 11-15)
-- ==========================================

-- 11. Tampilkan seluruh data pada tabel ruangan
SELECT * FROM ruangan;

-- 12. Tampilkan data sensor yang statusnya aktif
SELECT * FROM sensor WHERE status = 'aktif';

-- 13. Tampilkan data dengan suhu di atas 26°C
SELECT id_data, suhu, kelembapan FROM data_sensor WHERE suhu > 26;

-- 14. Tampilkan data sensor pada tanggal/waktu tertentu
SELECT id_data, suhu, kelembapan FROM data_sensor WHERE waktu = "2025-12-20 10:41:19";

-- 15. Tampilkan 5 data sensor terbaru
SELECT id_data, suhu, kelembapan, waktu FROM data_sensor ORDER BY waktu DESC LIMIT 5;

-- ==========================================
-- D. JOIN ANTAR TABEL (Soal 16-20)
-- ==========================================

-- 16. Tampilkan nama ruangan, kode sensor, dan status sensor
SELECT r.nama_ruangan, s.kode_sensor, s.status 
FROM ruangan r 
JOIN sensor s ON r.id_ruangan = s.id_ruangan;

-- 17. Tampilkan nama ruangan, suhu, kelembapan, dan waktu
SELECT r.nama_ruangan, d.suhu, d.kelembapan, d.waktu
FROM ruangan r
JOIN sensor s ON r.id_ruangan = s.id_ruangan
JOIN data_sensor d ON d.id_sensor = s.id_sensor;

-- 18. Tampilkan data sensor hanya dari Ruang Server
SELECT r.nama_ruangan, d.suhu, d.kelembapan, d.waktu
FROM data_sensor d
JOIN sensor s ON s.id_sensor = d.id_sensor
JOIN ruangan r ON r.id_ruangan = s.id_ruangan
WHERE r.nama_ruangan = "Ruang Server";

-- 19. Tampilkan seluruh data sensor beserta lokasi ruangan
SELECT r.nama_ruangan, r.lokasi, d.suhu, d.kelembapan, d.waktu
FROM data_sensor d
JOIN sensor s ON s.id_sensor = d.id_sensor
JOIN ruangan r ON r.id_ruangan = s.id_ruangan;

-- 20. Tampilkan data pembacaan sensor yang status sensornya aktif
-- Catatan: Query diperbaiki ke status 'aktif' sesuai soal dan kunci jawaban
SELECT r.nama_ruangan, r.lokasi, d.suhu, d.kelembapan, d.waktu, s.status
FROM data_sensor d
JOIN sensor s ON s.id_sensor = d.id_sensor
JOIN ruangan r ON r.id_ruangan = s.id_ruangan
WHERE s.status = "aktif";

-- ==========================================
-- E. FUNGSI AGREGAT & GROUP BY (Soal 21-25)
-- ==========================================

-- 21. Rata-rata suhu untuk setiap ruangan
SELECT r.nama_ruangan, AVG(d.suhu)
FROM data_sensor d
JOIN sensor s ON s.id_sensor = d.id_sensor
JOIN ruangan r ON r.id_ruangan = s.id_ruangan
GROUP BY r.nama_ruangan;

-- 22. Suhu tertinggi dan terendah dari seluruh data
SELECT MAX(suhu) AS suhu_tertinggi, MIN(suhu) AS suhu_terendah FROM data_sensor;

-- 23. Jumlah data sensor yang tercatat di setiap ruangan
SELECT r.nama_ruangan, COUNT(d.id_data)
FROM data_sensor d
JOIN sensor s ON s.id_sensor = d.id_sensor
JOIN ruangan r ON r.id_ruangan = s.id_ruangan
GROUP BY r.nama_ruangan;

-- 24. Rata-rata kelembapan per ruangan
SELECT r.nama_ruangan, AVG(d.kelembapan)
FROM data_sensor d
JOIN sensor s ON s.id_sensor = d.id_sensor
JOIN ruangan r ON r.id_ruangan = s.id_ruangan
GROUP BY r.nama_ruangan;

-- 25. Ruangan dengan rata-rata suhu tertinggi
SELECT r.nama_ruangan, AVG(d.suhu)
FROM data_sensor d
JOIN sensor s ON s.id_sensor = d.id_sensor
JOIN ruangan r ON r.id_ruangan = s.id_ruangan
GROUP BY r.nama_ruangan 
ORDER BY AVG(d.suhu) DESC LIMIT 1;
