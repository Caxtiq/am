

class Message {
  final int id;
  final String senderId;
  final int receiverId;
  final String content;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'sender_id': senderId,
        'receiver_id': receiverId,
        'content': content,
      };
}
