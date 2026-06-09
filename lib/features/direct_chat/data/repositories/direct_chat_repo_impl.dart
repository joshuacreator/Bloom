import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/direct_message_entity.dart';
import '../../domain/repositories/direct_chat_repo.dart';
import '../datasources/direct_message_dto.dart';

class DirectChatRepoImpl implements DirectChatRepo {
  final FirebaseFirestore _firestore;

  const DirectChatRepoImpl(this._firestore);

  @override
  Stream<List<DirectMessageEntity>> observeChats(String userId) {
    return _firestore
        .collection('direct_chats')
        .where('participants', arrayContains: userId)
        .orderBy('time', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map(
            (doc) {
              final dto = DirectMessageDto.fromFirestore(
                doc.data(),
                doc.id,
              );
              return dto.toDomain();
            },
          ).toList(),
        );
  }

  @override
  Future<void> sendMessage(DirectMessageEntity message) async {
    final dto = DirectMessageDto.fromDomain(message);
    await _firestore.collection('direct_chats').add(dto.toFirestore());
  }
}
