import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repo.dart';
import '../datasources/user_dto.dart';

class AuthRepoImpl implements AuthRepo {
  final fb.FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  const AuthRepoImpl({
    required fb.FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
  })  : _auth = firebaseAuth,
        _firestore = firestore;

  @override
  Stream<UserEntity?> authStateChanges() {
    return _auth.userChanges().asyncMap((fbUser) async {
      if (fbUser == null) return null;
      return _buildUserEntity(fbUser);
    });
  }

  @override
  Future<UserEntity> login(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final fbUser = credential.user;
      if (fbUser == null) {
        throw const AuthException('Login failed. Please try again.');
      }
      final user = await _buildUserEntity(fbUser);
      if (user == null) {
        throw const AuthException('User data not found.');
      }
      return user;
    } on fb.FirebaseAuthException catch (e) {
      logger.e('Login error', error: e);
      throw AuthException(e.message ?? 'Login failed.', code: e.code);
    }
  }

  @override
  Future<UserEntity> register(
    String email,
    String password,
    UserEntity user,
  ) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final fbUser = credential.user;
      if (fbUser == null) {
        throw const AuthException('Registration failed. Please try again.');
      }
      final dto = UserDto(
        userId: fbUser.uid,
        name: user.name,
        email: email,
        phone: user.phone,
      );
      await _firestore.collection('users').doc(fbUser.uid).set(
            dto.toFirestore(),
          );
      return dto.toDomain(emailVerified: fbUser.emailVerified);
    } on fb.FirebaseAuthException catch (e) {
      logger.e('Register error', error: e);
      throw AuthException(e.message ?? 'Registration failed.', code: e.code);
    }
  }

  @override
  Future<void> sendPasswordResetLink(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on fb.FirebaseAuthException catch (e) {
      logger.e('Password reset error', error: e);
      throw AuthException(
        e.message ?? 'Failed to send reset link.',
        code: e.code,
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on fb.FirebaseAuthException catch (e) {
      logger.e('Sign out error', error: e);
      throw AuthException(e.message ?? 'Sign out failed.', code: e.code);
    }
  }

  @override
  Future<void> sendEmailVerificationLink() async {
    try {
      final fbUser = _auth.currentUser;
      if (fbUser == null) {
        throw const AuthException('No user is currently signed in.');
      }
      await fbUser.sendEmailVerification();
    } on fb.FirebaseAuthException catch (e) {
      logger.e('Email verification error', error: e);
      throw AuthException(
        e.message ?? 'Failed to send verification email.',
        code: e.code,
      );
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      final fbUser = _auth.currentUser;
      if (fbUser == null) {
        throw const AuthException('No user is currently signed in.');
      }
      await _firestore.collection('users').doc(fbUser.uid).delete();
      await fbUser.delete();
    } on fb.FirebaseAuthException catch (e) {
      logger.e('Delete account error', error: e);
      throw AuthException(
        e.message ?? 'Failed to delete account.',
        code: e.code,
      );
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final fbUser = _auth.currentUser;
    if (fbUser == null) return null;
    return _buildUserEntity(fbUser);
  }

  @override
  Stream<UserEntity?> getUserById(String userId) {
    return _firestore.collection('users').doc(userId).snapshots().map(
      (doc) {
        if (!doc.exists) return null;
        final data = doc.data()!;
        final dto = UserDto.fromFirestore(data, doc.id);
        return dto.toDomain();
      },
    );
  }

  Future<UserEntity?> _buildUserEntity(fb.User fbUser) async {
    try {
      final doc = await _firestore.collection('users').doc(fbUser.uid).get();
      if (!doc.exists) return null;
      final data = doc.data()!;
      final dto = UserDto.fromFirestore(data, doc.id);
      return dto.toDomain(emailVerified: fbUser.emailVerified);
    } catch (e) {
      logger.e('Error building user entity', error: e);
      return null;
    }
  }
}
