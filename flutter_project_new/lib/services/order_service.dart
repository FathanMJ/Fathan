import 'laravel_api_service.dart';
import '../config/api_config.dart';

class OrderService {
  // Get all orders for current user
  static Future<List<Map<String, dynamic>>> getUserOrders() async {
    try {
      final response = await LaravelApiService.get(ApiConfig.pesanan);
      return List<Map<String, dynamic>>.from(response['data'] ?? []);
    } catch (e) {
      print('Error fetching orders: $e');
      rethrow;
    }
  }

  // Get order by ID
  static Future<Map<String, dynamic>> getOrderById(int id) async {
    try {
      final response = await LaravelApiService.get('${ApiConfig.pesanan}/$id');
      return response['data'];
    } catch (e) {
      print('Error fetching order: $e');
      rethrow;
    }
  }

  // Create new order
  static Future<Map<String, dynamic>> createOrder({
    required List<Map<String, dynamic>> items,
    required String shippingAddress,
    String? notes,
  }) async {
    try {
      final response = await LaravelApiService.post(
        ApiConfig.pesanan,
        body: {
          'items': items,
          'shipping_address': shippingAddress,
          'notes': notes,
        },
      );
      return response['data'];
    } catch (e) {
      print('Error creating order: $e');
      rethrow;
    }
  }

  // Update order status
  static Future<bool> updateOrderStatus(int orderId, String status) async {
    try {
      final response = await LaravelApiService.put(
        '${ApiConfig.pesanan}/$orderId/status',
        body: {'status': status},
      );
      return response['success'] == true;
    } catch (e) {
      print('Error updating order status: $e');
      rethrow;
    }
  }

  // Track order by resi
  static Future<Map<String, dynamic>> trackOrder(String resi) async {
    try {
      final response = await LaravelApiService.get('/tracking/$resi');
      return response['data'];
    } catch (e) {
      print('Error tracking order: $e');
      rethrow;
    }
  }
}









