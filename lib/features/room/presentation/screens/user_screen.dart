import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/widgets/app_circle_avatar.dart';
import '../../../../common/widgets/image_viewer.dart';
import '../../../../common/widgets/seperator.dart';
import '../../../../common/widgets/show_more_text.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/domain/entities/user_entity.dart';

final userStreamProvider = StreamProvider.family<UserEntity?, String>(
  (ref, userId) => ref.watch(anyUserProvider(userId)),
);

class UserScreen extends ConsumerWidget {
  static const String id = 'user-screen';

  const UserScreen({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userStreamProvider(userId));
    return Scaffold(
      appBar: AppBar(),
      body: userAsync.when(
        data: (user) {
          final userImg = user?.image ?? '';
          return ListView(
            children: [
              GestureDetector(
                onTap: () => showDialog(
                  context: context,
                  builder: (context) => ImageViewer(image: userImg),
                ),
                child: Hero(
                  tag: 'user-tag-${user?.userId ?? userId}',
                  child: AppCircleAvatar(
                    image: CachedNetworkImageProvider(userImg),
                    isActive: false,
                  ),
                ),
              ),
              AppConstants.height16,
              Text(
                user?.name ?? '',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Separator(),
              AppShowMoreText(text: user?.about ?? ''),
              if (user?.about != null && user!.about!.isNotEmpty)
                const Separator(),
            ],
          );
        },
        error: (_, __) => const Center(child: Text('Could not load user')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
