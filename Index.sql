Berdasarkan dokumen soal ujian yang Anda lampirkan, berikut adalah kode SQL lengkap untuk membangun database kendali_banjir, memasukkan data, serta jawaban untuk 10 pertanyaan UAS tersebut.
1. Pembuatan Database dan Tabel
Berikut adalah struktur tabel sesuai dengan instruksi pada gambar:
-- Buat Database
CREATE DATABASE kendali_banjir;
USE kendali_banjir;

-- Tabel 1: Data_Waduk
CREATE TABLE Data_Waduk (
    id_waduk INT PRIMARY KEY AUTO_INCREMENT,
    nama_waduk VARCHAR(100),
    lokasi VARCHAR(100)
);

-- Tabel 2: Data_Tinggi_Air
CREATE TABLE Data_Tinggi_Air (
    id_data INT PRIMARY KEY AUTO_INCREMENT,
    id_waduk INT,
    tinggi_air DECIMAL(5,2),
    tanggal DATE,
    waktu TIME,
    FOREIGN KEY (id_waduk) REFERENCES Data_Waduk(id_waduk)
);

-- Tabel 3: Peringatan
CREATE TABLE Peringatan (
    id_peringatan INT PRIMARY KEY AUTO_INCREMENT,
    id_waduk INT,
    pesan VARCHAR(255),
    tanggal DATE,
    waktu TIME,
    FOREIGN KEY (id_waduk) REFERENCES Data_Waduk(id_waduk)
);

2. Penyisipan Data (Insert Data)
Data ini disesuaikan dengan contoh yang ada pada lembar soal:
-- Insert Data_Waduk
INSERT INTO Data_Waduk (nama_waduk, lokasi) VALUES
('Waduk Utama', 'Kota A'),
('Waduk Kedua', 'Kota B'),
('Waduk Ketiga', 'Kota C'),
('Waduk Empat', 'Kota D'),
('Waduk Lima', 'Kota E');

-- Insert Data_Tinggi_Air
INSERT INTO Data_Tinggi_Air (id_waduk, tinggi_air, tanggal, waktu) VALUES
(1, 4.50, '2023-12-20', '10:00:00'),
(1, 5.10, '2023-12-20', '11:00:00'),
(2, 3.75, '2023-12-20', '10:15:00'),
(3, 6.20, '2023-12-20', '09:00:00'),
(2, 4.80, '2023-12-20', '12:00:00');

-- Insert Peringatan
INSERT INTO Peringatan (id_waduk, pesan, tanggal, waktu) VALUES
(1, 'Peringatan: Tinggi air mencapai batas aman.', '2023-12-20', '11:01:00'),
(3, 'Peringatan: Tinggi air sangat tinggi, segera ambil tindakan!', '2023-12-20', '09:05:00'),
(1, 'Peringatan: Tinggi air melebihi batas aman.', '2023-12-21', '14:00:00'),
(2, 'Peringatan: Siapkan pompa untuk mengurangi tinggi air.', '2023-12-21', '15:30:00'),
(3, 'Peringatan: Waspadai kemungkinan banjir jika curah hujan meningkat.', '2023-12-21', '16:00:00');

3. Jawaban 10 Pertanyaan UAS
Berikut adalah logika query untuk menjawab soal nomor 1 sampai 10 pada gambar:
Bagian DML (4 Soal)
 * Insert Waduk Baru
   INSERT INTO Data_Waduk (nama_waduk, lokasi) VALUES ('Waduk Enam', 'Kota F');

 * Update Tinggi Air
   UPDATE Data_Tinggi_Air SET tinggi_air = 4.90 WHERE id_waduk = 2;

 * Delete Data Tinggi Air
   DELETE FROM Data_Tinggi_Air WHERE id_data = 1;

 * Batch Insert Peringatan
   INSERT INTO Peringatan (id_waduk, pesan, tanggal, waktu) VALUES 
(2, 'Peringatan: Tinggi Air Meningkat', '2023-12-22', '10:00:00'),
(2, 'Peringatan: Siapkan langkah antisipasi.', '2023-12-22', '11:00:00');

Bagian Join dan Nested Query (3 Soal)
 * Join Tinggi Air dan Waduk
   SELECT w.nama_waduk, t.tinggi_air 
FROM Data_Waduk w
JOIN Data_Tinggi_Air t ON w.id_waduk = t.id_waduk;

 * Join Peringatan dan Waduk
   SELECT p.pesan, w.nama_waduk 
FROM Peringatan p
JOIN Data_Waduk w ON p.id_waduk = w.id_waduk;

 * Waduk dengan Tinggi Air Tertinggi (Nested Query)
   SELECT nama_waduk FROM Data_Waduk 
WHERE id_waduk = (SELECT id_waduk FROM Data_Tinggi_Air ORDER BY tinggi_air DESC LIMIT 1);

Bagian Agregasi, GROUP BY, dan ORDER BY (3 Soal)
 * Rata-rata Tinggi Air per Waduk
   SELECT id_waduk, AVG(tinggi_air) as rata_rata 
FROM Data_Tinggi_Air 
GROUP BY id_waduk;

 * Jumlah Peringatan per Waduk
   SELECT id_waduk, COUNT(id_peringatan) as jumlah_peringatan 
FROM Peringatan 
GROUP BY id_waduk;

 * Tinggi Air Tertinggi per Tanggal
   SELECT tanggal, MAX(tinggi_air) as tinggi_maksimal 
FROM Data_Tinggi_Air 
GROUP BY tanggal;

Semoga sukses UAS-nya besok jam 2 siang! Apakah ada bagian dari kode ini yang ingin Anda tanyakan lebih lanjut?
