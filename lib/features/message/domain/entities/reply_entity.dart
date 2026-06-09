class ReplyEntity {
  final String id;
  final String message;
  final String replySenderId;
  final String toMessageId;
  final String toSenderId;
  final bool isMe;
  final bool pending;
  final DateTime time;
  final List<String> likes;

  const ReplyEntity({
    required this.id,
    required this.message,
    required this.replySenderId,
    required this.toMessageId,
    required this.toSenderId,
    this.isMe = false,
    this.pending = false,
    required this.time,
    this.likes = const [],
  });

  ReplyEntity copyWith({
    String? id,
    String? message,
    String? replySenderId,
    String? toMessageId,
    String? toSenderId,
    bool? isMe,
    bool? pending,
    DateTime? time,
    List<String>? likes,
  }) {
    return ReplyEntity(
      id: id ?? this.id,
      message: message ?? this.message,
      replySenderId: replySenderId ?? this.replySenderId,
      toMessageId: toMessageId ?? this.toMessageId,
      toSenderId: toSenderId ?? this.toSenderId,
      isMe: isMe ?? this.isMe,
      pending: pending ?? this.pending,
      time: time ?? this.time,
      likes: likes ?? this.likes,
    );
  }
}
