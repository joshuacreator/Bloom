import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/space_entity.dart';
import '../notifiers/space_notifier.dart';
import '../providers/space_providers.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../views/widgets/space_card.dart';
import '../../../../views/widgets/b_nav_bar.dart';
import '../../../../views/dialogues/loading_indicator.dart';
import '../../../../views/dialogues/snack_bar.dart';
import '../../../../views/screens/search_screen.dart';
import '../../../../views/screens/space/space_info_screen.dart' as old;
import '../../../../views/screens/room/room_chats_screen.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../services/connection_state.dart';

class DiscoverSpacesScreen extends ConsumerWidget {
  static String id = 'discover-spaces';

  const DiscoverSpacesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateProvider).value!;
    final spaces = ref.watch(allSpacesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover Spaces'),
        actions: [
          IconButton(
            onPressed: () => showSearch(
              context: context,
              delegate: CustomSearchDelegate(),
            ),
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: spaces.when(
        data: (data) => data.isEmpty
            ? const Center(child: Text('Nothing to see here'))
            : ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final space = data[index];
                  final isParticipant =
                      space.participants?.contains(auth.uid) ?? false;
                  return SpaceCard(
                    img: space.image,
                    name: space.name,
                    desc: space.desc ?? '',
                    isParticipant: isParticipant,
                    onTap: () {
                      context.push(
                        '/${BNavBar.id}/${RoomChatsScreen.id}/${old.SpaceInfoScreen.id}',
                        extra: space,
                      );
                    },
                    onJoin: () async {
                      final isConnected = await isOnline();
                      if (!isConnected) {
                        if (context.mounted) {
                          showSnackBar(context, msg: "You're offline");
                        }
                        return;
                      }
                      if (context.mounted) {
                        ref.read(spaceNotifierProvider.notifier).joinSpace(
                              space.id!,
                              auth.uid,
                            );
                      }
                    },
                  );
                },
              ),
        error: (error, stackTrace) => const Center(
          child: Text('Oops! An error occurred'),
        ),
        loading: () => const Center(child: LoadingIndicator()),
      ),
    );
  }
}
