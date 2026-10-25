import 'package:afforestation_app/core/routes/routes.dart';
import 'package:afforestation_app/core/services/local/shared_pref.dart';
import 'package:afforestation_app/core/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldColor =
        isDark ? const Color(0xFF121212) : const Color(0xFFF7F9FA);
    final surfaceColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final cardBorderColor = isDark ? Colors.white12 : const Color(0xFFEFEFEF);
    final primaryTextColor = isDark ? Colors.white : const Color(0xFF1B3A1E);
    final secondaryTextColor = isDark ? Colors.white70 : Colors.grey;

    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          "لوحة المستخدم",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primaryTextColor,
          ),
        ),
        centerTitle: true,
        actions: [
          // Theme toggle button
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              final isCurrentlyDark = themeMode == ThemeMode.dark;
              return IconButton(
                icon: Icon(
                  isCurrentlyDark
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                  color: isDark ? Colors.white70 : const Color(0xFF1B3A1E),
                  size: 22,
                ),
                onPressed: () {
                  context.read<ThemeCubit>().toggleTheme();
                },
              );
            },
          ),
          const SizedBox(width: 8),
        ],
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
                  _buildLogoutBtn(context),
                  _buildUserProfileHeader(
                    primaryTextColor,
                    secondaryTextColor,
                    isDark,
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
                      surfaceColor: surfaceColor,
                      borderColor: cardBorderColor,
                      textColor: primaryTextColor,
                      subTextColor: secondaryTextColor,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildStatCard(
                      title: "نشاطك الأسبوعي",
                      value: "12",
                      unit: "عملية",
                      icon: Icons.insights_outlined,
                      surfaceColor: surfaceColor,
                      borderColor: cardBorderColor,
                      textColor: primaryTextColor,
                      subTextColor: secondaryTextColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Text(
                "العمليات السريعة",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: primaryTextColor,
                ),
              ),
              const SizedBox(height: 12),
              _buildActionCard(
                title: "إضافة عملية تشجير جديدة",
                subtitle:
                    "سجل بيانات شتلات جديدة في المواقع الميدانية المعتمدة",
                icon: Icons.add_circle_outline,
                surfaceColor: surfaceColor,
                borderColor: cardBorderColor,
                textColor: primaryTextColor,
                subTextColor: secondaryTextColor,
                isDark: isDark,
                onTap: () {
                  context.push(Routes.addAfforestation);
                },
              ),
              const SizedBox(height: 12),
              _buildActionCard(
                title: "عرض البيانات المضافة",
                subtitle:
                    "راجع سجلاتك السابقة وتتبع حالة نمو النباتات التي قمت بزراعتها",
                icon: Icons.eco_outlined,
                surfaceColor: surfaceColor,
                borderColor: cardBorderColor,
                textColor: primaryTextColor,
                subTextColor: secondaryTextColor,
                isDark: isDark,
                onTap: () {
                  context.push(Routes.search);
                },
              ),
              const SizedBox(height: 30),
              _buildMotivationalBanner(isDark),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutBtn(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        icon: const Icon(
          Icons.logout,
          color: Color(0xFFD32F2F),
          size: 20,
        ),
        onPressed: () async {
          await SharedPref.prefs.clear();
          if (context.mounted) {
            context.go(Routes.login);
          }
        },
      ),
    );
  }

  Widget _buildUserProfileHeader(
    Color primaryTextColor,
    Color secondaryTextColor,
    bool isDark,
  ) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "مرحباً مجدداً، $userName",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: primaryTextColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              userEmail,
              style: TextStyle(
                fontSize: 12,
                color: secondaryTextColor,
              ),
            ),
          ],
        ),
        const SizedBox(width: 12),
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? Colors.white24 : const Color(0xFFC8E6C9),
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.person,
              color: Color(0xFF2E7D32),
              size: 24,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String unit,
    required IconData icon,
    required Color surfaceColor,
    required Color borderColor,
    required Color textColor,
    required Color subTextColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: const Color(0xFF43A047), size: 20),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: subTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                unit,
                style: TextStyle(
                  fontSize: 12,
                  color: subTextColor,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: textColor,
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
    required Color surfaceColor,
    required Color borderColor,
    required Color textColor,
    required Color subTextColor,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Icon(
              Icons.arrow_back_ios,
              size: 14,
              color: isDark ? Colors.white38 : Colors.grey,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 11,
                      color: subTextColor,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF2E7D32).withValues(alpha: 0.25)
                    : const Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward,
                color: Color(0xFF2E7D32),
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMotivationalBanner(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E3A1E) : const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              "تساهم جهودك في زيادة الغطاء النباتي. شكراً لمساهمتك في حماية البيئة وتطوير المناطق الخضراء.",
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white70 : const Color(0xFF2E7D32),
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Icon(
            Icons.nature_people_outlined,
            color: isDark ? const Color(0xFF81C784) : const Color(0xFF2E7D32),
            size: 24,
          ),
        ],
      ),
    );
  }
}
