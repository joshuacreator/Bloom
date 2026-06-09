import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/exceptions/error_mapper.dart';
import '../../../../views/dialogues/snack_bar.dart';
import '../../../../views/widgets/app_button.dart';
import '../../../../views/widgets/app_text_buttons.dart';
import '../../../../views/widgets/app_text_field.dart';
import '../providers/auth_provider.dart';
import 'auth_checker_screen.dart';
import 'password_reset_screen.dart';
import 'register_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static String id = '/login';

  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(authNotifierProvider.notifier).login(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
    final state = ref.read(authNotifierProvider);
    if (state.hasError && mounted) {
      showSnackBar(
        context,
        msg: mapErrorToUserFriendlyMessage(
          state.error as AppException,
        ),
      );
    } else if (mounted) {
      context.go(AuthCheckerScreen.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authNotifierProvider).isLoading;
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppTextField(
                  label: 'Email',
                  hintText: 'Enter your email address',
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                ),
                const SizedBox(height: 20),
                AppTextField(
                  label: 'Password',
                  hintText: 'Enter your password',
                  controller: _passwordController,
                  obscureText: _obscureText,
                  suffixIcon: IconButton(
                    onPressed: () => setState(() {
                      _obscureText = !_obscureText;
                    }),
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                    ),
                    color: Colors.purple[300],
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppTextButton(
                      onPressed: () => context.go(PasswordResetScreen.id),
                      label: 'Reset password',
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppOutlinedButton(
                      label: 'Register',
                      onTap: () => context.go(RegisterScreen.id),
                    ),
                    AppButton(
                      label: 'Log In',
                      onTap: isLoading ? null : _handleLogin,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
