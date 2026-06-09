import '../entities/room_entity.dart';

abstract class RoomRepo {
  Stream<List<RoomEntity>> observeRooms(String spaceId);

  Stream<RoomEntity?> observeRoom(String spaceId, String roomId);

  Stream<List<String>> observeParticipants(String spaceId, String roomId);

  Future<void> createRoom(
    RoomEntity room,
    String spaceId,
    String userId,
    String? imagePath,
  );

  Future<void> joinRoom(String spaceId, String roomId, String userId);

  Future<void> leaveRoom(String spaceId, String roomId, String userId);

  Future<void> updateRoom(
    String spaceId,
    String roomId,
    String? name,
    String? desc,
  );

  Future<void> deleteRoom(String spaceId, String roomId);
}
