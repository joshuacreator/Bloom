import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import 'image_viewer.dart';

class UserTile extends StatelessWidget {
  const UserTile({
    super.key,
    required this.title,
    required this.image,
    required this.tag,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final String title;
  final String image;
  final String tag;
  final String? subtitle;
  final Widget? trailing;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: GestureDetector(
        onTap: () => showDialog(
          context: context,
          builder: (context) => ImageViewer(image: image),
        ),
        child: Hero(
          tag: tag,
          child: CircleAvatar(
            radius: AppConstants.circularAvatarRadius,
            backgroundImage: CachedNetworkImageProvider(image),
          ),
        ),
      ),
      title: Text(title),
      subtitle: (subtitle == null || subtitle!.isEmpty)
          ? null
          : Text(
              subtitle!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      trailing: trailing,
    );
  }
}
