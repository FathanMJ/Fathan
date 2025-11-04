import 'laravel_api_service.dart';
import '../config/api_config.dart';

class AuthService {
  // Get current user from stored token
  Future<Map<String, dynamic>?> get currentUser async {
    final token = await LaravelApiService.getToken();
    if (token == null) return null;

    try {
      final response = await LaravelApiService.get(ApiConfig.user);
      return response['data'];
    } catch (e) {
      return null;
    }
  }

  // Check if user is authenticated
  Future<bool> get isAuthenticated async {
    final token = await LaravelApiService.getToken();
    return token != null;
  }

  // Sign up with email and password
  Future<Map<String, dynamic>?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    String? phone,
    String? address,
  }) async {
    try {
      final response = await LaravelApiService.post(
        ApiConfig.register,
        body: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': password,
          'telepon': phone ?? '',
          'alamat': address ?? '',
        },
        requiresAuth: false,
      );

      if (response['success'] == true) {
        // Save token
        final token = response['data']['token'];
        await LaravelApiService.saveToken(token);

        return response['data'];
      } else {
        throw Exception(response['message'] ?? 'Registrasi gagal');
      }
    } catch (e) {
      throw 'Gagal terhubung ke server. Periksa koneksi Anda.';
    }
  }

  // Sign in with email and password
  Future<Map<String, dynamic>?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await LaravelApiService.post(
        ApiConfig.login,
        body: {'email': email, 'password': password},
        requiresAuth: false,
      );

      if (response['success'] == true) {
        // Save token
        final token = response['data']['token'];
        await LaravelApiService.saveToken(token);

        return response['data'];
      } else {
        throw Exception(response['message'] ?? 'Login gagal');
      }
    } catch (e) {
      throw 'Gagal terhubung ke server. Periksa koneksi Anda.';
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      // Call logout API to revoke token on server
      await LaravelApiService.post(ApiConfig.logout);
    } catch (e) {
      // Even if API call fails, we should still clear local token
    } finally {
      // Remove token from local storage
      await LaravelApiService.removeToken();
    }
  }

  // Update profile
  Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? address,
  }) async {
    final body = <String, dynamic>{};
    if (name != null) body['nama'] = name;
    if (email != null) body['email'] = email;
    if (phone != null) body['telepon'] = phone;
    if (address != null) body['alamat'] = address;

    final response = await LaravelApiService.put(ApiConfig.user, body: body);
    if (response['success'] == true) {
      return Map<String, dynamic>.from(response['data'] as Map);
    }
    throw Exception(response['message'] ?? 'Gagal memperbarui profil');
  }
}
