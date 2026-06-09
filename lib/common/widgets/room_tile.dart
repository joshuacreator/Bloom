import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../models/room.dart';
import 'image_viewer.dart';

class RoomTile extends StatelessWidget {
  const RoomTile({
    super.key,
    this.subtitle,
    this.trailing,
    required this.roomData,
    this.showInfoIcon = false,
    this.onTap,
    this.onInfoIconPressed,
  });

  final String? subtitle;
  final Widget? trailing;
  final Room roomData;
  final bool showInfoIcon;
  final void Function()? onTap;
  final void Function()? onInfoIconPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: GestureDetector(
        onTap: () => showDialog(
          context: context,
          builder: (context) => ImageViewer(
            image: (roomData.image == null || roomData.image!.isEmpty)
                ? AppConstants.defaultRoomImgPath
                : roomData.image!,
            onInfoIconPressed: showInfoIcon ? onInfoIconPressed : null,
          ),
        ),
        child: CircleAvatar(
          radius: AppConstants.circularAvatarRadius,
          backgroundImage: CachedNetworkImageProvider(
            (roomData.image == null || roomData.image!.isEmpty)
                ? AppConstants.defaultRoomImgPath
                : roomData.image!,
          ),
        ),
      ),
      title: Text(
        roomData.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 16),
      ),
      subtitle: (subtitle == null || subtitle!.isEmpty)
          ? null
          : Text(
              subtitle!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
