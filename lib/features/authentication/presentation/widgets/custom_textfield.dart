import 'package:flutter/material.dart';
import 'package:quikservnew/core/theme/colors.dart';

class CustomInputField extends StatelessWidget {
  final String hint;
  final IconData prefixIcon;
  final bool obscure;
  final IconData? suffixIcon;
  final TextEditingController? controller;
  final TextInputAction textInputAction;
  final bool enabled;
  const CustomInputField({
    super.key,
    required this.hint,
    required this.prefixIcon,
    this.obscure = false,
    this.suffixIcon,
    this.controller,
    this.textInputAction = TextInputAction.next,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      textInputAction: textInputAction,
      enabled: enabled,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(prefixIcon),
        suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
      ),
    );
  }
}
