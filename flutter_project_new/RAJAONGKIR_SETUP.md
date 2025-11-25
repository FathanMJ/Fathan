# Setup Raja Ongkir - Integrasi via Laravel API

Dokumentasi ini menjelaskan cara kerja sistem Raja Ongkir yang terintegrasi melalui API Laravel.

## 🏗️ Arsitektur Sistem

```
Flutter App → Laravel API → Raja Ongkir API → Response → Laravel → Flutter
```

**Penting**: Flutter **TIDAK** memanggil Raja Ongkir API langsung, melainkan melalui Laravel API sebagai perantara.

## 📋 Alur Kerja

### 1. **Flutter memanggil API Laravel**
   - Flutter mengirim request ke endpoint Laravel
   - Laravel meneruskan request ke Raja Ongkir API
   - Laravel mengembalikan response ke Flutter

### 2. **Saat Checkout**
   - User pilih provinsi, kota, dan kurir di Flutter
   - Flutter kirim request hitung ongkir ke Laravel
   - Laravel hitung ongkir via Raja Ongkir
   - User pilih layanan pengiriman (REG, YES, EZ, dll)
   - Saat checkout, data ongkir disimpan ke database

### 3. **Data yang Disimpan**
   - `kurir_pengiriman`: JNE, J&T, SiCepat, dll
   - `layanan_pengiriman`: REG, YES, EZ, dll
   - `harga_ongkir`: Harga yang dipilih user
   - `estimasi_pengiriman`: Estimasi hari (2-3 hari, dll)
   - `id_ongkir`: ID dari tabel ongkir (opsional)

## 🔌 Endpoint API Laravel yang Digunakan

### 1. Get Provinsi
```
GET /api/ongkir/provinsi
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "province_id": "1",
      "province": "Bali"
    },
    ...
  ]
}
```

### 2. Get Kota berdasarkan Provinsi
```
GET /api/ongkir/kota?provinsi_id=10
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "city_id": "439",
      "city_name": "Bandung",
      "province_id": "9",
      "province": "Jawa Barat",
      "type": "Kota",
      "postal_code": "40111"
    },
    ...
  ]
}
```

### 3. Get Kecamatan (Opsional)
```
GET /api/ongkir/kecamatan?kota_id=439
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "subdistrict_id": "1234",
      "subdistrict_name": "Coblong",
      "city_id": "439",
      "city_name": "Bandung"
    },
    ...
  ]
}
```

### 4. Hitung Ongkir
```
POST /api/ongkir/hitung
```

**Request Body:**
```json
{
  "origin": "128",
  "destination": "501",
  "weight": 1200,
  "courier": "jne"
}
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "code": "jne",
      "name": "Jalur Nugraha Ekakurir (JNE)",
      "costs": [
        {
          "service": "REG",
          "description": "Layanan Reguler",
          "cost": [
            {
              "value": 30000,
              "etd": "2-3",
              "note": "Hari"
            }
          ]
        },
        {
          "service": "YES",
          "description": "Yakin Esok Sampai",
          "cost": [
            {
              "value": 45000,
              "etd": "1",
              "note": "Hari"
            }
          ]
        }
      ]
    }
  ]
}
```

## 🛠️ Setup di Laravel (Backend)

### 1. Install Package
```bash
composer require kavist/rajaongkir
```

### 2. Konfigurasi .env
```env
RAJAONGKIR_API_KEY=xxxxxxxxxxxx
RAJAONGKIR_ACCOUNT_TYPE=pro
```

### 3. Buat Controller & Routes
Buat controller untuk handle request dari Flutter:
- `OngkirController@getProvinces`
- `OngkirController@getCities`
- `OngkirController@getSubdistricts`
- `OngkirController@calculateCost`

## 📱 Setup di Flutter (Mobile)

### 1. Konfigurasi API Base URL
File: `lib/config/api_config.dart`
```dart
static const String baseUrl = 'http://10.0.2.2:8000/api'; // Android Emulator
// atau
static const String baseUrl = 'http://192.168.x.x:8000/api'; // Device fisik
```

