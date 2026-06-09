import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:basic_board/features/auth/domain/entities/user_entity.dart';
import 'package:basic_board/features/profile/domain/repositories/profile_repo.dart';
import 'package:basic_board/features/profile/domain/usecases/update_profile_use_case.dart';

class MockProfileRepo extends Mock implements ProfileRepo {}

void main() {
  late MockProfileRepo mockRepo;
  late UpdateProfileUseCase useCase;

  setUp(() {
    mockRepo = MockProfileRepo();
    useCase = UpdateProfileUseCase(mockRepo);
  });

  const testUser = UserEntity(userId: '1', name: 'Updated', email: 'test@test.com', phone: 1234567890);

  test('returns updated user on success', () async {
    when(() => mockRepo.updateProfile(any())).thenAnswer((_) async => testUser);

    final result = await useCase.execute(
      userId: '1',
      name: 'Updated',
      phone: 1234567890,
    );

    expect(result, equals(testUser));
    verify(() => mockRepo.updateProfile(any())).called(1);
  });

  test('throws when repo throws', () async {
    when(() => mockRepo.updateProfile(any())).thenThrow(Exception('Update failed'));

    expect(
      () => useCase.execute(userId: '1', name: 'Updated', phone: 1234567890),
      throwsA(isA<Exception>()),
    );
  });
}
