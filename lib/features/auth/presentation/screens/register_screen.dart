import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/exceptions/error_mapper.dart';
import '../../../../common/widgets/snack_bar.dart';
import '../../../../common/widgets/app_button.dart';
import '../../../../common/widgets/app_text_field.dart';
import '../../domain/entities/user_entity.dart';
import '../providers/auth_provider.dart';
import 'auth_checker_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  static String id = '/register';

  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    final user = UserEntity(
      userId: '',
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: int.tryParse(_phoneController.text.trim()) ?? 0,
    );
    await ref.read(authNotifierProvider.notifier).register(
          _emailController.text.trim(),
          _passwordController.text.trim(),
          user,
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
      appBar: AppBar(title: const Text('Register')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppTextField(
                  label: 'Display name',
                  hintText: 'e.g. Joshua Ewaoche',
                  textInputAction: TextInputAction.next,
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  validate: false,
                ),
                const SizedBox(height: 20),
                AppTextField(
                  label: 'Phone number',
                  hintText: 'Enter your phone number',
                  textInputAction: TextInputAction.next,
                  controller: _phoneController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                AppTextField(
                  label: 'Email',
                  hintText: 'Enter your email address',
                  textInputAction: TextInputAction.next,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
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
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppOutlinedButton(
                      label: 'Login',
                      onPressed: () => context.go(LoginScreen.id),
                    ),
                    AppButton(
                      label: 'Register',
                      onPressed: isLoading ? null : _handleRegister,
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
