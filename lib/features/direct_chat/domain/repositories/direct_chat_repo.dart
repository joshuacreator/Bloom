import '../entities/direct_message_entity.dart';

abstract class DirectChatRepo {
  Stream<List<DirectMessageEntity>> observeChats(String userId);

  Future<void> sendMessage(DirectMessageEntity message);
}
