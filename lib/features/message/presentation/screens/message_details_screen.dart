import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../configs/colour_config.dart';
import '../../../../configs/consts.dart';
import '../../../../configs/text_config.dart';
import '../../../../services/connection_state.dart';
import '../../../../views/dialogues/app_dialogues.dart';
import '../../../../views/dialogues/info_edit_dialogue.dart';
import '../../../../views/dialogues/loading_indicator.dart';
import '../../../../views/dialogues/loading_indicator_build.dart';
import '../../../../views/dialogues/snack_bar.dart';
import '../../../../views/widgets/seperator.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/entities/reply_entity.dart';
import '../notifiers/message_notifier.dart';
import '../providers/message_providers.dart';
import '../widgets/message_text_field.dart';
import '../widgets/message_tile.dart';
import '../widgets/reply_tile.dart';

class MessageDetailsScreen extends ConsumerStatefulWidget {
  const MessageDetailsScreen({
    super.key,
    required this.message,
    required this.spaceId,
    required this.roomId,
  });

  final MessageEntity message;
  final String spaceId;
  final String roomId;

  @override
  ConsumerState<MessageDetailsScreen> createState() =>
      _MessageDetailsScreenState();
}

class _MessageDetailsScreenState extends ConsumerState<MessageDetailsScreen> {
  final _key = GlobalKey<FormState>();
  final _replyTextController = TextEditingController();

  @override
  void dispose() {
    _replyTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance.currentUser;
    final msg = ref.watch(
      messageStreamProvider(
        (
          spaceId: widget.spaceId,
          roomId: widget.roomId,
          messageId: widget.message.id,
        ),
      ),
    );
    final replies = ref.watch(
      repliesStreamProvider(
        (
          spaceId: widget.spaceId,
          roomId: widget.roomId,
          messageId: widget.message.id,
        ),
      ),
    );
    final me = auth?.uid == widget.message.senderId || auth?.uid == null;

    final dateTime = DateFormat('dd MMM hh:mm a').format(widget.message.time);
    final bottom = MediaQuery.viewInsetsOf(context).bottom + forty + ten;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.keyboard_arrow_down),
        ),
        actions: [
          IconButton(
            onPressed: () {
              final currentMsg = msg.valueOrNull;
              if (currentMsg == null || currentMsg.message.isEmpty) {
                showSnackBar(context, msg: "There's nothing to copy");
                return;
              }
              Clipboard.setData(
                ClipboardData(text: currentMsg.message),
              ).then(
                (value) => showSnackBar(context, msg: 'Copied to clipboard'),
              );
            },
            icon: const Icon(Icons.copy),
          ),
        ],
      ),
      body: replies.when(
        data: (data) {
          return SingleChildScrollView(
            child: Column(
              children: [
                _MsgTile(
                  message: widget.message,
                  date: dateTime,
                  me: me,
                ),
                _ReactionTile(
                  me: me,
                  messageId: widget.message.id,
                  spaceId: widget.spaceId,
                  roomId: widget.roomId,
                  auth: auth,
                  msg: msg,
                ),
                height10,
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: ten),
                      child: Text(
                        'Replies (${data.length})',
                        style: TextConfig.intro,
                      ),
                    ),
                  ],
                ),
                height10,
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final reply = data[index];
                    return ReplyTile(
                      reply: reply,
                      spaceId: widget.spaceId,
                      roomId: widget.roomId,
                      messageId: widget.message.id,
                    );
                  },
                ),
              ],
            ),
          );
        },
        error: (error, stackTrace) {
          return const Center(child: Text('Oops! An error occurred'));
        },
        loading: () {
          return const Center(child: LoadingIndicator());
        },
      ),
      persistentFooterButtons: [
        Form(
          key: _key,
          child: MessageTextField(
            onSend: () async {
              if (_replyTextController.text.trim().isEmpty) return;
              await ref.read(messageNotifierProvider.notifier).sendReply(
                    reply: ReplyEntity(
                      id: '',
                      message: _replyTextController.text.trim(),
                      replySenderId: auth?.uid ?? '',
                      toMessageId: widget.message.id,
                      toSenderId: widget.message.senderId,
                      time: DateTime.now(),
                    ),
                    spaceId: widget.spaceId,
                    roomId: widget.roomId,
                    messageId: widget.message.id,
                  );
              _replyTextController.clear();
              FocusManager.instance.primaryFocus!.unfocus();
            },
            hintText: 'Type a reply',
            textController: _replyTextController,
            hasPrefix: false,
          ),
        ),
        SizedBox(height: bottom),
      ],
    );
  }
}

class _ReactionTile extends ConsumerWidget {
  const _ReactionTile({
    required this.me,
    required this.messageId,
    required this.spaceId,
    required this.roomId,
    required this.auth,
    required this.msg,
  });

