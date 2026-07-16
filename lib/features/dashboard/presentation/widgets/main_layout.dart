import 'dart:io';

import 'package:afforestation_app/core/services/local/shared_pref.dart';
import 'package:afforestation_app/features/dashboard/presentation/pages/admin.dart';
import 'package:afforestation_app/features/dashboard/presentation/widgets/statistics_placeholder.dart';
import 'package:afforestation_app/features/dashboard/presentation/pages/user.dart';
import 'package:afforestation_app/features/search/presentation/cubit/search_cubit.dart';
import 'package:afforestation_app/features/search/presentation/page/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 3; // Defaults to index 3 (الرئيسية / Home)

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    final user = SharedPref.getUserInfo();
    final name = user?.name ?? user?.email?.split('@').first ?? "أحمد";
    _screens = [
      UserView(userName: name, userEmail: user?.email ?? ""), // Index 0: الملف الشخصي (Profile)
      const StatisticsPlaceholderView(), // Index 1: الإحصائيات (Statistics)
      BlocProvider(
        create: (_) => SearchCubit(),
        child: Search(
          onBackToHome: () {
            setState(() => _currentIndex = 3);
          },
        ),
      ),
      AdminView(adminName: name), // Index 3: الرئيسية (Home)
    ];
  }

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF53B157),
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'الملف الشخصي',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: 'الإحصائيات',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'البحث'),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
        ],
      ),
    );

    // Apply SafeArea only on Android to prevent the bottom navigation bar
    // from being obscured by the system navigation bar / gesture area
    if (Platform.isAndroid) {
      return SafeArea(
        top: false,
        child: scaffold,
      );
    }

    return scaffold;
  }
}

