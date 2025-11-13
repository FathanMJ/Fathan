import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class LaravelApiService {
  // Use base URL from config
  static String get baseUrl => ApiConfig.baseUrl;

  // Get authentication token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Save authentication token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Remove authentication token (logout)
  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // Helper method untuk membuat HTTP request dengan headers
  static Future<Map<String, dynamic>> _makeRequest(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Add authentication header if needed
    if (requiresAuth) {
      final token = await getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    try {
      print('🌐 Making $method request to: $uri');
      print('📋 Headers: ${headers.keys}');
      
      http.Response response;

      switch (method.toUpperCase()) {
        case 'GET':
          response = await http
              .get(uri, headers: headers)
              .timeout(const Duration(seconds: 30));
          break;
        case 'POST':
          response = await http
              .post(
                uri,
                headers: headers,
                body: body != null ? jsonEncode(body) : null,
              )
              .timeout(const Duration(seconds: 30));
          break;
        case 'PUT':
          response = await http
              .put(
                uri,
                headers: headers,
                body: body != null ? jsonEncode(body) : null,
              )
              .timeout(const Duration(seconds: 30));
          break;
        case 'DELETE':
          response = await http
              .delete(uri, headers: headers)
              .timeout(const Duration(seconds: 30));
          break;
        default:
          throw Exception('Unsupported HTTP method: $method');
      }

      print('📥 Response status: ${response.statusCode}');
      print('📦 Response body (first 500 chars): ${response.body.length > 500 ? response.body.substring(0, 500) : response.body}');
      
      Map<String, dynamic> responseData;
      try {
        responseData = jsonDecode(response.body) as Map<String, dynamic>;
      } catch (e) {
        print('❌ Failed to parse JSON: $e');
        print('📄 Raw response: ${response.body}');
        throw Exception('Invalid JSON response from server');
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('✅ Request successful');
        return responseData;
      } else {
        print('❌ Request failed with status ${response.statusCode}');
        throw Exception(
          responseData['message'] ?? 'Terjadi kesalahan pada server',
        );
      }
    } catch (e) {
      print('❌ Error in _makeRequest: $e');
      if (e is http.ClientException || e.toString().contains('Failed host lookup')) {
        throw Exception('Gagal terhubung ke server. Periksa koneksi Anda.');
      }
      rethrow;
    }
  }

  // POST request helper
  static Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    return _makeRequest(
      'POST',
      endpoint,
      body: body,
      requiresAuth: requiresAuth,
    );
  }

  // GET request helper
  static Future<Map<String, dynamic>> get(
    String endpoint, {
    bool requiresAuth = true,
  }) async {
    return _makeRequest('GET', endpoint, requiresAuth: requiresAuth);
  }

  // PUT request helper
  static Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    return _makeRequest(
      'PUT',
      endpoint,
      body: body,
      requiresAuth: requiresAuth,
    );
  }

  // DELETE request helper
  static Future<Map<String, dynamic>> delete(
    String endpoint, {
    bool requiresAuth = true,
  }) async {
    return _makeRequest('DELETE', endpoint, requiresAuth: requiresAuth);
  }
}
