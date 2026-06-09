import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../providers/firebase_storage_provider.dart';
import '../../../../providers/firestore_provider.dart';
import '../../data/repositories/room_repo_impl.dart';
import '../../domain/entities/room_entity.dart';
import '../../domain/repositories/room_repo.dart';
import '../../domain/usecases/create_room_use_case.dart';
import '../../domain/usecases/delete_room_use_case.dart';
import '../../domain/usecases/join_room_use_case.dart';
import '../../domain/usecases/leave_room_use_case.dart';
import '../../domain/usecases/observe_rooms_use_case.dart';
import '../../domain/usecases/update_room_use_case.dart';
import '../notifiers/room_notifier.dart';

final roomRepoProvider = Provider<RoomRepo>((ref) {
  final firestore = ref.watch(firestoreProvider);
  final storage = ref.watch(firebaseStorageProvider);
  return RoomRepoImpl(firestore, storage);
});

final createRoomUseCaseProvider = Provider<CreateRoomUseCase>((ref) {
  return CreateRoomUseCase(ref.watch(roomRepoProvider));
});

final joinRoomUseCaseProvider = Provider<JoinRoomUseCase>((ref) {
  return JoinRoomUseCase(ref.watch(roomRepoProvider));
});

final leaveRoomUseCaseProvider = Provider<LeaveRoomUseCase>((ref) {
  return LeaveRoomUseCase(ref.watch(roomRepoProvider));
});

final updateRoomUseCaseProvider = Provider<UpdateRoomUseCase>((ref) {
  return UpdateRoomUseCase(ref.watch(roomRepoProvider));
});

final deleteRoomUseCaseProvider = Provider<DeleteRoomUseCase>((ref) {
  return DeleteRoomUseCase(ref.watch(roomRepoProvider));
});

final observeRoomsUseCaseProvider = Provider<ObserveRoomsUseCase>((ref) {
  return ObserveRoomsUseCase(ref.watch(roomRepoProvider));
});

final roomNotifierProvider = AsyncNotifierProvider<RoomNotifier, void>(
  RoomNotifier.new,
);

// Stream providers

final observeRoomsProvider =
    StreamProvider.family<List<RoomEntity>, String>(
  (ref, spaceId) => ref.watch(roomRepoProvider).observeRooms(spaceId),
);

typedef RoomParams = ({String spaceId, String roomId});

final observeRoomProvider =
    StreamProvider.family<RoomEntity?, RoomParams>(
  (ref, params) =>
      ref.watch(roomRepoProvider).observeRoom(params.spaceId, params.roomId),
);

final observeParticipantsProvider =
    StreamProvider.family<List<String>, RoomParams>(
  (ref, params) => ref
      .watch(roomRepoProvider)
      .observeParticipants(params.spaceId, params.roomId),
);
