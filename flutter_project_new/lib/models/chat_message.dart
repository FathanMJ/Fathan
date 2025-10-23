enum MessageType { text, image, file }
enum MessageStatus { sent, read }

class ChatMessage {
  final String sender;
  final String text;
  final MessageType type;
  final MessageStatus status;
  final DateTime timestamp;

  ChatMessage({
    required this.sender,
    required this.text,
    required this.type,
    required this.status,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'text': text,
      'type': type.name,
      'status': status.name,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      sender: json['sender'],
      text: json['text'],
      type: MessageType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => MessageType.text,
      ),
      status: MessageStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => MessageStatus.sent,
      ),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
