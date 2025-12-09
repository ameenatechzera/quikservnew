// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:quikservnew/core/theme/colors.dart';
// import 'package:quikservnew/core/utils/widgets/app_snackbar.dart';
// import 'package:quikservnew/features/authentication/domain/parameters/login_params.dart';
// import 'package:quikservnew/features/authentication/domain/parameters/register_server_params.dart';
// import 'package:quikservnew/features/authentication/presentation/bloc/logincubit/login_cubit.dart';
// import 'package:quikservnew/features/authentication/presentation/bloc/registercubit/register_cubit.dart';
// import 'package:quikservnew/features/authentication/presentation/widgets/custom_textfield.dart';
// import 'package:quikservnew/features/authentication/presentation/widgets/login_locks.dart';
// import 'package:quikservnew/features/directsale/presentation/screens/home_screen.dart';

// class LoginScreen extends StatelessWidget {
//   LoginScreen({super.key});
//   final TextEditingController usernameCtrl = TextEditingController();
//   final TextEditingController passwordCtrl = TextEditingController();
//   final TextEditingController codeCtrl = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.white,
//       resizeToAvoidBottomInset: false,
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           Image.asset(
//             'assets/images/WhatsApp Image 2025-12-02 at 11.45.21_c494808e.jpg',
//             fit: BoxFit.cover,
//           ),

//           SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 24,
//                 vertical: 150,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Image.asset(
//                     'assets/icons/quikserv_icon.png',
//                     width: 80,
//                     height: 80,
//                   ),
//                   const SizedBox(height: 16),
//                   const Text(
//                     'Login',
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.black,
//                     ),
//                   ),
//                   const SizedBox(height: 32),
//                   Loginlocks(),
//                   const SizedBox(height: 32),
//                   CustomInputField(
//                     hint: 'User Name',
//                     controller: usernameCtrl,
//                     prefixIcon: Icons.person,
//                   ),

//                   const SizedBox(height: 16),
//                   CustomInputField(
//                     hint: 'Password',
//                     controller: passwordCtrl,
//                     prefixIcon: Icons.lock,
//                     obscure: true,
//                     suffixIcon: Icons.visibility,
//                   ),

//                   SizedBox(height: 16),

//                   CustomInputField(
//                     hint: 'Restaurant Code',
//                     controller: codeCtrl,
//                     prefixIcon: Icons.code,
//                   ),

//                   const SizedBox(height: 50),
//                   BlocBuilder<RegisterCubit, RegisterState>(
//                     builder: (context, state) {
//                       return SizedBox(
//                         width: double.infinity,
//                         height: 50,
//                         child: ElevatedButton(
//                           onPressed: () {
//                             final slno = int.tryParse(codeCtrl.text);
//                             if (slno == null) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                   content: Text("Please enter a valid code"),
//                                 ),
//                               );
//                               return;
//                             }
//                             // Trigger registration
//                             context.read<RegisterCubit>().registerServer(
//                               RegisterServerRequest(
//                                 slno: int.parse(codeCtrl.text),
//                               ),
//                             );
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: AppColors.primary,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                           child: const Text(
//                             'Login',
//                             style: TextStyle(
//                               color: AppColors.black,
//                               fontSize: 18,
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                   // BlocListener for Register -> Login -> Navigate
//                   BlocListener<RegisterCubit, RegisterState>(
//                     listener: (context, state) {
//                       if (state is RegisterSuccess) {
//                         // Trigger login after successful registration
//                         context.read<LoginCubit>().loginUser(
//                           LoginRequest(
//                             username: usernameCtrl.text,
//                             password: passwordCtrl.text,
//                           ),
//                         );
//                       } else if (state is RegisterFailure) {
//                         // ScaffoldMessenger.of(
//                         //   context,
//                         // ).showSnackBar(SnackBar(content: Text(state.error)));
//                         showAppSnackBar(context, state.error);
//                       }
//                     },
//                     child: BlocListener<LoginCubit, LoginState>(
//                       listener: (context, state) {
//                         if (state is LoginSuccess) {
//                           Navigator.of(context).pushReplacement(
//                             MaterialPageRoute(builder: (_) => HomeScreen()),
//                           );
//                         } else if (state is LoginFailure) {
//                           showAppSnackBar(context, state.error);
//                         }
//                       },
//                       child: const SizedBox.shrink(),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/core/utils/widgets/app_snackbar.dart';
import 'package:quikservnew/features/authentication/domain/parameters/login_params.dart';
import 'package:quikservnew/features/authentication/domain/parameters/register_server_params.dart';
import 'package:quikservnew/features/authentication/presentation/bloc/logincubit/login_cubit.dart';
import 'package:quikservnew/features/authentication/presentation/bloc/registercubit/register_cubit.dart';
import 'package:quikservnew/features/authentication/presentation/widgets/custom_textfield.dart';
import 'package:quikservnew/features/authentication/presentation/widgets/login_locks.dart';
import 'package:quikservnew/features/category/presentation/bloc/category_cubit.dart';
import 'package:quikservnew/features/groups/presentation/bloc/groups_cubit.dart';
import 'package:quikservnew/features/products/presentation/bloc/products_cubit.dart';
import 'package:quikservnew/features/settings/presentation/bloc/settings_cubit.dart';
import 'package:quikservnew/features/units/presentation/bloc/unit_cubit.dart';
import 'package:quikservnew/features/sale/presentation/screens/home_screen.dart';
import 'package:quikservnew/features/vat/presentation/bloc/vat_cubit.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController usernameCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController codeCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        /// ------------------- REGISTER LISTENER -------------------
        BlocListener<RegisterCubit, RegisterState>(
          listener: (context, state) async {
            if (state is RegisterSuccess) {
              /// Save database name globally
              await SharedPreferenceHelper().setDatabaseName(
                state.result.companyDetails.first.databaseName!,
              );

              /// After register -> trigger login
              context.read<LoginCubit>().loginUser(
                LoginRequest(
                  username: usernameCtrl.text,
                  password: passwordCtrl.text,
                ),
              );
            } else if (state is RegisterFailure) {
              showAppSnackBar(context, state.error);
            }
          },
        ),

        /// ------------------- LOGIN LISTENER -----------------------
        BlocListener<LoginCubit, LoginState>(
          listener: (context, state) async {
            if (state is LoginSuccess) {
              /// Save token globally
              await SharedPreferenceHelper().setToken(
                state.loginResponse.token,
              );

              /// Trigger fetching units
              await context.read<UnitCubit>().fetchUnits();

              /// 🔹 Fetch VAT
              await context.read<VatCubit>().fetchVat();

              /// Fetch Groups
              await context.read<GroupsCubit>().fetchGroups();

              /// Trigger fetching Products
              await context.read<ProductCubit>().fetchProducts();
              await context.read<SettingsCubit>().fetchSettings();
              await context.read<CategoriesCubit>().fetchCategories();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => HomeScreen()),
              );
            } else if (state is LoginFailure) {
              showAppSnackBar(context, state.error);
            }
          },
        ),
      ],

      /// ------------------- UI STARTS HERE ------------------------
      child: Scaffold(
        backgroundColor: AppColors.white,
        resizeToAvoidBottomInset: false,
        body: Stack(
          fit: StackFit.expand,
          children: [
            /// Background Image
            Image.asset(
              'assets/images/WhatsApp Image 2025-12-02 at 11.45.21_c494808e.jpg',
              fit: BoxFit.cover,
            ),

            /// Content
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 150,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// Logo
                    Image.asset(
                      'assets/icons/quikserv_icon.png',
                      width: 80,
                      height: 80,
                    ),
                    const SizedBox(height: 16),

                    /// Title
                    const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),

                    const SizedBox(height: 32),

                    /// Lock Icons
                    Loginlocks(),
                    const SizedBox(height: 32),

                    /// Input Fields
                    CustomInputField(
                      hint: 'User Name',
                      controller: usernameCtrl,
                      prefixIcon: Icons.person,
                    ),
                    const SizedBox(height: 16),

                    CustomInputField(
                      hint: 'Password',
                      controller: passwordCtrl,
                      prefixIcon: Icons.lock,
                      obscure: true,
                      suffixIcon: Icons.visibility,
                    ),
                    const SizedBox(height: 16),

                    CustomInputField(
                      hint: 'Restaurant Code',
                      controller: codeCtrl,
                      prefixIcon: Icons.code,
                    ),

                    const SizedBox(height: 50),

                    /// LOGIN BUTTON
                    BlocBuilder<RegisterCubit, RegisterState>(
                      builder: (context, state) {
                        return SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              final slno = int.tryParse(codeCtrl.text);

                              if (slno == null) {
                                showAppSnackBar(
                                  context,
                                  "Please enter a valid code",
                                );
                                return;
                              }

                              /// First perform register
                              context.read<RegisterCubit>().registerServer(
                                RegisterServerRequest(slno: slno),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
