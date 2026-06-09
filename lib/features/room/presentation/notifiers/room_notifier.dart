import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/room_entity.dart';
import '../../domain/usecases/create_room_use_case.dart';
import '../../domain/usecases/delete_room_use_case.dart';
import '../../domain/usecases/join_room_use_case.dart';
import '../../domain/usecases/leave_room_use_case.dart';
import '../../domain/usecases/update_room_use_case.dart';

class RoomNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> createRoom({
    required CreateRoomUseCase useCase,
    required RoomEntity room,
    required String spaceId,
    required String userId,
    String? imagePath,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => useCase(room, spaceId, userId, imagePath),
    );
  }

  Future<void> joinRoom({
    required JoinRoomUseCase useCase,
    required String spaceId,
    required String roomId,
    required String userId,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => useCase(spaceId, roomId, userId),
    );
  }

  Future<void> leaveRoom({
    required LeaveRoomUseCase useCase,
    required String spaceId,
    required String roomId,
    required String userId,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => useCase(spaceId, roomId, userId),
    );
  }

  Future<void> updateRoom({
    required UpdateRoomUseCase useCase,
    required String spaceId,
    required String roomId,
    String? name,
    String? desc,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => useCase(spaceId, roomId, name, desc),
    );
  }

  Future<void> deleteRoom({
    required DeleteRoomUseCase useCase,
    required String spaceId,
    required String roomId,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => useCase(spaceId, roomId),
    );
  }
}
