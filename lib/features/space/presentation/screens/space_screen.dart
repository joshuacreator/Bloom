import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/space_entity.dart';
import '../providers/space_providers.dart';
import 'discover_space_screen.dart';
import 'create_space_screen.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../common/widgets/space_tile.dart';
import '../../../../common/widgets/seperator.dart';
import '../../../../common/widgets/b_nav_bar.dart';
import '../../../../common/widgets/loading_indicator.dart';

class SpaceScreen extends ConsumerWidget {
  const SpaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateProvider).value!;
    final spaces = ref.watch(mySpacesProvider(auth.uid));
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.05,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Space'),
          actions: [
            IconButton(
              onPressed: () {
                context.pop();
                context.push('/${BNavBar.id}/${DiscoverSpacesScreen.id}');
              },
              icon: const Icon(Icons.workspaces),
              tooltip: 'Discover Spaces',
            ),
            IconButton(
              onPressed: () {
                context.pop();
                context.push('/${BNavBar.id}/${CreateSpaceScreen.id}');
              },
              icon: const Icon(Icons.add_rounded),
              tooltip: 'Create Space',
            ),
          ],
        ),
        body: spaces.when(
          data: (data) => data.isEmpty
              ? const Center(
                  child: Text(
                    'Spaces you join will appear here',
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.only(top: 10),
                  itemCount: data.length,
                  separatorBuilder: (context, index) => const Separator(),
                  itemBuilder: (context, index) {
                    final space = data[index];
                    final dateTime =
                        DateFormat('dd MMM hh:mm a').format(space.createdAt);
                    return SpaceTile(
                      id: space.id!,
                      title: space.name,
                      subtitle: 'Created $dateTime',
                      image: space.image ?? '',
                      onTap: () {
                        context.pop();
                        context.go('/${BNavBar.id}', extra: space);
                      },
                    );
                  },
                ),
          error: (error, stackTrace) => const Center(
            child: Text('An error occurred'),
          ),
          loading: () => const Center(child: Center(child: LoadingIndicator())),
        ),
      ),
    );
  }
}
