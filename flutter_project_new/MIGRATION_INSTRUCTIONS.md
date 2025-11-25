# Instruksi Migration Laravel untuk Tabel Ongkir

## 📋 File Migration

File migration sudah dibuat di:
```
database_migrations/2025_11_19_000001_create_ongkir_table.php
```

## 🚀 Cara Menggunakan

### 1. Copy File Migration ke Laravel Project

```bash
# Copy file migration ke folder database/migrations di Laravel
cp database_migrations/2025_11_19_000001_create_ongkir_table.php /path/to/laravel/database/migrations/
```

Atau manual:
- Copy file `2025_11_19_000001_create_ongkir_table.php`
- Paste ke folder `database/migrations/` di project Laravel Anda

### 2. Jalankan Migration

```bash
# Masuk ke folder Laravel project
cd /path/to/laravel

# Jalankan migration
php artisan migrate

# Atau jika ingin melihat SQL yang akan dijalankan
php artisan migrate --pretend
```

### 3. Rollback (Jika Perlu)

```bash
# Rollback migration terakhir
php artisan migrate:rollback

# Rollback semua migration
php artisan migrate:reset
```

## 📝 Struktur Tabel yang Akan Dibuat

```sql
CREATE TABLE `ongkir` (
  `id_ongkir` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `kurir` varchar(50) NOT NULL,
  `layanan` varchar(50) NOT NULL,
  `harga` decimal(12,2) NOT NULL,
  `estimasi` varchar(50) DEFAULT NULL,
  `dibuat_pada` timestamp NOT NULL DEFAULT current_timestamp(),
  `diperbarui_pada` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_ongkir`),
  KEY `idx_ongkir_kurir` (`kurir`),
  KEY `idx_ongkir_layanan` (`layanan`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

## ⚠️ Catatan Penting

1. **Jika tabel sudah ada**: Migration akan gagal jika tabel `ongkir` sudah ada di database
   - Solusi: Hapus tabel dulu atau gunakan `Schema::dropIfExists()` sebelum create

2. **Nama Kolom**: 
   - Menggunakan `dibuat_pada` dan `diperbarui_pada` (bukan `created_at` dan `updated_at`)
   - Sesuai dengan struktur database yang ada

3. **Primary Key**: 
   - Menggunakan `id_ongkir` sebagai primary key
   - Auto increment

## 🔧 Alternatif: Jika Tabel Sudah Ada

Jika tabel `ongkir` sudah ada di database, Anda bisa:

### Opsi 1: Skip Migration
```bash
# Tambahkan ke file migration
if (!Schema::hasTable('ongkir')) {
    // ... create table ...
}
```

### Opsi 2: Buat Migration Baru untuk Update
```php
// Buat migration baru untuk update struktur jika perlu
php artisan make:migration update_ongkir_table --table=ongkir
```

## ✅ Checklist

- [ ] Copy file migration ke folder `database/migrations/`
- [ ] Pastikan tidak ada konflik dengan migration lain
- [ ] Jalankan `php artisan migrate`
- [ ] Verifikasi tabel sudah dibuat dengan benar
- [ ] Test insert data ongkir

## 🧪 Test Migration

Setelah migration berhasil, test dengan:

```php
// Di tinker atau controller
use App\Models\Ongkir;

$ongkir = Ongkir::create([
    'kurir' => 'JNE',
    'layanan' => 'REG',
    'harga' => 30000.00,
    'estimasi' => '2-3 hari',
]);

echo $ongkir->id_ongkir; // Harus ada ID
```

