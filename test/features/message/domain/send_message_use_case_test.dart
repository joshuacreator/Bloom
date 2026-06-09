import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:basic_board/features/message/domain/entities/message_entity.dart';
import 'package:basic_board/features/message/domain/repositories/message_repo.dart';
import 'package:basic_board/features/message/domain/usecases/send_message_use_case.dart';

class MockMessageRepo extends Mock implements MessageRepo {}

void main() {
  late MockMessageRepo mockRepo;
  late SendMessageUseCase useCase;

  setUp(() {
    mockRepo = MockMessageRepo();
    useCase = SendMessageUseCase(mockRepo);
  });

  final now = DateTime.now();
  const testMessage = MessageEntity(
    id: '1',
    message: 'Hello',
    senderId: 'user1',
    time: null,
  );

  test('returns message on successful send', () async {
    when(() => mockRepo.sendMessage(any())).thenAnswer((_) async => testMessage);

    final result = await useCase.execute(
      message: 'Hello',
      senderId: 'user1',
      roomId: 'room1',
    );

    expect(result, equals(testMessage));
    verify(() => mockRepo.sendMessage(any())).called(1);
  });

  test('throws when repo throws', () async {
    when(() => mockRepo.sendMessage(any())).thenThrow(Exception('Send failed'));

    expect(
      () => useCase.execute(
        message: 'Hello',
        senderId: 'user1',
        roomId: 'room1',
      ),
      throwsA(isA<Exception>()),
    );
  });
}
