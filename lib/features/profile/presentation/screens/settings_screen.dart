import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/firestore_provider.dart';
import '../../../../providers/users_providers.dart';
import '../../../../services/auth.dart';
import '../../../../core/utils/connection_state.dart';
import '../../../../common/widgets/snack_bar.dart';
import '../../../../common/widgets/app_text_buttons.dart';
import '../../../../common/widgets/b_nav_bar.dart';
import '../../../../common/widgets/profile_tile.dart';
import '../../../../common/widgets/seperator.dart';
import '../../../../common/widgets/settings_tile.dart';
import '../screens/account_screen.dart';
import '../screens/theme_selector_screen.dart';

class SettingsScreen extends ConsumerWidget {
  static String id = 'settings';

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateProvider).value;
    final user = ref.watch(anyUserProvider(auth!.uid));
    final firestore = ref.watch(firestoreProvider);
    final email = auth.email;
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ProfileTile(
                  name: user.value?['name'] ?? '',
                  email: email ?? '',
                  imageUrl: user.value?['image'] ?? '',
                ),
                const Separator(),
                SettingTile(
                  title: user.value?['active'] == true
                      ? "You're currently Active"
                      : "You're currently Away",
                  leading: user.value?['active'] == true
                      ? Icons.person_pin_circle_outlined
                      : Icons.person_off_outlined,
                  onTap: () async {
                    bool isConnected = await isOnline();
                    if (!isConnected) {
                      if (context.mounted) {
                        showSnackBar(context, msg: "You're offline");
                      }
                      return;
                    }
                    firestore.collection('users').doc(auth.uid).update({
                      'active': user.value?['active'] == true ? false : true,
                    });
                  },
                ),
                SettingTile(
                  title: 'Account',
                  leading: Icons.account_circle_outlined,
                  onTap: () {
                    context.push(
                      '${BNavBar.id}/${SettingsScreen.id}/${AccountScreen.id}',
                    );
                  },
                ),
                const Separator(),
                SettingTile(
                  title: 'Appearance',
                  leading: Icons.light_mode_outlined,
                  onTap: () {
                    context.push(
                      '${BNavBar.id}/${SettingsScreen.id}/${ThemeSelectorScreen.id}',
                    );
                  },
                ),
                const Separator(),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: AppTextButtonIcon(
              label: 'Log out',
              icon: Icons.logout_rounded,
              onPressed: () {
                Auth().signOut(context);
                context.go('/login-screen');
              },
            ),
          ),
        ],
      ),
    );
  }
}
