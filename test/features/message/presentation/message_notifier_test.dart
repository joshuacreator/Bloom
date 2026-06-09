import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:basic_board/features/message/domain/entities/message_entity.dart';
import 'package:basic_board/features/message/domain/repositories/message_repo.dart';
import 'package:basic_board/features/message/presentation/notifiers/message_notifier.dart';
import 'package:basic_board/features/message/presentation/providers/message_provider.dart';

class MockMessageRepo extends Mock implements MessageRepo {}

void main() {
  late MockMessageRepo mockRepo;
  late ProviderContainer container;

  const testMessage = MessageEntity(
    id: '1',
    message: 'Hello',
    senderId: 'user1',
    time: null,
  );

  setUp(() {
    mockRepo = MockMessageRepo();
    container = ProviderContainer(
      overrides: [
        messageRepoProvider.overrideWithValue(mockRepo),
      ],
    );
  });

  tearDown(() => container.dispose());

  group('sendMessage', () {
    test('emits message on success', () async {
      when(() => mockRepo.sendMessage(any())).thenAnswer((_) async => testMessage);

      final notifier = container.read(messageNotifierProvider.notifier);
      await notifier.sendMessage(
        message: 'Hello',
        senderId: 'user1',
        roomId: 'room1',
      );

      final state = container.read(messageNotifierProvider);
      expect(state.value, equals(testMessage));
      verify(() => mockRepo.sendMessage(any())).called(1);
    });

    test('emits error when send fails', () async {
      when(() => mockRepo.sendMessage(any())).thenThrow(Exception('Send failed'));

      final notifier = container.read(messageNotifierProvider.notifier);
      await notifier.sendMessage(
        message: 'Hello',
        senderId: 'user1',
        roomId: 'room1',
      );

      final state = container.read(messageNotifierProvider);
      expect(state.hasError, isTrue);
      expect(state.error, isA<Exception>());
    });
  });
}
