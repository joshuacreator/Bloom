import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../domain/entities/room_entity.dart';
import '../../domain/repositories/room_repo.dart';
import '../datasources/room_dto.dart';

class RoomRepoImpl implements RoomRepo {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  RoomRepoImpl(this._firestore, this._storage);

  @override
  Stream<List<RoomEntity>> observeRooms(String spaceId) {
    return _firestore
        .collection('spaces')
        .doc(spaceId)
        .collection('rooms')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) =>
                    RoomDto.fromJson(doc.data(), docId: doc.id).toDomain(),
              )
              .toList(),
        );
  }

  @override
  Stream<RoomEntity?> observeRoom(String spaceId, String roomId) {
    return _firestore
        .collection('spaces')
        .doc(spaceId)
        .collection('rooms')
        .doc(roomId)
        .snapshots()
        .map(
          (doc) => doc.exists
              ? RoomDto.fromJson(doc.data()!, docId: doc.id).toDomain()
              : null,
        );
  }

  @override
  Stream<List<String>> observeParticipants(String spaceId, String roomId) {
    return _firestore
        .collection('spaces')
        .doc(spaceId)
        .collection('rooms')
        .doc(roomId)
        .collection('participants')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
  }

  @override
  Future<void> createRoom(
    RoomEntity room,
    String spaceId,
    String userId,
    String? imagePath,
  ) async {
    final roomRef = _firestore
        .collection('spaces')
        .doc(spaceId)
        .collection('rooms');

    final docRef = await roomRef.add({
      'name': room.name,
      'desc': room.desc,
      'creatorId': room.creatorId,
      'private': room.private,
      'image': room.image,
      'createdAt': room.createdAt ?? DateTime.now(),
      'participants': room.participants,
    });

    await docRef.update({'id': docRef.id});

    await _firestore
        .collection('spaces')
        .doc(spaceId)
        .update({'rooms': FieldValue.arrayUnion([docRef.id])});

    await docRef
        .collection('participants')
        .doc(userId)
        .set({'id': userId, 'joined': DateTime.now()});

    if (imagePath != null) {
      final imageUrl = await _uploadImage(
        imagePath,
        'rooms/${room.id ?? docRef.id}/${docRef.id}.png',
      );
      await docRef.update({'image': imageUrl});
    }
  }

  @override
  Future<void> joinRoom(String spaceId, String roomId, String userId) async {
    await _firestore
        .collection('spaces')
        .doc(spaceId)
        .collection('rooms')
        .doc(roomId)
        .collection('participants')
        .doc(userId)
        .set({'id': userId, 'joined': DateTime.now()});

    await _firestore
        .collection('spaces')
        .doc(spaceId)
        .collection('rooms')
        .doc(roomId)
        .update({'participants': FieldValue.arrayUnion([userId])});
  }

  @override
  Future<void> leaveRoom(String spaceId, String roomId, String userId) async {
    await _firestore
        .collection('spaces')
        .doc(spaceId)
        .collection('rooms')
        .doc(roomId)
        .collection('participants')
        .doc(userId)
        .delete();

    await _firestore
        .collection('spaces')
        .doc(spaceId)
        .collection('rooms')
        .doc(roomId)
        .update({'participants': FieldValue.arrayRemove([userId])});
  }

  @override
  Future<void> updateRoom(
    String spaceId,
    String roomId,
    String? name,
    String? desc,
  ) async {
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (desc != null) data['desc'] = desc;

    await _firestore
        .collection('spaces')
        .doc(spaceId)
        .collection('rooms')
        .doc(roomId)
        .update(data);
  }

  @override
  Future<void> deleteRoom(String spaceId, String roomId) async {
    await _firestore
        .collection('spaces')
        .doc(spaceId)
        .update({'rooms': FieldValue.arrayRemove([roomId])});

    await _firestore
        .collection('spaces')
        .doc(spaceId)
        .collection('rooms')
        .doc(roomId)
        .delete();
  }

  Future<String> _uploadImage(String imagePath, String storagePath) async {
    final file = File(imagePath);
    final uploadTask = _storage.ref().child(storagePath).putFile(file);
    final snapshot = await uploadTask;
    return snapshot.ref.getDownloadURL();
  }
}
