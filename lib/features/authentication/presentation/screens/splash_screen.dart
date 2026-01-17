import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/features/sale/presentation/screens/home_screen.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState(); // Wait for first frame to avoid jump / bottom animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _opacity = 1.0; // fade in logo
      });
    });
    _navigateNext();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Override global status bar ONLY for splash
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // or your splash bg color
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
          child: Image.asset(
            "assets/icons/QUIKSERV LOGO 02 1.png",
            fit: BoxFit.contain,
          ),
        ),
        // child: Column(
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     Image.asset(
        //       "assets/icons/QUIKSERV LOGO 02 1.png",

        //       fit: BoxFit.contain,
        //     ),
        //     const SizedBox(height: 16),
        //   ],
        // ),
      ),
    );
  }

  Future<void> _navigateNext() async {
    final sharedPrefHelper = SharedPreferenceHelper();
    final token = await sharedPrefHelper.getToken();

    // Optional: keep splash for 3 seconds
    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, __, ___) =>
            token != null && token.isNotEmpty ? HomeScreen() : LoginScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }
}
