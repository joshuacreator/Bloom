import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:basic_board/features/space/domain/entities/space_entity.dart';
import 'package:basic_board/features/space/domain/repositories/space_repo.dart';
import 'package:basic_board/features/space/domain/usecases/create_space_use_case.dart';

class MockSpaceRepo extends Mock implements SpaceRepo {}

void main() {
  late MockSpaceRepo mockRepo;
  late CreateSpaceUseCase useCase;

  setUp(() {
    mockRepo = MockSpaceRepo();
    useCase = CreateSpaceUseCase(mockRepo);
  });

  const testSpace = SpaceEntity(
    id: '1',
    name: 'Test Space',
    desc: 'A test space',
    private: false,
  );

  test('returns space on successful creation', () async {
    when(() => mockRepo.createSpace(any())).thenAnswer((_) async => testSpace);

    final result = await useCase.execute(
      name: 'Test Space',
      desc: 'A test space',
      private: false,
    );

    expect(result, equals(testSpace));
    verify(() => mockRepo.createSpace(any())).called(1);
  });

  test('throws when repo throws', () async {
    when(() => mockRepo.createSpace(any())).thenThrow(Exception('Creation failed'));

    expect(
      () => useCase.execute(name: 'Test Space', desc: 'A test space', private: false),
      throwsA(isA<Exception>()),
    );
  });
}
