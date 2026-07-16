import 'package:afforestation_app/core/routes/routes.dart';
import 'package:afforestation_app/core/services/local/shared_pref.dart';
import 'package:afforestation_app/core/styles/colors.dart';
import 'package:afforestation_app/features/auth/data/repository/aurth_repo.dart';
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
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _handleNavigation();
      }
    });
  }

  Future<void> _handleNavigation() async {
    // Check if the user has cached credentials
    if (SharedPref.isLoggedIn) {
      final credentials = SharedPref.getCredentials();
      if (credentials != null) {
        // Try auto-login with cached email & password
        try {
          final result = await AuthRepo.login(
            email: credentials.email,
            password: credentials.password,
          );
          if (result != null && mounted) {
            final role = SharedPref.getRole();
            if (role == 'Admin') {
              context.go(Routes.admin);
            } else {
              final user = SharedPref.getUserInfo();
              context.go(
                Routes.user,
                extra: {
                  'userName': user?.name ?? user?.email?.split('@').first ?? "مستخدم",
                  'userEmail': user?.email ?? "",
                },
              );
            }
            return;
          }
        } catch (_) {
          // Auto-login failed — fall through to login screen
        }
      }
    }

    // No cached session or auto-login failed — go to login
    if (mounted) {
      context.go(Routes.login);
    }
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

