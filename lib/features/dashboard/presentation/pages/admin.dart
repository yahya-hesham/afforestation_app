import 'package:afforestation_app/core/functions/extenstion.dart';
import 'package:afforestation_app/core/routes/routes.dart';
import 'package:afforestation_app/core/services/local/shared_pref.dart';
import 'package:afforestation_app/features/location/page/add_new_location_type.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../notifications/presentation/pages/notifications_screen.dart';

// 👇 1. استيراد صفحات الـ Auth (اللوجن) من أجل زرار الخروج
import 'package:afforestation_app/features/auth/presentation/pages/login.dart';

// 👇 2. استيراد صفحات الإضافة (نبات - عملية تشجير)
import 'package:afforestation_app/features/add/adding_plant/presentation/pages/add_new_plant_screen.dart';
import 'package:afforestation_app/features/add/adding_plant/presentation/pages/add_new_operation_screen.dart';

// 👇 3. استيراد صفحة إظهار جميع النباتات (PlantManagementScreen)
import 'package:afforestation_app/features/dashboard/presentation/pages/plant_management_screen.dart';

// 👇 4. استيراد صفحة إدارة المستخدمين وإضافتهم
import 'package:afforestation_app/features/users/presentation/pages/user_management_screen.dart';
// 👇 6. استيراد باقي صفحات الشريط السفلي
import 'package:afforestation_app/features/search/presentation/page/search.dart'; 
import 'package:afforestation_app/features/search/presentation/page/statistics_summary.dart'; 
import 'package:afforestation_app/features/dashboard/presentation/pages/user.dart';

class AdminView extends StatefulWidget {
  final String adminName;

  const AdminView({super.key, this.adminName = "أحمد"});

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  int _currentIndex = 0;

  // 🛠️ دالة بناء الصفحة الرئيسية للأدمن متطابقة مع تصميم الصور (Visly AI)
  Widget _buildAdminHome() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Center(
            child: Column(
              children: [
                Text(
                  "لوحة تحكم المسؤول",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1B3A1E)),
                ),
                SizedBox(height: 4),
                Text(
                  "قم بإدارة نظام التشجير الخاص بك بكفاءة",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 🚪 زرار الخروج
              TextButton.icon(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginView()),
                    (route) => false,
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFFFEBEE),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                ),
                icon: const Icon(Icons.logout, color: Colors.redAccent, size: 16),
                label: const Text(
                  "خروج",
                  style: TextStyle(color: Colors.redAccent, fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${widget.adminName} ،مرحباً بك مجدداً",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B3A1E)),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "جاهز لإحداث فرق اليوم؟",
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            "مسؤول النظام",
            style: TextStyle(color: Color(0xFF53B157), fontSize: 13, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 25),

          // ➕ 1. قسم إضافة أنواع
          _buildSectionHeader(title: "إضافة أنواع", icon: Icons.add),
          _buildDashboardButton(
            title: "إضافة نوع نبات جديد", 
            icon: Icons.park_outlined, 
            onTap: () {
              // هينقلك لصفحة إضافة نبات مؤقتاً لحين عمل صفحة "النوع" المستقلة
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AddNewPlantScreen()));
            }
          ),
          _buildDashboardButton(
            title: "إضافة نوع موقع جديد", 
            icon: Icons.location_on_outlined, 
            onTap: () {
              
             // Navigator.push(context, MaterialPageRoute(builder: (context) => const ManageLocationsScreen()));
            }
          ),

          const SizedBox(height: 20),

