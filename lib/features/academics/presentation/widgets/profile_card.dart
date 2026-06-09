import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    required this.studentId,
    required this.name,
    required this.intake,
    required this.image,
  });

  final String studentId, name, intake, image;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppConstants.defaultBorderRadius,
        boxShadow: [
          BoxShadow(
            color: AppColors.lightGrey.withOpacity(0.2),
            spreadRadius: 2.0,
            blurRadius: 2.0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: AppConstants.circularAvatarRadius,
                backgroundImage: CachedNetworkImageProvider(image),
              ),
              const Gap(10.0),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    ),
                  ),
                  Text(
                    intake,
                    style: TextStyle(color: AppColors.black),
                  ),
                ],
              ),
            ],
          ),
          Flexible(
            child: QrImageView(
              data: studentId,
              backgroundColor: AppColors.white,
              size: AppConstants.circularAvatarRadius * 2,
              gapless: true,
              padding: const EdgeInsets.all(5.0),
            ),
          ),
        ],
      ),
    );
  }
}
