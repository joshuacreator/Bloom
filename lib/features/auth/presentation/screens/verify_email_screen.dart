import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/widgets/app_button.dart';
import '../providers/auth_provider.dart';
import 'auth_checker_screen.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  static String id = '/verify-email';

  const VerifyEmailScreen({super.key});

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _sendVerificationEmail();
    _timer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => FirebaseAuth.instance.currentUser?.reload(),
    );
  }

  Future<void> _sendVerificationEmail() async {
    await ref.read(authNotifierProvider.notifier).sendEmailVerificationLink();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).valueOrNull;
    final isVerified = user?.emailVerified ?? false;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'A verification email has been sent to your email.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          if (isVerified)
            AppButton(
              label: 'Verified',
              onTap: () => context.go(AuthCheckerScreen.id),
            ),
          if (!isVerified)
            AppButton(
              label: 'Cancel',
              onTap: () async {
                await ref.read(authNotifierProvider.notifier).signOut();
              },
            ),
        ],
      ),
    );
  }
}
