import 'package:bookia/core/services/apis/dio_provider.dart';
import 'package:bookia/core/services/local/shared_pref.dart';
import 'package:flutter/material.dart';
import 'feautures/auth/presentation/pages/login.dart'; 

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //DioProvider.init();
  await SharedPref.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginView(), 
    );
  }
}
