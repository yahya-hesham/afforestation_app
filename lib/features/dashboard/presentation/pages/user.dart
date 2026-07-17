import 'package:afforestation_app/core/routes/routes.dart';
import 'package:afforestation_app/core/services/local/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afforestation_app/features/auth/presentation/pages/login.dart';
import 'package:afforestation_app/features/add/adding_plant/presentation/pages/add_new_operation_screen.dart';
import 'package:afforestation_app/features/dashboard/presentation/cubit/user_cudit/user_cubit.dart';
import 'package:afforestation_app/features/dashboard/presentation/cubit/user_cudit/user_state.dart';
class UserView extends StatelessWidget {
  final String userName;
  final String userEmail;

  const UserView({
    super.key,
    this.userName = "أحمد",
    this.userEmail = "ahmed.user@gmail.com",
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9FA),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "لوحة المستخدم",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B3A1E),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.redAccent),
                    onPressed: () async {
                      await SharedPref.prefs.clear();
                      if (context.mounted) {
                        context.go(Routes.login);
                      }
                    },
                  ),
    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        if (state is LogoutLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(
              child: CircularProgressIndicator(color: Color(0xFF53B157)),
            ),
          );
        } else if (state is LogoutSuccess) {
          Navigator.pop(context); // إغلاق اللودينج ديايلوج
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginView()),
            (route) => false,
          );
        } else if (state is LogoutError) {
          Navigator.pop(context); // إغلاق اللودينج ديايلوج
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFF7F9FA),
          appBar: AppBar(
            backgroundColor: const Color(0xFFF7F9FA),
            elevation: 0,
            automaticallyImplyLeading: false,
            title: const Text(
              "لوحة المستخدم",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B3A1E)),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.logout, color: Colors.redAccent),
                        onPressed: () {
                          context.read<UserCubit>().logout();
                        },
                      ),
                      Row(
                        children: [
                          Text(
                            "مرحباً مجدداً، $userName",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1B3A1E),
                            ),
                          ),
                          Text(
                            userEmail,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "مرحباً مجدداً، $userName",
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B3A1E)),
                              ),
                              Text(
                                userEmail,
                                style: const TextStyle(fontSize: 13, color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          const CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.grey,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          title: "إجمالي الأعمال",
                          value: "145",
                          unit: "شتلة",
                          icon: Icons.analytics_outlined,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildStatCard(
                          title: "نشاطك الأسبوعي",
                          value: "12",
                          unit: "عملية",
                          icon: Icons.insights_outlined,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "العمليات السريعة",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B3A1E)),
                  ),
                  const SizedBox(height: 12),
                  _buildActionCard(
                    title: "إضافة عملية تشجير جديدة",
                    subtitle: "سجل بيانات شتلات جديدة في المواقع الميدانية المعتمدة",
                    icon: Icons.add_circle_outline,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddNewOperationScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    "عرض البيانات المضافة",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B3A1E)),
                  ),
                  const SizedBox(height: 12),
                  _buildActionCard(
                    title: "عرض البيانات المضافة",
                    subtitle: "راجع سجلاتك السابقة وتتبع حالة نمو النباتات التي قمت بزراعتها",
                    icon: Icons.storage_outlined,
                    onTap: () {},
                  ),
                  const SizedBox(height: 30),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "تساهم جهودك في زيادة الغطاء النباتي. شكراً لمساهمتك في حماية البيئة وتطوير المناطق الخضراء.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Color(0xFF2E7D32), height: 1.5),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                "العمليات السريعة",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B3A1E),
                ),
              ),
              const SizedBox(height: 12),
              _buildActionCard(
                title: "إضافة عملية تشجير جديدة",
                subtitle:
                    "سجل بيانات شتلات جديدة في المواقع الميدانية المعتمدة",
                icon: Icons.add_circle_outline,
                onTap: () {},
              ),
              const SizedBox(height: 25),
              const Text(
                "عرض البيانات المضافة",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B3A1E),
                ),
              ),
              const SizedBox(height: 12),
              _buildActionCard(
                title: "عرض البيانات المضافة",
                subtitle:
                    "راجع سجلاتك السابقة وتتبع حالة نمو النباتات التي قمت بزراعتها",
                icon: Icons.storage_outlined,
                onTap: () {},
              ),
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "تساهم جهودك في زيادة الغطاء النباتي. شكراً لمساهمتك في حماية البيئة وتطوير المناطق الخضراء.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF2E7D32),
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String unit,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEFEFEF)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: const Color(0xFF53B157), size: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                unit,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(width: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B3A1E),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFEFEFEF)),
        ),
        child: Row(
          children: [
            const Icon(Icons.arrow_back_ios, size: 14, color: Colors.grey),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B3A1E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xFF53B157), size: 24),
            ),
          ],
        ),
      ),
    );
  }
}
