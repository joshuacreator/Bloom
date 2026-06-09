import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';

class ImageViewer extends StatelessWidget {
  const ImageViewer({
    super.key,
    required this.image,
    this.onInfoIconPressed,
  });

  final String image;
  final void Function()? onInfoIconPressed;

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        height: AppConstants.spacingXl * 10,
        width: double.infinity,
        decoration: BoxDecoration(
          color: brightness == Brightness.dark
              ? AppColors.backgroundOnDark()
              : AppColors.backgroundOnLight(),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            width: 4,
            color: brightness == Brightness.dark
                ? AppColors.backgroundOnDark()
                : AppColors.backgroundOnLight(),
          ),
          image: DecorationImage(
            image: CachedNetworkImageProvider(image),
            fit: BoxFit.cover,
          ),
        ),
        child: onInfoIconPressed == null
            ? null
            : Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(24),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                    child: IconButton(
                      onPressed: onInfoIconPressed,
                      icon: const Icon(Icons.info_outline_rounded),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
