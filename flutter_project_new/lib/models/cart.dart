import 'order_item.dart';

class Cart {
  final String id;
  final List<OrderItem> items;
  final double totalPrice;
  final int totalItems;
  final DateTime createdAt;

  Cart({
    required this.id,
    required this.items,
    required this.totalPrice,
    required this.totalItems,
    required this.createdAt,
  });

  Cart copyWith({
    String? id,
    List<OrderItem>? items,
    double? totalPrice,
    int? totalItems,
    DateTime? createdAt,
  }) {
    return Cart(
      id: id ?? this.id,
      items: items ?? this.items,
      totalPrice: totalPrice ?? this.totalPrice,
      totalItems: totalItems ?? this.totalItems,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Cart addItem(OrderItem item) {
    final newItems = List<OrderItem>.from(items)..add(item);
    final newTotalPrice = newItems.fold(0.0, (sum, item) => sum + item.totalPrice);
    final newTotalItems = newItems.fold(0, (sum, item) => sum + item.totalQuantity);

    return Cart(
      id: id,
      items: newItems,
      totalPrice: newTotalPrice,
      totalItems: newTotalItems,
      createdAt: createdAt,
    );
  }

  Cart removeItem(String itemId) {
    final newItems = items.where((item) => item.id != itemId).toList();
    final newTotalPrice = newItems.fold(0.0, (sum, item) => sum + item.totalPrice);
    final newTotalItems = newItems.fold(0, (sum, item) => sum + item.totalQuantity);

    return Cart(
      id: id,
      items: newItems,
      totalPrice: newTotalPrice,
      totalItems: newTotalItems,
      createdAt: createdAt,
    );
  }

  Cart updateItem(String itemId, OrderItem updatedItem) {
    final newItems = items.map((item) => item.id == itemId ? updatedItem : item).toList();
    final newTotalPrice = newItems.fold(0.0, (sum, item) => sum + item.totalPrice);
    final newTotalItems = newItems.fold(0, (sum, item) => sum + item.totalQuantity);

    return Cart(
      id: id,
      items: newItems,
      totalPrice: newTotalPrice,
      totalItems: newTotalItems,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'totalPrice': totalPrice,
      'totalItems': totalItems,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      totalPrice: json['totalPrice'].toDouble(),
      totalItems: json['totalItems'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

