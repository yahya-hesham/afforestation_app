import 'package:afforestation_app/core/routes/routes.dart';
import 'package:afforestation_app/features/auth/presentation/pages/login.dart';
import 'package:afforestation_app/features/auth/presentation/pages/register_screen.dart';
import 'package:afforestation_app/features/dashboard/presentation/pages/user.dart';
import 'package:afforestation_app/features/dashboard/presentation/widgets/main_layout.dart';
import 'package:afforestation_app/features/notifications/presentation/pages/notifications_screen.dart';
import 'package:afforestation_app/features/splash/presentation/page/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final routes = GoRouter(
    initialLocation: Routes.splash,
    navigatorKey: navigatorKey,
    routes: [
      GoRoute(path: Routes.splash, builder: (context, state) => SplashScreen()),
      GoRoute(
        path: Routes.login,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: Routes.register,
        builder: (context, state) => AddUserScreen(),
      ),
      GoRoute(
        path: Routes.admin,
        builder: (context, state) => const MainLayout(),
      ),
      GoRoute(
        path: Routes.user,
        builder: (context, state) {
          final extra = state.extra as Map<String, String>?;
          return UserView(
            userName: extra?['userName'] ?? "مستخدم",
            userEmail: extra?['userEmail'] ?? "",
          );
        },
      ),
      GoRoute(
        path: Routes.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
    ],
  );
}
