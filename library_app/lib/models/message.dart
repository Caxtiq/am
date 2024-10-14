class Message {
  final int id;
  final int senderId;
  final int receiverId;
  final String content;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
  }) : timestamp = DateTime.now();

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      senderId: json['sender']['id'],
      receiverId: json['receiver']['id'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'sender': {'id': senderId},
        'receiver': {'id': receiverId},
        'content': content,
        'timestamp': timestamp.millisecondsSinceEpoch,
      };
}
