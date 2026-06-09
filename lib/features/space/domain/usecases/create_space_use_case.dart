import '../entities/space_entity.dart';
import '../repositories/space_repo.dart';

class CreateSpaceUseCase {
  final SpaceRepo _repo;

  const CreateSpaceUseCase(this._repo);

  Future<void> call(SpaceEntity space, String userId, String? imagePath) {
    return _repo.createSpace(space, userId, imagePath);
  }
}
