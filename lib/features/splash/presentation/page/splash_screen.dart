import 'package:afforestation_app/core/routes/routes.dart';
import 'package:afforestation_app/core/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Redirect to the login page after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.go(Routes.login);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              'assets/icons/splash.png',
              width: 230.53,
              height: 238.77,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 50,
            child: Center(
              child: Text(
                'Afforestation App',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 40.0,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
