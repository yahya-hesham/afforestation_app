import 'package:afforestation_app/feautures/dashboard/presentation/pages/admin.dart';
import 'package:afforestation_app/feautures/dashboard/presentation/pages/statistics_placeholder.dart';
import 'package:afforestation_app/feautures/dashboard/presentation/pages/user.dart';
import 'package:afforestation_app/feautures/search/presentation/page/search.dart';
import 'package:flutter/material.dart';

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
    _screens = [
      const UserView(userName: "أحمد"), // Index 0: الملف الشخصي (Profile)
      const StatisticsPlaceholderView(), // Index 1: الإحصائيات (Statistics)
      Search(),
      const AdminView(adminName: "أحمد"), // Index 3: الرئيسية (Home)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'البحث',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
        ],
      ),
    );
  }
}
