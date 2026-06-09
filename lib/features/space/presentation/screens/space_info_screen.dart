import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/space_entity.dart';
import '../notifiers/space_notifier.dart';
import '../providers/space_providers.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../models/room.dart';
import '../../../../models/space.dart' as old;
import '../../../../providers/auth_provider.dart';
import '../../../../providers/room/room_data_providers.dart';
import '../../../../services/room_db.dart';
import '../../../../common/widgets/b_nav_bar.dart';
import '../../../../common/widgets/show_more_text.dart';
import '../../../../common/widgets/room_tile.dart';
import '../../../../common/widgets/seperator.dart';
import '../../../../common/widgets/app_text_buttons.dart';
import '../../../../common/widgets/loading_indicator.dart';
import '../../../../common/widgets/snack_bar.dart';
import '../../../../views/dialogues/popup_menu.dart';
import '../../../../views/dialogues/app_dialogues.dart';
import '../../../../views/dialogues/info_edit_dialogue.dart';
import '../../../../views/dialogues/bottom_sheets.dart';
import '../../../../common/widgets/loading_indicator.dart';
import '../../../../views/screens/room/room_chats_screen.dart';
import '../../../../views/screens/room/room_msg_screen.dart';
import '../../../../views/screens/room/room_info_screen.dart';
import '../../../../views/screens/room/create_room_screen.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/connection_state.dart';
import '../../../../core/utils/image_helper.dart';

class SpaceInfoScreen extends ConsumerStatefulWidget {
  static String id = 'space-info';

  const SpaceInfoScreen({super.key, required this.space});

  final SpaceEntity space;

  @override
  ConsumerState<SpaceInfoScreen> createState() => _SpaceInfoScreenState();
}

