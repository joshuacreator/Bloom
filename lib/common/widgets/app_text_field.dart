import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.label = '',
    required this.hintText,
    this.maxLines = 1,
    this.minLines,
    this.textInputAction = TextInputAction.done,
    this.controller,
    this.onChanged,
    this.onFieldSubmitted,
    this.initialValue,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.validate = true,
    this.borderless = false,
    this.autofocus = false,
    this.expands = false,
  });

  final String? label;
  final String hintText;
  final int? maxLines;
  final int? minLines;
  final TextInputAction? textInputAction;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final String? initialValue;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final int? maxLength;
  final bool validate;
  final bool borderless;
  final bool autofocus;
  final bool expands;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validate
          ? (value) {
              if (value == null || value.isEmpty) {
                return 'This field cannot be empty';
              }
              return null;
            }
          : null,
      expands: expands,
      onChanged: onChanged,
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLength: maxLength,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 15,
        ),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: AppConstants.defaultBorderRadius,
        ),
        label: borderless ? null : Text(label!),
        hintText: hintText,
        hintStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          color: AppColors.grey,
        ),
        filled: borderless,
        fillColor: AppColors.grey.withValues(alpha: 0.3),
        focusedBorder: borderless
            ? OutlineInputBorder(
                borderRadius: AppConstants.defaultBorderRadius,
                borderSide: BorderSide.none,
              )
            : OutlineInputBorder(
                borderRadius: AppConstants.defaultBorderRadius,
                borderSide: const BorderSide(width: 2),
              ),
        enabledBorder: borderless
            ? OutlineInputBorder(
                borderRadius: AppConstants.defaultBorderRadius,
                borderSide: BorderSide.none,
              )
            : OutlineInputBorder(
                borderRadius: AppConstants.defaultBorderRadius,
              ),
      ),
      autofocus: autofocus,
      maxLines: maxLines,
      minLines: minLines,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      textInputAction: textInputAction,
      initialValue: initialValue,
    );
  }
}
