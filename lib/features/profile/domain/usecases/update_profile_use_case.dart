import '../entities/profile_entity.dart';
import '../repositories/profile_repo.dart';

class UpdateProfileUseCase {
  final ProfileRepo repo;

  const UpdateProfileUseCase(this.repo);

  Future<void> call(ProfileEntity profile) => repo.updateProfile(profile);
}
