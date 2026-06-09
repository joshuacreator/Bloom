import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:basic_board/features/room/domain/entities/room_entity.dart';
import 'package:basic_board/features/room/domain/repositories/room_repo.dart';
import 'package:basic_board/features/room/domain/usecases/create_room_use_case.dart';

class MockRoomRepo extends Mock implements RoomRepo {}

void main() {
  late MockRoomRepo mockRepo;
  late CreateRoomUseCase useCase;

  setUp(() {
    mockRepo = MockRoomRepo();
    useCase = CreateRoomUseCase(mockRepo);
  });

  const testRoom = RoomEntity(
    id: '1',
    name: 'General',
    creatorId: 'user1',
    private: false,
  );

  test('returns room on successful creation', () async {
    when(() => mockRepo.createRoom(any())).thenAnswer((_) async => testRoom);

    final result = await useCase.execute(
      name: 'General',
      creatorId: 'user1',
      spaceId: 'space1',
      private: false,
    );

    expect(result, equals(testRoom));
    verify(() => mockRepo.createRoom(any())).called(1);
  });

  test('throws when repo throws', () async {
    when(() => mockRepo.createRoom(any())).thenThrow(Exception('Creation failed'));

    expect(
      () => useCase.execute(
        name: 'General',
        creatorId: 'user1',
        spaceId: 'space1',
        private: false,
      ),
      throwsA(isA<Exception>()),
    );
  });
}
