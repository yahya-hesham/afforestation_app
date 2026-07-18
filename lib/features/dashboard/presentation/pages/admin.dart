import 'package:afforestation_app/core/functions/extenstion.dart';
import 'package:afforestation_app/core/functions/navigations.dart';
import 'package:afforestation_app/core/routes/routes.dart';
import 'package:afforestation_app/core/services/local/shared_pref.dart';
import 'package:afforestation_app/features/dashboard/presentation/pages/location_management_screen.dart';
import 'package:afforestation_app/features/dashboard/presentation/pages/plant_management_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../notifications/presentation/pages/notifications_screen.dart';

class AdminView extends StatefulWidget {
  final String adminName;

  const AdminView({super.key, this.adminName = "أحمد"});

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Notification bell
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1B3A1E).withValues(alpha: 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: Color(0xFF1B3A1E),
                  size: 22,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationsScreen(),
                    ),
                  );
                },
              ),
            ),
            // Logo
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1B3A1E), Color(0xFF2D5A27)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1B3A1E).withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.park_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
            // Language toggle
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1B3A1E).withValues(alpha: 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.language_rounded,
                  color: Color(0xFF1B3A1E),
                  size: 22,
                ),
                onPressed: () {
                  context.isArabic
                      ? context.setLocale(const Locale('en'))
                      : context.setLocale(const Locale('ar'));
                },
              ),
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
              // Title section
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
              const SizedBox(height: 24),

              // Welcome card
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1B3A1E), Color(0xFF2D5A27)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1B3A1E).withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
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
                        backgroundColor: Colors.white.withValues(alpha: 0.15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                      ),
                      icon: const Icon(
                        Icons.logout_rounded,
                        color: Color(0xFFFF8A80),
                        size: 16,
                      ),
                      label: const Text(
                        "خروج",
                        style: TextStyle(
                          color: Color(0xFFFF8A80),
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
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "جاهز لإحداث فرق اليوم؟",
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFFB8E6B8),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF53B157),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "مسؤول النظام",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // --- Section: إضافة أنواع ---
              _buildSectionHeader(
                title: "إضافة أنواع",
                icon: Icons.add_circle_outline,
              ),
              _buildDashboardButton(
                title: "إضافة نوع نبات جديد",
                icon: Icons.eco_outlined,
                iconColor: const Color(0xFF43A047),
                iconBgColor: const Color(0xFFE8F5E9),
                onTap: () {},
              ),
              _buildDashboardButton(
                title: "إضافة نوع موقع جديد",
                icon: Icons.location_on_outlined,
                iconColor: const Color(0xFF1565C0),
                iconBgColor: const Color(0xFFE3F2FD),
                onTap: () {},
              ),

              const SizedBox(height: 25),

              // --- Section: إضافة عناصر ---
              _buildSectionHeader(
                title: "إضافة عناصر",
                icon: Icons.assignment_outlined,
              ),
              _buildDashboardButton(
                title: "إضافة عملية تشجير",
                icon: Icons.grass,
                iconColor: const Color(0xFF2E7D32),
                iconBgColor: const Color(0xFFE8F5E9),
                onTap: () {
                  pushTo(context, Routes.addAfforestation);
                },
              ),
              _buildDashboardButton(
                title: "إضافة نبات",
                icon: Icons.local_florist_outlined,
                iconColor: const Color(0xFFE91E63),
                iconBgColor: const Color(0xFFFCE4EC),
                onTap: () {
                  pushTo(context, Routes.addPlant);
                },
              ),
              _buildDashboardButton(
                title: "إضافة الموقع",
                icon: Icons.map_outlined,
                iconColor: const Color(0xFFFF6F00),
                iconBgColor: const Color(0xFFFFF3E0),
                onTap: () {},
              ),

              const SizedBox(height: 25),

              // --- Section: إدارة المستخدمين ---
              _buildSectionHeader(
                title: "إدارة المستخدمين",
                icon: Icons.people_outline,
              ),
              _buildDashboardButton(
                title: "إضافة مستخدم",
                icon: Icons.person_add_alt_1_outlined,
                iconColor: const Color(0xFF5E35B1),
                iconBgColor: const Color(0xFFEDE7F6),
                onTap: () {
                  pushTo(context, Routes.addUser);
                },
              ),
              _buildDashboardButton(
                title: "إظهار جميع المستخدمين",
                icon: Icons.supervised_user_circle_outlined,
                iconColor: const Color(0xFF00838F),
                iconBgColor: const Color(0xFFE0F7FA),
                onTap: () {
                  pushTo(context, Routes.manageUsers);
                },
              ),

              const SizedBox(height: 25),

              // --- Section: بحث وعرض البيانات ---
              _buildSectionHeader(
                title: "بحث وعرض البيانات",
                icon: Icons.storage_outlined,
              ),
              _buildDashboardButton(
                title: "البحث المتقدم",
                icon: Icons.search_rounded,
                iconColor: const Color(0xFF37474F),
                iconBgColor: const Color(0xFFECEFF1),
                onTap: () {
                  pushTo(context, Routes.search);
                },
              ),
              _buildDashboardButton(
                title: "إظهار جميع النباتات",
                icon: Icons.format_list_bulleted_outlined,
                iconColor: const Color(0xFF43A047),
                iconBgColor: const Color(0xFFE8F5E9),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PlantManagementScreen(),
                    ),
                  );
                },
              ),
              _buildDashboardButton(
                title: "إظهار جميع المواقع",
                icon: Icons.layers_outlined,
                iconColor: const Color(0xFFEF6C00),
                iconBgColor: const Color(0xFFFFF3E0),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LocationManagementScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({required String title, required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1B3A1E),
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFF1B3A1E).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF1B3A1E), size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardButton({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    Color iconColor = const Color(0xFF53B157),
    Color iconBgColor = const Color(0xFFE8F5E9),
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: const Color(0xFF53B157).withValues(alpha: 0.08),
          highlightColor: const Color(0xFF53B157).withValues(alpha: 0.04),
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF1B3A1E).withValues(alpha: 0.06),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1B3A1E).withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F7F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios,
                    size: 12,
                    color: Color(0xFF9E9E9E),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF2B2B2B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: iconBgColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon, color: iconColor, size: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
