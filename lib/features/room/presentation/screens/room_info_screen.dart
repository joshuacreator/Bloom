import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../common/widgets/app_button.dart';
import '../../../../common/widgets/app_text_buttons.dart';
import '../../../../common/widgets/app_text_field.dart';
import '../../../../common/widgets/image_viewer.dart';
import '../../../../common/widgets/loading_indicator.dart';
import '../../../../common/widgets/seperator.dart';
import '../../../../common/widgets/show_more_text.dart';
import '../../../../common/widgets/snack_bar.dart';
import '../../../../common/widgets/user_tile.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../config/firebase_providers.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/users_providers.dart';
import '../../../../services/connection_state.dart';
import '../../../../services/image_helper.dart';
import '../../../../services/room_db.dart';
import '../../domain/entities/room_entity.dart';
import '../providers/room_providers.dart';

class RoomInfoScreen extends ConsumerStatefulWidget {
  static const String id = 'room-info';

  const RoomInfoScreen({
    super.key,
    required this.room,
    required this.spaceId,
  });

  final RoomEntity room;
  final String spaceId;

  @override
  ConsumerState<RoomInfoScreen> createState() => _RoomInfoScreenState();
}

class _RoomInfoScreenState extends ConsumerState<RoomInfoScreen> {
  final _imageHelper = ImageHelper();
  String? _fileImage;
  late TextEditingController _nameController;
  late TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.room.name);
    _descController = TextEditingController(text: widget.room.desc ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authStateProvider).value!;
    final creator = ref.watch(anyUserProvider(widget.room.creatorId));

    final roomParams = (spaceId: widget.spaceId, roomId: widget.room.id!);
    final roomAsync = ref.watch(observeRoomProvider(roomParams));
    final participantsAsync =
        ref.watch(observeParticipantsProvider(roomParams));

    return Scaffold(
      appBar: AppBar(
        actions: [
          _buildMenu(
            context,
            userId: auth.uid,
            isCreator: auth.uid == widget.room.creatorId,
          ),
        ],
      ),
      body: participantsAsync.when(
        data: (participantIds) {
          return ListView(
            shrinkWrap: true,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => ImageViewer(
                        image: (widget.room.image == null ||
                                widget.room.image!.isEmpty)
                            ? AppConstants.defaultRoomImgPath
                            : widget.room.image!,
                      ),
                    ),
                    child: Hero(
                      tag: 'room-display-img',
                      child: _fileImage != null
                          ? CircleAvatar(
                              radius: context.defaultSize * 2,
                              backgroundImage: FileImage(File(_fileImage!)),
                            )
                          : CircleAvatar(
                              radius: context.defaultSize * 2,
                              backgroundImage: CachedNetworkImageProvider(
                                (widget.room.image == null ||
                                        widget.room.image!.isEmpty)
                                    ? AppConstants.defaultRoomImgPath
                                    : widget.room.image!,
                              ),
                            ),
                    ),
                  ),
                  AppConstants.height16,
                  Text(
                    widget.room.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20),
                  ),
                  AppConstants.height8,
                  Text(
                    'Created by ${creator.value?['name'] ?? ''}',
                    style: AppTextStyles.intro,
                  ),
                  AppConstants.height8,
                  const Separator(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _ActionsTile(
                        icon: Icons.call_rounded,
                        onTap: () {},
                      ),
                      const SizedBox(width: 20),
                      _ActionsTile(
                        icon: Icons.videocam_rounded,
                        onTap: () {},
                      ),
                    ],
                  ),
                  const Separator(),
                  if (widget.room.desc != null &&
                      widget.room.desc!.isNotEmpty)
                    Column(
                      children: [
                        AppShowMoreText(text: widget.room.desc!),
                        const Separator(),
                      ],
                    ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Row(
                      children: [
                        Text(
                          'Participants(${participantIds.length})',
                          style: AppTextStyles.intro,
                        ),
                      ],
                    ),
                  ),
                  AppConstants.height8,
                  ...participantIds.map((pid) {
                    final isMe = pid == auth.uid;
                    final userData =
                        ref.watch(anyUserProvider(pid)).value;

                    return UserTile(
                      title: isMe
                          ? '${userData?['name'] ?? ''} (You)'
                          : '${userData?['name'] ?? ''}',
                      image: userData?['image'] as String? ??
                          AppConstants.defaultUserImgPath,
                      tag: isMe ? '' : 'user-tag',
                      onTap: isMe
                          ? null
                          : () {
                              // Navigate to user profile
                            },
                    );
                  }),
                ],
              ),
            ],
          );
        },
        error: (_, __) =>
            const Center(child: Text('Oops! An error occurred')),
        loading: () => const Center(child: LoadingIndicator()),
      ),
    );
  }

  Widget _buildMenu(
    BuildContext context, {
    required String userId,
    required bool isCreator,
  }) {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(
        borderRadius: AppConstants.defaultBorderRadius,
      ),
      offset: const Offset(0, kToolbarHeight),
      itemBuilder: (context) {
        if (isCreator) {
          return [
            PopupMenuItem(
              onTap: () async {
                final connected = await isOnline();
                if (!connected) {
                  if (context.mounted) {
                    showSnackBar(context, msg: "You're offline");
                  }
                  return;
                }
                if (context.mounted) {
                  _showImagePickerDialogue(context);
                }
              },
              child: const Text('Change display picture'),
            ),
            PopupMenuItem(
              onTap: () => _showEditDialogue(context),
              child: const Text('Change Room info'),
            ),
            if (widget.room.participants.contains(userId))
              PopupMenuItem(
                onTap: () => _showLeaveDialogue(context, userId: userId),
                child: const Text('Leave Room'),
              )
            else
              PopupMenuItem(
                onTap: () {
                  RoomDB().join(
                    context,
                    spaceId: widget.spaceId,
                    roomId: widget.room.id!,
                    userId: userId,
                    roomName: widget.room.name,
                  );
                },
                child: const Text('Join Room'),
              ),
            PopupMenuItem(
              onTap: () => _showDeleteDialogue(context),
              child: const Text(
                'Delete Room',
                style: TextStyle(color: AppColors.danger),
              ),
            ),
          ];
        }
        return [
          if (widget.room.participants.contains(userId))
            PopupMenuItem(
              onTap: () => _showLeaveDialogue(context, userId: userId),
              child: const Text('Leave Room'),
            )
          else
            PopupMenuItem(
              onTap: () {
                RoomDB().join(
                  context,
                  spaceId: widget.spaceId,
                  roomId: widget.room.id!,
                  userId: userId,
                  roomName: widget.room.name,
                );
              },
              child: const Text('Join Room'),
            ),
        ];
      },
    );
  }

  void _showImagePickerDialogue(BuildContext context) {
    showModalBottomSheet(
      enableDrag: false,
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.sd_storage_outlined),
              title: const Text('Device storage'),
              onTap: () async {
                final path = await _imageHelper.pickImage(
                  context,
                  source: ImageSource.gallery,
                );
                if (path.isNotEmpty && context.mounted) {
                  final cropped =
                      await _imageHelper.cropImage(context, path: path);
                  if (context.mounted) {
                    context.pop();
                    context.pop();
                    showLoadingIndicator(context, label: 'Saving');
                    setState(() => _fileImage = cropped);
                    final firestore = ref.read(firestoreProvider);
                    await _imageHelper.uploadImage(
                      context,
                      imagePath: cropped,
                      docRef: firestore
                          .collection('spaces')
                          .doc(widget.spaceId)
                          .collection('rooms')
                          .doc(widget.room.id),
                      storagePath:
                          'rooms/${widget.room.name}.png',
                    );
                    if (context.mounted) context.pop();
                  }
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Camera'),
              onTap: () async {
                final path = await _imageHelper.pickImage(
                  context,
                  source: ImageSource.camera,
                );
                if (path.isNotEmpty && context.mounted) {
                  final cropped =
                      await _imageHelper.cropImage(context, path: path);
                  if (context.mounted) {
                    context.pop();
                    context.pop();
                    setState(() => _fileImage = cropped);
                    final firestore = ref.read(firestoreProvider);
                    await _imageHelper.uploadImage(
                      context,
                      imagePath: cropped,
                      docRef: firestore
                          .collection('spaces')
                          .doc(widget.spaceId)
                          .collection('rooms')
                          .doc(widget.room.id),
                      storagePath:
                          'rooms/${widget.room.name}.png',
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditDialogue(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      enableDrag: false,
      context: context,
      builder: (context) {
        final bottom = MediaQuery.viewInsetsOf(context).bottom;
        return Padding(
          padding: EdgeInsets.fromLTRB(8, 8, 8, bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Row(
                children: [Text('Edit Room info')],
              ),
              AppConstants.height8,
              AppTextField(
                hintText: 'Room name',
                borderless: true,
                textInputAction: TextInputAction.next,
                autofocus: true,
                controller: _nameController,
              ),
              AppConstants.height8,
              AppTextField(
                hintText: 'Room description',
                borderless: true,
                maxLines: 5,
                controller: _descController,
                keyboardType: TextInputType.multiline,
              ),
              AppConstants.height24,
              AppButton(
                label: 'Save',
                onPressed: () {
                  if (_nameController.text.trim().isEmpty) return;
                  RoomDB().edit(
                    context,
                    spaceId: widget.spaceId,
                    roomId: widget.room.id!,
                    name: _nameController.text.trim(),
                    desc: _descController.text.trim(),
                  );
                },
              ),
              AppConstants.height8,
            ],
          ),
        );
      },
    );
  }

  void _showLeaveDialogue(BuildContext context, {required String userId}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Leave this Room?'),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actionsOverflowAlignment: OverflowBarAlignment.center,
          actions: [
            AppButton(
              label: 'Cancel',
              onPressed: () => context.pop(),
            ),
            AppTextButton(
              label: 'Leave',
              onPressed: () {
                RoomDB().leave(
                  context,
                  spaceId: widget.spaceId,
                  roomId: widget.room.id!,
                  userId: userId,
                  roomName: widget.room.name,
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialogue(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(
            'You are about to delete ${widget.room.name}.\n'
            'All participants will be removed and all messages will be deleted.\n'
            'This cannot be undone.',
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          shape: RoundedRectangleBorder(
            borderRadius: AppConstants.defaultBorderRadius,
          ),
          insetPadding: const EdgeInsets.all(8),
          actions: [
            AppTextButton(
              label: 'Delete',
              onPressed: () {
                RoomDB().delete(
                  context,
                  roomId: widget.room.id!,
                  roomName: widget.room.name,
                  spaceId: widget.spaceId,
                );
              },
            ),
            AppTextButton(
              label: 'Cancel',
              onPressed: () => context.pop(),
            ),
          ],
        );
      },
    );
  }
}

class _ActionsTile extends StatelessWidget {
  const _ActionsTile({
    required this.icon,
    this.onTap,
  });

  final IconData icon;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppConstants.defaultBorderRadius,
      child: Ink(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.lightGrey),
          borderRadius: AppConstants.defaultBorderRadius,
        ),
        child: Icon(icon),
      ),
    );
  }
}
