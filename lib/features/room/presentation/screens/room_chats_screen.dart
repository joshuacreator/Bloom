import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/widgets/loading_indicator.dart';
import '../../../../common/widgets/snack_bar.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../message/presentation/providers/message_providers.dart';
import '../../domain/entities/room_entity.dart';
import '../providers/room_providers.dart';

class RoomChatsScreen extends ConsumerStatefulWidget {
  static const String id = 'room-chats';

  const RoomChatsScreen({super.key, this.spaceId});

  final String? spaceId;

  @override
  ConsumerState<RoomChatsScreen> createState() => _RoomChatsScreenState();
}

class _RoomChatsScreenState extends ConsumerState<RoomChatsScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authStateProvider).valueOrNull;
    final spaceId = widget.spaceId ?? '';
    final roomsAsync = ref.watch(observeRoomsProvider(spaceId));

    return Scaffold(
      appBar: AppBar(
        title: Text(spaceId),
        actions: [
          IconButton(
            onPressed: () {
              context.push(
                '/${RoomChatsScreen.id}/create',
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: roomsAsync.when(
        data: (rooms) {
          if (rooms.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: const Text(
                  'You have not joined any Rooms in this Space yet',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.only(top: 8),
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              final room = rooms[index];
              final isParticipant =
                  auth != null && room.participants.contains(auth.userId);

              if (!isParticipant) return const SizedBox.shrink();

              return _RoomListItem(
                room: room,
                spaceId: spaceId,
              );
            },
          );
        },
        error: (error, _) => Center(
          child: Text('An error occurred: $error'),
        ),
        loading: () => const LoadingIndicator(),
      ),
    );
  }
}

class _RoomListItem extends ConsumerWidget {
  const _RoomListItem({
    required this.room,
    required this.spaceId,
  });

  final RoomEntity room;
  final String spaceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateProvider).valueOrNull;

    final lastMessageAsync = ref.watch(
      lastMessageStreamProvider((spaceId: spaceId, roomId: room.id ?? '')),
    );
    final lastMessage = lastMessageAsync.valueOrNull;
    final senderId = lastMessage?.senderId ?? '';
    final isMe = auth?.userId == senderId;
    final lastMsg = lastMessage?.message ?? '';
    final subtitle = lastMsg.isEmpty
        ? 'No messages yet'
        : isMe
            ? '~me: $lastMsg'
            : '~$senderId: $lastMsg';

    return ListTile(
      leading: CircleAvatar(
        radius: AppConstants.circularAvatarRadius,
        backgroundImage: CachedNetworkImageProvider(
          (room.image == null || room.image!.isEmpty)
              ? AppConstants.defaultRoomImgPath
              : room.image!,
        ),
      ),
      title: Text(
        room.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 16),
      ),
      subtitle: subtitle.isEmpty
          ? null
          : Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
      onTap: () {
        context.push(
          '${RoomChatsScreen.id}/msg/$spaceId',
          extra: room,
        );
      },
    );
  }
}
