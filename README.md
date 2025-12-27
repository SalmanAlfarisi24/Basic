1. CREATE DATABASE DAN TABEL

```sql
-- Buat database
CREATE DATABASE sistem_banjir;
USE sistem_banjir;

-- Tabel Data_waduk
CREATE TABLE Data_waduk (
    id_waduk INT PRIMARY KEY AUTO_INCREMENT,
    nama_waduk VARCHAR(50) NOT NULL,
    lokasi VARCHAR(100),
    kapasitas_max DECIMAL(10,2),
    ketinggian_max DECIMAL(5,2)
);

-- Tabel Data_tinggi_air
CREATE TABLE Data_tinggi_air (
    id_ukur INT PRIMARY KEY AUTO_INCREMENT,
    id_waduk INT,
    tanggal_waktu DATETIME,
    ketinggian_air DECIMAL(5,2),
    debit_air DECIMAL(8,2),
    FOREIGN KEY (id_waduk) REFERENCES Data_waduk(id_waduk)
);

-- Tabel Peringatan
CREATE TABLE Peringatan (
    id_peringatan INT PRIMARY KEY AUTO_INCREMENT,
    id_waduk INT,
    level_peringatan ENUM('Normal', 'Waspada', 'Siaga', 'Awas'),
    pesan TEXT,
    tanggal_issued DATETIME,
    FOREIGN KEY (id_waduk) REFERENCES Data_waduk(id_waduk)
);
```

2. INSERT DATA

```sql
-- Data Waduk
INSERT INTO Data_waduk (nama_waduk, lokasi, kapasitas_max, ketinggian_max) VALUES
('Waduk Jatiluhur', 'Purwakarta, Jawa Barat', 3000.00, 107.00),
('Waduk Saguling', 'Bandung Barat, Jawa Barat', 982.00, 643.00),
('Waduk Cirata', 'Purwakarta-Cianjur, Jawa Barat', 2160.00, 221.00),
('Waduk Gajah Mungkur', 'Wonogiri, Jawa Tengah', 763.00, 136.50);

-- Data Tinggi Air
INSERT INTO Data_tinggi_air (id_waduk, tanggal_waktu, ketinggian_air, debit_air) VALUES
(1, '2024-01-15 08:00:00', 105.50, 150.75),
(1, '2024-01-15 14:00:00', 106.80, 180.25),
(2, '2024-01-15 09:30:00', 640.20, 95.50),
(2, '2024-01-15 15:00:00', 642.80, 120.75),
(3, '2024-01-15 10:00:00', 218.50, 200.30),
(1, '2024-01-16 08:00:00', 107.50, 210.45),
(4, '2024-01-15 11:00:00', 134.00, 85.60);

-- Data Peringatan
INSERT INTO Peringatan (id_waduk, level_peringatan, pesan, tanggal_issued) VALUES
(1, 'Siaga', 'Ketinggian air mendekati batas maksimum, waspadai luapan', '2024-01-16 09:15:00'),
(2, 'Waspada', 'Debit air meningkat, pantau terus', '2024-01-15 16:30:00'),
(3, 'Normal', 'Kondisi stabil', '2024-01-15 12:00:00'),
(1, 'Awas', 'Batas maksimum terlampaui, lakukan pelebaran pintu air', '2024-01-16 10:00:00');
```

3. 10 CONTOH SOAL BESERTA JAWABAN

```sql
-- SOAL 1: DML (UPDATE)
-- Ubah kapasitas maksimum Waduk Gajah Mungkur menjadi 800 juta m³
UPDATE Data_waduk 
SET kapasitas_max = 800.00 
WHERE nama_waduk = 'Waduk Gajah Mungkur';

-- SOAL 2: DML (DELETE)
-- Hapus data pengukuran yang memiliki debit air di bawah 100 m³/detik
DELETE FROM Data_tinggi_air 
WHERE debit_air < 100;

-- SOAL 3: JOIN (INNER JOIN)
-- Tampilkan nama waduk, lokasi, dan level peringatan terakhir
SELECT d.nama_waduk, d.lokasi, p.level_peringatan, p.tanggal_issued
FROM Data_waduk d
INNER JOIN Peringatan p ON d.id_waduk = p.id_waduk
ORDER BY p.tanggal_issued DESC;

-- SOAL 4: JOIN (LEFT JOIN)
-- Tampilkan semua waduk beserta data pengukurannya (jika ada)
SELECT d.nama_waduk, t.tanggal_waktu, t.ketinggian_air
FROM Data_waduk d
LEFT JOIN Data_tinggi_air t ON d.id_waduk = t.id_waduk;

-- SOAL 5: Nested Query (Subquery)
-- Tampilkan waduk yang pernah mendapatkan peringatan level 'Awas'
SELECT nama_waduk, lokasi
FROM Data_waduk
WHERE id_waduk IN (
    SELECT id_waduk 
    FROM Peringatan 
    WHERE level_peringatan = 'Awas'
);

-- SOAL 6: Fungsi Agregasi (AVG, GROUP BY)
-- Hitung rata-rata ketinggian air per waduk
SELECT d.nama_waduk, AVG(t.ketinggian_air) as rata_ketinggian
FROM Data_waduk d
JOIN Data_tinggi_air t ON d.id_waduk = t.id_waduk
GROUP BY d.id_waduk;

-- SOAL 7: Fungsi Agregasi (MAX, HAVING)
-- Tampilkan waduk dengan ketinggian air maksimum di atas 200 meter
SELECT d.nama_waduk, MAX(t.ketinggian_air) as ketinggian_tertinggi
FROM Data_waduk d
JOIN Data_tinggi_air t ON d.id_waduk = t.id_waduk
GROUP BY d.id_waduk
HAVING ketinggian_tertinggi > 200;

-- SOAL 8: Nested Query dengan Agregasi
-- Tampilkan waduk dengan ketinggian air di atas rata-rata semua waduk
SELECT nama_waduk, ketinggian_air, tanggal_waktu
FROM Data_tinggi_air t
JOIN Data_waduk d ON t.id_waduk = d.id_waduk
WHERE ketinggian_air > (
    SELECT AVG(ketinggian_air) 
    FROM Data_tinggi_air
);

-- SOAL 9: JOIN Multiple Table
-- Tampilkan semua data lengkap: waduk, pengukuran, dan peringatan
SELECT d.nama_waduk, t.tanggal_waktu, t.ketinggian_air, 
       p.level_peringatan, p.pesan
FROM Data_waduk d
LEFT JOIN Data_tinggi_air t ON d.id_waduk = t.id_waduk
LEFT JOIN Peringatan p ON d.id_waduk = p.id_waduk
ORDER BY d.nama_waduk, t.tanggal_waktu DESC;

-- SOAL 10: Fungsi Agregasi Kompleks
-- Tampilkan statistik lengkap per waduk
SELECT d.nama_waduk,
       COUNT(t.id_ukur) as jumlah_pengukuran,
       MIN(t.ketinggian_air) as ketinggian_min,
       MAX(t.ketinggian_air) as ketinggian_max,
       AVG(t.ketinggian_air) as ketinggian_rata,
       COUNT(p.id_peringatan) as jumlah_peringatan
FROM Data_waduk d
LEFT JOIN Data_tinggi_air t ON d.id_waduk = t.id_waduk
LEFT JOIN Peringatan p ON d.id_waduk = p.id_waduk
GROUP BY d.id_waduk
ORDER BY jumlah_peringatan DESC;
```
