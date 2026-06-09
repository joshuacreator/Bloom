class MessageEntity {
  final String id;
  final String message;
  final String senderId;
  final String? image;
  final String? file;
  final DateTime time;
  final bool pending;
  final bool me;
  final List<String> likes;

  const MessageEntity({
    required this.id,
    required this.message,
    required this.senderId,
    this.image,
    this.file,
    required this.time,
    this.pending = false,
    this.me = false,
    this.likes = const [],
  });

  MessageEntity copyWith({
    String? id,
    String? message,
    String? senderId,
    String? image,
    String? file,
    DateTime? time,
    bool? pending,
    bool? me,
    List<String>? likes,
  }) {
    return MessageEntity(
      id: id ?? this.id,
      message: message ?? this.message,
      senderId: senderId ?? this.senderId,
      image: image ?? this.image,
      file: file ?? this.file,
      time: time ?? this.time,
      pending: pending ?? this.pending,
      me: me ?? this.me,
      likes: likes ?? this.likes,
    );
  }
}
