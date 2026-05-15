```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            padding: 20px;
        }

        .form-container {
            background: white;
            padding: 20px;
            max-width: 500px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .form-group {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }

        .form-group label {
            flex: 0 0 120px;
            font-weight: bold;
        }

        .form-group input, 
        .form-group select {
            flex: 1; //ambil sisa ruang 
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        .btn-simpan {
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
        }

        .btn-simpan:hover {
            background-color: #45a049;
        }
        </style>
</head>
<body>
    <div class="form-container">
    <h2>Form Input Barang</h2>
    <form>
        <div class="form-group">
            <label>Kode Barang</label>
            <input type="text" placeholder="Contoh: BRG001">
        </div>
        <div class="form-group">
            <label>Nama Barang</label>
            <input type="text" placeholder="Nama barang lengkap">
        </div>
        <div class="form-group">
            <label>Kategori</label>
            <select>
                <option>-- Pilih Kategori --</option>
            </select>
        </div>
        <div class="form-group">
            <label>Harga (Rp)</label>
            <input type="number" value="0">
        </div>
        <div class="form-group">
            <label>Stok Barang</label>
            <input type="text" placeholder="Jumlah stok">
        </div>
        <button type="submit" class="btn-simpan">Simpan Barang</button>
    </form>
</div>
</body>
</html>

```
