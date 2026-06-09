import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/space_repo_impl.dart';
import '../../domain/entities/space_entity.dart';
import '../../domain/repositories/space_repo.dart';
import '../../domain/usecases/create_space_use_case.dart';
import '../../domain/usecases/delete_space_use_case.dart';
import '../../domain/usecases/join_space_use_case.dart';
import '../../domain/usecases/leave_space_use_case.dart';
import '../../domain/usecases/observe_spaces_use_case.dart';
import '../../domain/usecases/update_space_use_case.dart';
import '../../../../providers/firestore_provider.dart';
import '../../../../providers/firebase_storage_provider.dart';

final spaceRepoProvider = Provider<SpaceRepo>((ref) {
  final firestore = ref.watch(firestoreProvider);
  final storage = ref.watch(firebaseStorageProvider);
  return SpaceRepoImpl(firestore, storage);
});

final createSpaceUseCaseProvider = Provider<CreateSpaceUseCase>((ref) {
  return CreateSpaceUseCase(ref.watch(spaceRepoProvider));
});

final joinSpaceUseCaseProvider = Provider<JoinSpaceUseCase>((ref) {
  return JoinSpaceUseCase(ref.watch(spaceRepoProvider));
});

final leaveSpaceUseCaseProvider = Provider<LeaveSpaceUseCase>((ref) {
  return LeaveSpaceUseCase(ref.watch(spaceRepoProvider));
});

final updateSpaceUseCaseProvider = Provider<UpdateSpaceUseCase>((ref) {
  return UpdateSpaceUseCase(ref.watch(spaceRepoProvider));
});

final deleteSpaceUseCaseProvider = Provider<DeleteSpaceUseCase>((ref) {
  return DeleteSpaceUseCase(ref.watch(spaceRepoProvider));
});

final observeSpacesUseCaseProvider = Provider<ObserveSpacesUseCase>((ref) {
  return ObserveSpacesUseCase(ref.watch(spaceRepoProvider));
});

class SpaceNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> createSpace(SpaceEntity space, String userId, String? imagePath) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(createSpaceUseCaseProvider)(space, userId, imagePath),
    );
  }

  Future<void> joinSpace(String spaceId, String userId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(joinSpaceUseCaseProvider)(spaceId, userId),
    );
  }

  Future<void> leaveSpace(String spaceId, String userId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(leaveSpaceUseCaseProvider)(spaceId, userId),
    );
  }

  Future<void> updateSpace(String spaceId, String? name, String? desc) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(updateSpaceUseCaseProvider)(spaceId, name, desc),
    );
  }

  Future<void> deleteSpace(String spaceId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(deleteSpaceUseCaseProvider)(spaceId),
    );
  }
}

final spaceNotifierProvider = AsyncNotifierProvider<SpaceNotifier, void>(
  SpaceNotifier.new,
);
