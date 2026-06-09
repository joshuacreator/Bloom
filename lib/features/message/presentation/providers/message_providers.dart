import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/message_repo_impl.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/entities/reply_entity.dart';
import '../../domain/repositories/message_repo.dart';
import '../notifiers/message_notifier.dart';

final messageRepoProvider = Provider<MessageRepo>(
  (ref) => MessageRepoImpl(),
);

final messageNotifierProvider =
    AutoDisposeAsyncNotifierProvider<MessageNotifier, void>(
  MessageNotifier.new,
);

final messagesStreamProvider = StreamProvider.family<List<MessageEntity>, ({String spaceId, String roomId})>(
  (ref, params) {
    final repo = ref.watch(messageRepoProvider);
    return repo.observeMessages(params.spaceId, params.roomId);
  },
);

final messageStreamProvider = StreamProvider.family<MessageEntity?, ({String spaceId, String roomId, String messageId})>(
  (ref, params) {
    final repo = ref.watch(messageRepoProvider);
    return repo.observeMessage(params.spaceId, params.roomId, params.messageId);
  },
);

final lastMessageStreamProvider = StreamProvider.family<MessageEntity?, ({String spaceId, String roomId})>(
  (ref, params) {
    final repo = ref.watch(messageRepoProvider);
    return repo.observeLastMessage(params.spaceId, params.roomId);
  },
);

final repliesStreamProvider = StreamProvider.family<List<ReplyEntity>, ({String spaceId, String roomId, String messageId})>(
  (ref, params) {
    final repo = ref.watch(messageRepoProvider);
    return repo.observeReplies(
      params.spaceId,
      params.roomId,
      params.messageId,
    );
  },
);

final repliesCountStreamProvider = StreamProvider.family<int, ({String spaceId, String roomId, String messageId})>(
  (ref, params) {
    final repo = ref.watch(messageRepoProvider);
    return repo.observeRepliesCount(
      params.spaceId,
      params.roomId,
      params.messageId,
    );
  },
);

final likesCountStreamProvider = StreamProvider.family<int, ({String spaceId, String roomId, String messageId})>(
  (ref, params) {
    final repo = ref.watch(messageRepoProvider);
    return repo.observeLikesCount(
      params.spaceId,
      params.roomId,
      params.messageId,
    );
  },
);
