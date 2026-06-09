import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/reply_entity.dart';

class ReplyDTO {
  static ReplyEntity fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return ReplyEntity(
      id: data['id'] as String? ?? doc.id,
      message: data['reply'] as String? ?? '',
      replySenderId: data['replySenderId'] as String? ?? '',
      toMessageId: data['toMessageId'] as String? ?? '',
      toSenderId: data['toSenderId'] as String? ?? '',
      isMe: (data['isMe'] as bool?) ?? false,
      pending: (data['pending'] as bool?) ?? false,
      time: (data['time'] as Timestamp?)?.toDate() ?? DateTime.now(),
      likes: data['likes'] != null
          ? List<String>.from(data['likes'] as List)
          : const [],
    );
  }

  static Map<String, dynamic> toFirestore(ReplyEntity entity) {
    return {
      'id': entity.id,
      'reply': entity.message,
      'replySenderId': entity.replySenderId,
      'toMessageId': entity.toMessageId,
      'toSenderId': entity.toSenderId,
      'time': entity.time,
      'likes': entity.likes,
    };
  }
}
