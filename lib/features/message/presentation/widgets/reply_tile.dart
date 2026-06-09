import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/users_providers.dart';
import '../../../../core/utils/connection_state.dart';
import '../../../../core/utils/date_time_utils.dart';
import '../../../../views/dialogues/info_edit_dialogue.dart';
import '../../../../common/widgets/loading_indicator.dart';
import '../../../../common/widgets/snack_bar.dart';
import '../../../../views/screens/room/room_chats_screen.dart';
import '../../../../views/screens/room/room_info_screen.dart';
import '../../../../views/screens/room/room_msg_screen.dart';
import '../../../../views/screens/user_screen.dart';
import '../../../../common/widgets/app_text_buttons.dart';
import '../../../../common/widgets/b_nav_bar.dart';
import '../../../../common/widgets/image_viewer.dart';
import '../../../../common/widgets/show_more_text.dart';
import '../../domain/entities/reply_entity.dart';

class ReplyTile extends ConsumerStatefulWidget {
  const ReplyTile({
    super.key,
    required this.reply,
    required this.spaceId,
    required this.roomId,
    required this.messageId,
    this.onLikeToggled,
    this.onEdited,
    this.onDeleted,
  });

  final ReplyEntity reply;
  final String spaceId;
  final String roomId;
  final String messageId;
  final void Function()? onLikeToggled;
  final void Function(String newMessage)? onEdited;
  final VoidCallback? onDeleted;

  @override
  ConsumerState<ReplyTile> createState() => _ReplyTileState();
}

class _ReplyTileState extends ConsumerState<ReplyTile> {
  bool showReactions = false;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(anyUserProvider(widget.reply.replySenderId));
    final auth = ref.watch(authStateProvider).value!;
    final textController = TextEditingController(text: widget.reply.message);

    return Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: GestureDetector(
        onTap: () {
          setState(() {
            showReactions = !showReactions;
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade300.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => showDialog(
                          context: context,
                          builder: (context) => ImageViewer(
                            image: user.value?['image'],
                            onInfoIconPressed: widget.reply.isMe
                                ? null
                                : () => context.push(
                                      '${BNavBar.id}/${RoomChatsScreen.id}/${RoomMsgScreen.id}/${widget.spaceId}/${RoomInfoScreen.id}/${widget.spaceId}/${UserScreen.id}/${widget.reply.replySenderId}',
                                    ),
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage: CachedNetworkImageProvider(
                            user.value?['image'],
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        widget.reply.isMe
                            ? '${user.value?['name']} (You)'
                            : user.value?['name'] ?? '',
                        style: AppTextStyles.small,
                      ),
                      widget.reply.pending
                          ? Icon(
                              Icons.access_time_rounded,
                              color: Colors.grey,
                              size: 17,
                            )
                          : const SizedBox(),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 40 + 10),
                    child: AppShowMoreText(text: widget.reply.message),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.reply.likes.isEmpty
                            ? ''
                            : widget.reply.likes.length == 1
                                ? '1 like'
                                : '${widget.reply.likes.length} likes',
                        style: AppTextStyles.small,
                      ),
                      Text(timeAgo(widget.reply.time), style: AppTextStyles.small),
                    ],
                  ),
                ],
              ),
            ),
            Visibility(
              visible: showReactions,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildReactionIconButton(
                    icon: widget.reply.likes.contains(auth.uid)
                        ? Icons.favorite
                        : Icons.favorite_border_outlined,
                    color: widget.reply.likes.contains(auth.uid)
                        ? AppColors.danger
                        : null,
                    tooltip: widget.reply.likes.contains(auth.uid)
                        ? 'Revoke like'
                        : 'Like',
                    onPressed: widget.onLikeToggled,
                  ),
                  if (widget.reply.isMe)
                    _buildReactionIconButton(
                      icon: Icons.edit_outlined,
                      tooltip: 'Edit reply',
                      onPressed: () => messageEditDialogue(
                        context,
                        messageController: textController,
                        onSaved: () {
                          if (widget.reply.message ==
                              textController.text.trim()) {
                            return;
                          }
                          widget.onEdited?.call(textController.text.trim());
                        },
                      ),
                    ),
                  if (widget.reply.isMe)
                    _buildReactionIconButton(
                      icon: Icons.delete_outline,
                      tooltip: 'Delete reply',
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: const Text('Delete reply?'),
                          actions: [
                            AppTextButton(
                              label: 'Delete',
                              onPressed: () {
                                context.pop();
                                widget.onDeleted?.call();
                              },
                            ),
                            AppTextButton(
                              label: 'Cancel',
                              onPressed: () => context.pop(),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconButton _buildReactionIconButton({
    required IconData icon,
    void Function()? onPressed,
    Color? color,
    required String tooltip,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      iconSize: 20,
      padding: EdgeInsets.zero,
      splashRadius: 1,
      color: color,
      tooltip: tooltip,
    );
  }
}
