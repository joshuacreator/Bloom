import '../entities/reply_entity.dart';
import '../repositories/message_repo.dart';

class ObserveRepliesUseCase {
  final MessageRepo _repo;

  const ObserveRepliesUseCase(this._repo);

  Stream<List<ReplyEntity>> call(
    String spaceId,
    String roomId,
    String messageId,
  ) {
    return _repo.observeReplies(spaceId, roomId, messageId);
  }
}
