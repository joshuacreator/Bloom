import '../entities/room_entity.dart';
import '../repositories/room_repo.dart';

class CreateRoomUseCase {
  final RoomRepo repo;

  const CreateRoomUseCase(this.repo);

  Future<void> call(
    RoomEntity room,
    String spaceId,
    String userId,
    String? imagePath,
  ) {
    return repo.createRoom(room, spaceId, userId, imagePath);
  }
}
