enum OrderStatus { pending, processing, shipped, completed }

class Order {
  final String orderId;
  final DateTime date;
  final OrderStatus status;
  final double total;
  final int itemCount;

  Order({
    required this.orderId,
    required this.date,
    required this.status,
    required this.total,
    required this.itemCount,
  });

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'date': date.toIso8601String(),
      'status': status.name,
      'total': total,
      'itemCount': itemCount,
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['orderId'],
      date: DateTime.parse(json['date']),
      status: OrderStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      total: json['total'].toDouble(),
      itemCount: json['itemCount'],
    );
  }
}
