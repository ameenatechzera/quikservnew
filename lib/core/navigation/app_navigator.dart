import 'package:flutter/material.dart';

class AppNavigator {
  static Future<T?> pushSlide<T>({
    required BuildContext context,
    required Widget page,
    Duration duration = const Duration(milliseconds: 500),
  }) {
    return Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: duration,
        reverseTransitionDuration: duration,
        pageBuilder: (_, animation, __) => page,
        transitionsBuilder: (_, animation, __, child) {
          final offsetAnimation =
              Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut),
              );

          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }

  static void pop(BuildContext context) {
    Navigator.of(context).pop();
  }
}
