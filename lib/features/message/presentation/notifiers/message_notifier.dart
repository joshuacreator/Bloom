import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../services/connection_state.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/entities/reply_entity.dart';
import '../../domain/usecases/delete_message_use_case.dart';
import '../../domain/usecases/edit_message_use_case.dart';
import '../../domain/usecases/send_message_use_case.dart';
import '../../domain/usecases/send_reply_use_case.dart';
import '../providers/message_providers.dart';

class MessageNotifier extends AutoDisposeAsyncNotifier<void> {
  late final SendMessageUseCase _sendMessage;
  late final SendReplyUseCase _sendReply;
  late final EditMessageUseCase _editMessage;
  late final DeleteMessageUseCase _deleteMessage;

  @override
  Future<void> build() {
    final repo = ref.watch(messageRepoProvider);
    _sendMessage = SendMessageUseCase(repo);
    _sendReply = SendReplyUseCase(repo);
    _editMessage = EditMessageUseCase(repo);
    _deleteMessage = DeleteMessageUseCase(repo);
    return Future.value();
  }

  Future<void> sendMessage({
    required MessageEntity message,
    required String spaceId,
    required String roomId,
    String? imagePath,
    String? filePath,
  }) async {
    final isConnected = await isOnline();
    if (!isConnected) {
      throw const AppException("You're offline");
    }
    await _sendMessage(
      message: message,
      spaceId: spaceId,
      roomId: roomId,
      imagePath: imagePath,
      filePath: filePath,
    );
  }

  Future<void> sendReply({
    required ReplyEntity reply,
    required String spaceId,
    required String roomId,
    required String messageId,
  }) async {
    final isConnected = await isOnline();
    if (!isConnected) {
      throw const AppException("You're offline");
    }
    await _sendReply(
      reply: reply,
      spaceId: spaceId,
      roomId: roomId,
      messageId: messageId,
    );
  }

  Future<void> editMessage({
    required String spaceId,
    required String roomId,
    required String messageId,
    required String newMessage,
  }) async {
    final isConnected = await isOnline();
    if (!isConnected) {
      throw const AppException("You're offline");
    }
    await _editMessage(
      spaceId: spaceId,
      roomId: roomId,
      messageId: messageId,
      newMessage: newMessage,
    );
  }

  Future<void> deleteMessage({
    required String spaceId,
    required String roomId,
    required String messageId,
  }) async {
    final isConnected = await isOnline();
    if (!isConnected) {
      throw const AppException("You're offline");
    }
    await _deleteMessage(
      spaceId: spaceId,
      roomId: roomId,
      messageId: messageId,
    );
  }
}
