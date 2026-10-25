import 'package:afforestation_app/core/functions/extenstion.dart';
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
          "user_dashboard_title".tr(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primaryTextColor,
          ),
        ),
        centerTitle: true,
        actions: [
          // Earth language toggle button
          IconButton(
            tooltip: context.isArabic ? "English" : "العربية",
            icon: Icon(
              Icons.language_rounded,
              color: isDark ? const Color(0xFF81C784) : const Color(0xFF43A047),
              size: 22,
            ),
            onPressed: () {
              context.toggleLanguage();
            },
          ),
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildUserProfileHeader(
                    primaryTextColor,
                    secondaryTextColor,
                    isDark,
                  ),
                  _buildLogoutBtn(context),
                ],
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      title: "total_works".tr(),
                      value: "145",
                      unit: "unit_seedling".tr(),
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
                      title: "weekly_activity".tr(),
                      value: "12",
                      unit: "unit_operation".tr(),
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
                "quick_operations".tr(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: primaryTextColor,
                ),
              ),
              const SizedBox(height: 12),
              _buildActionCard(
                title: "add_new_afforestation_title".tr(),
                subtitle: "add_new_afforestation_subtitle".tr(),
                icon: Icons.add_circle_outline,
                surfaceColor: surfaceColor,
                borderColor: cardBorderColor,
                textColor: primaryTextColor,
                subTextColor: secondaryTextColor,
                isDark: isDark,
                isArabic: context.isArabic,
                onTap: () {
                  context.push(Routes.addAfforestation);
                },
              ),
              const SizedBox(height: 12),
              _buildActionCard(
                title: "view_added_data_title".tr(),
                subtitle: "view_added_data_subtitle".tr(),
                icon: Icons.eco_outlined,
                surfaceColor: surfaceColor,
                borderColor: cardBorderColor,
                textColor: primaryTextColor,
                subTextColor: secondaryTextColor,
                isDark: isDark,
                isArabic: context.isArabic,
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
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "welcome_user".tr(args: [userName]),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: subTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(icon, color: const Color(0xFF43A047), size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: TextStyle(
                  fontSize: 12,
                  color: subTextColor,
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
    required bool isArabic,
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
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF2E7D32).withValues(alpha: 0.25)
                    : const Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: const Color(0xFF2E7D32),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
            Icon(
              isArabic ? Icons.arrow_back_ios_new : Icons.arrow_forward_ios,
              size: 14,
              color: isDark ? Colors.white38 : Colors.grey,
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
          Icon(
            Icons.nature_people_outlined,
            color: isDark ? const Color(0xFF81C784) : const Color(0xFF2E7D32),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "user_motivation_text".tr(),
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white70 : const Color(0xFF2E7D32),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
