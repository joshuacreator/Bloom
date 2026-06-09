import '../repositories/room_repo.dart';

class LeaveRoomUseCase {
  final RoomRepo repo;

  const LeaveRoomUseCase(this.repo);

  Future<void> call(String spaceId, String roomId, String userId) {
    return repo.leaveRoom(spaceId, roomId, userId);
  }
}
