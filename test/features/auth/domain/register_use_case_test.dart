import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:basic_board/features/auth/domain/entities/user_entity.dart';
import 'package:basic_board/features/auth/domain/repositories/auth_repo.dart';
import 'package:basic_board/features/auth/domain/usecases/register_use_case.dart';

class MockAuthRepo extends Mock implements AuthRepo {}

void main() {
  late MockAuthRepo mockRepo;
  late RegisterUseCase useCase;

  setUp(() {
    mockRepo = MockAuthRepo();
    useCase = RegisterUseCase(mockRepo);
  });

  const testUser = UserEntity(userId: '1', name: 'Test', email: 'test@test.com', phone: 0);

  test('returns user on successful registration', () async {
    when(() => mockRepo.register(any(), any(), any())).thenAnswer((_) async => testUser);

    final result = await useCase.execute('test@test.com', 'password', testUser);

    expect(result, equals(testUser));
    verify(() => mockRepo.register('test@test.com', 'password', testUser)).called(1);
  });

  test('throws when repo throws', () async {
    when(() => mockRepo.register(any(), any(), any())).thenThrow(Exception('Registration failed'));

    expect(
      () => useCase.execute('test@test.com', 'password', testUser),
      throwsA(isA<Exception>()),
    );
  });
}
