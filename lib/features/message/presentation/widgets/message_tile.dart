import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../providers/users_providers.dart';
import '../../../../core/utils/date_time_utils.dart';
import '../../../../views/dialogues/app_dialogues.dart';
import '../../../../views/screens/room/room_chats_screen.dart';
import '../../../../views/screens/room/room_info_screen.dart';
import '../../../../views/screens/room/room_msg_screen.dart';
import '../../../../views/screens/user_screen.dart';
import '../../../../common/widgets/b_nav_bar.dart';
import '../../../../common/widgets/image_viewer.dart';
import '../../domain/entities/message_entity.dart';
import '../providers/message_providers.dart';

class MessageTile extends ConsumerStatefulWidget {
  const MessageTile({
    super.key,
    required this.message,
    required this.spaceId,
    required this.roomId,
    this.onTap,
  });

  final MessageEntity message;
  final String spaceId;
  final String roomId;
  final void Function()? onTap;

  @override
  ConsumerState<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends ConsumerState<MessageTile> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(anyUserProvider(widget.message.senderId));
    final repliesCount = ref.watch(
      repliesCountStreamProvider(
        (
          spaceId: widget.spaceId,
          roomId: widget.roomId,
          messageId: widget.message.id,
        ),
      ),
    );

    final count = repliesCount.valueOrNull ?? 0;

    return Padding(
      padding: EdgeInsets.all(5),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: AppConstants.defaultBorderRadius,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: widget.message.me
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Row(
                textDirection:
                    widget.message.me ? TextDirection.rtl : TextDirection.ltr,
                children: [
                  GestureDetector(
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => ImageViewer(
                        image: user.value?['image'] ?? '',
                        onInfoIconPressed: widget.message.me
                            ? null
                            : () => context.push(
                                  '${BNavBar.id}/${RoomChatsScreen.id}/${RoomMsgScreen.id}/${widget.spaceId}/${RoomInfoScreen.id}/${widget.spaceId}/${UserScreen.id}/${widget.message.senderId}',
                                ),
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: CachedNetworkImageProvider(
                        user.value?['image'] ?? '',
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    constraints: BoxConstraints(maxWidth: 140),
                    child: Text(
                      widget.message.me ? '' : user.value?['name'] ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.intro,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    timeAgo(widget.message.time),
                    style: AppTextStyles.intro.copyWith(fontSize: 10),
                  ),
                  SizedBox(width: 10),
                  widget.message.me && widget.message.pending
                      ? Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                          size: 17,
                        )
                      : const SizedBox(),
                  SizedBox(width: 10),
                ],
              ),
              Visibility(
                visible:
                    widget.message.image != null && widget.message.image!.isNotEmpty,
                child: widget.message.image != null &&
                        widget.message.image!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: AppConstants.defaultBorderRadius,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 160,
                            maxWidth: 240,
                          ),
                          child: CachedNetworkImage(
                            imageUrl: widget.message.image!.isEmpty
                                ? AppConstants.defaultRoomImgPath
                                : widget.message.image!,
                            errorWidget: (context, url, error) => Icon(
                              Icons.image,
                              size: 120,
                            ),
                            progressIndicatorBuilder: (context, url, progress) {
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: CircularProgressIndicator(
                                    value: progress.progress,
                                    strokeCap: StrokeCap.round,
                                  ),
                                ),
                              );
                            },
                            alignment: widget.message.me
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            fit: BoxFit.contain,
                          ),
                        ),
                      )
                    : const SizedBox(),
              ),
              widget.message.message.isEmpty
                  ? const SizedBox()
                  : ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 360),
                      child: Text.rich(
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        TextSpan(
                          children: extractText(context, widget.message.message),
                        ),
                      ),
                    ),
              const SizedBox(height: 5),
              Visibility(
                visible: count > 0,
                child: Text(
                  'Replies ($count)',
                  style: AppTextStyles.sub,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<TextSpan> extractText(BuildContext context, String rawString) {
  final textSpan = <TextSpan>[];
  final urlRegExp = RegExp(
    r"((https?:www\.)|(https?:\/\/)|(www\.)|(.?))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?",
  );

  rawString.splitMapJoin(
    urlRegExp,
    onMatch: (match) {
      final linkString = '${match.group(0)}';
      final link = Uri.parse(linkString);
      textSpan.add(
        TextSpan(
          text: linkString,
          style: const TextStyle(color: Colors.blueAccent),
          recognizer: TapGestureRecognizer()
            ..onTap = () => linkAlertDialogue(
                  context,
                  link: link,
                  linkString: linkString,
                ),
        ),
      );
      return '';
    },
    onNonMatch: (nonMatch) {
      textSpan.add(TextSpan(text: nonMatch.substring(0)));
      return '';
    },
  );
  return textSpan;
}
