import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:basic_board/features/auth/domain/entities/user_entity.dart';
import 'package:basic_board/features/auth/domain/repositories/auth_repo.dart';
import 'package:basic_board/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:basic_board/features/auth/presentation/providers/auth_provider.dart';

class MockAuthRepo extends Mock implements AuthRepo {}

void main() {
  late MockAuthRepo mockRepo;
  late ProviderContainer container;

  const testUser = UserEntity(userId: '1', name: 'Test', email: 'test@test.com', phone: 0);

  setUp(() {
    mockRepo = MockAuthRepo();
    container = ProviderContainer(
      overrides: [
        authRepoProvider.overrideWithValue(mockRepo),
      ],
    );
  });

  tearDown(() => container.dispose());

  group('login', () {
    test('emits logged-in user on success', () async {
      when(() => mockRepo.login(any(), any())).thenAnswer((_) async => testUser);

      final notifier = container.read(authNotifierProvider.notifier);
      await notifier.login('test@test.com', 'password');

      final state = container.read(authNotifierProvider);
      expect(state.value, equals(testUser));
      verify(() => mockRepo.login('test@test.com', 'password')).called(1);
    });

    test('emits error when login fails', () async {
      when(() => mockRepo.login(any(), any())).thenThrow(Exception('Login failed'));

      final notifier = container.read(authNotifierProvider.notifier);
      await notifier.login('test@test.com', 'wrong');

      final state = container.read(authNotifierProvider);
      expect(state.hasError, isTrue);
      expect(state.error, isA<Exception>());
    });
  });

  group('register', () {
    test('emits registered user on success', () async {
      when(() => mockRepo.register(any(), any(), any())).thenAnswer((_) async => testUser);

      final notifier = container.read(authNotifierProvider.notifier);
      await notifier.register('test@test.com', 'password', testUser);

      final state = container.read(authNotifierProvider);
      expect(state.value, equals(testUser));
      verify(() => mockRepo.register('test@test.com', 'password', testUser)).called(1);
    });

    test('emits error when registration fails', () async {
      when(() => mockRepo.register(any(), any(), any())).thenThrow(Exception('Registration failed'));

      final notifier = container.read(authNotifierProvider.notifier);
      await notifier.register('test@test.com', 'password', testUser);

      final state = container.read(authNotifierProvider);
      expect(state.hasError, isTrue);
    });
  });

  group('signOut', () {
    test('clears user state on success', () async {
      when(() => mockRepo.signOut()).thenAnswer((_) async {});
      when(() => mockRepo.login(any(), any())).thenAnswer((_) async => testUser);

      final notifier = container.read(authNotifierProvider.notifier);
      await notifier.login('test@test.com', 'password');
      expect(container.read(authNotifierProvider).value, equals(testUser));

      await notifier.signOut();
      expect(container.read(authNotifierProvider).value, isNull);
      verify(() => mockRepo.signOut()).called(1);
    });

    test('emits error when signOut fails', () async {
      when(() => mockRepo.signOut()).thenThrow(Exception('Sign out failed'));

      final notifier = container.read(authNotifierProvider.notifier);
      await notifier.signOut();

      final state = container.read(authNotifierProvider);
      expect(state.hasError, isTrue);
    });
  });

  group('sendPasswordReset', () {
    test('succeeds without emitting user', () async {
      when(() => mockRepo.sendPasswordReset(any())).thenAnswer((_) async {});

      final notifier = container.read(authNotifierProvider.notifier);
      await notifier.sendPasswordReset('test@test.com');

      verify(() => mockRepo.sendPasswordReset('test@test.com')).called(1);
    });

    test('emits error when reset fails', () async {
      when(() => mockRepo.sendPasswordReset(any())).thenThrow(Exception('Reset failed'));

      final notifier = container.read(authNotifierProvider.notifier);
      await notifier.sendPasswordReset('test@test.com');

      final state = container.read(authNotifierProvider);
      expect(state.hasError, isTrue);
    });
  });
}
