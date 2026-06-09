import '../repositories/space_repo.dart';

class DeleteSpaceUseCase {
  final SpaceRepo _repo;

  const DeleteSpaceUseCase(this._repo);

  Future<void> call(String spaceId) {
    return _repo.deleteSpace(spaceId);
  }
}
