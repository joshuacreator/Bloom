import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/academics/presentation/screens/academics_home_screen.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/profile/presentation/screens/settings_screen.dart';
import '../../features/room/presentation/screens/room_chats_screen.dart';
import '../../features/space/domain/entities/space_entity.dart';
import '../../features/space/presentation/providers/space_providers.dart';

class BNavBar extends ConsumerStatefulWidget {
  static const String id = '/b-nav-bar';

  const BNavBar({super.key, this.space});

  final SpaceEntity? space;

  @override
  ConsumerState<BNavBar> createState() => _BNavBarState();
}

class _BNavBarState extends ConsumerState<BNavBar> {
  int _currentPage = 1;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider).valueOrNull;
    final userId = authState?.userId ?? '';
    final mySpacesAsync = ref.watch(mySpacesProvider(userId));
    final firstSpace = mySpacesAsync.valueOrNull?.isNotEmpty == true
        ? mySpacesAsync.valueOrNull!.first
        : null;
    final space = widget.space ?? firstSpace;

    return Scaffold(
      body: [
        if (space != null)
          RoomChatsScreen(spaceId: space.id)
        else
          const Center(child: Text('No space selected')),
        const AcademicsHomeScreen(),
        const SettingsScreen(),
      ][_currentPage],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (value) {
          setState(() {
            _currentPage = value;
          });
        },
        selectedIndex: _currentPage,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.chat_rounded),
            label: 'Chat',
            tooltip: 'Space',
          ),
          NavigationDestination(
            icon: Icon(Icons.school_rounded),
            label: 'Me',
            tooltip: 'My academics',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_rounded),
            label: 'Settings',
            tooltip: 'Settings',
          ),
        ],
      ),
    );
  }
}