          // 📄 2. قسم إضافة عناصر
          _buildSectionHeader(title: "إضافة عناصر", icon: Icons.description_outlined),
          _buildDashboardButton(
            title: "إضافة عملية تشجير", 
            icon: Icons.grass, 
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AddNewOperationScreen()));
            }
          ),
          _buildDashboardButton(
            title: "إضافة نبات", 
            icon: Icons.park, 
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AddNewPlantScreen()));
            }
          ),
          _buildDashboardButton(
            title: "إضافة الموقع", 
            icon: Icons.location_on, 
            onTap: () {
             // Navigator.push(context, MaterialPageRoute(builder: (context) => const ManageLocationsScreen()));
            }
          ),

          const SizedBox(height: 20),

          // 👥 3. قسم إدارة المستخدمين
          _buildSectionHeader(title: "إدارة المستخدمين", icon: Icons.people_outline),
          _buildDashboardButton(
            title: "إضافة مستخدم", 
            icon: Icons.person_add_alt_1_outlined, 
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const UserManagementScreen()));
            }
          ),
          _buildDashboardButton(
            title: "إظهار جميع المستخدمين", 
            icon: Icons.people, 
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const UserManagementScreen()));
            }
          ),

          const SizedBox(height: 20),

          // 🗄️ 4. قسم بحث وعرض البيانات
          _buildSectionHeader(title: "بحث وعرض البيانات", icon: Icons.storage_outlined),
          _buildDashboardButton(
            title: "البحث المتقدم", 
            icon: Icons.search, 
            onTap: () {
              setState(() {
                _currentIndex = 1; // ينقلك لتبويب البحث في الشريط السفلي
              });
            }
          ),
          _buildDashboardButton(
            title: "إظهار جميع النباتات", 
            icon: Icons.insert_drive_file_outlined, 
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const PlantManagementScreen()));
            }
          ),
          _buildDashboardButton(
            title: "إظهار جميع المواقع", 
            icon: Icons.insert_drive_file_outlined, 
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) => const ManageLocationsScreen()));
            }
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildAdminHome(),           // 0: الرئيسية
      const Search(),              // 1: البحث
      const StatisticsSummaryPage(), // 2: إحصائيات
      const UserView(),            // 3: الملف الشخصي
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9FA),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(
                Icons.notifications_none_outlined,
                color: Colors.black87,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationsScreen(),
                  ),
                );
              },
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_none_outlined, color: Colors.black87),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.language_outlined, color: Colors.black87),
                  onPressed: () {
                    context.isArabic
                        ? context.setLocale(const Locale('en'))
                        : context.setLocale(const Locale('ar'));
                  },
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF1B3A1E),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.park_outlined, color: Colors.white, size: 20),
            ),
            IconButton(
              icon: const Icon(Icons.language, color: Colors.black87),
              onPressed: () {
                context.isArabic
                    ? context.setLocale(const Locale('en'))
                    : context.setLocale(const Locale('ar'));
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Center(
                child: Column(
                  children: [
                    Text(
                      "لوحة تحكم المسؤول",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B3A1E),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "قم بإدارة نظام التشجير الخاص بك بكفاءة",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () async {
                      await SharedPref.prefs.clear();
                      if (context.mounted) {
                        context.go(Routes.login);
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFFFEBEE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                    ),
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.redAccent,
                      size: 16,
                    ),
                    label: const Text(
                      "خروج",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "${widget.adminName} ،مرحباً بك مجدداً",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1B3A1E),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "جاهز لإحداث فرق اليوم؟",
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),
              const Text(
                "مسؤول النظام",
                style: TextStyle(
                  color: Color(0xFF53B157),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),

              _buildSectionHeader(
                title: "إضافة أنواع",
                icon: Icons.add_circle_outline,
              ),
              _buildDashboardButton(
                title: "إضافة نوع نبات جديد",
                icon: Icons.eco_outlined,
                onTap: () {},
              ),
              _buildDashboardButton(
                title: "إضافة نوع موقع جديد",
                icon: Icons.location_on_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LocationTypesScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 25),

              _buildSectionHeader(
                title: "إضافة عناصر",
                icon: Icons.assignment_outlined,
              ),
              _buildDashboardButton(
                title: "إضافة عملية تشجير",
                icon: Icons.grass,
                onTap: () {},
              ),
              _buildDashboardButton(
                title: "إضافة نبات",
                icon: Icons.local_florist_outlined,
                onTap: () {},
              ),
              _buildDashboardButton(
                title: "إضافة الموقع",
                icon: Icons.map_outlined,
                onTap: () {},
              ),

              const SizedBox(height: 25),

              _buildSectionHeader(
                title: "إدارة المستخدمين",
                icon: Icons.people_outline,
              ),
              _buildDashboardButton(
                title: "إضافة مستخدم",
                icon: Icons.person_add_alt_1_outlined,
                onTap: () {},
              ),
              _buildDashboardButton(
                title: "إظهار جميع المستخدمين",
                icon: Icons.supervised_user_circle_outlined,
                onTap: () {},
              ),

              const SizedBox(height: 25),

              _buildSectionHeader(
                title: "بحث وعرض البيانات",
                icon: Icons.storage_outlined,
              ),
              _buildDashboardButton(
                title: "البحث المتقدم",
                icon: Icons.search,
                onTap: () {},
              ),
              _buildDashboardButton(
                title: "إظهار جميع النباتات",
                icon: Icons.format_list_bulleted_outlined,
                onTap: () {},
              ),
              _buildDashboardButton(
                title: "إظهار جميع المواقع",
                icon: Icons.layers_outlined,
                onTap: () {},
              ),

              const SizedBox(height: 40),
            ],
          ),
        child: IndexedStack(
          index: _currentIndex,
          children: pages,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF53B157),
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              activeIcon: Icon(Icons.search),
              label: 'البحث',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined),
              activeIcon: Icon(Icons.bar_chart),
              label: 'إحصائيات',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'الملف الشخصي',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({required String title, required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1B3A1E))),
          const SizedBox(width: 10),
          Icon(icon, color: Colors.grey.shade600, size: 20),
        ],
      ),
    );
  }

  Widget _buildDashboardButton({required String title, required IconData icon, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFEFEFEF)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 6,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.arrow_back_ios, size: 14, color: Colors.grey),
              Row(
                children: [
                  Text(title, style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500)),
                  const SizedBox(width: 14),
                  Icon(icon, color: const Color(0xFF53B157), size: 22),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}