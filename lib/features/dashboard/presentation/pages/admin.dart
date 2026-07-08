import 'package:afforestation_app/core/functions/extenstion.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

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
      backgroundColor: const Color(0xFFF7F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9FA),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.notifications_none_outlined,
                    color: Colors.black87,
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(
                    Icons.language_outlined,
                    color: Colors.black87,
                  ),
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
              child: const Icon(
                Icons.park_outlined,
                color: Colors.white,
                size: 20,
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
                    onPressed: () {
                      Navigator.pop(context);
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
                onTap: () {},
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
        ),
      ),
    );
  }

  Widget _buildSectionHeader({required String title, required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B3A1E),
            ),
          ),
          const SizedBox(width: 10),
          Icon(icon, color: const Color(0xFF1B3A1E), size: 20),
        ],
      ),
    );
  }

  Widget _buildDashboardButton({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
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
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.arrow_back_ios, size: 14, color: Colors.grey),
              Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
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
