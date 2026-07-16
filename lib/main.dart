import 'package:afforestation_app/core/services/local/shared_pref.dart';
import 'package:afforestation_app/core/styles/themes.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:afforestation_app/feautures/users/presentation/pages/add_new_operation_screen.dart';
=======
import 'package:afforestation_app/features/auth/presentation/pages/login.dart';
>>>>>>> 7c6dd4d8307d93388498c5d5d778175ea31c2433

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
<<<<<<< HEAD
      locale: const Locale('ar'),
      supportedLocales: const [
        Locale('ar'),
      ],
      home: const AddNewOperationScreen(), 
=======
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: const LoginView(),
>>>>>>> 7c6dd4d8307d93388498c5d5d778175ea31c2433
    );
  }
}