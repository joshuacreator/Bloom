import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../views/dialogues/loading_indicator.dart';
import '../../../../views/widgets/b_nav_bar.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';
import 'verify_email_screen.dart';

class AuthCheckerScreen extends ConsumerWidget {
  static String id = '/';

  const AuthCheckerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    return authState.when(
      data: (user) {
        if (user != null && user.emailVerified) {
          return const BNavBar();
        } else if (user != null && !user.emailVerified) {
          return const VerifyEmailScreen();
        }
        return const LoginScreen();
      },
      error: (_, __) => const Center(
        child: Text('An error occurred'),
      ),
      loading: () => const Center(child: LoadingIndicator()),
    );
  }
}
