import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/entities/space_entity.dart';
import '../notifiers/space_notifier.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../common/widgets/app_button.dart';
import '../../../../common/widgets/app_text_field.dart';
import '../../../../common/widgets/privacy_tile.dart';
import '../../../../views/dialogues/bottom_sheets.dart';
import '../../../../common/widgets/snack_bar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/connection_state.dart';
import '../../../../core/utils/image_helper.dart';

class CreateSpaceScreen extends ConsumerStatefulWidget {
  static String id = 'create-space';

  const CreateSpaceScreen({super.key});

  @override
  ConsumerState<CreateSpaceScreen> createState() => _CreateSpaceScreenState();
}

class _CreateSpaceScreenState extends ConsumerState<CreateSpaceScreen> {
  bool _isPrivate = false;
  String _privacyText = 'Public (Anyone can join)';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final ImageHelper _imageHelper = ImageHelper();
  File? _image;

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).value;
    return Scaffold(
      appBar: AppBar(title: const Text('Create Space')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.always,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => imagePickerDialogue(
                            context,
                            onStorageTapped: () => _imageHelper
                                .pickImage(context, source: ImageSource.gallery)
                                .then((value) => _imageHelper
                                    .cropImage(context, path: value))
                                .then((value) {
                              setState(() => _image = File(value));
                              context.pop();
                              context.pop();
                            }),
                            onCameraTapped: () => _imageHelper
                                .pickImage(context, source: ImageSource.camera)
                                .then((value) => _imageHelper
                                    .cropImage(context, path: value))
                                .then((value) {
                              setState(() => _image = File(value));
                              context.pop();
                              context.pop();
                            }),
                          ),
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: AppColors.grey,
                              borderRadius: BorderRadius.circular(10),
                              image: _image == null
                                  ? null
                                  : DecorationImage(
                                      image: FileImage(_image!),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            child: _image == null
                                ? const Center(
                                    child: Icon(Icons.image),
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: AppTextField(
                            hintText: 'Name (required)',
                            textInputAction: TextInputAction.next,
                            controller: _nameController,
                            autofocus: true,
                            borderless: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    AppTextField(
                      hintText: 'Description',
                      maxLines: 5,
                      controller: _descController,
                      borderless: true,
                      validate: false,
                    ),
                    const SizedBox(height: 30),
                    PrivacySwitch(
                      value: _isPrivate,
                      text: _privacyText,
                      onChanged: (newValue) {
                        setState(() {
                          _isPrivate = !_isPrivate;
                          _privacyText = _isPrivate
                              ? 'Private (Invite only)'
                              : 'Public (Anyone can join)';
                        });
                      },
                    ),
                    const SizedBox(height: 30),
                    AppButton(
                      label: 'Create',
                      onPressed: () async {
                        final isConnected = await isOnline();
                        if (!isConnected) {
                          if (context.mounted) {
                            showSnackBar(context, msg: "You're offline");
                          }
                          return;
                        }
                        if (_nameController.text.trim().isEmpty) {
                          if (context.mounted) {
                            showSnackBar(context,
                                msg: 'The name field is required');
                          }
                          return;
                        }
                        final space = SpaceEntity(
                          id: null,
                          name: _nameController.text.trim(),
                          desc: _descController.text.trim(),
                          image: null,
                          participants: [],
                          rooms: [],
                          creatorId: user!.uid,
                          createdAt: DateTime.now(),
                          private: _isPrivate,
                        );
                        if (context.mounted) {
                          ref
                              .read(spaceNotifierProvider.notifier)
                              .createSpace(space, user.uid, _image?.path);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
