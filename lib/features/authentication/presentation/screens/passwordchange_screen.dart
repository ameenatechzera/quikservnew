import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/core/utils/widgets/app_toast.dart';
import 'package:quikservnew/core/utils/widgets/common_appbar.dart';
import 'package:quikservnew/features/authentication/domain/parameters/changepassword_parameter.dart';
import 'package:quikservnew/features/authentication/presentation/bloc/registercubit/register_cubit.dart';

class PasswordChangeScreen extends StatelessWidget {
  PasswordChangeScreen({super.key});
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: "Change Password"),

      body: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is ChangePasswordFailure) {
            showAnimatedToast(
              context,
              message: state.message,
              isSuccess: false,
            );
          }

          if (state is ChangePasswordSuccess) {
            showAnimatedToast(
              context,
              message: 'Password updated successfully',
              isSuccess: true,
            );

            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          final isLoading = state is ChangePassworsLoading;
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Update your password',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Choose a strong password to keep your account secure.',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 30),

                /// OLD PASSWORD
                _passwordField(
                  label: 'Current Password',
                  controller: oldPasswordController,
                ),
                const SizedBox(height: 20),

                /// NEW PASSWORD
                _passwordField(
                  label: 'New Password',
                  controller: newPasswordController,
                ),
                const SizedBox(height: 20),

                /// CONFIRM PASSWORD
                _passwordField(
                  label: 'Confirm New Password',
                  controller: confirmPasswordController,
                ),
                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 4,
                    ),
                    onPressed: isLoading
                        ? null
                        : () {
                            if (oldPasswordController.text.isEmpty ||
                                newPasswordController.text.isEmpty ||
                                confirmPasswordController.text.isEmpty) {
                              showAnimatedToast(
                                context,
                                message: 'Please fill all fields',
                                isSuccess: false,
                              );

                              return;
                            }

                            if (newPasswordController.text !=
                                confirmPasswordController.text) {
                              showAnimatedToast(
                                context,
                                message: 'Passwords do not match',
                                isSuccess: false,
                              );

                              return;
                            }

                            final request = ChangePasswordRequest(
                              oldPassword: oldPasswordController.text.trim(),
                              newPassword: newPasswordController.text.trim(),
                              userId: 2,
                            );

                            context.read<RegisterCubit>().changePassword(
                              request,
                            );
                          },
                    child: isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Update Password',
                            style: TextStyle(
                              fontSize: 16,

                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _passwordField({
    required String label,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,

      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
