import '../repositories/room_repo.dart';

class DeleteRoomUseCase {
  final RoomRepo repo;

  const DeleteRoomUseCase(this.repo);

  Future<void> call(String spaceId, String roomId) {
    return repo.deleteRoom(spaceId, roomId);
  }
}
