import '../repositories/profile_repo.dart';

class UpdateProfileImageUseCase {
  final ProfileRepo repo;

  const UpdateProfileImageUseCase(this.repo);

  Future<void> call(String userId, String imagePath) =>
      repo.updateProfileImage(userId, imagePath);
}
