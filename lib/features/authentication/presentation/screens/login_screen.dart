import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/core/utils/widgets/app_snackbar.dart';
import 'package:quikservnew/features/authentication/domain/parameters/register_server_params.dart';
import 'package:quikservnew/features/authentication/presentation/bloc/logincubit/login_cubit.dart';
import 'package:quikservnew/features/authentication/presentation/bloc/registercubit/register_cubit.dart';
import 'package:quikservnew/features/authentication/presentation/helper/login_screen_helper.dart';
import 'package:quikservnew/features/authentication/presentation/widgets/custom_textfield.dart';
import 'package:quikservnew/features/authentication/presentation/widgets/login_locks.dart';
import 'package:quikservnew/features/authentication/presentation/widgets/three_dot_loader.dart';
import 'package:quikservnew/features/settings/presentation/bloc/settings_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController codeCtrl = TextEditingController();
  final TextEditingController deviceIdController = TextEditingController();
  final ValueNotifier<bool> isProcessing = ValueNotifier<bool>(false);

  final ValueNotifier<String> loadingMsg = ValueNotifier<String>(
    "Loading, please wait...",
  );

  @override
  void initState() {
    super.initState();
    LoginScreenHelper.getDeviceId(deviceIdController);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
    return MultiBlocListener(
      listeners: [
        /// ------------------- REGISTER LISTENER -------------------
        BlocListener<RegisterCubit, RegisterState>(
          listener: (context, state) async {
            await LoginScreenHelper.handleRegisterState(
              context: context,
              state: state,
              codeCtrl: codeCtrl,
              deviceIdController: deviceIdController,
              isProcessing: isProcessing,
              loadingMsg: loadingMsg,
            );
          },
        ),

        /// ------------------- LOGIN LISTENER -----------------------
        BlocListener<LoginCubit, LoginState>(
          listener: (context, state) async {
            await LoginScreenHelper.handleLoginState(
              context: context,
              state: state,
              usernameCtrl: usernameCtrl,
              passwordCtrl: passwordCtrl,
              codeCtrl: codeCtrl,
              deviceIdController: deviceIdController,
              isProcessing: isProcessing,
              loadingMsg: loadingMsg,
            );
          },
        ),

        /// ------------------- SETTINGS LISTENER (VAT STORE HERE) -------------------
        BlocListener<SettingsCubit, SettingsState>(
          listener: (context, state) async {
            await LoginScreenHelper.handleSettingsState(
              context: context,
              state: state,
            );
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
                  child: ValueListenableBuilder<bool>(
                    valueListenable: isProcessing,
                    builder: (context, processing, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          /// Logo
                          Image.asset(
                            'assets/icons/quikservlogo.png',
                            width: 100,
                            height: 100,
                          ),
                          const SizedBox(height: 16),

                          /// Lock Icons
                          Loginlocks(),
                          const SizedBox(height: 16),

                          /// Input Fields
                          CustomInputField(
                            hint: 'User Name',
                            controller: usernameCtrl,

                            prefixIcon: Icons.person,
                            enabled: !processing,
                          ),
                          const SizedBox(height: 10),

                          CustomInputField(
                            hint: 'Password',
                            controller: passwordCtrl,
                            prefixIcon: Icons.lock,
                            isPassword: true,
                            suffixIcon: Icons.visibility,
                            enabled: !processing,
                          ),
                          const SizedBox(height: 10),

                          CustomInputField(
                            hint: 'Restaurant Code',
                            controller: codeCtrl,
                            prefixIcon: Icons.code,
                            textInputAction: TextInputAction.done,
                            enabled: !processing,
                          ),

                          const SizedBox(height: 20),

                          // Login button
                          SizedBox(
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

                                      final slno = codeCtrl.text;

                                      // Start processing
                                      isProcessing.value = true;
                                      // ✅ first message must stay same
                                      loadingMsg.value =
                                          "Loading, please wait...";
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
                                      children: [
                                        ThreeDotLoader(color: Colors.blue),
                                        SizedBox(height: 5),
                                        ValueListenableBuilder<String>(
                                          valueListenable: loadingMsg,
                                          builder: (context, msg, _) {
                                            return Text(
                                              msg,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            );
                                          },
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
                            ),
                          ),
                        ],
                      );
                    },
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
