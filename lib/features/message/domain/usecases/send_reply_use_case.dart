import '../entities/reply_entity.dart';
import '../repositories/message_repo.dart';

class SendReplyUseCase {
  final MessageRepo _repo;

  const SendReplyUseCase(this._repo);

  Future<void> call({
    required ReplyEntity reply,
    required String spaceId,
    required String roomId,
    required String messageId,
  }) {
    return _repo.sendReply(reply, spaceId, roomId, messageId);
  }
}
