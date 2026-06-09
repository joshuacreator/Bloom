import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/message_entity.dart';

class MessageDTO {
  static MessageEntity fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return MessageEntity(
      id: data['id'] as String? ?? doc.id,
      message: data['message'] as String? ?? '',
      senderId: data['senderId'] as String? ?? '',
      image: data['image'] as String?,
      file: data['file'] as String?,
      time: (data['time'] as Timestamp?)?.toDate() ?? DateTime.now(),
      pending: (data['pending'] as bool?) ?? false,
      me: (data['me'] as bool?) ?? false,
      likes: data['likes'] != null
          ? List<String>.from(data['likes'] as List)
          : const [],
    );
  }

  static Map<String, dynamic> toFirestore(MessageEntity entity) {
    return {
      'id': entity.id,
      'message': entity.message,
      'senderId': entity.senderId,
      'image': entity.image,
      'file': entity.file,
      'time': entity.time,
      'likes': entity.likes,
    };
  }
}
