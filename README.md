Running Text (teks berjalan) menggunakan Arduino dan LCD 16x2.
1. Persiapan Awal
Sebelum masuk ke kode utama, pastikan kamu sudah menginisialisasi library LiquidCrystal. Berikut adalah contoh setup pin yang umum digunakan:
#include <LiquidCrystal.h>

// Inisialisasi pin: (RS, E, D4, D5, D6, D7)
LiquidCrystal lcd(12, 11, 5, 4, 3, 2);

void setup() {
  lcd.begin(16, 2); // Memulai LCD ukuran 16 kolom, 2 baris
}

2. Kode Running Text: Kiri ke Kanan
Logika ini menggunakan perulangan for yang menambah nilai kolom secara bertahap.
void loop() {
  // Perulangan dari kolom 0 sampai 15
  for (int i = 0; i <= 15; i++) {
    lcd.clear();         // Bersihkan layar dari teks sebelumnya
    lcd.setCursor(i, 0); // Atur posisi kursor (kolom i, baris 0)
    lcd.print("AMCC HS"); // Cetak teks
    delay(200);          // Kecepatan gerakan (semakin kecil, semakin cepat)
  }
}

Penjelasan Logika:
 * for (int i = 0; i <= 15; i++): Variabel i bertindak sebagai koordinat kolom. Nilainya akan naik satu per satu dari 0, 1, 2, hingga 15.
 * lcd.setCursor(i, 0): Baris ini adalah kuncinya. Karena nilai i berubah-ubah, maka titik awal tulisan pun akan bergeser ke kanan pada setiap putaran loop.
 * lcd.clear(): Sangat penting untuk menghapus tulisan di posisi sebelumnya agar tidak terjadi penumpukan karakter (efek bayangan).
3. Kode Running Text: Kanan ke Kiri
Untuk arah sebaliknya, kita hanya perlu membalik logika perulangannya.
void loop() {
  // Perulangan mundur dari kolom 15 ke 0
  for (int i = 15; i >= 0; i--) {
    lcd.clear();
    lcd.setCursor(i, 0);
    lcd.print("AMCC HS");
    delay(200);
  }
}

Penjelasan Logika:
 * i = 15; i >= 0; i--: Kita mulai dari kolom paling ujung kanan (16-1 = 15) dan menguranginya satu per satu hingga mencapai kolom 0. Ini memberikan ilusi teks bergerak mundur atau masuk dari sisi kanan.
4. Tips Tambahan: Menggunakan Fungsi Bawaan
Selain menggunakan logika setCursor() secara manual, library LiquidCrystal sebenarnya memiliki fungsi bawaan untuk menggeser seluruh isi layar:
 * lcd.scrollDisplayLeft(): Menggeser semua teks di LCD satu langkah ke kiri.
 * lcd.scrollDisplayRight(): Menggeser semua teks di LCD satu langkah ke kanan.
> Catatan Penting: Teknik setCursor() yang ada di tutorial tersebut lebih fleksibel jika kamu hanya ingin menggerakkan satu baris saja sementara baris lainnya tetap diam (statis).
>
Kode Arduino: Running Text "Mantul" (Bolak-Balik)
Kita hanya perlu menggabungkan dua logika perulangan for di dalam fungsi void loop().
void loop() 
{
  // 1. Gerakan dari Kiri ke Kanan
  for (int i = 0; i <= 15; i++) 
  {
    lcd.clear();
    lcd.setCursor(i, 0);   // Posisi kolom i, baris atas
    lcd.print("AMCC HS");
    delay(150);            // Kecepatan gerak
  }

  // 2. Gerakan dari Kanan ke Kiri
  for (int i = 15; i >= 0; i--) 
  {
    lcd.clear();
    lcd.setCursor(i, 0);   // Posisi kolom i, baris atas
    lcd.print("AMCC HS");
    delay(150);            // Kecepatan gerak
  }
}
