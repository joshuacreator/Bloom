import '../entities/direct_message_entity.dart';
import '../repositories/direct_chat_repo.dart';

class SendDirectMessageUseCase {
  final DirectChatRepo _repo;

  const SendDirectMessageUseCase(this._repo);

  Future<void> call(DirectMessageEntity message) {
    return _repo.sendMessage(message);
  }
}
