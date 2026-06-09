import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:basic_board/features/room/domain/entities/room_entity.dart';
import 'package:basic_board/features/room/domain/repositories/room_repo.dart';
import 'package:basic_board/features/room/presentation/notifiers/room_notifier.dart';
import 'package:basic_board/features/room/presentation/providers/room_provider.dart';

class MockRoomRepo extends Mock implements RoomRepo {}

void main() {
  late MockRoomRepo mockRepo;
  late ProviderContainer container;

  const testRoom = RoomEntity(
    id: '1',
    name: 'General',
    creatorId: 'user1',
    private: false,
  );

  setUp(() {
    mockRepo = MockRoomRepo();
    container = ProviderContainer(
      overrides: [
        roomRepoProvider.overrideWithValue(mockRepo),
      ],
    );
  });

  tearDown(() => container.dispose());

  group('createRoom', () {
    test('emits room on success', () async {
      when(() => mockRepo.createRoom(any())).thenAnswer((_) async => testRoom);

      final notifier = container.read(roomNotifierProvider.notifier);
      await notifier.createRoom(
        name: 'General',
        creatorId: 'user1',
        spaceId: 'space1',
        private: false,
      );

      final state = container.read(roomNotifierProvider);
      expect(state.value, equals(testRoom));
      verify(() => mockRepo.createRoom(any())).called(1);
    });

    test('emits error when creation fails', () async {
      when(() => mockRepo.createRoom(any())).thenThrow(Exception('Creation failed'));

      final notifier = container.read(roomNotifierProvider.notifier);
      await notifier.createRoom(
        name: 'General',
        creatorId: 'user1',
        spaceId: 'space1',
        private: false,
      );

      final state = container.read(roomNotifierProvider);
      expect(state.hasError, isTrue);
      expect(state.error, isA<Exception>());
    });
  });
}
