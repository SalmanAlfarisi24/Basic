```html
<!DOCTYPE html>
<html lang="id">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Form Input Barang</title>

<style>
body{
    font-family: Arial, sans-serif;
    background:#f4f4f4;
    display:flex;
    justify-content:center;
    align-items:center;
    height:100vh;
}

.container{
    background:white;
    padding:25px;
    border-radius:10px;
    box-shadow:0 0 10px rgba(0,0,0,0.2);
    width:420px;
}

h2{
    text-align:center;
    margin-bottom:20px;
}

.form-group{
    display:grid;
    grid-template-columns:120px 1fr;
    margin-bottom:12px;
    align-items:center;
}

input,select{
    padding:8px;
    border:1px solid #ccc;
    border-radius:5px;
}

button{
    margin-top:10px;
    width:100%;
    padding:10px;
    background:blue;
    color:white;
    border:none;
    border-radius:5px;
    cursor:pointer;
}

button:hover{
    background:darkblue;
}
</style>
</head>

<body>

<div class="container">
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
                <option>Makanan</option>
                <option>Minuman</option>
                <option>Elektronik</option>
                <option>Alat Tulis</option>
            </select>
        </div>

        <div class="form-group">
            <label>Harga (Rp)</label>
            <input type="number" placeholder="0">
        </div>

        <div class="form-group">
            <label>Stok Barang</label>
            <input type="number" placeholder="Jumlah stok">
        </div>

        <button type="submit">
            Simpan Barang
        </button>

    </form>

</div>

</body>
</html>
```
