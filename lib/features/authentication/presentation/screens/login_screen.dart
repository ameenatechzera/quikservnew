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
  // Track processing (register/login/post-login APIs)
  final ValueNotifier<bool> isProcessing = ValueNotifier<bool>(false);

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
              isProcessing.value = false; // re-enable button
              print(state.error);
              showAppSnackBar(context, state.error);
            }
          },
        ),

        /// ------------------- LOGIN LISTENER -----------------------
        BlocListener<LoginCubit, LoginState>(
          listener: (context, state) async {
            if (state is LoginSuccess) {
              // Disable button during post-login API calls
              isProcessing.value = true;
              try {
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
              } catch (e) {
                showAppSnackBar(context, "Error fetching data: $e");
              } finally {
                isProcessing.value = false; // Enable button if needed
              }
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

                    // Login button
                    ValueListenableBuilder<bool>(
                      valueListenable: isProcessing,
                      builder: (context, processing, child) {
                        return SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed:
                                processing
                                    ? null
                                    : () {
                                      final slno = codeCtrl.text;
                                      if (slno == null) {
                                        showAppSnackBar(
                                          context,
                                          "Please enter a valid code",
                                        );
                                        return;
                                      }

                                      // Start processing
                                      isProcessing.value = true;

                                      // Trigger register first
                                      context
                                          .read<RegisterCubit>()
                                          .registerServer(
                                            RegisterServerRequest(slno: slno),
                                          );
                                    },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child:
                                processing
                                    ? Text('processing.......')
                                    : const Text(
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
