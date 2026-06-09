import '../entities/user_entity.dart';

abstract class AuthRepo {
  Stream<UserEntity?> authStateChanges();

  Future<UserEntity> login(String email, String password);

  Future<UserEntity> register(String email, String password, UserEntity user);

  Future<void> sendPasswordResetLink(String email);

  Future<void> signOut();

  Future<void> sendEmailVerificationLink();

  Future<void> deleteAccount();

  Future<UserEntity?> getCurrentUser();

  Stream<UserEntity?> getUserById(String userId);
}
