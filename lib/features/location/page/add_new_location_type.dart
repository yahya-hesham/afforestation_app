import 'package:afforestation_app/features/dashboard/presentation/widgets/plant_bottom_nav_bar.dart';
import 'package:afforestation_app/features/location/wedget/wedget_location_type/build_add_new_card.dart';
import 'package:afforestation_app/features/location/wedget/wedget_location_type/build_app_bar.dart';
import 'package:afforestation_app/features/location/wedget/wedget_location_type/build_current.dart';
import 'package:afforestation_app/features/location/wedget/wedget_location_type/build_location_card.dart';
import 'package:afforestation_app/features/location/wedget/wedget_location_type/screen_title.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF68B258),
        scaffoldBackgroundColor: const Color(0xFFF5FAF5),
        fontFamily: 'Cairo',
      ),
      builder: (context, child) {
        return Directionality(textDirection: TextDirection.rtl, child: child!);
      },
      home: const LocationTypesScreen(),
    );
  }
}

class LocationTypesScreen extends StatelessWidget {
  const LocationTypesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            build_app_bar(),
            const Divider(height: 1, color: Color(0xFFE0E0E0)),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    screen_title(),
                    const SizedBox(height: 24),
                    build_add_new_card(),
                    const SizedBox(height: 32),
                    build_current_type_header(),
                    const SizedBox(height: 16),
                    build_location_card(
                      title: 'مشاتل مركزية',
                      date: '01-10-2023',
                      locationsCount: 12,
                      progress: 0.3,
                    ),
                    const SizedBox(height: 12),
                    build_location_card(
                      title: 'طرق سريعة',
                      date: '05-10-2023',
                      locationsCount: 45,
                      progress: 0.8,
                    ),
                    const SizedBox(height: 12),
                    build_location_card(
                      title: 'حدائق عامة',
                      date: '12-10-2023',
                      locationsCount: 20,
                      progress: 0.5,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: const PlantBottomNavigationBar(),
    );
  }
}
