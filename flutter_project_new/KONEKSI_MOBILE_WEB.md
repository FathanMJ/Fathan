# 📱➡️💻 Status Koneksi Mobile (Flutter) dengan Web (Laravel)

## 📊 Status Saat Ini

### ❌ BELUM TERHUBUNG

**Masalah:**
- Aplikasi Flutter saat ini **HANYA** menggunakan **Firebase** untuk authentication
- Laravel backend **TIDAK** digunakan oleh aplikasi Flutter
- Kedua sistem berjalan **terpisah**

### ✅ Yang Sudah Selesai

1. **Flutter menggunakan Firebase Auth** untuk login/register
2. **Laravel backend** sudah memiliki API endpoints di `slemn24_web/routes/api.php`
3. **Sudah dibuat** file koneksi API:
   - `lib/services/laravel_api_service.dart` - Service untuk koneksi ke Laravel
   - `lib/config/api_config.dart` - Konfigurasi URL API
4. **Sudah diinstall** package yang diperlukan:
   - `http` - untuk HTTP request
   - `shared_preferences` - untuk menyimpan token

## 🔄 Cara Menghubungkan

### Opsi 1: Gunakan Laravel Backend Saja (Recommended)
Ganti Firebase Auth dengan Laravel Sanctum API

### Opsi 2: Hybrid (Firebase + Laravel)
Gunakan Firebase untuk auth, lalu sync data ke Laravel

### Opsi 3: Tetap Pakai Firebase
Fokus ke Firebase saja, Laravel hanya untuk web admin

## 🚀 Next Steps

### 1. Pilih Salah Satu Opsi di Atas
**Rekomendasi:** Opsi 1 (Laravel Backend Saja) karena:
- ✅ Mudah manage user dari web
- ✅ Integrasi langsung dengan database
- ✅ Tanpa dependency Firebase untuk auth

### 2. Setup Laravel Backend
Pastikan server Laravel running:
```bash
cd slemn24_web
php artisan serve
```

### 3. Test Koneksi
Update URL di `lib/config/api_config.dart` sesuai environment Anda:
- **Local:** `http://localhost:8000/api`
- **Android Emulator:** `http://10.0.2.2:8000/api`
- **Device (WiFi):** `http://192.168.x.x:8000/api` (ganti dengan IP komputer Anda)

### 4. Implementasi Auth Service
Contoh menggunakan Laravel API:
```dart
// Login dengan Laravel
final response = await LaravelApiService.post(
  ApiConfig.login,
  body: {
    'email': email,
    'password': password,
  },
  requiresAuth: false,
);

// Save token
await LaravelApiService.saveToken(response['data']['token']);
```

## 📝 API Endpoints yang Tersedia

### Authentication
- `POST /api/register` - Daftar user baru
- `POST /api/login` - Login
- `POST /api/logout` - Logout
- `GET /api/user` - Get user info

### Produk
- `GET /api/produk` - List produk
- `GET /api/produk/{id}` - Detail produk
- `GET /api/produk/search` - Search produk
- `GET /api/produk/kategori/{id}` - Produk by kategori

### Pesanan
- `GET /api/pesanan` - List pesanan user
- `POST /api/pesanan` - Buat pesanan baru
- `GET /api/pesanan/{id}` - Detail pesanan
- `PUT /api/pesanan/{id}/status` - Update status pesanan

### Custom Order
- `GET /api/custom-order` - List custom order
- `POST /api/custom-order` - Buat custom order
- `GET /api/custom-order/{id}` - Detail custom order

### Chat
- `GET /api/chat/rooms` - List chat rooms
- `POST /api/chat/rooms` - Buat room baru
- `GET /api/chat/rooms/{id}/messages` - Get messages
- `POST /api/chat/rooms/{id}/messages` - Send message

## 🔧 File yang Perlu Diupdate

1. **Update `lib/services/auth_service.dart`**
   - Tambahkan method untuk login via Laravel API
   - Simpan token di SharedPreferences

2. **Update UI Login/Register**
   - Ganti dari Firebase Auth ke Laravel API Auth
   - Atau gunakan hybrid approach

3. **Create Product Service** (jika perlu)
   - `lib/services/product_service.dart` untuk handle produk
   - `lib/services/order_service.dart` untuk handle pesanan

## ⚡ Quick Start - Connect Now!

Jika ingin langsung connect sekarang, saya bisa bantu implement:
1. Update auth service untuk integrate dengan Laravel
2. Create service untuk produk & pesanan
3. Update UI untuk fetch data dari Laravel

**Tinggal bilang: "Ya, connect sekarang!"** ✨
















