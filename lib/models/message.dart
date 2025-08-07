class Message {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'isUser': isUser ? 1 : 0,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'],
      text: map['text'],
      isUser: map['isUser'] == 1,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
    );
  }
}
