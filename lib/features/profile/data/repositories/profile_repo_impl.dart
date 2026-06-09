import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repo.dart';
import '../datasources/profile_dto.dart';

class ProfileRepoImpl implements ProfileRepo {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  const ProfileRepoImpl({
    required this.firestore,
    required this.storage,
  });

  @override
  Future<ProfileEntity> getProfile(String userId) async {
    final doc = await firestore.collection('users').doc(userId).get();
    final data = doc.data();
    if (data == null) {
      throw Exception('Profile not found');
    }
    return ProfileDto.fromFirestore(data, doc.id).toDomain();
  }

  @override
  Future<void> updateProfile(ProfileEntity profile) async {
    await firestore.collection('users').doc(profile.userId).update({
      'name': profile.name,
      'about': profile.about,
      'phone': profile.phone,
    });
  }

  @override
  Future<void> updateProfileImage(String userId, String imagePath) async {
    final uploadTask = await storage
        .ref()
        .child('users/$userId.png')
        .putFile(File(imagePath));
    final downloadUrl = await uploadTask.ref.getDownloadURL();
    await firestore.collection('users').doc(userId).update({
      'image': downloadUrl,
    });
  }

  @override
  Future<void> deleteAccount() async {
    await FirebaseAuth.instance.currentUser?.delete();
  }

  @override
  Stream<ProfileEntity> observeProfile(String userId) {
    return firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((doc) {
          final data = doc.data();
          if (data == null) {
            throw Exception('Profile not found');
          }
          return ProfileDto.fromFirestore(data, doc.id).toDomain();
        });
  }
}
