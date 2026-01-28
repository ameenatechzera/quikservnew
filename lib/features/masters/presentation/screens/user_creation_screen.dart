import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/core/utils/widgets/app_snackbar.dart';
import 'package:quikservnew/core/utils/widgets/common_appbar.dart';

import 'package:quikservnew/features/masters/domain/entities/user_types_result.dart';
import 'package:quikservnew/features/masters/domain/parameters/save_user_parameters.dart';
import 'package:quikservnew/features/masters/presentation/bloc/user_creation_cubit.dart';
import 'package:quikservnew/features/masters/presentation/widgets/user_widgets.dart';

class UserCreationScreen extends StatelessWidget {
  UserCreationScreen({super.key});
  final TextEditingController userTypeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    String? selectedUserType;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserCreationCubit>().fetchUserTypes();
    });
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
                BlocConsumer<UserCreationCubit, UserCreationState>(
                  listener: (context, state) {
                    if (state is FetchUserTypesLoaded) {
                      selectedUserType = state.userTypes.first.typeId
                          .toString();
                      userTypeController.text = selectedUserType.toString();
                    }
                    if (state is SaveUserCompleted) {
                      showAppSnackBar(context, 'User Created Successfully..!');
                      Navigator.pop(context);
                    }
                  },
                  builder: (context, state) {
                    if (state is FetchUserTypesLoaded) {
                      List<UserTypes> list_userTypes = [];
                      list_userTypes.addAll(state.userTypes);
                      return userDropdownField(
                        list_userTypes,
                        selectedUserType,
                        (value) {
                          print('selectedValue $value');
                          userTypeController.text = value!;
                        },
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
                const SizedBox(height: 18),
                usertextField(label: "Name", controller: nameController),
                const SizedBox(height: 18),
                usertextField(
                  label: "Username",
                  controller: usernameController,
                ),
                const SizedBox(height: 18),
                usertextField(
                  label: "Password",
                  isPassword: true,
                  controller: passwordController,
                ),
                const SizedBox(height: 18),
                usertextField(
                  label: "Re Enter Password",
                  isPassword: true,
                  controller: confirmPasswordController,
                ),
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
                    onPressed: () {
                      print('nameController ${nameController.text.toString()}');
                      print(
                        'passwordController ${passwordController.text.toString()}',
                      );
                      // bool saveStatus = saveValidation(context);
                      int userTypeId = int.parse(
                        userTypeController.text.toString(),
                      );
                      context.read<UserCreationCubit>().saveUser(
                        SaveUserParameters(
                          username: nameController.text.toString(),
                          password: passwordController.text.toString(),
                          user_type: userTypeId,
                          isactive: 1,
                          name: nameController.text.toString(),

                          branchIds: [],
                          CreatedUser: '',
                        ),
                      );
                    },
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

  bool saveValidation(BuildContext context) {
    bool saveStatus = true;
    print('nameController ${nameController.text.toString()}');
    print('passwordController ${passwordController.text.toString()}');
    String stPassword = passwordController.text.toString().trim();
    String stConfirmPassword = confirmPasswordController.text.toString().trim();
    if (nameController.text.toString().isEmpty) {
      showAppSnackBar(context, 'Name cant be empty');
      saveStatus = false;
    } else if (userTypeController.text.toString().isEmpty) {
      showAppSnackBar(context, 'Usertype cant be empty');
      saveStatus = false;
    } else if (usernameController.text.toString().isEmpty) {
      showAppSnackBar(context, 'Username cant be empty');
      saveStatus = false;
    } else if (passwordController.text.toString().isEmpty) {
      showAppSnackBar(context, 'Password cant be empty');
      saveStatus = false;
    } else if (confirmPasswordController.text.toString().isEmpty) {
      showAppSnackBar(context, 'Confirm password cant be empty');
      saveStatus = false;
    } else {
      if (stPassword != stConfirmPassword) {
        showAppSnackBar(context, 'Password and confirm password mismatch');
        saveStatus = false;
      }
    }
    return saveStatus;
  }
}
