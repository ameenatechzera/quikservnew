import 'package:flutter/material.dart';
import 'package:quikservnew/core/theme/colors.dart';

class CustomInputField extends StatelessWidget {
  final String hint;
  final IconData prefixIcon;
  final bool isPassword;
  final IconData? suffixIcon;
  final TextEditingController? controller;
  final TextInputAction textInputAction;
  final bool enabled;
  final ValueNotifier<bool> obscureNotifier = ValueNotifier(true);
  CustomInputField({
    super.key,
    required this.hint,
    required this.prefixIcon,
    this.isPassword = false,
    this.suffixIcon,
    this.controller,
    this.textInputAction = TextInputAction.next,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: obscureNotifier,
      builder: (context, isObscure, child) {
        return TextField(
          controller: controller,
          obscureText: isPassword ? isObscure : false,
          textInputAction: textInputAction,
          enabled: enabled,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(prefixIcon),
            suffixIcon: isPassword
                ? IconButton(
                    onPressed: () {
                      obscureNotifier.value = !obscureNotifier.value;
                    },
                    icon: Icon(
                      isObscure ? Icons.visibility_off : Icons.visibility,
                    ),
                  )
                : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
            filled: true,
            fillColor: Colors.white.withOpacity(0.9),
          ),
        );
      },
    );
  }
}
