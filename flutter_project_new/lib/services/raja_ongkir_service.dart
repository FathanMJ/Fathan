import '../models/raja_ongkir/province.dart';
import '../models/raja_ongkir/city.dart';
import '../models/raja_ongkir/shipping_cost.dart';
import '../config/api_config.dart';
import 'laravel_api_service.dart';

/// Service untuk mengakses data Raja Ongkir melalui API Laravel
/// Laravel akan memanggil Raja Ongkir API dan mengembalikan data ke Flutter
class RajaOngkirService {
  // Get all provinces via Laravel API
  // GET /api/ongkir/provinsi
  static Future<List<Province>> getProvinces(String searchTerm) async {
    try {
      final response = await LaravelApiService.get(
        '${ApiConfig.ongkirProvinsi}?search=$searchTerm',
        requiresAuth: false, // Provinsi dan kota biasanya tidak perlu auth
      );

      // Response dari Laravel biasanya dalam format:
      // { "success": true, "data": [...] }
      if (response['success'] == true) {
        final results = response['data'] as List<dynamic>;
        return results.map((json) => Province.fromJson(json)).toList();
      } else {
        throw Exception(response['message'] ?? 'Failed to load provinces');
      }
    } catch (e) {
      print('Error fetching provinces with search: $e');
      rethrow;
    }
  }

  // Get cities by search query via Laravel API
  // GET /api/ongkir/kota?search=bandung
  static Future<List<City>> getCities(String searchTerm) async {
    try {
      final response = await LaravelApiService.get(
        '${ApiConfig.ongkirKota}?search=$searchTerm',
        requiresAuth: false,
      );

      if (response['success'] == true) {
        final results = response['data'] as List<dynamic>;
        return results.map((json) => City.fromJson(json)).toList();
      } else {
        throw Exception(response['message'] ?? 'Failed to load cities');
      }
    } catch (e) {
      print('Error fetching cities with search: $e');
      rethrow;
    }
  }

  // Get all cities via Laravel API
  // GET /api/ongkir/kota
  static Future<List<City>> getAllCities() async {
    try {
      final response = await LaravelApiService.get(
        ApiConfig.ongkirKota,
        requiresAuth: false,
      );

      if (response['success'] == true) {
        final results = response['data'] as List<dynamic>;
        return results.map((json) => City.fromJson(json)).toList();
      } else {
        throw Exception(response['message'] ?? 'Failed to load cities');
      }
    } catch (e) {
      print('Error fetching cities: $e');
      rethrow;
    }
  }

  // Get subdistricts (kecamatan) by city via Laravel API
  // GET /api/ongkir/kecamatan?kota_id=439
  static Future<List<Map<String, dynamic>>> getSubdistrictsByCity(
    String cityId,
  ) async {
    try {
      final response = await LaravelApiService.get(
        '${ApiConfig.ongkirKecamatan}?kota_id=$cityId',
        requiresAuth: false,
      );

      if (response['success'] == true) {
        final results = response['data'] as List<dynamic>;
        return results.map((json) => json as Map<String, dynamic>).toList();
      } else {
        throw Exception(response['message'] ?? 'Failed to load subdistricts');
      }
    } catch (e) {
      print('Error fetching subdistricts: $e');
      rethrow;
    }
  }

  // Calculate shipping cost via Laravel API
  // POST /api/ongkir/hitung
  // Body: { "origin": "128", "destination": "501", "weight": 1200, "courier": "jne" }
  static Future<List<ShippingCost>> calculateShippingCost({
    required String origin,
    required String destination,
    required int weight, // in grams
    required String courier, // jne, pos, tiki, etc.
    String? subdistrict, // optional: kecamatan tujuan
  }) async {
    try {
      final body = {
        'origin': origin,
        'destination': destination,
        'weight': weight,
        'courier': courier,
      };

      // Tambahkan subdistrict jika ada
      if (subdistrict != null && subdistrict.isNotEmpty) {
        body['subdistrict'] = subdistrict;
      }

      final response = await LaravelApiService.post(
        ApiConfig.ongkirHitung,
        body: body,
        requiresAuth: false, // Hitung ongkir biasanya tidak perlu auth
      );

      // Response dari Laravel biasanya dalam format:
      // { "success": true, "data": [...] }
      // atau langsung array dari RajaOngkir yang sudah di-format
      if (response['success'] == true) {
        final results = response['data'] as List<dynamic>;
        return results.map((json) => ShippingCost.fromJson(json)).toList();
      } else {
        throw Exception(
          response['message'] ?? 'Failed to calculate shipping cost',
        );
      }
    } catch (e) {
      print('Error calculating shipping cost: $e');
      rethrow;
    }
  }

  // Get available couriers
  // Bisa diambil dari Laravel API atau hardcoded sesuai paket
  // Untuk fleksibilitas, kita bisa ambil dari API Laravel atau hardcode
  static List<Map<String, String>> getAvailableCouriers() {
    // Default couriers yang umum digunakan
    // Jika Laravel menyediakan endpoint untuk ini, bisa dipanggil dari API
    return [
      {'code': 'jne', 'name': 'JNE'},
      {'code': 'pos', 'name': 'POS Indonesia'},
      {'code': 'tiki', 'name': 'TIKI'},
      {'code': 'sicepat', 'name': 'SiCepat Express'},
      {'code': 'jnt', 'name': 'J&T Express'},
      {'code': 'anteraja', 'name': 'AnterAja'},
      {'code': 'ninja', 'name': 'Ninja Express'},
      {'code': 'lion', 'name': 'Lion Parcel'},
      {'code': 'ide', 'name': 'IDE Express'},
      {'code': 'sentral', 'name': 'Sentral Cargo'},
    ];
  }
}
