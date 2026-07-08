import 'package:afforestation_app/core/services/local/shared_pref.dart';
import 'package:afforestation_app/core/styles/themes.dart';
import 'package:flutter/material.dart';
import 'package:afforestation_app/features/user_managment/view/add_new_operation_screen.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      home: const AddNewOperationScreen(), 
    );
  }
}