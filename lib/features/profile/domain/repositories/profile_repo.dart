import '../entities/profile_entity.dart';

abstract class ProfileRepo {
  Future<ProfileEntity> getProfile(String userId);

  Future<void> updateProfile(ProfileEntity profile);

  Future<void> updateProfileImage(String userId, String imagePath);

  Future<void> deleteAccount();

  Stream<ProfileEntity> observeProfile(String userId);
}
