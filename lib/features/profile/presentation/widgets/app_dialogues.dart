import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../models/space.dart';
import '../../../../services/auth.dart';
import '../../../../services/room_db.dart';
import '../../../../services/space_db.dart';
import '../../../../common/widgets/loading_indicator.dart';
import '../../../../common/widgets/snack_bar.dart';
import '../../../../common/widgets/app_button.dart';
import '../../../../common/widgets/app_text_buttons.dart';
import '../../../../common/widgets/b_nav_bar.dart';

void linkAlertDialogue(
  BuildContext context, {
  required Uri link,
  required String linkString,
}) {
  showDialog(
    context: context,
    builder: (context) => SizedBox(
      width: double.infinity,
      child: AlertDialog(
        actionsAlignment: MainAxisAlignment.end,
        actionsOverflowAlignment: OverflowBarAlignment.center,
        alignment: Alignment.bottomCenter,
        insetPadding: EdgeInsets.all(10),
        content: Text.rich(
          TextSpan(
            text: 'Do you want to open ',
            children: [
              TextSpan(
                text: '$link',
                style: const TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          AppButton(
            onPressed: () async {
              context.pop();
              await launchUrl(link, mode: LaunchMode.inAppWebView).catchError(
                (value) =>
                    showSnackBar(context, msg: 'Unable to open this link'),
              );
            },
            label: 'Open',
          ),
          AppTextButton(
            onPressed: () => Clipboard.setData(ClipboardData(text: linkString))
                .then((value) {
              context.pop();
              showSnackBar(context, msg: 'Copied to clipboard');
            }),
            label: 'Copy',
          ),
        ],
      ),
    ),
  );
}

void deleteMessageAlertDialogue(
  BuildContext context, {
  required String msgId,
  required dynamic msgRef,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: const Text('Delete message?\nThis can not be reversed'),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        insetPadding: EdgeInsets.all(10),
        actions: [
          AppTextButton(
            label: 'Proceed',
            onPressed: () {
              showLoadingIndicator(context);
              msgRef.doc(msgId).delete().then((value) {
                context.pop();
                context.pop();
                context.pop();
                showSnackBar(context, msg: 'Message deleted');
              }).catchError((e) {
                context.pop();
                context.pop();
                showSnackBar(context, msg: 'Unable to delete message');
              });
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

void leaveRoomDialogue(
  BuildContext context, {
  required String roomName,
  required String userId,
  required String roomId,
  required String spcId,
}) {
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
            onPressed: () {
              context.pop();
            },
          ),
          AppTextButton(
            label: 'Leave',
            onPressed: () {
              RoomDB().leave(
                context,
                spaceId: spcId,
                roomId: roomId,
                userId: userId,
                roomName: roomName,
              );
            },
          ),
        ],
      );
    },
  );
}

void deleteRoomDialogue(
  BuildContext context, {
  required String roomId,
  required String roomName,
  required String spaceId,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Text(
          'You are about to delete $roomName.\nAll participants will be removed and all messages will be deleted.\nThis cannot be undone.',
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        insetPadding: EdgeInsets.all(10),
        actions: [
          AppTextButton(
            label: 'Delete',
            onPressed: () {
              RoomDB().delete(
                context,
                roomId: roomId,
                roomName: roomName,
                spaceId: spaceId,
              );
            },
          ),
          AppTextButton(
            label: 'Cancel',
            onPressed: () {
              context.pop();
            },
          ),
        ],
      );
    },
  );
}

void deleteAccountDialogue(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: const Text(
          'You are about to delete your account. This cannot be reversed and your data will be lost forever.',
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        insetPadding: EdgeInsets.all(10),
        actions: [
          AppTextButton(
            label: 'Delete',
            onPressed: () {
              Auth().deleteAccount(context);
            },
          ),
          AppTextButton(
            label: 'Cancel',
            onPressed: () {
              context.pop();
            },
          ),
        ],
      );
    },
  );
}

void leaveSpaceDialogue(
  BuildContext context, {
  required Space space,
  required String spaceName,
  required String userId,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          'Leave $spaceName?',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actionsOverflowAlignment: OverflowBarAlignment.center,
        insetPadding: EdgeInsets.all(10),
        actions: [
          AppButton(
            label: 'Cancel',
            onPressed: () {
              context.pop();
            },
          ),
          AppTextButton(
            label: 'Leave',
            onPressed: () {
              SpaceDB()
                  .exit(context, space: space, userId: userId)
                  .then((value) => context.go(BNavBar.id));
            },
          ),
        ],
      );
    },
  );
}
