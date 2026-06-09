import '../entities/message_entity.dart';
import '../entities/reply_entity.dart';

abstract class MessageRepo {
  Stream<List<MessageEntity>> observeMessages(String spaceId, String roomId);

  Stream<MessageEntity?> observeMessage(
    String spaceId,
    String roomId,
    String messageId,
  );

  Stream<MessageEntity?> observeLastMessage(String spaceId, String roomId);

  Stream<List<ReplyEntity>> observeReplies(
    String spaceId,
    String roomId,
    String messageId,
  );

  Stream<int> observeRepliesCount(
    String spaceId,
    String roomId,
    String messageId,
  );

  Stream<int> observeLikesCount(
    String spaceId,
    String roomId,
    String messageId,
  );

  Future<void> sendMessage(
    MessageEntity message,
    String spaceId,
    String roomId,
    String? imagePath,
    String? filePath,
  );

  Future<void> sendReply(
    ReplyEntity reply,
    String spaceId,
    String roomId,
    String messageId,
  );

  Future<void> editMessage(
    String spaceId,
    String roomId,
    String messageId,
    String newMessage,
  );

  Future<void> deleteMessage(
    String spaceId,
    String roomId,
    String messageId,
  );

  Future<void> toggleLike(
    String spaceId,
    String roomId,
    String messageId,
    String userId,
  );

  Future<void> toggleReplyLike(
    String spaceId,
    String roomId,
    String messageId,
    String replyId,
    String userId,
  );
}
