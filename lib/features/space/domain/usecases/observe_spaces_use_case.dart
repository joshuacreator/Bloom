import '../entities/space_entity.dart';
import '../repositories/space_repo.dart';

class ObserveSpacesUseCase {
  final SpaceRepo _repo;

  const ObserveSpacesUseCase(this._repo);

  Stream<List<SpaceEntity>> allSpaces() => _repo.observeAllSpaces();

  Stream<List<SpaceEntity>> mySpaces(String userId) =>
      _repo.observeMySpaces(userId);

  Stream<SpaceEntity?> singleSpace(String spaceId) =>
      _repo.observeSpace(spaceId);
}
