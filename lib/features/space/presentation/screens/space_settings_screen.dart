import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/entities/space_entity.dart';
import '../notifiers/space_notifier.dart';
import '../providers/space_providers.dart';
import '../../../../views/widgets/app_text_field.dart';
import '../../../../views/widgets/app_text_buttons.dart';
import '../../../../views/dialogues/bottom_sheets.dart';
import '../../../../views/dialogues/snack_bar.dart';
import '../../../../views/dialogues/loading_indicator_build.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../services/connection_state.dart';
import '../../../../services/image_helper.dart';

class SpaceSettingsScreen extends ConsumerStatefulWidget {
  static String id = 'space-settings';

  const SpaceSettingsScreen({super.key, required this.space});

  final SpaceEntity space;

  @override
  ConsumerState<SpaceSettingsScreen> createState() =>
      _SpaceSettingsScreenState();
}

class _SpaceSettingsScreenState extends ConsumerState<SpaceSettingsScreen> {
  final ImageHelper _imageHelper = ImageHelper();
  String? _image;

  late final TextEditingController _nameController;
  late final TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.space.name);
    _descController = TextEditingController(text: widget.space.desc);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Space Settings'),
        actions: [
          AppTextButton(
            onPressed: () async {
              final isConnected = await isOnline();
              if (!isConnected) {
                if (context.mounted) {
                  showSnackBar(context, msg: "You're offline");
                }
                return;
              }
              if (_nameController.text == widget.space.name ||
                  _descController.text == widget.space.desc) {
                if (context.mounted) {
                  showSnackBar(context, msg: 'No changes were made');
                }
                return;
              }
              if (context.mounted) {
                _saveChanges();
              }
            },
            label: 'Save',
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
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
                            if (context.mounted) context.pop();
                          }
                        }
                      },
                    );
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.width * 0.5,
                  decoration: BoxDecoration(
                    color: AppColors.grey,
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: _image != null
                          ? FileImage(File(_image!))
                          : NetworkImage(widget.space.image ?? '')
                              as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          Column(
            children: [
              AppTextField(
                hintText: 'Name (required)',
                borderless: true,
                controller: _nameController,
              ),
              const SizedBox(height: 10),
              AppTextField(
                hintText: 'Description',
                borderless: true,
                controller: _descController,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _saveChanges() async {
    showLoadingIndicator(context, label: 'Saving...');
    await ref.read(spaceNotifierProvider.notifier).updateSpace(
          widget.space.id!,
          _nameController.text.trim(),
          _descController.text.trim(),
        );
    if (_image != null && context.mounted) {
      await _imageHelper.uploadImage(
        context,
        imagePath: _image!,
        docRef: FirebaseFirestore.instance
            .collection('spaces')
            .doc(widget.space.id!),
        storagePath: 'spaces/${widget.space.id!}.png',
      );
    }
  }
}
