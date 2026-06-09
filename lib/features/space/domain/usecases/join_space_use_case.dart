import '../repositories/space_repo.dart';

class JoinSpaceUseCase {
  final SpaceRepo _repo;

  const JoinSpaceUseCase(this._repo);

  Future<void> call(String spaceId, String userId) {
    return _repo.joinSpace(spaceId, userId);
  }
}
