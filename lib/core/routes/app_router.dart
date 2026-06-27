import 'package:bookia/core/routes/routes.dart';
import 'package:bookia/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:bookia/features/auth/presentation/login_register/page/login_screen.dart';
import 'package:bookia/features/auth/presentation/login_register/page/register_screen.dart';
import 'package:bookia/features/checkout/presentation/cubit/checkout_cubit.dart';
import 'package:bookia/features/checkout/presentation/page/place_order_screen.dart.dart';
import 'package:bookia/features/details/page/details_screen.dart';
import 'package:bookia/features/home/data/models/best_seller_response/product.dart';
import 'package:bookia/features/main/main_app_screen.dart';
import 'package:bookia/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:bookia/features/profile/presentation/page/edit_profile_screen.dart';
import 'package:bookia/features/search/presentation/cubit/search_cubit.dart';
import 'package:bookia/features/search/presentation/page/search_screen.dart';
import 'package:bookia/features/splash/splash_screen.dart';
import 'package:bookia/features/welcome/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final routes = GoRouter(
    navigatorKey: navigatorKey,
    routes: [
          ],
  );
}
  