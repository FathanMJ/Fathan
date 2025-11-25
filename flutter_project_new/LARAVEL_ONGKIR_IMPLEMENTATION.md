# Implementasi Ongkir di Laravel

## 📋 Struktur Tabel `ongkir`

Tabel sudah dibuat dengan SQL di `create_table_ongkir.sql`

## 🔧 Model Laravel

### 1. Buat Model Ongkir

```php
// app/Models/Ongkir.php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Ongkir extends Model
{
    protected $table = 'ongkir';
    protected $primaryKey = 'id_ongkir';
    public $timestamps = true;

    protected $fillable = [
        'kurir',
        'layanan',
        'harga',
        'estimasi',
    ];

    protected $casts = [
        'harga' => 'decimal:2',
        'dibuat_pada' => 'datetime',
        'diperbarui_pada' => 'datetime',
    ];

    // Relationship dengan pesanan
    public function pesanan()
    {
        return $this->hasMany(Pesanan::class, 'ongkir_id', 'id_ongkir');
    }
}
```

## 🛣️ Controller untuk API Ongkir

### 1. Install Package Raja Ongkir

```bash
composer require kavist/rajaongkir
```

### 2. Konfigurasi .env

```env
RAJAONGKIR_API_KEY=your_api_key_here
RAJAONGKIR_ACCOUNT_TYPE=starter
```

### 3. Buat Controller OngkirController

```php
// app/Http/Controllers/Api/OngkirController.php
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Kavist\RajaOngkir\Facades\RajaOngkir;

class OngkirController extends Controller
{
    /**
     * Get all provinces
     * GET /api/ongkir/provinsi
     */
    public function getProvinces()
    {
        try {
            $provinces = RajaOngkir::provinsi()->all();
            
            return response()->json([
                'success' => true,
                'data' => $provinces
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil data provinsi: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get cities by province
     * GET /api/ongkir/kota?provinsi_id=10
     */
    public function getCities(Request $request)
    {
        try {
            $provinceId = $request->query('provinsi_id');
            
            if (!$provinceId) {
                // Get all cities if no province_id
                $cities = RajaOngkir::kota()->all();
            } else {
                // Get cities by province
                $cities = RajaOngkir::kota()->dariProvinsi($provinceId)->get();
            }
            
            return response()->json([
                'success' => true,
                'data' => $cities
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil data kota: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get subdistricts by city
     * GET /api/ongkir/kecamatan?kota_id=439
     */
    public function getSubdistricts(Request $request)
    {
        try {
            $cityId = $request->query('kota_id');
            
            if (!$cityId) {
                return response()->json([
                    'success' => false,
                    'message' => 'Parameter kota_id diperlukan'
                ], 400);
            }
            
            $subdistricts = RajaOngkir::kecamatan()->dariKota($cityId)->get();
            
            return response()->json([
                'success' => true,
                'data' => $subdistricts
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil data kecamatan: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Calculate shipping cost
     * POST /api/ongkir/hitung
     * Body: {
     *   "origin": "128",
     *   "destination": "501",
     *   "weight": 1200,
     *   "courier": "jne"
     * }
     */
    public function calculateCost(Request $request)
    {
        try {
            $request->validate([
                'origin' => 'required|string',
                'destination' => 'required|string',
                'weight' => 'required|integer|min:1',
                'courier' => 'required|string',
            ]);

            $cost = RajaOngkir::ongkosKirim([
                'origin' => $request->origin,
                'destination' => $request->destination,
                'weight' => $request->weight,
                'courier' => $request->courier,
            ])->get();

            return response()->json([
                'success' => true,
                'data' => $cost
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal menghitung ongkir: ' . $e->getMessage()
            ], 500);
        }
    }
}
```

## 🛣️ Routes API

```php
// routes/api.php

use App\Http\Controllers\Api\OngkirController;

Route::prefix('ongkir')->group(function () {
    Route::get('/provinsi', [OngkirController::class, 'getProvinces']);
    Route::get('/kota', [OngkirController::class, 'getCities']);
    Route::get('/kecamatan', [OngkirController::class, 'getSubdistricts']);
    Route::post('/hitung', [OngkirController::class, 'calculateCost']);
});
```

## 📦 Update PesananController untuk Simpan Ongkir

```php
// app/Http/Controllers/Api/PesananController.php

use App\Models\Ongkir;

public function createOrder(Request $request)
{
    // ... validasi dan logic lainnya ...

    // Simpan ongkir jika ada
    $ongkirId = null;
    if ($request->has('kurir_pengiriman') && $request->has('layanan_pengiriman')) {
        $ongkir = Ongkir::create([
            'kurir' => $request->kurir_pengiriman,
            'layanan' => $request->layanan_pengiriman,
            'harga' => $request->harga_ongkir ?? 0,
            'estimasi' => $request->estimasi_pengiriman,
        ]);
        
        $ongkirId = $ongkir->id_ongkir;
    }

    // Buat pesanan dengan ongkir_id
    $pesanan = Pesanan::create([
        'pelanggan_id' => $user->id_pelanggan,
        'ongkir_id' => $ongkirId,
        'total' => $total,
        'alamat_pengiriman' => $request->alamat_pengiriman,
        'metode_pembayaran' => $request->metode_pembayaran,
        // ... field lainnya ...
    ]);

    // ... logic lainnya ...
}
```

## 🔍 Query untuk Admin (View Order dengan Ongkir)

```php
// Di PesananController atau di Model Pesanan

public function getOrderWithOngkir($id)
{
    $pesanan = Pesanan::with('ongkir')
        ->where('id_pesanan', $id)
        ->first();

    return response()->json([
        'success' => true,
        'data' => $pesanan
    ]);
}
```

## 📝 Relationship di Model Pesanan

```php
// app/Models/Pesanan.php

public function ongkir()
{
    return $this->belongsTo(Ongkir::class, 'ongkir_id', 'id_ongkir');
}
```

## ✅ Checklist Implementasi

- [ ] Install package `kavist/rajaongkir`
- [ ] Konfigurasi API key di `.env`
- [ ] Buat Model `Ongkir`
- [ ] Buat `OngkirController` dengan 4 method
- [ ] Tambahkan routes di `routes/api.php`
- [ ] Update `PesananController` untuk simpan ongkir
- [ ] Test semua endpoint
- [ ] Update Model `Pesanan` dengan relationship

## 🧪 Testing Endpoints

```bash
# Get Provinsi
curl http://localhost:8000/api/ongkir/provinsi

# Get Kota
curl http://localhost:8000/api/ongkir/kota?provinsi_id=9

# Get Kecamatan
curl http://localhost:8000/api/ongkir/kecamatan?kota_id=439

# Hitung Ongkir
curl -X POST http://localhost:8000/api/ongkir/hitung \
  -H "Content-Type: application/json" \
  -d '{
    "origin": "128",
    "destination": "501",
    "weight": 1200,
    "courier": "jne"
  }'
```