class _SpaceInfoScreenState extends ConsumerState<SpaceInfoScreen> {
  final ImageHelper _imageHelper = ImageHelper();
  String? _image;

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authStateProvider).value!;
    final space = ref.watch(spaceProvider(widget.space.id!));
    final room = ref.watch(spaceRoomsProvider(widget.space.id!));
    final nameController = TextEditingController(text: widget.space.name);
    final descController = TextEditingController(text: widget.space.desc);
    final brightness = MediaQuery.of(context).platformBrightness;
    return Scaffold(
      body: space.when(
        data: (data) {
          final dateTime =
              DateFormat('dd MMM yyy').format(data?.createdAt ?? DateTime.now());
          final bool isCreator = auth.uid == data?.creatorId;
          final bool isParticipant =
              data?.participants?.contains(auth.uid) ?? false;
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                actions: [
                  _buildPopupMenu(
                    context,
                    nameController: nameController,
                    descController: descController,
                    userId: auth.uid,
                    isSpaceParticipant: isParticipant,
                    isCreator: isCreator,
                  ),
                ],
                expandedHeight: MediaQuery.of(context).size.width * 0.8,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: _image != null
                                ? FileImage(File(_image!))
                                : NetworkImage(data?.image ?? '')
                                    as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: brightness == Brightness.dark
                                ? Colors.black.withOpacity(0.3)
                                : Colors.white.withOpacity(0.3),
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text.rich(
                                TextSpan(
                                  text: '${data?.name ?? ''}\n',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: MediaQuery.of(context).size.width * 0.1,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Created $dateTime',
                                      style: const TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: AppShowMoreText(text: data?.desc ?? ''),
                    ),
                    const Separator(),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            data?.rooms == null
                                ? 'Rooms (0)'
                                : 'Rooms (${data?.rooms?.length})',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          Visibility(
                            visible: isCreator && isParticipant,
                            child: IconButton(
                              onPressed: () {
                                context.push(
                                  '/${BNavBar.id}/${RoomChatsScreen.id}/${SpaceInfoScreen.id}/${CreateRoomScreen.id}/${widget.space.id}',
                                );
                              },
                              icon: const Icon(Icons.add),
                              tooltip: 'Add Room',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              data?.rooms == null || data!.rooms!.isEmpty
                  ? SliverList(
                      delegate: SliverChildListDelegate([
                        Center(
                          heightFactor: 10,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: const Text(
                              'There are no Rooms in this Space yet',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ]),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        childCount: room.value?.length ?? 0,
                        (context, index) {
                          final roomData = Room(
                            id: room.value?[index]['id'] ?? '',
                            creatorId: room.value?[index]['creatorId'] ?? '',
                            name: room.value?[index]['name'] ?? '',
                            desc: room.value?[index]['desc'] ?? '',
                            private: room.value?[index]['private'] ?? true,
                            image: room.value?[index]['image'] ?? AppConstants.defaultRoomImgPath,
                            createdAt: (room.value?[index]['createdAt'] as Timestamp?)?.toDate(),
                            participants: room.value?[index]['participants'] ?? [],
                          );

                          final isRoomParticipant =
                              roomData.participants.contains(auth.uid);

                          return RoomTile(
                            roomData: roomData,
                            subtitle:
                                'Participants (${roomData.participants.length})',
                            trailing: !isParticipant
                                ? null
                                : isRoomParticipant
                                    ? AppTextButton(
                                        label: 'Leave',
                                        color: AppColors.danger,
                                        onPressed: () {
                                          leaveRoomDialogue(
                                            context,
                                            spcId: widget.space.id!,
                                            roomId: roomData.id!,
                                            userId: auth.uid,
                                            roomName: roomData.name,
                                          );
                                        },
                                      )
                                    : AppTextButton(
                                        label: 'Join',
                                        color: AppColors.go,
                                        onPressed: () {
                                          RoomDB().join(
                                            context,
                                            spaceId: widget.space.id!,
                                            roomId: roomData.id!,
                                            userId: auth.uid,
                                            roomName: roomData.name,
                                          );
                                        },
                                      ),
                            onTap: () => !isParticipant
                                ? showSnackBar(
                                    context,
                                    msg:
                                        "You must be a participant of ${data.name} to view this Room's details",
                                  )
                                : context.push(
                                    '/${BNavBar.id}/${RoomChatsScreen.id}/${RoomMsgScreen.id}/${widget.space.id}/${RoomInfoScreen.id}/${widget.space.id}',
                                    extra: roomData,
                                  ),
                          );
                        },
                      ),
                    ),
            ],
          );
        },
        error: (error, stackTrace) => const Center(
          child: Text('An error occurred. Tap to refresh'),
        ),
        loading: () => const Center(child: LoadingIndicator(label: 'Please wait...')),
      ),
    );
  }

  Widget _buildPopupMenu(
    BuildContext context, {
    required TextEditingController nameController,
    required TextEditingController descController,
    required String userId,
    required bool isSpaceParticipant,
    required bool isCreator,
  }) {
    return AppPopupMenu(
      items: isCreator && isSpaceParticipant
          ? [
              AppPopupMenu.buildPopupMenuItem(
                context,
                label: 'Change display image',
                onTap: () async {
                  final isConnected = await isOnline();
                  if (!isConnected) {
                    if (context.mounted) {
                      showSnackBar(context, msg: "You're offline");
                    }
                    return;
                  }
                  if (context.mounted) {
                    imagePickerDialogue(
                      context,
                      onStorageTapped: () async {
                        context.pop();
                        final imagePath = await _imageHelper.pickImage(
                          context,
                          source: ImageSource.gallery,
                        );
                        if (context.mounted) {
                          final croppedImg = await _imageHelper
                              .cropImage(context, path: imagePath);
                          if (context.mounted) {
                            context.pop();
                            showLoadingIndicator(context, label: 'Saving...');
                          }
                          if (context.mounted) {
                            setState(() => _image = croppedImg);
                            await _imageHelper.uploadImage(
                              context,
                              imagePath: croppedImg,
                              docRef: FirebaseFirestore.instance
                                  .collection('spaces')
                                  .doc(widget.space.id!),
                              storagePath:
                                  'spaces/${widget.space.id!}.png',
                            );
                            if (context.mounted) context.pop();
                          }
                        }
                      },
                      onCameraTapped: () async {
                        context.pop();
                        final imagePath = await _imageHelper.pickImage(
                          context,
                          source: ImageSource.camera,
                        );
                        if (context.mounted) {
                          final croppedImg = await _imageHelper
                              .cropImage(context, path: imagePath);
                          if (context.mounted) {
                            context.pop();
                            showLoadingIndicator(context, label: 'Saving...');
                          }
                          if (context.mounted) {
                            setState(() => _image = croppedImg);
                            await _imageHelper.uploadImage(
                              context,
                              imagePath: croppedImg,
                              docRef: FirebaseFirestore.instance
                                  .collection('spaces')
                                  .doc(widget.space.id!),
                              storagePath:
                                  'spaces/${widget.space.id!}.png',
                            );
                            if (context.mounted) context.pop();
                          }
                        }
                      },
                    );
                  }
                },
              ),
              AppPopupMenu.buildPopupMenuItem(
                context,
                label: 'Edit Space info',
                onTap: () async {
                  final isConnected = await isOnline();
                  if (!isConnected) {
                    if (context.mounted) {
                      showSnackBar(context, msg: "You're offline");
                    }
                    return;
                  }
                  if (context.mounted) {
                    infoEditDialogue(
                      context,
                      nameController: nameController,
                      aboutController: descController,
                      onSaved: () {
                        if (nameController.text.trim().isEmpty) return;
                        ref.read(spaceNotifierProvider.notifier).updateSpace(
                              widget.space.id!,
                              nameController.text.trim(),
                              descController.text.trim(),
                            );
                      },
                    );
                  }
                },
              ),
              isSpaceParticipant
                  ? AppPopupMenu.buildPopupMenuItem(
                      context,
                      label: 'Leave Space',
                      onTap: () async {
                        final isConnected = await isOnline();
                        if (!isConnected) {
                          if (context.mounted) {
                            showSnackBar(context, msg: "You're offline");
                          }
                          return;
                        }
                        if (context.mounted) {
                          leaveSpaceDialogue(
                            context,
                            space: old.Space(
                              id: widget.space.id,
                              name: widget.space.name,
                              desc: widget.space.desc,
                              image: widget.space.image,
                              creatorId: widget.space.creatorId,
                              participants: widget.space.participants,
                              rooms: widget.space.rooms,
                              createdAt: widget.space.createdAt,
                              private: widget.space.private,
                            ),
                            spaceName: widget.space.name,
                            userId: userId,
                          );
                        }
                      },
                    )
                  : AppPopupMenu.buildPopupMenuItem(
                      context,
                      label: 'Join Space',
                      onTap: () async {
                        final isConnected = await isOnline();
                        if (!isConnected) {
                          if (context.mounted) {
                            showSnackBar(context, msg: "You're offline");
                          }
                          return;
                        }
                        if (context.mounted) {
                          ref.read(spaceNotifierProvider.notifier).joinSpace(
                                widget.space.id!,
                                userId,
                              );
                        }
                      },
                    ),
            ]
          : [
              isSpaceParticipant
                  ? AppPopupMenu.buildPopupMenuItem(
                      context,
                      label: 'Leave Space',
                      onTap: () async {
                        final isConnected = await isOnline();
                        if (!isConnected) {
                          if (context.mounted) {
                            showSnackBar(context, msg: "You're offline");
                          }
                          return;
                        }
                        if (context.mounted) {
                          leaveSpaceDialogue(
                            context,
                            space: old.Space(
                              id: widget.space.id,
                              name: widget.space.name,
                              desc: widget.space.desc,
                              image: widget.space.image,
                              creatorId: widget.space.creatorId,
                              participants: widget.space.participants,
                              rooms: widget.space.rooms,
                              createdAt: widget.space.createdAt,
                              private: widget.space.private,
                            ),
                            spaceName: widget.space.name,
                            userId: userId,
                          );
                        }
                      },
                    )
                  : AppPopupMenu.buildPopupMenuItem(
                      context,
                      label: 'Join Space',
                      onTap: () async {
                        final isConnected = await isOnline();
                        if (!isConnected) {
                          if (context.mounted) {
                            showSnackBar(context, msg: "You're offline");
                          }
                          return;
                        }
                        if (context.mounted) {
                          ref.read(spaceNotifierProvider.notifier).joinSpace(
                                widget.space.id!,
                                userId,
                              );
                        }
                      },
                    ),
            ],
    );
  }
}
