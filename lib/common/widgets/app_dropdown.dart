import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';

class AppDropdownField extends StatelessWidget {
  const AppDropdownField({
    super.key,
    required this.hintText,
    required this.value,
    this.items,
    this.onChanged,
  });

  final String hintText;
  final String? value;
  final List<DropdownMenuItem<String>>? items;
  final void Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        hintStyle: const TextStyle(fontWeight: FontWeight.normal),
        hintText: hintText,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 15,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppConstants.defaultBorderRadius,
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppConstants.defaultBorderRadius,
          borderSide: BorderSide(
            color: Colors.purple.shade300,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppConstants.defaultBorderRadius,
          borderSide: BorderSide(
            color: Colors.purple.shade300,
          ),
        ),
      ),
      items: items,
      onChanged: onChanged,
    );
  }
}
