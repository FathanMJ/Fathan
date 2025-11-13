class ChatConversation {
  final String? adminName;
  final String lastMessage;
  final DateTime lastMessageDate;
  final bool isRead;
  final String? orderId;
  final String roomId;
  final String? pelangganName;

  ChatConversation({
    this.adminName,
    required this.lastMessage,
    required this.lastMessageDate,
    required this.isRead,
    this.orderId,
    required this.roomId,
    this.pelangganName,
  });

  Map<String, dynamic> toJson() {
    return {
      'adminName': adminName,
      'lastMessage': lastMessage,
      'lastMessageDate': lastMessageDate.toIso8601String(),
      'isRead': isRead,
      'orderId': orderId,
      'roomId': roomId,
      'pelangganName': pelangganName,
    };
  }

  factory ChatConversation.fromJson(Map<String, dynamic> json) {
    // Handle API response from Laravel
    final lastMessageData = json['messages'] != null && json['messages'].isNotEmpty
        ? json['messages'][0]
        : null;
    
    final lastMessage = lastMessageData?['pesan'] ?? 
                       lastMessageData?['content'] ?? 
                       json['last_message'] ?? 
                       'Tidak ada pesan';
    
    final lastMessageDateStr = lastMessageData?['dikirim_pada'] ?? 
                              lastMessageData?['created_at'] ?? 
                              json['last_message_date'] ?? 
                              json['dibuat_pada'];
    
    DateTime lastMessageDate;
    try {
      lastMessageDate = DateTime.parse(lastMessageDateStr);
    } catch (e) {
      lastMessageDate = DateTime.now();
    }
    
    final admin = json['admin'] ?? json['admin_user'];
    final pelanggan = json['pelanggan'];
    
    return ChatConversation(
      adminName: admin?['nama'] ?? admin?['name'] ?? 'Admin',
      pelangganName: pelanggan?['nama'] ?? pelanggan?['name'],
      lastMessage: lastMessage,
      lastMessageDate: lastMessageDate,
      isRead: lastMessageData?['dibaca'] == 1 || 
              lastMessageData?['is_read'] == true ||
              json['is_read'] == true || false,
      orderId: json['order_id'] ?? json['pesanan_id'],
      roomId: json['id_chat_room']?.toString() ?? json['id']?.toString() ?? '',
    );
  }
}
