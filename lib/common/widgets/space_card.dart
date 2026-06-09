import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/extensions.dart';
import 'app_button.dart';
import 'show_more_text.dart';

class SpaceCard extends StatelessWidget {
  const SpaceCard({
    super.key,
    required this.img,
    required this.name,
    required this.desc,
    required this.isParticipant,
    this.onTap,
    this.onJoin,
  });

  final String? img;
  final String name;
  final String desc;
  final bool isParticipant;
  final void Function()? onTap;
  final void Function()? onJoin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.grey),
          ),
          child: Column(
            children: [
              Container(
                constraints: BoxConstraints(
                  maxHeight: context.defaultSize * 5,
                ),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      img ?? AppConstants.defaultSpaceImgPath,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (desc.isNotEmpty)
                AppShowMoreText(text: desc, trimLines: 3),
              const SizedBox(height: 10),
              if (!isParticipant)
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      label: 'Join',
                      onPressed: onJoin,
                    ),
                  ),
                )
              else
                const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}
