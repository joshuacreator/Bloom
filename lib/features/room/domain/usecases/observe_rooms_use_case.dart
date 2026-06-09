import '../entities/room_entity.dart';
import '../repositories/room_repo.dart';

class ObserveRoomsUseCase {
  final RoomRepo repo;

  const ObserveRoomsUseCase(this.repo);

  Stream<List<RoomEntity>> call(String spaceId) {
    return repo.observeRooms(spaceId);
  }
}
