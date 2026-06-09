import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../common/widgets/loading_indicator.dart';
import '../../../../common/widgets/snack_bar.dart';
import '../../../../config/firebase_providers.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../models/message.dart';
import '../../../../services/message_db.dart';
import '../../../../core/utils/image_helper.dart';
import '../../domain/entities/room_entity.dart';

class RoomMsgScreen extends ConsumerStatefulWidget {
  static const String id = 'room-chat';

  const RoomMsgScreen({
    super.key,
    required this.room,
    required this.spaceId,
  });

  final RoomEntity room;
  final String spaceId;

  @override
  ConsumerState<RoomMsgScreen> createState() => _RoomMsgScreenState();
}

class _RoomMsgScreenState extends ConsumerState<RoomMsgScreen> {
  final _messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _imageHelper = ImageHelper();
  String? _fileImage;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final firestore = ref.watch(firestoreProvider);
    final auth = ref.watch(authStateProvider).valueOrNull;
    final senderId = auth?.uid ?? '';

    final messagesRef = firestore
        .collection('spaces')
        .doc(widget.spaceId)
        .collection('rooms')
        .doc(widget.room.id)
        .collection('messages');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.room.name),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: messagesRef.orderBy('time', descending: true).snapshots(
                    includeMetadataChanges: true,
                  ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingIndicator();
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final messages = snapshot.data?.docs ?? [];
                return ListView.builder(
                  padding: const EdgeInsets.only(top: 8),
                  itemCount: messages.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    final doc = messages[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final isMe = data['senderId'] == senderId;
                    return ListTile(
                      title: Text(data['message'] as String? ?? ''),
                      trailing: isMe
                          ? const Icon(Icons.check, size: 16)
                          : null,
                    );
                  },
                );
              },
            ),
          ),
          _buildTexter(context, messagesRef: messagesRef, senderId: senderId),
        ],
      ),
    );
  }

  Widget _buildTexter(
    BuildContext context, {
    required CollectionReference messagesRef,
    required String senderId,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_fileImage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox.square(
                    dimension: context.defaultSize * 7,
                    child: Image.file(File(_fileImage!)),
                  ),
                  IconButton(
                    onPressed: () => setState(() => _fileImage = null),
                    icon: const Icon(Icons.cancel),
                  ),
                ],
              ),
            ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.attach_file_rounded),
                onPressed: () async {
                  final path = await _imageHelper.pickImage(
                    context,
                    source: ImageSource.gallery,
                  );
                  if (path.isNotEmpty && context.mounted) {
                    final cropped =
                        await _imageHelper.cropImage(context, path: path);
                    if (context.mounted) {
                      setState(() => _fileImage = cropped);
                    }
                  }
                },
              ),
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: 'Type a message',
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send_rounded),
                onPressed: () async {
                  if (_messageController.text.trim().isEmpty &&
                      (_fileImage == null || _fileImage!.isEmpty)) {
                    return;
                  }

                  final msgDb = MessageDB();
                  await msgDb.send(
                    Message(
                      senderId: senderId ?? '',
                      message: _messageController.text.trim(),
                      image: _fileImage,
                      time: DateTime.now(),
                      likes: [],
                    ),
                    context,
                    ref: messagesRef,
                    spaceId: widget.spaceId,
                    roomId: widget.room.id ?? '',
                  );
                  _messageController.clear();
                  if (mounted) setState(() => _fileImage = null);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
