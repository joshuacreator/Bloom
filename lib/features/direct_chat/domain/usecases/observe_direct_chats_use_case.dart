import '../entities/direct_message_entity.dart';
import '../repositories/direct_chat_repo.dart';

class ObserveDirectChatsUseCase {
  final DirectChatRepo _repo;

  const ObserveDirectChatsUseCase(this._repo);

  Stream<List<DirectMessageEntity>> call(String userId) {
    return _repo.observeChats(userId);
  }
}
