import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../domain/entities/message_entity.dart';
import '../../domain/entities/reply_entity.dart';
import '../../domain/repositories/message_repo.dart';
import '../datasources/message_dto.dart';
import '../datasources/reply_dto.dart';

class MessageRepoImpl implements MessageRepo {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  MessageRepoImpl({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  CollectionReference _messagesRef(String spaceId, String roomId) {
    return _firestore
        .collection('spaces')
        .doc(spaceId)
        .collection('rooms')
        .doc(roomId)
        .collection('messages');
  }

  CollectionReference _repliesRef(
    String spaceId,
    String roomId,
    String messageId,
  ) {
    return _messagesRef(spaceId, roomId).doc(messageId).collection('replies');
  }

  @override
  Stream<List<MessageEntity>> observeMessages(String spaceId, String roomId) {
    return _messagesRef(spaceId, roomId)
        .orderBy('time', descending: true)
        .snapshots(includeMetadataChanges: true)
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => MessageDTO.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
              .toList(),
        );
  }

  @override
  Stream<MessageEntity?> observeMessage(
    String spaceId,
    String roomId,
    String messageId,
  ) {
    return _messagesRef(spaceId, roomId)
        .doc(messageId)
        .snapshots()
        .map((doc) => doc.exists ? MessageDTO.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>) : null);
  }

  @override
  Stream<MessageEntity?> observeLastMessage(String spaceId, String roomId) {
    return _messagesRef(spaceId, roomId)
        .orderBy('time', descending: true)
        .limit(1)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.isNotEmpty
                  ? MessageDTO.fromFirestore(snapshot.docs.first as DocumentSnapshot<Map<String, dynamic>>)
                  : null,
        );
  }

  @override
  Stream<List<ReplyEntity>> observeReplies(
    String spaceId,
    String roomId,
    String messageId,
  ) {
    return _repliesRef(spaceId, roomId, messageId)
        .orderBy('time', descending: true)
        .snapshots(includeMetadataChanges: true)
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ReplyDTO.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
              .toList(),
        );
  }

  @override
  Stream<int> observeRepliesCount(
    String spaceId,
    String roomId,
    String messageId,
  ) {
    return _repliesRef(spaceId, roomId, messageId)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  @override
  Stream<int> observeLikesCount(
    String spaceId,
    String roomId,
    String messageId,
  ) {
    return _messagesRef(spaceId, roomId).doc(messageId).snapshots().map(
      (doc) {
        if (!doc.exists) return 0;
        final data = doc.data() as Map<String, dynamic>?;
        final likes = data?['likes'] as List?;
        return likes?.length ?? 0;
      },
    );
  }

  @override
  Future<void> sendMessage(
    MessageEntity message,
    String spaceId,
    String roomId,
    String? imagePath,
    String? filePath,
  ) async {
    final docRef = await _messagesRef(spaceId, roomId).add({
      'message': message.message,
      'senderId': message.senderId,
      'image': message.image,
      'file': message.file,
      'time': message.time,
      'likes': message.likes,
    });

    await docRef.update({'id': docRef.id});

    if (imagePath != null) {
      final storagePath =
          'spaces/$spaceId/rooms/$roomId/messages/${docRef.id}_${DateTime.now().millisecondsSinceEpoch}.png';
      final uploadTask =
          await _storage.ref().child(storagePath).putFile(File(imagePath));
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      await docRef.update({'image': downloadUrl});
    }

    if (filePath != null) {
      final storagePath =
          'spaces/$spaceId/rooms/$roomId/messages/${docRef.id}_${DateTime.now().millisecondsSinceEpoch}';
      final uploadTask =
          await _storage.ref().child(storagePath).putFile(File(filePath));
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      await docRef.update({'file': downloadUrl});
    }
  }

  @override
  Future<void> sendReply(
    ReplyEntity reply,
    String spaceId,
    String roomId,
    String messageId,
  ) async {
    final docRef = await _repliesRef(spaceId, roomId, messageId).add({
      'reply': reply.message,
      'replySenderId': reply.replySenderId,
      'toMessageId': reply.toMessageId,
      'toSenderId': reply.toSenderId,
      'time': reply.time,
      'likes': reply.likes,
    });

    await docRef.update({'id': docRef.id});
  }

  @override
  Future<void> editMessage(
    String spaceId,
    String roomId,
    String messageId,
    String newMessage,
  ) async {
    await _messagesRef(spaceId, roomId).doc(messageId).update({
      'message': newMessage,
    });
  }

  @override
  Future<void> deleteMessage(
    String spaceId,
    String roomId,
    String messageId,
  ) async {
    await _messagesRef(spaceId, roomId).doc(messageId).delete();
  }

  @override
  Future<void> toggleLike(
    String spaceId,
    String roomId,
    String messageId,
    String userId,
  ) async {
    final docRef = _messagesRef(spaceId, roomId).doc(messageId);
    final doc = await docRef.get();
    if (!doc.exists) return;
    final data = doc.data() as Map<String, dynamic>?;
    final likes = List<String>.from(data?['likes'] ?? []);
    if (likes.contains(userId)) {
      await docRef.update({
        'likes': FieldValue.arrayRemove([userId]),
      });
    } else {
      await docRef.update({
        'likes': FieldValue.arrayUnion([userId]),
      });
    }
  }

  @override
  Future<void> toggleReplyLike(
    String spaceId,
    String roomId,
    String messageId,
    String replyId,
    String userId,
  ) async {
    final docRef =
        _repliesRef(spaceId, roomId, messageId).doc(replyId);
    final doc = await docRef.get();
    if (!doc.exists) return;
    final data = doc.data() as Map<String, dynamic>?;
    final likes = List<String>.from(data?['likes'] ?? []);
    if (likes.contains(userId)) {
      await docRef.update({
        'likes': FieldValue.arrayRemove([userId]),
      });
    } else {
      await docRef.update({
        'likes': FieldValue.arrayUnion([userId]),
      });
    }
  }
}
