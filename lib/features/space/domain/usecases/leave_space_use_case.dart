import '../repositories/space_repo.dart';

class LeaveSpaceUseCase {
  final SpaceRepo _repo;

  const LeaveSpaceUseCase(this._repo);

  Future<void> call(String spaceId, String userId) {
    return _repo.leaveSpace(spaceId, userId);
  }
}
