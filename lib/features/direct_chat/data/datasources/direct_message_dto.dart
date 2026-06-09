import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/direct_message_entity.dart';

class DirectMessageDto {
  final String id;
  final String message;
  final String fromId;
  final String toId;
  final String? image;
  final String? file;
  final DateTime time;
  final bool pending;
  final List<String> participants;

  const DirectMessageDto({
    required this.id,
    required this.message,
    required this.fromId,
    required this.toId,
    this.image,
    this.file,
    required this.time,
    this.pending = false,
    this.participants = const [],
  });

  factory DirectMessageDto.fromFirestore(Map<String, dynamic> data, String docId) {
    return DirectMessageDto(
      id: docId,
      message: data['message'] as String? ?? '',
      fromId: data['fromId'] as String? ?? '',
      toId: data['toId'] as String? ?? '',
      image: data['image'] as String?,
      file: data['file'] as String?,
      time: (data['time'] as Timestamp?)?.toDate() ?? DateTime.now(),
      pending: data['pending'] as bool? ?? false,
      participants: data['participants'] != null
          ? List<String>.from(data['participants'] as List)
          : const [],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'message': message,
      'fromId': fromId,
      'toId': toId,
      'image': image,
      'file': file,
      'time': Timestamp.fromDate(time),
      'pending': pending,
      'participants': participants,
    };
  }

  DirectMessageEntity toDomain() {
    return DirectMessageEntity(
      id: id,
      message: message,
      fromId: fromId,
      toId: toId,
      image: image,
      file: file,
      time: time,
      pending: pending,
      participants: participants,
    );
  }

  factory DirectMessageDto.fromDomain(DirectMessageEntity entity) {
    return DirectMessageDto(
      id: entity.id,
      message: entity.message,
      fromId: entity.fromId,
      toId: entity.toId,
      image: entity.image,
      file: entity.file,
      time: entity.time,
      pending: entity.pending,
      participants: entity.participants,
    );
  }
}
