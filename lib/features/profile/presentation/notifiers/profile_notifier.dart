import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/profile_entity.dart';
import '../providers/profile_providers.dart';

class ProfileNotifier extends Notifier<AsyncValue<ProfileEntity?>> {
  @override
  AsyncValue<ProfileEntity?> build() => const AsyncData(null);

  Future<void> getProfile(String userId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(getProfileUseCaseProvider)(userId),
    );
  }

  Future<void> updateProfile(ProfileEntity profile) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(updateProfileUseCaseProvider)(profile);
      return profile;
    });
  }

  Future<void> updateProfileImage(String userId, String imagePath) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(updateProfileImageUseCaseProvider)(userId, imagePath);
      return state.value;
    });
  }

  Future<void> deleteAccount() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () async {
        await ref.read(deleteAccountUseCaseProvider)();
        return state.value;
      },
    );
  }
}

final profileNotifierProvider =
    NotifierProvider<ProfileNotifier, AsyncValue<ProfileEntity?>>(
  ProfileNotifier.new,
);