  final bool me;
  final String messageId;
  final String spaceId;
  final String roomId;
  final User? auth;
  final AsyncValue<MessageEntity?> msg;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMsg = msg.valueOrNull;
    final likes = currentMsg?.likes ?? [];
    final messageController =
        TextEditingController(text: currentMsg?.message ?? '');

    return Column(
      children: [
        const Separator(height: 0),
        height5,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _ReactionButton(
              label: likes.isEmpty
                  ? 'Like'
                  : likes.length == 1
                      ? '1 Like'
                      : '${likes.length} Likes',
              icon: auth?.uid != null && likes.contains(auth!.uid)
                  ? Icons.thumb_up
                  : Icons.thumb_up_outlined,
              colour: auth?.uid != null && likes.contains(auth!.uid)
                  ? ColourConfig.go
                  : null,
              onPressed: () async {
                final isConnected = await isOnline();
                if (!isConnected) {
                  if (context.mounted) {
                    showSnackBar(context, msg: "You're offline");
                  }
                  return;
                }
                await ref.read(messageRepoProvider).toggleLike(
                      spaceId,
                      roomId,
                      messageId,
                      auth?.uid ?? '',
                    );
              },
            ),
            if (me)
              _ReactionButton(
                label: 'Edit',
                icon: Icons.edit_outlined,
                onPressed: () async {
                  final isConnected = await isOnline();
                  if (!isConnected) {
                    if (context.mounted) {
                      showSnackBar(context, msg: "You're offline");
                    }
                    return;
                  }
                  if (context.mounted) {
                    messageEditDialogue(
                      context,
                      messageController: messageController,
                      onSaved: () async {
                        if (currentMsg?.message ==
                            messageController.text.trim()) {
                          return;
                        }
                        showLoadingIndicator(context, label: 'Saving...');
                        await ref
                            .read(messageNotifierProvider.notifier)
                            .editMessage(
                              spaceId: spaceId,
                              roomId: roomId,
                              messageId: messageId,
                              newMessage: messageController.text.trim(),
                            );
                        if (context.mounted) {
                          context.pop();
                          context.pop();
                          showSnackBar(context, msg: 'Message edited');
                        }
                      },
                    );
                  }
                },
              ),
            _ReactionButton(
              label: me ? 'Delete' : 'Reply privately',
              icon: me ? Icons.delete_forever_outlined : Icons.reply,
              onPressed: me
                  ? () async {
                      final isConnected = await isOnline();
                      if (!isConnected) {
                        if (context.mounted) {
                          showSnackBar(context, msg: "You're offline");
                        }
                        return;
                      }
                      if (context.mounted) {
                        showLoadingIndicator(context);
                        await ref
                            .read(messageNotifierProvider.notifier)
                            .deleteMessage(
                              spaceId: spaceId,
                              roomId: roomId,
                              messageId: messageId,
                            );
                        if (context.mounted) {
                          context.pop();
                          context.pop();
                          context.pop();
                          showSnackBar(context, msg: 'Message deleted');
                        }
                      }
                    }
                  : null,
            ),
          ],
        ),
        height10,
        const Separator(height: 0),
      ],
    );
  }
}

class _MsgTile extends StatelessWidget {
  const _MsgTile({
    required this.message,
    required this.date,
    required this.me,
  });

  final MessageEntity message;
  final String date;
  final bool me;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ten),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: size / 2,
                          backgroundImage: CachedNetworkImageProvider(
                            defaultRoomImgPath,
                          ),
                        ),
                        SizedBox(width: ten),
                        Text(
                          me ? '(You)' : message.senderId,
                          style: TextConfig.small,
                        ),
                      ],
                    ),
                    Text(date, style: TextConfig.intro),
                  ],
                ),
                height10,
                Visibility(
                  visible:
                      message.image != null && message.image!.isNotEmpty,
                  child: message.image != null &&
                          message.image!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: defaultBorderRadius,
                          child: CachedNetworkImage(
                            imageUrl: message.image!,
                            progressIndicatorBuilder:
                                (context, url, progress) {
                              return Center(
                                child: CircularProgressIndicator(
                                  value: progress.progress,
                                ),
                              );
                            },
                            fit: BoxFit.contain,
                          ),
                        )
                      : const SizedBox(),
                ),
                height10,
                Text.rich(
                  TextSpan(
                    children: extractText(
                      context,
                      message.message,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReactionButton extends StatelessWidget {
  const _ReactionButton({
    required this.label,
    required this.icon,
    this.colour,
    this.onPressed,
  });

  final String label;
  final IconData icon;
  final Color? colour;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          padding: EdgeInsets.all(ten),
          onPressed: onPressed,
          icon: Icon(icon, color: colour),
        ),
        Text(label, style: TextConfig.sub),
      ],
    );
  }
}
