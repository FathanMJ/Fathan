import 'laravel_api_service.dart';
import '../config/api_config.dart';
import '../models/address.dart';

class AddressService {
  /// Get all addresses for current user
  static Future<List<Address>> getAddresses() async {
    try {
      final response = await LaravelApiService.get('/addresses');
      final List<dynamic> data = response['data'] ?? [];
      return data.map((json) => Address.fromApiJson(json)).toList();
    } catch (e) {
      print('Error fetching addresses: $e');
      rethrow;
    }
  }

  /// Create new address
  static Future<Address> createAddress({
    required String alamatLengkap,
    String? kota,
    String? provinsi,
    String? kodePos,
    String? telepon,
    bool isPrimary = false,
  }) async {
    try {
      final response = await LaravelApiService.post(
        '/addresses',
        body: {
          'alamat_lengkap': alamatLengkap,
          'kota': kota,
          'provinsi': provinsi,
          'kode_pos': kodePos,
          'telepon': telepon,
          'is_primary': isPrimary,
        },
      );
      return Address.fromApiJson(response['data']);
    } catch (e) {
      print('Error creating address: $e');
      rethrow;
    }
  }

  /// Update address
  static Future<Address> updateAddress({
    required int id,
    required String alamatLengkap,
    String? kota,
    String? provinsi,
    String? kodePos,
    String? telepon,
  }) async {
    try {
      final response = await LaravelApiService.put(
        '/addresses/$id',
        body: {
          'alamat_lengkap': alamatLengkap,
          'kota': kota,
          'provinsi': provinsi,
          'kode_pos': kodePos,
          'telepon': telepon,
        },
      );
      return Address.fromApiJson(response['data']);
    } catch (e) {
      print('Error updating address: $e');
      rethrow;
    }
  }

  /// Delete address
  static Future<void> deleteAddress(int id) async {
    try {
      await LaravelApiService.delete('/addresses/$id');
    } catch (e) {
      print('Error deleting address: $e');
      rethrow;
    }
  }
}

