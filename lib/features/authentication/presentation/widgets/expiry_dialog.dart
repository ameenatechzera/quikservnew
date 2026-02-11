// =========================
// EXPIRY CHECK (FROM SHARED PREF)
// =========================
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';

Future<bool> isLicenseExpired() async {
  final expiryDateString = await SharedPreferenceHelper().getExpiryDate();

  print('📅 EXPIRY DATE FROM PREF: "$expiryDateString"');

  // ✅ FIRST INSTALL → allow login/register
  if (expiryDateString.isEmpty) {
    print('🟢 NO EXPIRY FOUND → FIRST INSTALL → NOT EXPIRED');
    return false;
  }
  try {
    final expiryDate = DateTime.parse(expiryDateString);
    // 4️⃣ Get today's date (device date)
    final DateTime today = DateTime.now();

    // Compare only date (ignore time)
    final exp = DateTime(expiryDate.year, expiryDate.month, expiryDate.day);
    final now = DateTime(today.year, today.month, today.day);

    // expired if today >= expiry
    return now.isAfter(exp) || now.isAtSameMomentAs(exp);
  } catch (_) {
    // ✅ If parsing fails, block (safer)
    return true;
  }
}

// =========================
// EXPIRY DIALOG
// =========================
void showExpiryDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      title: const Text('License Expired'),
      content: const Text(
        'Your Subscription has expired.\nPlease contact your Software Team.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
