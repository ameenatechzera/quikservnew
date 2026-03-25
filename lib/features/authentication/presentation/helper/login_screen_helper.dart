import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/core/utils/widgets/app_snackbar.dart';
import 'package:quikservnew/features/authentication/domain/parameters/device_register_request.dart';
import 'package:quikservnew/features/authentication/domain/parameters/login_params.dart';
import 'package:quikservnew/features/authentication/presentation/bloc/logincubit/login_cubit.dart';
import 'package:quikservnew/features/authentication/presentation/bloc/registercubit/register_cubit.dart';
import 'package:quikservnew/features/authentication/presentation/widgets/expiry_dialog.dart';
import 'package:quikservnew/features/category/presentation/bloc/category_cubit.dart';
import 'package:quikservnew/features/groups/presentation/bloc/groups_cubit.dart';
import 'package:quikservnew/features/products/presentation/bloc/products_cubit.dart';
import 'package:quikservnew/features/sale/presentation/screens/home_screen.dart';
import 'package:quikservnew/features/settings/presentation/bloc/settings_cubit.dart';
import 'package:quikservnew/features/units/presentation/bloc/unit_cubit.dart';
import 'package:quikservnew/features/vat/presentation/bloc/vat_cubit.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';

class LoginScreenHelper {
  static bool validateLoginFields({
    required BuildContext context,
    required TextEditingController usernameCtrl,
    required TextEditingController passwordCtrl,
    required TextEditingController codeCtrl,
  }) {
    if (usernameCtrl.text.trim().isEmpty ||
        passwordCtrl.text.trim().isEmpty ||
        codeCtrl.text.trim().isEmpty) {
      showAppSnackBar(context, 'Please fill all fields');
      return false;
    }
    return true;
  }

  static Future<void> getDeviceId(
    TextEditingController deviceIdController,
  ) async {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      deviceIdController.text = androidInfo.id.toString();

      if (kDebugMode) {
        debugPrint('androidInfo.id ${androidInfo.id}');
      }
      return;
    }

    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      deviceIdController.text = iosInfo.identifierForVendor ?? 'unknown-ios-id';
      return;
    }

    deviceIdController.text = 'unsupported-platform';
  }

  static Future<void> handleRegisterState({
    required BuildContext context,
    required RegisterState state,
    required TextEditingController codeCtrl,
    required TextEditingController deviceIdController,
    required ValueNotifier<bool> isProcessing,
    required ValueNotifier<String> loadingMsg,
  }) async {
    if (state is RegisterLoading) {
      loadingMsg.value = "Logging in...";
      return;
    }

    if (state is RegisterSuccess) {
      final company = state.result.companyDetails.first;

      await SharedPreferenceHelper().setDatabaseName(company.databaseName!);
      await SharedPreferenceHelper().setExpiryDate(company.expiryDate!);
      await SharedPreferenceHelper().setCompanyName(company.companyName);
      await SharedPreferenceHelper().setCompanyAddress1(company.address1);
      await SharedPreferenceHelper().setCompanyAddress2(company.address2);
      await SharedPreferenceHelper().setCompanyPhoneNo(company.phone);

      try {
        await SharedPreferenceHelper().setCompanyLogo(company.companyLogo);
      } catch (_) {}

      loadingMsg.value = "Checking expirydate...";
      final expired = await isLicenseExpired();

      if (expired) {
        loadingMsg.value = "Loading, please wait...";
        showExpiryDialog(context);
        isProcessing.value = false;
        return;
      }

      loadingMsg.value = "Logging in...";
      context.read<LoginCubit>().checkDeviceRegisterStatus(
        DeviceRegisterRequest(deviceId: deviceIdController.text),
      );
      return;
    }

    if (state is RegisterFailure) {
      isProcessing.value = false;
      loadingMsg.value = "Loading, please wait...";
      showAppSnackBar(context, state.error);
      return;
    }
  }

  static Future<void> handleLoginState({
    required BuildContext context,
    required LoginState state,
    required TextEditingController usernameCtrl,
    required TextEditingController passwordCtrl,
    required TextEditingController codeCtrl,
    required TextEditingController deviceIdController,
    required ValueNotifier<bool> isProcessing,
    required ValueNotifier<String> loadingMsg,
  }) async {
    if (state is DeviceRegisterStatusSuccess) {
      await SharedPreferenceHelper().setDeviceID(deviceIdController.text);

      if (state.registerResponse.data?.result == true) {
        context.read<LoginCubit>().loginUser(
          LoginRequest(
            username: usernameCtrl.text.trim(),
            password: passwordCtrl.text.trim(),
          ),
        );
      } else {
        isProcessing.value = false;
        showAppSnackBar(context, 'Device Not Registered..!');
      }
      return;
    }

    if (state is LoginSuccess) {
      isProcessing.value = true;

      try {
        await SharedPreferenceHelper().setToken(state.loginResponse.token);
        await SharedPreferenceHelper().setBranchId(
          state.loginResponse.data.first.branchIds.first.toString(),
        );
        await SharedPreferenceHelper().setSubscriptionCode(
          codeCtrl.text.trim(),
        );
        await SharedPreferenceHelper().setStaffName(
          state.loginResponse.data.first.name,
        );

        loadingMsg.value = "Fetching Units...";
        await context.read<UnitCubit>().fetchUnits();

        loadingMsg.value = "Fetching Tax...";
        await context.read<VatCubit>().fetchVat();

        loadingMsg.value = "Fetching Groups...";
        await context.read<GroupsCubit>().fetchGroups();

        loadingMsg.value = "Fetching Products...";
        await context.read<ProductCubit>().fetchProducts();

        loadingMsg.value = "Fetching Settings...";
        await context.read<SettingsCubit>().fetchSettings();

        loadingMsg.value = "Fetching Categories...";
        await context.read<CategoriesCubit>().fetchCategories();

        if (!context.mounted) return;

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } catch (e) {
        isProcessing.value = false;
        loadingMsg.value = "Loading, please wait...";
        showAppSnackBar(context, "Error fetching data: $e");
      }
      return;
    }

    if (state is LoginFailure) {
      isProcessing.value = false;
      loadingMsg.value = "Loading, please wait...";
      showAppSnackBar(context, 'Invalid Credentials');
    }
  }

  static Future<void> handleSettingsState({
    required BuildContext context,
    required SettingsState state,
  }) async {
    if (state is SettingsLoaded) {
      final settings = state.settings.settings!.first;

      await SharedPreferenceHelper().setVatStatus(settings.vatStatus!);
      await SharedPreferenceHelper().setVatType(settings.vatType!);
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
      await SharedPreferenceHelper().setKOTStatus(
        (settings.isKOT ?? '').toString(),
      );

      if (kDebugMode) {
        final storedVatStatus = await SharedPreferenceHelper().getVatStatus();
        final storedVatType = await SharedPreferenceHelper().getVatType();

        debugPrint('VAT STATUS  : $storedVatStatus');
        debugPrint('VAT TYPE    : $storedVatType');
      }
      return;
    }

    if (state is SettingsError) {
      showAppSnackBar(context, state.error);
    }
  }
}
