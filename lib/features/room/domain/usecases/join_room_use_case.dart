import '../repositories/room_repo.dart';

class JoinRoomUseCase {
  final RoomRepo repo;

  const JoinRoomUseCase(this.repo);

  Future<void> call(String spaceId, String roomId, String userId) {
    return repo.joinRoom(spaceId, roomId, userId);
  }
}
