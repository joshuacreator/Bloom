import '../repositories/room_repo.dart';

class UpdateRoomUseCase {
  final RoomRepo repo;

  const UpdateRoomUseCase(this.repo);

  Future<void> call(
    String spaceId,
    String roomId,
    String? name,
    String? desc,
  ) {
    return repo.updateRoom(spaceId, roomId, name, desc);
  }
}
