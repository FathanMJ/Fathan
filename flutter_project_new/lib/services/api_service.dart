import 'dart:async';
import '../models/order.dart';

class ApiService {
  // Sementara stub: kembalikan list kosong sehingga screen bisa compile.
  Future<List<Order>> getOrderHistory() async {
    return Future.value(<Order>[]);
  }

  // Tambahkan method nyata sesuai kebutuhan API Anda nanti.
}