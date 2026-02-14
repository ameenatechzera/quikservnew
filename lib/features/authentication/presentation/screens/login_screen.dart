import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/core/utils/widgets/app_snackbar.dart';
import 'package:quikservnew/features/authentication/domain/parameters/login_params.dart';
import 'package:quikservnew/features/authentication/domain/parameters/register_server_params.dart';
import 'package:quikservnew/features/authentication/presentation/bloc/logincubit/login_cubit.dart';
import 'package:quikservnew/features/authentication/presentation/bloc/registercubit/register_cubit.dart';
import 'package:quikservnew/features/authentication/presentation/widgets/custom_textfield.dart';
import 'package:quikservnew/features/authentication/presentation/widgets/expiry_dialog.dart';
import 'package:quikservnew/features/authentication/presentation/widgets/login_locks.dart';
import 'package:quikservnew/features/authentication/presentation/widgets/three_dot_loader.dart';
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
    // ✅ Override global status bar ONLY for login
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // or login bg color
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
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
              await SharedPreferenceHelper().setExpiryDate(
                state.result.companyDetails.first.expiryDate!,
              );

              /// ✅ STORE COMPANY NAME
              await SharedPreferenceHelper().setCompanyName(
                state.result.companyDetails.first.companyName,
              );

              /// ✅ STORE COMPANY Address1
              await SharedPreferenceHelper().setCompanyAddress1(
                state.result.companyDetails.first.address1,
              );

              /// ✅ STORE COMPANY Address2
              await SharedPreferenceHelper().setCompanyAddress2(
                state.result.companyDetails.first.address2,
              );

              /// ✅ STORE COMPANY PhoneNo
              await SharedPreferenceHelper().setCompanyPhoneNo(
                state.result.companyDetails.first.phone,
              );
              final logoutStatus = await SharedPreferenceHelper()
                  .getLogoutStatus();
              //if(logoutStatus=='true')
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
            } else if (state is LoginFailure) {
              isProcessing.value = false; // re-enable button
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
                print('reached_0');

                /// Save token globally
                await SharedPreferenceHelper().setToken(
                  state.loginResponse.token,
                );
                print('reached_1');
                await SharedPreferenceHelper().setBranchId(
                  state.loginResponse.data.first.branchIds.first.toString(),
                );
                await SharedPreferenceHelper().setSubscriptionCode(
                  codeCtrl.text.toString(),
                );

                print('reached_2');
                await SharedPreferenceHelper().setStaffName(
                  state.loginResponse.data.first.name,
                );
                print('reached_3');

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
              isProcessing.value = false;
              showAppSnackBar(context, 'Invalid Credentials');
            }
          },
        ),

        /// ------------------- SETTINGS LISTENER (VAT STORE HERE) -------------------
        BlocListener<SettingsCubit, SettingsState>(
          listener: (context, state) async {
            if (state is SettingsLoaded) {
              final settings = state.settings.settings!.first;

              /// 🔍 DEBUG: Print raw values from API
              debugPrint('🧾 SETTINGS API RESPONSE');
              debugPrint('VAT STATUS  : ${settings.vatStatus}');
              debugPrint('VAT TYPE    : ${settings.vatType}');
              debugPrint('APP VERSION    : ${settings.appVersion}');

              /// ✅ STORE VAT STATUS & TYPE FROM SETTINGS API
              await SharedPreferenceHelper().setVatStatus(settings.vatStatus!);
              await SharedPreferenceHelper().setVatType(settings.vatType!);

              // ✅ STORE LEDGER IDS + APP VERSION
              await SharedPreferenceHelper().setCashLedgerId(
                (settings.cashLedgerId ?? '').toString(),
              );
              await SharedPreferenceHelper().setCardLedgerId(
                (settings.cardLedgerId ?? '').toString(),
              );
              await SharedPreferenceHelper().setBankLedgerId(
                (settings.bankLedgerId ?? '').toString(),
              );
              await SharedPreferenceHelper().setAppVersion(
                (settings.appVersion ?? '').toString(),
              );
              final storedVatStatus = await SharedPreferenceHelper()
                  .getVatStatus();
              final storedVatType = await SharedPreferenceHelper().getVatType();

              debugPrint('💾 STORED IN SHARED PREFS');
              debugPrint('VAT STATUS  : $storedVatStatus');
              debugPrint('VAT TYPE    : $storedVatType');
            }

            if (state is SettingsError) {
              debugPrint('❌ SETTINGS ERROR: ${state.error}');
              showAppSnackBar(context, state.error);
            }
          },
        ),
      ],

      /// ------------------- UI STARTS HERE ------------------------
      child: PopScope(
        canPop: false, // 🚫 disables system back
        child: Scaffold(
          backgroundColor: AppColors.white,
          resizeToAvoidBottomInset: true,
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
                    vertical: 100,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /// Logo
                      Image.asset(
                        'assets/icons/quikservlogo.png',
                        width: 100,
                        height: 100,
                      ),
                      const SizedBox(height: 16),

                      /// Title
                      // const Text(
                      //   'Login',
                      //   style: TextStyle(
                      //     fontSize: 24,
                      //     fontWeight: FontWeight.bold,
                      //     color: AppColors.black,
                      //   ),
                      // ),
                      //
                      // const SizedBox(height: 32),

                      /// Lock Icons
                      Loginlocks(),
                      const SizedBox(height: 16),

                      /// Input Fields
                      CustomInputField(
                        hint: 'User Name',
                        controller: usernameCtrl,

                        prefixIcon: Icons.person,
                      ),
                      const SizedBox(height: 10),

                      CustomInputField(
                        hint: 'Password',
                        controller: passwordCtrl,
                        prefixIcon: Icons.lock,
                        obscure: true,
                        suffixIcon: Icons.visibility,
                      ),
                      const SizedBox(height: 10),

                      CustomInputField(
                        hint: 'Restaurant Code',
                        controller: codeCtrl,
                        prefixIcon: Icons.code,
                        textInputAction: TextInputAction.done,
                      ),

                      const SizedBox(height: 20),

                      // Login button
                      ValueListenableBuilder<bool>(
                        valueListenable: isProcessing,
                        builder: (context, processing, child) {
                          return SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: processing
                                  ? null
                                  : () async {
                                      if (usernameCtrl.text.isEmpty ||
                                          passwordCtrl.text.isEmpty ||
                                          codeCtrl.text.isEmpty) {
                                        showAppSnackBar(
                                          context,
                                          'Please fill all fields',
                                        );
                                        return;
                                      }
                                      //  EXPIRY CHECK FIRST (BEFORE ANYTHING)
                                      final expired = await isLicenseExpired();
                                      if (expired) {
                                        showExpiryDialog(context);
                                        return; //  STOP EVERYTHING
                                      }
                                      final slno = codeCtrl.text;

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
                              child: processing
                                  ? Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        ThreeDotLoader(color: Colors.blue),
                                        SizedBox(height: 5),
                                        Text(
                                          "Loading, please wait...",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ],
                                    )
                                  : const Text(
                                      'Login',
                                      style: TextStyle(
                                        color: AppColors.black,
                                        fontSize: 18,
                                      ),
                                    ),
                              // child: processing
                              //     ? Text('processing.......')
                              //     : const Text(
                              //         'Login',
                              //         style: TextStyle(
                              //           color: AppColors.black,
                              //           fontSize: 18,
                              //         ),
                              //       ),
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
      ),
    );
  }
}
