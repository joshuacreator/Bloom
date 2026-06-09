import '../entities/message_entity.dart';
import '../repositories/message_repo.dart';

class ObserveMessagesUseCase {
  final MessageRepo _repo;

  const ObserveMessagesUseCase(this._repo);

  Stream<List<MessageEntity>> call(String spaceId, String roomId) {
    return _repo.observeMessages(spaceId, roomId);
  }
}
