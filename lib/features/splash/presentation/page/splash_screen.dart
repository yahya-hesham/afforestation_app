import 'package:afforestation_app/core/functions/extenstion.dart';
import 'package:afforestation_app/core/routes/routes.dart';
import 'package:afforestation_app/core/services/local/shared_pref.dart';
import 'package:afforestation_app/features/auth/data/repository/aurth_repo.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Logo scale + fade
  late final AnimationController _logoController;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;

  // Title slide-up + fade
  late final AnimationController _titleController;
  late final Animation<double> _titleOpacity;
  late final Animation<Offset> _titleSlide;

  // Subtitle fade
  late final AnimationController _subtitleController;
  late final Animation<double> _subtitleOpacity;

  @override
  void initState() {
    super.initState();

    // --- Logo animation (0 → 900 ms) ---
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _logoScale = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOutBack,
    );
    _logoOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0, 0.5, curve: Curves.easeIn),
      ),
    );

    // --- Title animation (starts at 600 ms) ---
    _titleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _titleOpacity = CurvedAnimation(
      parent: _titleController,
      curve: Curves.easeIn,
    );
    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _titleController, curve: Curves.easeOutCubic),
        );

    // --- Subtitle animation (starts at 900 ms) ---
    _subtitleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _subtitleOpacity = CurvedAnimation(
      parent: _subtitleController,
      curve: Curves.easeIn,
    );

    // Chain the animations sequentially
    _logoController.forward().then((_) {
      _titleController.forward().then((_) {
        _subtitleController.forward().then((_) {
          Future.delayed(const Duration(milliseconds: 800), () {
            if (mounted) _handleNavigation();
          });
        });
      });
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _titleController.dispose();
    _subtitleController.dispose();
    super.dispose();
  }

  Future<void> _handleNavigation() async {
    if (SharedPref.isLoggedIn) {
      final credentials = SharedPref.getCredentials();
      if (credentials != null) {
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
                  'userName':
                      user?.name ?? user?.email?.split('@').first ?? 'مستخدم',
                  'userEmail': user?.email ?? '',
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

    if (mounted) context.go(Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2D5A27), // primary dark green
              Color(0xFF74C365), // secondary light green
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Logo ──────────────────────────────────────────
                  FadeTransition(
                    opacity: _logoOpacity,
                    child: ScaleTransition(
                      scale: _logoScale,
                      child: Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(24),
                        child: Image.asset(
                          'assets/icons/splash.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 36),

                  // ── App name ─────────────────────────────────────
                  SlideTransition(
                    position: _titleSlide,
                    child: FadeTransition(
                      opacity: _titleOpacity,
                      child: Text(
                        'Afforestation App',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── Tagline ───────────────────────────────────────
                  FadeTransition(
                    opacity: _subtitleOpacity,
                    child: Text(
                      'Growing a greener tomorrow',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withOpacity(0.85),
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),

                  const SizedBox(height: 60),

                  // ── Loading indicator ─────────────────────────────
                  FadeTransition(
                    opacity: _subtitleOpacity,
                    child: Column(
                      children: [
                        SizedBox(
                          width: 32,
                          height: 32,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'loading'.tr(),
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
