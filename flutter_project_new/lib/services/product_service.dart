import 'laravel_api_service.dart';
import '../config/api_config.dart';

class ProductService {
  // Get all products
  static Future<List<Map<String, dynamic>>> getAllProducts() async {
    try {
      final response = await LaravelApiService.get(ApiConfig.produk);
      return List<Map<String, dynamic>>.from(response['data'] ?? []);
    } catch (e) {
      print('Error fetching products: $e');
      rethrow;
    }
  }

  // Get product by ID
  static Future<Map<String, dynamic>> getProductById(int id) async {
    try {
      final response = await LaravelApiService.get('${ApiConfig.produk}/$id');
      return response['data'];
    } catch (e) {
      print('Error fetching product: $e');
      rethrow;
    }
  }

  // Search products
  static Future<List<Map<String, dynamic>>> searchProducts(String query) async {
    try {
      final response = await LaravelApiService.get(
        '${ApiConfig.produk}/search?q=$query',
      );
      return List<Map<String, dynamic>>.from(response['data'] ?? []);
    } catch (e) {
      print('Error searching products: $e');
      rethrow;
    }
  }

  // Get products by category
  static Future<List<Map<String, dynamic>>> getProductsByCategory(
    int categoryId,
  ) async {
    try {
      final response = await LaravelApiService.get(
        '${ApiConfig.produk}/kategori/$categoryId',
      );
      return List<Map<String, dynamic>>.from(response['data'] ?? []);
    } catch (e) {
      print('Error fetching products by category: $e');
      rethrow;
    }
  }
}









