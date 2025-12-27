KODE LENGKAP UAS SISTEM DATABASE KENDALI BANJIR

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
