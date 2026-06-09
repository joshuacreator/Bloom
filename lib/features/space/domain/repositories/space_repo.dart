import '../entities/space_entity.dart';

abstract class SpaceRepo {
  Stream<List<SpaceEntity>> observeAllSpaces();

  Stream<List<SpaceEntity>> observeMySpaces(String userId);

  Stream<SpaceEntity?> observeSpace(String spaceId);

  Future<void> createSpace(
    SpaceEntity space,
    String userId,
    String? imagePath,
  );

  Future<void> joinSpace(String spaceId, String userId);

  Future<void> leaveSpace(String spaceId, String userId);

  Future<void> updateSpace(
    String spaceId,
    String? name,
    String? desc,
  );

  Future<void> deleteSpace(String spaceId);
}
