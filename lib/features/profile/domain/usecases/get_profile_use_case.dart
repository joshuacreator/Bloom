import '../entities/profile_entity.dart';
import '../repositories/profile_repo.dart';

class GetProfileUseCase {
  final ProfileRepo repo;

  const GetProfileUseCase(this.repo);

  Future<ProfileEntity> call(String userId) => repo.getProfile(userId);
}
