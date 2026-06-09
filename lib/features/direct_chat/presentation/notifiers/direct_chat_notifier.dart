import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/direct_message_entity.dart';
import '../../domain/usecases/observe_direct_chats_use_case.dart';
import '../../domain/usecases/send_direct_message_use_case.dart';

class DirectChatNotifier extends StateNotifier<AsyncValue<List<DirectMessageEntity>>> {
  final ObserveDirectChatsUseCase _observeUseCase;
  final SendDirectMessageUseCase _sendUseCase;
  StreamSubscription<List<DirectMessageEntity>>? _subscription;

  DirectChatNotifier({
    required ObserveDirectChatsUseCase observeUseCase,
    required SendDirectMessageUseCase sendUseCase,
    required String userId,
  })  : _observeUseCase = observeUseCase,
        _sendUseCase = sendUseCase,
        super(const AsyncValue.loading()) {
    _startObserving(userId);
  }

  void _startObserving(String userId) {
    _subscription = _observeUseCase(userId).listen(
      (chats) {
        state = AsyncValue.data(chats);
      },
      onError: (error, stack) {
        state = AsyncValue.error(error, stack);
      },
    );
  }

  Future<void> sendMessage(DirectMessageEntity message) async {
    try {
      await _sendUseCase(message);
    } catch (e) {
      rethrow;
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
