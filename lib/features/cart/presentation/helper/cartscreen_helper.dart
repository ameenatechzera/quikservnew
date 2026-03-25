import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/features/authentication/domain/parameters/device_register_request.dart';
import 'package:quikservnew/features/authentication/presentation/bloc/registercubit/register_cubit.dart';
import 'package:quikservnew/features/cart/domain/usecases/cart_manager.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreenHelper {
  String getTaxLabel(String? vatType) {
    switch (vatType?.toLowerCase()) {
      case 'tax':
        return 'Tax';
      case 'gst':
        return 'GST';
      default:
        return ''; // Default label if null or unknown
    }
  }

  Future<Map<String, dynamic>> calculateTotals() async {
    final items = CartManager().cartItems.value;
    final subTotal = items.fold(0.0, (sum, item) => sum + item.totalPrice);
    final discount = 0.0;

    final vatStatus = await SharedPreferenceHelper().getVatStatus();
    final vatType = await SharedPreferenceHelper().getVatType();
    double tax = 0.0;
    if (vatStatus == true) {
      // Apply 1% tax regardless of tax type (tax or gst)
      tax = subTotal * 0.01; // 1% tax
    }
    final total = subTotal - discount + tax;

    return {
      'subTotal': subTotal,
      'discount': discount,
      'tax': tax,
      'total': total,
      'vatType': vatType,
    };
  }

  Future<void> handleExpiryWarning({
    required BuildContext context,
    required TextEditingController expiredStatusController,
  }) async {
    expiredStatusController.text = 'true';
    final prefs = await SharedPreferences.getInstance();

    final today = DateTime.now();
    final todayKey =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    final expiryString = await SharedPreferenceHelper().getExpiryDate();

    if (expiryString.isEmpty || expiryString.trim().isEmpty) return;

    final expiry = DateTime.parse(expiryString);
    String? st_CurrentDate = await SharedPreferenceHelper().getCurrentDate();

    // final todayDate = DateTime(today.year, today.month, today.day);
    // final todayDate = await SharedPreferenceHelper().getCurrentDate();
    DateTime todayDate;
    try {
      todayDate = DateTime.parse(st_CurrentDate!);
      print('todayDate $todayDate');
    } catch (_) {
      todayDate = DateTime(today.year, today.month, today.day);
      print('todayDateCatch $todayDate');
    }

    final expDate = DateTime(expiry.year, expiry.month, expiry.day);

    final daysLeft = expDate.difference(todayDate).inDays;
    print('daysLeft $daysLeft');

    // if (daysLeft < 1 || daysLeft > 7) return;
    if (daysLeft > 7) return;

    //final lastShown = prefs.getString('expiry_warning_last_shown');

    //if (lastShown == todayKey) return; //check once in a day

    await prefs.setString('expiry_warning_last_shown', todayKey);

    if (!context.mounted) return;

    showExpirySoonDialog(
      context: context,
      daysLeft: daysLeft,
      expiryDate: expDate,
      expiredStatusController: expiredStatusController,
    );
  }

  Future<void> checkAndShowExpiryWarningOnceDaily({
    required BuildContext context,
    required TextEditingController expiredStatusController,
  }) async {
    print('reached__checkAndShowExpiryWarningOnceDaily');
    // try {
    final prefs = await SharedPreferences.getInstance();

    ///  CALL REGISTER API ONCE PER DAY

    DateTime today;
    final deviceId = await SharedPreferenceHelper().getDeviceID();
    String? st_CurrentDate = await SharedPreferenceHelper().getCurrentDate();

    print('st_CurrentDate $st_CurrentDate');

    if (st_CurrentDate != null && st_CurrentDate.isNotEmpty) {
      today = DateTime.parse(st_CurrentDate);
    } else {
      today = DateTime.now();
    }

    final todayKey =
        "${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
    print('todayKey $todayKey');

    final lastApiCall = prefs.getString('subscription_api_last_called') ?? '';

    // Remove time part (important if time exists)
    DateTime lastCall;
    int difference = 0;
    try {
      lastCall = DateTime.parse(lastApiCall);
      lastCall = DateTime(lastCall.year, lastCall.month, lastCall.day);

      difference = today.difference(lastCall).inDays;
    } catch (_) {}
    print("Difference in days: $difference");
    //if (lastApiCall != todayKey) {
    print('reachedHere');
    final code = await SharedPreferenceHelper().getSubscriptionCode();

    // if (code.isNotEmpty) {
    //   await context.read<RegisterCubit>().registerServer(
    //     RegisterServerRequest(slno: code),
    //   );
    // }
    if (code.isNotEmpty && difference >= 14) {
      context.read<RegisterCubit>().checkDeviceRegisterStatus(
        DeviceRegisterRequest(deviceId: deviceId.toString()),
      );
      await prefs.setString('subscription_api_last_called', todayKey);
    } else {
      print('ElselastApiCall $lastApiCall');
      if (lastApiCall.isEmpty) {
        context.read<RegisterCubit>().checkDeviceRegisterStatus(
          DeviceRegisterRequest(deviceId: deviceId.toString()),
        );

        await prefs.setString('subscription_api_last_called', todayKey);
      } else {
        await handleExpiryWarning(
          context: context,
          expiredStatusController: expiredStatusController,
        );
      }
    }
  }

  void showExpirySoonDialog({
    required BuildContext context,
    required int daysLeft,
    required DateTime expiryDate,
    required TextEditingController expiredStatusController,
  }) {
    String st_head = 'Subscription Expiring';
    String st_text =
        'Your subscription will expire in $daysLeft day(s).\n\nPlease renew to avoid interruption.';
    if (daysLeft == 0) {
      st_text = 'Your subscription expired.';
      st_head = 'Subscription Expired';
      expiredStatusController.text = 'false';
    } else {
      expiredStatusController.text = 'true';
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Color(0xFFFFC107)),
            Text(st_head),
          ],
        ),
        content: Text(st_text),
        actions: [
          TextButton(
            //onPressed: () => Navigator.pop(context),
            onPressed: () {
              if (daysLeft <= 0) {
                exit(0);
              } else {
                Navigator.pop(context);
              }
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
