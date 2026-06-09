import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/exceptions/error_mapper.dart';
import '../../../../common/widgets/snack_bar.dart';
import '../../../../common/widgets/app_button.dart';
import '../../../../common/widgets/app_text_field.dart';
import '../providers/auth_provider.dart';

class PasswordResetScreen extends ConsumerStatefulWidget {
  static String id = '/password-reset';

  const PasswordResetScreen({super.key});

  @override
  ConsumerState<PasswordResetScreen> createState() =>
      _PasswordResetScreenState();
}

class _PasswordResetScreenState extends ConsumerState<PasswordResetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleReset() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      await ref.read(authNotifierProvider.notifier).sendPasswordResetLink(
            _emailController.text.trim(),
          );
      if (mounted) {
        showSnackBar(
          context,
          msg:
              'A password reset link has been sent to ${_emailController.text.trim()}',
        );
        context.pop();
      }
    } on AppException catch (e) {
      if (mounted) {
        showSnackBar(context, msg: mapErrorToUserFriendlyMessage(e));
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(context, msg: 'An unexpected error occurred.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Reset Password'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppTextField(
                  label: 'Email',
                  hintText: 'Enter your email address',
                  controller: _emailController,
                ),
                const SizedBox(height: 40),
                AppButton(
                  label: 'Proceed',
                  onTap: _handleReset,
                ),
                const SizedBox(height: 20),
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => context.pop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
