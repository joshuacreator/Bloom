import '../repositories/space_repo.dart';

class UpdateSpaceUseCase {
  final SpaceRepo _repo;

  const UpdateSpaceUseCase(this._repo);

  Future<void> call(String spaceId, String? name, String? desc) {
    return _repo.updateSpace(spaceId, name, desc);
  }
}
