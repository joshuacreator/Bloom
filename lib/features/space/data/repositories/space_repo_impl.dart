import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../domain/entities/space_entity.dart';
import '../../domain/repositories/space_repo.dart';
import '../datasources/space_dto.dart';

class SpaceRepoImpl implements SpaceRepo {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  const SpaceRepoImpl(this._firestore, this._storage);

  @override
  Stream<List<SpaceEntity>> observeAllSpaces() {
    return _firestore
        .collection('spaces')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => SpaceDTO.fromFirestore(doc).toDomain())
            .toList());
  }

  @override
  Stream<List<SpaceEntity>> observeMySpaces(String userId) {
    return _firestore
        .collection('spaces')
        .where('participants', arrayContains: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => SpaceDTO.fromFirestore(doc).toDomain())
            .toList());
  }

  @override
  Stream<SpaceEntity?> observeSpace(String spaceId) {
    return _firestore
        .collection('spaces')
        .doc(spaceId)
        .snapshots()
        .map((doc) =>
            doc.exists ? SpaceDTO.fromFirestore(doc).toDomain() : null);
  }

  @override
  Future<void> createSpace(
    SpaceEntity space,
    String userId,
    String? imagePath,
  ) async {
    final docRef = await _firestore.collection('spaces').add({
      'name': space.name,
      'desc': space.desc,
      'image': imagePath,
      'creatorId': space.creatorId,
      'createdAt': space.createdAt,
      'private': space.private,
      'rooms': space.rooms,
      'participants': [userId],
    });

    String? downloadUrl;
    if (imagePath != null && imagePath.isNotEmpty) {
      final path = 'spaces/${docRef.id}.png';
      final uploadTask =
          await _storage.ref().child(path).putFile(File(imagePath));
      downloadUrl = await uploadTask.ref.getDownloadURL();
    }

    await docRef.update({
      'id': docRef.id,
      'image': downloadUrl ?? imagePath,
    });

    await docRef.collection('participants').doc(userId).set({
      'id': userId,
      'joined': DateTime.now(),
    });
  }

  @override
  Future<void> joinSpace(String spaceId, String userId) async {
    await _firestore.collection('spaces').doc(spaceId).update({
      'participants': FieldValue.arrayUnion([userId]),
    });

    await _firestore
        .collection('spaces')
        .doc(spaceId)
        .collection('participants')
        .doc(userId)
        .set({'id': userId, 'joined': DateTime.now()});
  }

  @override
  Future<void> leaveSpace(String spaceId, String userId) async {
    await _firestore.collection('spaces').doc(spaceId).update({
      'participants': FieldValue.arrayRemove([userId]),
    });

    await _firestore
        .collection('spaces')
        .doc(spaceId)
        .collection('participants')
        .doc(userId)
        .delete();
  }

  @override
  Future<void> updateSpace(String spaceId, String? name, String? desc) async {
    await _firestore
        .collection('spaces')
        .doc(spaceId)
        .update({'name': name, 'desc': desc});
  }

  @override
  Future<void> deleteSpace(String spaceId) async {
    await _firestore.collection('spaces').doc(spaceId).delete();
  }
}