### 2. Endpoint Sudah Terkonfigurasi
File: `lib/config/api_config.dart`
```dart
static const String ongkirProvinsi = '/ongkir/provinsi';
static const String ongkirKota = '/ongkir/kota';
static const String ongkirKecamatan = '/ongkir/kecamatan';
static const String ongkirHitung = '/ongkir/hitung';
```

### 3. Service Sudah Siap
File: `lib/services/raja_ongkir_service.dart`
- Semua method sudah memanggil API Laravel
- Tidak perlu konfigurasi API key di Flutter
- API key hanya di Laravel

## 🗄️ Struktur Database

### Tabel: `pesanan`
```sql
- id_pesanan
- id_pelanggan
- id_ongkir (opsional)
- total
- alamat_pengiriman
- kurir_pengiriman (JNE, J&T, dll)
- layanan_pengiriman (REG, YES, dll)
- harga_ongkir
- estimasi_pengiriman (2-3 hari, dll)
```

### Tabel: `ongkir` (Opsional)
```sql
- id_ongkir
- kurir
- layanan
- harga
- estimasi
```

## 🎯 Fitur di Flutter

### Checkout Screen
1. **Pilih Kota Asal**: Default Jakarta Pusat (alamat gudang)
2. **Pilih Provinsi Tujuan**: Dropdown semua provinsi
3. **Pilih Kota Tujuan**: Dropdown kota berdasarkan provinsi
4. **Pilih Kurir**: JNE, J&T, SiCepat, dll
5. **Hitung Ongkir**: Tombol untuk menghitung biaya
6. **Pilih Layanan**: Pilih layanan pengiriman (REG, YES, EZ, dll)
7. **Total Otomatis**: Total harga termasuk ongkir

## 📌 Catatan Penting

### ✅ Keuntungan Arsitektur Ini
1. **Keamanan**: API key Raja Ongkir tidak ter-expose di Flutter
2. **Kontrol**: Laravel bisa validasi, cache, atau modifikasi data
3. **Fleksibilitas**: Bisa tambahkan logika bisnis di Laravel
4. **Konsistensi**: Semua API call melalui Laravel

### ⚠️ Yang Perlu Diperhatikan
1. **API Key**: Hanya di Laravel, tidak perlu di Flutter
2. **Rate Limiting**: Perhatikan batas penggunaan API di Laravel
3. **Error Handling**: Pastikan Laravel handle error dengan baik
4. **Response Format**: Pastikan Laravel return format yang konsisten

## 🔍 Troubleshooting

### Error: "Failed to load provinces"
- Pastikan endpoint `/api/ongkir/provinsi` sudah dibuat di Laravel
- Cek koneksi ke Laravel API
- Cek response format dari Laravel

### Error: "Failed to calculate shipping cost"
- Pastikan endpoint `/api/ongkir/hitung` sudah dibuat di Laravel
- Pastikan API key Raja Ongkir sudah dikonfigurasi di Laravel
- Cek parameter yang dikirim (origin, destination, weight, courier)

### Tidak ada kurir yang muncul
- Kurir di-hardcode di Flutter untuk fleksibilitas
- Bisa juga dibuat endpoint di Laravel untuk get available couriers

## 📚 Referensi

- [Package kavist/rajaongkir](https://github.com/kavist/rajaongkir)
- [Dokumentasi Raja Ongkir](https://rajaongkir.com/dokumentasi)
- [Panel Akun Raja Ongkir](https://rajaongkir.com/akun/panel)

## 🎉 Kesimpulan

Sistem ini menggunakan arsitektur **Flutter → Laravel → Raja Ongkir**, yang lebih aman dan fleksibel dibandingkan Flutter langsung ke Raja Ongkir. Semua konfigurasi API key dan logika bisnis ada di Laravel, sementara Flutter hanya fokus pada UI/UX.
