import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/user_entity.dart';
import '../providers/auth_provider.dart';

class AuthNotifier extends AsyncNotifier<UserEntity?> {
  @override
  Future<UserEntity?> build() async {
    final getCurrentUser = ref.read(getCurrentUserUseCaseProvider);
    return getCurrentUser.execute();
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(loginUseCaseProvider).execute(email, password),
    );
    if (state.hasError) {
      logger.e('Login failed', error: state.error);
    }
  }

  Future<void> register(
    String email,
    String password,
    UserEntity user,
  ) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(registerUseCaseProvider).execute(email, password, user),
    );
    if (state.hasError) {
      logger.e('Register failed', error: state.error);
    }
  }

  Future<void> sendPasswordResetLink(String email) async {
    try {
      await ref.read(sendPasswordResetUseCaseProvider).execute(email);
    } on AppException catch (e) {
      logger.e('Password reset failed', error: e);
      rethrow;
    }
  }

  Future<void> sendEmailVerificationLink() async {
    try {
      await ref.read(sendEmailVerificationUseCaseProvider).execute();
    } on AppException catch (e) {
      logger.e('Email verification failed', error: e);
      rethrow;
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(signOutUseCaseProvider).execute();
      return null;
    });
    if (state.hasError) {
      logger.e('Sign out failed', error: state.error);
    }
  }

  Future<void> deleteAccount() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(deleteAccountUseCaseProvider).execute();
      return null;
    });
    if (state.hasError) {
      logger.e('Delete account failed', error: state.error);
    }
  }
}
