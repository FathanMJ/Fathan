# 🔄 Setup Hybrid: Firebase Auth + Laravel Backend

## ✅ Yang Sudah Selesai

1. ✅ **Auth Service** - Update untuk sync ke Laravel setelah Firebase login
2. ✅ **Product Service** - Fetch produk dari Laravel API
3. ✅ **Order Service** - Handle pesanan via Laravel
4. ✅ **API Service** - Koneksi ke Laravel backend
5. ✅ **Laravel Backend** - Support Firebase UID

## 🏗️ Arsitektur Hybrid

```
┌─────────────────┐
│  Flutter App    │
└────────┬────────┘
         │
    ┌────┴─────┐
    │ Firebase │
    └────┬────┘
         │
    ┌────┴────────┐
    └────┬────────┘
         │
    ┌────┴────────────┐
    │  Laravel API    │
    └─────────────────┘
```

**Cara Kerja:**
1. User login/register via **Firebase Auth**
2. Data user **auto-sync** ke Laravel backend
3. Produk & pesanan dari **Laravel API**
4. Hybrid: Auth (Firebase) + Data (Laravel)

## 📋 File yang Dibuat

### Flutter (Mobile)
- ✅ `lib/services/auth_service.dart` - Updated dengan sync ke Laravel
- ✅ `lib/services/laravel_api_service.dart` - HTTP client untuk Laravel API
- ✅ `lib/services/product_service.dart` - Service untuk produk
- ✅ `lib/services/order_service.dart` - Service untuk pesanan
- ✅ `lib/config/api_config.dart` - Konfigurasi API endpoints

### Laravel (Backend)
- ✅ `app/Http/Controllers/Api/ApiAuthController.php` - Support Firebase UID

## 🚀 Cara Penggunaan

### 1. Start Laravel Server

```bash
cd slemn24_web
php artisan serve
# Server running di http://localhost:8000
```

### 2. Setup URL API di Flutter

Edit `lib/config/api_config.dart`:

```dart
// Local development
static const String baseUrl = 'http://localhost:8000/api';

// Android Emulator (ganti localhost)
// static const String baseUrl = 'http://10.0.2.2:8000/api';

// Device WiFi (ganti dengan IP komputer Anda)
// static const String baseUrl = 'http://192.168.1.100:8000/api';
```

### 3. Update Migration (Optional)

Jika database belum punya field `firebase_uid`:

```bash
cd slemn24_web

# Create migration
php artisan make:migration add_firebase_uid_to_users_table

# Edit migration file dan tambahkan:
# $table->string('firebase_uid')->nullable()->after('email');

# Run migration
php artisan migrate
```

### 4. Test Koneksi

```bash
cd flutter_project_new
flutter run
```

Coba login/register, lalu check console untuk:
- ✅ "Successfully synced to Laravel"
- ❌ "Laravel sync error" (tidak masalah, hanya warning)

## 📡 API Endpoints Tersedia

### Authentication (Hybrid)
- Register sync otomatis ke Laravel setelah Firebase
- Login sync otomatis ke Laravel setelah Firebase

### Products
```dart
// Get all products
final products = await ProductService.getAllProducts();

// Get product by ID
final product = await ProductService.getProductById(1);

// Search products
final results = await ProductService.searchProducts('t-shirt');
```

### Orders
```dart
// Get user orders
final orders = await OrderService.getUserOrders();

// Create order
final order = await OrderService.createOrder(
  items: [...],
  shippingAddress: 'Jalan ...',
);

// Track order
final tracking = await OrderService.trackOrder('RESI123');
```

## 🔧 Troubleshooting

### Error: "Connection refused"
**Solusi:**
1. Pastikan Laravel server running: `php artisan serve`
2. Check IP address di `api_config.dart`
3. Untuk Android emulator, gunakan `10.0.2.2` bukan `localhost`

### Error: "Firebase Auth Error"
**Solusi:**
1. Pastikan Email/Password enabled di Firebase Console
2. Check google-services.json di Android
3. Run: `flutter clean && flutter pub get`

### Warning: "Failed to sync to Laravel"
**Solusi:**
1. Ini normal jika Laravel offline
2. User tetap bisa pakai app via Firebase
3. Sync terjadi otomatis saat Laravel online

## 🎯 Next Steps

### A. Menggunakan Laravel API untuk Produk

Update home_screen.dart:

```dart
import 'services/product_service.dart';

// Get products from Laravel
final products = await ProductService.getAllProducts();
```

### B. Menggunakan Laravel API untuk Pesanan

Update order screen:

```dart
import 'services/order_service.dart';

// Get user orders
final orders = await OrderService.getUserOrders();
```

### C. Test Hybrid Connection

```bash
# Terminal 1: Start Laravel
cd slemn24_web && php artisan serve

# Terminal 2: Run Flutter
cd flutter_project_new && flutter run

# Test:
# 1. Register/Login di Flutter app
# 2. Check Laravel database untuk user baru
# 3. Check console: "Successfully synced to Laravel"
```

## ✨ Fitur Hybrid

### ✅ Firebase
- Quick & secure auth
- Real-time database
- Push notifications

### ✅ Laravel
- Full-featured API
- Database management
- Admin panel

### ✅ Hybrid
- Best of both worlds!
- Flexible & scalable
- Easy management

## 📞 Need Help?

Jika ada masalah:
1. Check console logs
2. Check Laravel logs: `storage/logs/laravel.log`
3. Verify API URL di config

---

**Status:** ✅ Ready to Use!
**Setup Time:** ~5 minutes
**Difficulty:** Easy










