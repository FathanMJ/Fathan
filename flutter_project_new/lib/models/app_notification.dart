class AppNotification {
  final String id;
  final String title;
  final String body;
  final int timestampMs;
  final bool isRead;
  final String? orderId;
  final String? type; // order_update, promotion, general, etc.

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.timestampMs,
    this.isRead = false,
    this.orderId,
    this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'timestampMs': timestampMs,
      'isRead': isRead,
      'orderId': orderId,
      'type': type,
    };
  }

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'],
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      timestampMs: json['timestampMs'] ?? 0,
      isRead: json['isRead'] ?? false,
      orderId: json['orderId'],
      type: json['type'],
    );
  }

  factory AppNotification.fromMap(String id, Map<dynamic, dynamic> map) {
    return AppNotification(
      id: id,
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      timestampMs: map['timestampMs'] ?? 0,
      isRead: map['isRead'] ?? false,
      orderId: map['orderId'],
      type: map['type'],
    );
  }

  AppNotification copyWith({
    String? id,
    String? title,
    String? body,
    int? timestampMs,
    bool? isRead,
    String? orderId,
    String? type,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      timestampMs: timestampMs ?? this.timestampMs,
      isRead: isRead ?? this.isRead,
      orderId: orderId ?? this.orderId,
      type: type ?? this.type,
    );
  }
}
