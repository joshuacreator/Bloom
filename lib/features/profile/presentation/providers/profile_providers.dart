import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/repositories/profile_repo_impl.dart';
import '../../domain/repositories/profile_repo.dart';
import '../../domain/usecases/delete_account_use_case.dart';
import '../../domain/usecases/get_profile_use_case.dart';
import '../../domain/usecases/update_profile_image_use_case.dart';
import '../../domain/usecases/update_profile_use_case.dart';
import '../notifiers/theme_notifier.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Must be overridden in main.dart');
});

final firestoreInstanceProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);

final firebaseStorageInstanceProvider = Provider<FirebaseStorage>(
  (ref) => FirebaseStorage.instance,
);

final profileRepoProvider = Provider<ProfileRepo>(
  (ref) => ProfileRepoImpl(
    firestore: ref.watch(firestoreInstanceProvider),
    storage: ref.watch(firebaseStorageInstanceProvider),
  ),
);

final getProfileUseCaseProvider = Provider<GetProfileUseCase>(
  (ref) => GetProfileUseCase(ref.watch(profileRepoProvider)),
);

final updateProfileUseCaseProvider = Provider<UpdateProfileUseCase>(
  (ref) => UpdateProfileUseCase(ref.watch(profileRepoProvider)),
);

final updateProfileImageUseCaseProvider = Provider<UpdateProfileImageUseCase>(
  (ref) => UpdateProfileImageUseCase(ref.watch(profileRepoProvider)),
);

final deleteAccountUseCaseProvider = Provider<DeleteAccountUseCase>(
  (ref) => DeleteAccountUseCase(ref.watch(profileRepoProvider)),
);

final themeSelectorProvider = NotifierProvider<ThemeNotifier, ThemeMode>(
  ThemeNotifier.new,
);
