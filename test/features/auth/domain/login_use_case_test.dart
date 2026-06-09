import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:basic_board/features/auth/domain/entities/user_entity.dart';
import 'package:basic_board/features/auth/domain/repositories/auth_repo.dart';
import 'package:basic_board/features/auth/domain/usecases/login_use_case.dart';

class MockAuthRepo extends Mock implements AuthRepo {}

void main() {
  late MockAuthRepo mockRepo;
  late LoginUseCase useCase;

  setUp(() {
    mockRepo = MockAuthRepo();
    useCase = LoginUseCase(mockRepo);
  });

  const testUser = UserEntity(userId: '1', name: 'Test', email: 'test@test.com', phone: 0);

  test('returns user on successful login', () async {
    when(() => mockRepo.login(any(), any())).thenAnswer((_) async => testUser);

    final result = await useCase.execute('test@test.com', 'password');

    expect(result, equals(testUser));
    verify(() => mockRepo.login('test@test.com', 'password')).called(1);
  });

  test('throws when repo throws', () async {
    when(() => mockRepo.login(any(), any())).thenThrow(Exception('Login failed'));

    expect(() => useCase.execute('test@test.com', 'wrong'), throwsA(isA<Exception>()));
  });
}
