import 'package:flutter/material.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/core/utils/widgets/common_appbar.dart';
import 'package:quikservnew/features/masters/presentation/widgets/user_widgets.dart';

class UserCreationScreen extends StatelessWidget {
  const UserCreationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFEFF2F6),
      appBar: const CommonAppBar(title: "User Creation"),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                userdropdownField(),
                const SizedBox(height: 18),
                usertextField(label: "Name"),
                const SizedBox(height: 18),
                usertextField(label: "Username"),
                const SizedBox(height: 18),
                usertextField(label: "Password", isPassword: true),
                const SizedBox(height: 18),
                usertextField(label: "Re Enter Password", isPassword: true),
                const SizedBox(height: 26),

                SizedBox(
                  height: 44,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "Save",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
