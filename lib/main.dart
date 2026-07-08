import 'package:afforestation_app/core/services/local/shared_pref.dart';
import 'package:afforestation_app/core/styles/themes.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:afforestation_app/feautures/auth/presentation/pages/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //DioProvider.init();
  await SharedPref.init();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: const LoginView(),
    );
  }
}