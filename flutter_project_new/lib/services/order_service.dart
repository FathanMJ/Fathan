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
    String paymentMethod = 'midtrans',
    String? tipePembayaran, // 'penuh' atau 'dp'
    int? shippingCostId,
    int? discountId,
    String? notes,
    // Data ongkir dari Raja Ongkir
    String? kurir,
    String? layanan,
    int? hargaOngkir,
    String? estimasi,
  }) async {
    try {
      final body = {
        'items': items,
        'alamat_pengiriman': shippingAddress,
        'metode_pembayaran': paymentMethod,
        'diskon_id': discountId,
        'catatan': notes,
      };
      
      // Tambahkan tipe_pembayaran jika ada (untuk DP)
      if (tipePembayaran != null) {
        body['tipe_pembayaran'] = tipePembayaran;
      }

      // Tambahkan ongkir_id jika ada
      if (shippingCostId != null) {
        body['ongkir_id'] = shippingCostId;
      }

      // Tambahkan data ongkir dari Raja Ongkir
      if (kurir != null) {
        body['kurir_pengiriman'] = kurir;
      }
      if (layanan != null) {
        body['layanan_pengiriman'] = layanan;
      }
      if (hargaOngkir != null) {
        body['harga_ongkir'] = hargaOngkir;
      }
      if (estimasi != null) {
        body['estimasi_pengiriman'] = estimasi;
      }

      final response = await LaravelApiService.post(
        ApiConfig.pesanan,
        body: body,
      );
      return Map<String, dynamic>.from(response['data'] ?? {});
    } catch (e) {
      print('Error creating order: $e');
      rethrow;
    }
  }

  // --- Custom Order Flow ---

  /// 1. Create a new custom order submission (Step A)
  static Future<Map<String, dynamic>> createCustomOrder({
    required Map<String, dynamic> customOrderData,
  }) async {
    try {
      // Endpoint ini harus dibuat di backend untuk menerima pengajuan custom order
      final response = await LaravelApiService.post(
        ApiConfig.customOrder, // contoh: '/api/custom-order'
        body: customOrderData,
      );
      return Map<String, dynamic>.from(response['data'] ?? {});
    } catch (e) {
      print('Error creating custom order: $e');
      rethrow;
    }
  }

  /// 2. Get payment token for Down Payment (Step D)
  static Future<Map<String, dynamic>> payCustomOrderDP(int orderId) async {
    try {
      // Endpoint untuk generate snap token DP
      final response = await LaravelApiService.post(
        '${ApiConfig.customOrder}/$orderId/pay-dp',
        body: {},
      );
      return Map<String, dynamic>.from(response['data'] ?? {});
    } catch (e) {
      print('Error paying custom order DP: $e');
      rethrow;
    }
  }

  /// 3. Get payment token for Final Payment (Step F)
  static Future<Map<String, dynamic>> payCustomOrderFinal(int orderId) async {
    try {
      // Endpoint untuk generate snap token pelunasan
      final response = await LaravelApiService.post(
        '${ApiConfig.customOrder}/$orderId/pay-remaining',
        body: {},
      );
      return Map<String, dynamic>.from(response['data'] ?? {});
    } catch (e) {
      print('Error paying custom order final payment: $e');
      rethrow;
    }
  }

  /// 4. Get payment status for custom order
  static Future<Map<String, dynamic>> getCustomOrderPaymentStatus(
    int orderId,
  ) async {
    try {
      final response = await LaravelApiService.get(
        '${ApiConfig.customOrder}/$orderId/payment-status',
      );
      return Map<String, dynamic>.from(response['data'] ?? {});
    } catch (e) {
      print('Error getting custom order payment status: $e');
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
