import 'package:bookia/core/styles/themes.dart';
import 'package:flutter/material.dart';
import 'feautures/auth/presentation/pages/login.dart'; 

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      home: const LoginView(), 
    );
  }
}
