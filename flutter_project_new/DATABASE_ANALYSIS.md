# Analisis Database untuk Integrasi Raja Ongkir

## 📊 Struktur Database Saat Ini

### 1. Tabel `pesanan` (Line 462-473)
```sql
CREATE TABLE `pesanan` (
  `id_pesanan` int(11) NOT NULL,
  `pelanggan_id` int(11) NOT NULL,
  `ongkir_id` int(11) DEFAULT NULL,  -- Foreign key ke tabel ongkir
  `diskon_id` int(11) DEFAULT NULL,
  `metode_pembayaran` enum('midtrans','cod') NOT NULL,
  `status_pembayaran` enum('pending','lunas','gagal') DEFAULT 'pending',
  `total` decimal(12,2) NOT NULL,
  `alamat_pengiriman` text NOT NULL,
  ...
)
```

**Status**: ✅ Ada `ongkir_id` untuk referensi ke tabel `ongkir`

**Kekurangan**: 
- ❌ Tidak ada kolom langsung untuk `kurir_pengiriman`
- ❌ Tidak ada kolom langsung untuk `layanan_pengiriman`
- ❌ Tidak ada kolom langsung untuk `harga_ongkir`
- ❌ Tidak ada kolom langsung untuk `estimasi_pengiriman`

### 2. Tabel `ongkir` (Line 241-249)
```sql
CREATE TABLE `ongkir` (
  `id_ongkir` int(11) NOT NULL,
  `kurir` varchar(50) NOT NULL,
  `layanan` varchar(50) NOT NULL,
  `harga` decimal(12,2) NOT NULL,
  `estimasi` varchar(50) DEFAULT NULL,
  ...
)
```

**Status**: ✅ Struktur sudah sesuai untuk menyimpan data ongkir

### 3. Tabel `pengiriman` (Line 391-402)
```sql
CREATE TABLE `pengiriman` (
  `id_pengiriman` int(11) NOT NULL,
  `pesanan_id` int(11) NOT NULL,
  `kurir` varchar(50) NOT NULL,
  `layanan` varchar(50) DEFAULT NULL,
  `resi` varchar(100) DEFAULT NULL,
  `status` enum('diproses','dikirim','sampai','batal') DEFAULT 'diproses',
  ...
)
```

**Status**: ✅ Untuk tracking pengiriman setelah pesanan dibuat

## 🔄 Alur Data yang Disarankan

### Opsi 1: Menggunakan Tabel `ongkir` (Recommended)
**Alur:**
1. Flutter kirim data ongkir saat checkout
2. Laravel simpan ke tabel `ongkir` → dapat `id_ongkir`
3. Laravel simpan `id_ongkir` ke tabel `pesanan`
4. Admin bisa lihat detail ongkir via join dengan tabel `ongkir`

**Keuntungan:**
- ✅ Data ter-normalisasi
- ✅ Bisa reuse data ongkir yang sama
- ✅ Struktur database sudah ada

**Kekurangan:**
- ⚠️ Perlu 2 query (insert ongkir, lalu insert pesanan)

### Opsi 2: Menambahkan Kolom Langsung di `pesanan`
**Alur:**
1. Flutter kirim data ongkir saat checkout
2. Laravel langsung simpan ke kolom di tabel `pesanan`
3. Tidak perlu insert ke tabel `ongkir` terlebih dahulu

**Keuntungan:**
- ✅ Lebih cepat (1 query saja)
- ✅ Data langsung tersedia di tabel `pesanan`

**Kekurangan:**
- ⚠️ Data tidak ter-normalisasi
- ⚠️ Perlu migration untuk tambah kolom

## 📝 Rekomendasi Migration SQL

### Opsi A: Tambah Kolom di Tabel `pesanan` (Quick Fix)
```sql
ALTER TABLE `pesanan`
ADD COLUMN `kurir_pengiriman` varchar(50) DEFAULT NULL AFTER `ongkir_id`,
ADD COLUMN `layanan_pengiriman` varchar(50) DEFAULT NULL AFTER `kurir_pengiriman`,
ADD COLUMN `harga_ongkir` decimal(12,2) DEFAULT 0.00 AFTER `layanan_pengiriman`,
ADD COLUMN `estimasi_pengiriman` varchar(50) DEFAULT NULL AFTER `harga_ongkir`;
```

### Opsi B: Tetap Pakai Tabel `ongkir` (Normalized)
Tidak perlu migration, tapi perlu update logic di Laravel:
1. Saat checkout, insert ke `ongkir` dulu
2. Ambil `id_ongkir`
3. Insert ke `pesanan` dengan `ongkir_id`

## 🎯 Rekomendasi Final

**Gunakan Opsi 1 (Tabel `ongkir`)** karena:
1. Struktur database sudah ada dan sesuai
2. Data lebih ter-normalisasi
3. Bisa tracking ongkir yang sering digunakan
4. Admin bisa analisis ongkir per kurir/layanan

**Update yang Diperlukan di Laravel:**
1. Saat create order, insert ke `ongkir` dulu
2. Ambil `id_ongkir` yang baru dibuat
3. Insert ke `pesanan` dengan `ongkir_id`

## 📋 Mapping Data Flutter → Database

### Data dari Flutter (OrderService.createOrder):
```dart
kurir: "JNE"
layanan: "REG"
hargaOngkir: 30000
estimasi: "2-3 hari"
```

### Insert ke Tabel `ongkir`:
```sql
INSERT INTO `ongkir` (`kurir`, `layanan`, `harga`, `estimasi`)
VALUES ('JNE', 'REG', 30000.00, '2-3 hari');
-- Dapat id_ongkir = X
```

### Insert ke Tabel `pesanan`:
```sql
INSERT INTO `pesanan` (..., `ongkir_id`, ...)
VALUES (..., X, ...);
```

## ✅ Checklist Implementasi Laravel

- [ ] Buat endpoint `/api/ongkir/provinsi`
- [ ] Buat endpoint `/api/ongkir/kota?provinsi_id=X`
- [ ] Buat endpoint `/api/ongkir/kecamatan?kota_id=X`
- [ ] Buat endpoint `/api/ongkir/hitung` (POST)
- [ ] Update logic create order:
  - [ ] Insert ke tabel `ongkir` dulu
  - [ ] Ambil `id_ongkir`
  - [ ] Insert ke `pesanan` dengan `ongkir_id`
- [ ] Update response order untuk include data ongkir (via join)

## 🔍 Query untuk Admin (View Order dengan Ongkir)

```sql
SELECT 
    p.id_pesanan,
    p.total,
    p.alamat_pengiriman,
    o.kurir,
    o.layanan,
    o.harga AS harga_ongkir,
    o.estimasi
FROM pesanan p
LEFT JOIN ongkir o ON p.ongkir_id = o.id_ongkir
WHERE p.id_pesanan = ?;
```

