class ChatConversation {
  final String adminName;
  final String lastMessage;
  final DateTime lastMessageDate;
  final bool isRead;
  final String orderId;

  ChatConversation({
    required this.adminName,
    required this.lastMessage,
    required this.lastMessageDate,
    required this.isRead,
    required this.orderId,
  });

  Map<String, dynamic> toJson() {
    return {
      'adminName': adminName,
      'lastMessage': lastMessage,
      'lastMessageDate': lastMessageDate.toIso8601String(),
      'isRead': isRead,
      'orderId': orderId,
    };
  }

  factory ChatConversation.fromJson(Map<String, dynamic> json) {
    return ChatConversation(
      adminName: json['adminName'],
      lastMessage: json['lastMessage'],
      lastMessageDate: DateTime.parse(json['lastMessageDate']),
      isRead: json['isRead'] ?? false,
      orderId: json['orderId'],
    );
  }
}
