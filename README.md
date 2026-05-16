```html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Form Input Barang</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: Arial, sans-serif; }
        body { background: #f4f4f4; display: flex; justify-content: center; align-items: center; min-height: 100vh; padding: 20px; }
        
        .form-container { background: white; padding: 25px; width: 100%; max-width: 450px; border-radius: 10px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
        h2 { text-align: center; margin-bottom: 20px; color: #333; }

        /* Seluruh isi form langsung diatur menjadi grid dua kolom dengan jarak baris 15px */
        form { display: grid; grid-template-columns: 120px 1fr; gap: 15px; align-items: center; }
        label { font-weight: bold; color: #444; }

        input, select, .btn-simpan { width: 100%; padding: 8px 12px; border: 1px solid #ccc; border-radius: 5px; font-size: 14px; outline: none; }
        input:focus, select:focus { border-color: #4CAF50; }

        /* Tombol dipaksa melebar penuh memotong jalur dua kolom grid */
        .btn-simpan { grid-column: span 2; background: #4CAF50; color: white; border: none; margin-top: 5px; font-size: 16px; font-weight: bold; cursor: pointer; }
        .btn-simpan:hover { background: #45a049; }
    </style>
</head>
<body>

<div class="form-container">
    <h2>Form Input Barang</h2>
    <form>
        <label for="kode">Kode Barang</label>
        <input type="text" id="kode" placeholder="Contoh: BRG001" required>

        <label for="nama">Nama Barang</label>
        <input type="text" id="nama" placeholder="Nama barang lengkap" required>

        <label for="kategori">Kategori</label>
        <select id="kategori" required>
            <option value="">-- Pilih Kategori --</option>
            <option value="makanan">Makanan</option>
            <option value="minuman">Minuman</option>
            <option value="elektronik">Elektronik</option>
            <option value="alat-tulis">Alat Tulis</option>
        </select>

        <label for="harga">Harga (Rp)</label>
        <input type="number" id="harga" placeholder="0" min="0" required>

        <label for="stok">Stok Barang</label>
        <input type="number" id="stok" placeholder="Jumlah stok" min="0" required>

        <button type="submit" class="btn-simpan">Simpan Barang</button>
    </form>
</div>

</body>
</html>


```
