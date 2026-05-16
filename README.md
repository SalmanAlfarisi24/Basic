```html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Form Barang</title>
    <style>
        * {
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }
        body {
            background: #f4f4f4;
            display: flex;
            justify-content: center;
            padding: 40px 20px;
        }
        .form-container {
            background: white;
            padding: 25px;
            width: 100%;
            max-width: 450px;
            border-radius: 10px;
        }
        h2 {
            text-align: center;
            margin-bottom: 20px;
        }
        form {
            display: grid;
            grid-template-columns: 120px 1fr;
            gap: 15px;
            align-items: center;
        }
        label {
            font-weight: bold;
        }
        input, select {
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 5px;
            outline: none;
        }
        .btn-simpan {
            grid-column: span 2;
            padding: 10px;
            background: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
        }
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
