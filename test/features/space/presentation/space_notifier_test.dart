import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:basic_board/features/space/domain/entities/space_entity.dart';
import 'package:basic_board/features/space/domain/repositories/space_repo.dart';
import 'package:basic_board/features/space/presentation/notifiers/space_notifier.dart';
import 'package:basic_board/features/space/presentation/providers/space_provider.dart';

class MockSpaceRepo extends Mock implements SpaceRepo {}

void main() {
  late MockSpaceRepo mockRepo;
  late ProviderContainer container;

  const testSpace = SpaceEntity(
    id: '1',
    name: 'Test Space',
    desc: 'A test space',
    private: false,
  );

  setUp(() {
    mockRepo = MockSpaceRepo();
    container = ProviderContainer(
      overrides: [
        spaceRepoProvider.overrideWithValue(mockRepo),
      ],
    );
  });

  tearDown(() => container.dispose());

  group('createSpace', () {
    test('emits space on success', () async {
      when(() => mockRepo.createSpace(any())).thenAnswer((_) async => testSpace);

      final notifier = container.read(spaceNotifierProvider.notifier);
      await notifier.createSpace(
        name: 'Test Space',
        desc: 'A test space',
        private: false,
      );

      final state = container.read(spaceNotifierProvider);
      expect(state.value, equals(testSpace));
      verify(() => mockRepo.createSpace(any())).called(1);
    });

    test('emits error when creation fails', () async {
      when(() => mockRepo.createSpace(any())).thenThrow(Exception('Creation failed'));

      final notifier = container.read(spaceNotifierProvider.notifier);
      await notifier.createSpace(
        name: 'Test Space',
        desc: 'A test space',
        private: false,
      );

      final state = container.read(spaceNotifierProvider);
      expect(state.hasError, isTrue);
      expect(state.error, isA<Exception>());
    });
  });
}
