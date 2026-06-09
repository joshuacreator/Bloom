import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../common/widgets/app_button.dart';
import '../../../../common/widgets/app_text_field.dart';
import '../../../../common/widgets/privacy_tile.dart';
import '../../../../common/widgets/loading_indicator.dart';
import '../../../../common/widgets/snack_bar.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../services/image_helper.dart';
import '../../domain/entities/room_entity.dart';
import '../providers/room_providers.dart';

class CreateRoomScreen extends ConsumerStatefulWidget {
  static const String id = 'create-room';

  const CreateRoomScreen({super.key, required this.spaceId});

  final String spaceId;

  @override
  ConsumerState<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends ConsumerState<CreateRoomScreen> {
  bool _isPrivate = false;
  String _privacyText = 'Public (Anyone can join)';
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  File? _image;
  final _imageHelper = ImageHelper();

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authStateProvider).value;

    return Scaffold(
      appBar: AppBar(title: const Text('Create Room')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => _showImagePicker(context),
                  child: _image != null
                      ? CircleAvatar(
                          radius: context.defaultSize,
                          backgroundImage: FileImage(_image!),
                        )
                      : CircleAvatar(
                          radius: context.defaultSize,
                          backgroundColor: Colors.grey.withValues(alpha: 0.3),
                          child: const Icon(Icons.camera_alt_outlined),
                        ),
                ),
                AppConstants.height8,
                Expanded(
                  child: AppTextField(
                    hintText: 'Name (required)',
                    textInputAction: TextInputAction.next,
                    controller: _nameController,
                    borderless: true,
                    autofocus: true,
                  ),
                ),
              ],
            ),
            AppConstants.height16,
            AppTextField(
              hintText: 'Description',
              maxLines: 5,
              controller: _descController,
              borderless: true,
            ),
            AppConstants.height16,
            PrivacySwitch(
              value: _isPrivate,
              text: _privacyText,
              onChanged: (newValue) {
                setState(() {
                  if (_isPrivate) {
                    _isPrivate = false;
                    _privacyText = 'Public (Anyone can join)';
                  } else {
                    _isPrivate = true;
                    _privacyText = 'Private (Invite only)';
                  }
                });
              },
            ),
            AppConstants.height24,
            AppButton(
              label: 'Create',
              onPressed: () {
                if (_nameController.text.trim().isEmpty) {
                  showSnackBar(context, msg: 'The name field is required');
                  return;
                }

                final room = RoomEntity(
                  name: _nameController.text.trim(),
                  desc: _descController.text.trim(),
                  creatorId: auth!.uid,
                  private: _isPrivate,
                  createdAt: DateTime.now(),
                  participants: [auth.uid],
                );

                final useCase = ref.read(createRoomUseCaseProvider);
                ref.read(roomNotifierProvider.notifier).createRoom(
                      useCase: useCase,
                      room: room,
                      spaceId: widget.spaceId,
                      userId: auth.uid,
                      imagePath: _image?.path,
                    );

                if (context.mounted) {
                  context.pop();
                  showSnackBar(
                    context,
                    msg: '${room.name} has been created',
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showImagePicker(BuildContext context) {
    showModalBottomSheet(
      enableDrag: false,
      context: context,
      builder: (ctx) {
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
                    setState(() => _image = File(cropped));
                    context.pop();
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
                    setState(() => _image = File(cropped));
                    context.pop();
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
}
