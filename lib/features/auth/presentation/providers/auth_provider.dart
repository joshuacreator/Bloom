import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/auth_repo_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repo.dart';
import '../../domain/usecases/delete_account_use_case.dart';
import '../../domain/usecases/get_current_user_use_case.dart';
import '../../domain/usecases/login_use_case.dart';
import '../../domain/usecases/observe_auth_state_use_case.dart';
import '../../domain/usecases/register_use_case.dart';
import '../../domain/usecases/send_email_verification_use_case.dart';
import '../../domain/usecases/send_password_reset_use_case.dart';
import '../../domain/usecases/sign_out_use_case.dart';
import '../notifiers/auth_notifier.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final authRepoProvider = Provider<AuthRepo>((ref) {
  return AuthRepoImpl(
    firebaseAuth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firestoreProvider),
  );
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.watch(authRepoProvider));
});

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  return RegisterUseCase(ref.watch(authRepoProvider));
});

final sendPasswordResetUseCaseProvider = Provider<SendPasswordResetUseCase>(
  (ref) => SendPasswordResetUseCase(ref.watch(authRepoProvider)),
);

final signOutUseCaseProvider = Provider<SignOutUseCase>(
  (ref) => SignOutUseCase(ref.watch(authRepoProvider)),
);

final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>(
  (ref) => GetCurrentUserUseCase(ref.watch(authRepoProvider)),
);

final observeAuthStateUseCaseProvider = Provider<ObserveAuthStateUseCase>(
  (ref) => ObserveAuthStateUseCase(ref.watch(authRepoProvider)),
);

final sendEmailVerificationUseCaseProvider =
    Provider<SendEmailVerificationUseCase>(
  (ref) => SendEmailVerificationUseCase(ref.watch(authRepoProvider)),
);

final deleteAccountUseCaseProvider = Provider<DeleteAccountUseCase>(
  (ref) => DeleteAccountUseCase(ref.watch(authRepoProvider)),
);

final authNotifierProvider =
    AsyncNotifierProvider<AuthNotifier, UserEntity?>(AuthNotifier.new);

final authStateProvider = StreamProvider<UserEntity?>((ref) {
  return ref.watch(observeAuthStateUseCaseProvider).execute();
});

final userProvider = Provider<UserEntity?>((ref) {
  return ref.watch(authStateProvider).valueOrNull;
});

final anyUserProvider =
    Provider.family<Stream<UserEntity?>, String>((ref, userId) {
  return ref.watch(authRepoProvider).getUserById(userId);
});
