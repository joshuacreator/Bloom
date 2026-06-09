import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/direct_chat_repo_impl.dart';
import '../../domain/entities/direct_message_entity.dart';
import '../../domain/repositories/direct_chat_repo.dart';
import '../../domain/usecases/observe_direct_chats_use_case.dart';
import '../../domain/usecases/send_direct_message_use_case.dart';
import '../notifiers/direct_chat_notifier.dart';

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final directChatRepoProvider = Provider<DirectChatRepo>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return DirectChatRepoImpl(firestore);
});

final observeDirectChatsUseCaseProvider = Provider<ObserveDirectChatsUseCase>((ref) {
  final repo = ref.watch(directChatRepoProvider);
  return ObserveDirectChatsUseCase(repo);
});

final sendDirectMessageUseCaseProvider = Provider<SendDirectMessageUseCase>((ref) {
  final repo = ref.watch(directChatRepoProvider);
  return SendDirectMessageUseCase(repo);
});

final directChatNotifierProvider =
    StateNotifierProvider.family<DirectChatNotifier, AsyncValue<List<DirectMessageEntity>>, String>(
  (ref, userId) {
    final observeUseCase = ref.watch(observeDirectChatsUseCaseProvider);
    final sendUseCase = ref.watch(sendDirectMessageUseCaseProvider);
    return DirectChatNotifier(
      observeUseCase: observeUseCase,
      sendUseCase: sendUseCase,
      userId: userId,
    );
  },
);
