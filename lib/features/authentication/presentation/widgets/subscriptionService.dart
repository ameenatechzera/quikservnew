import 'package:flutter/material.dart';
import 'package:quikservnew/features/authentication/domain/parameters/register_server_params.dart';
import 'package:quikservnew/features/authentication/presentation/bloc/registercubit/register_cubit.dart';
import 'package:quikservnew/features/authentication/presentation/widgets/subscriptionExpiredScreen.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubscriptionService {
  static const String expiryKey = "subscription_expiry_date";
  static const String lastCheckKey = "last_subscription_check";

  static Future<void> validateSubscription(
      BuildContext context,
     // String subscriptionCode,
      ) async {
    print('reachedSubscriptionChecl');
    final prefs = await SharedPreferences.getInstance();
    // await prefs.setString(
    //   lastCheckKey,
    //   '',
    // );

    final expiryString =await SharedPreferenceHelper().getExpiryDate();
    final lastCheck = prefs.getString(lastCheckKey);
    print('expiryString $expiryString');
    print('lastCheckDate $lastCheck');
    final subscriptionCode = await SharedPreferenceHelper().getSubscriptionCode();
   // final subscriptionCode = await SharedPreferenceHelper().getExpiryDate();
    DateTime now = DateTime.now();


    /// 1️⃣ Check stored expiry immediately
    if (expiryString != null) {
      final expiryDate = DateTime.parse(expiryString);
      print('expiryDate $expiryDate');
      print('nowDate $now');

      if (now.isAfter(expiryDate)) {
        print('Expired');
      //  _handleExpired(context);
        return;
      }
    }

    /// 2️⃣ Call API once per day
    bool shouldCallApi = false;

    if (lastCheck == null) {
      shouldCallApi = true;
    } else {
      final lastDate = DateTime.parse(lastCheck);

      if (lastDate.year != now.year ||
          lastDate.month != now.month ||
          lastDate.day != now.day) {
        shouldCallApi = true;
      }
    }

    if (shouldCallApi) {

      /// 🔥 THIS IS YOUR REQUIRED LINE
      // context.read<RegisterCubit>().registerServer(
      //   RegisterServerRequest(slno: subscriptionCode),
      // );

      await prefs.setString(
        lastCheckKey,
        now.toIso8601String(),
      );
    }
  }

  static Future<void> saveExpiryDate(String expiryDate) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(expiryKey, expiryDate);
  }

  static void _handleExpired(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const SubscriptionExpiredScreen(),
      ),
          (route) => false,
    );
  }
}
