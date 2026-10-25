import 'package:afforestation_app/core/functions/extenstion.dart';
import 'package:afforestation_app/core/styles/colors.dart';
import 'package:flutter/material.dart';

class StatisticsPlaceholderView extends StatelessWidget {
  const StatisticsPlaceholderView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg = isDark ? const Color(0xFF121212) : AppColors.background;
    final surfaceColor = isDark ? const Color(0xFF1E1E1E) : AppColors.surface;
    final textColor = isDark ? Colors.white : AppColors.onSurface;
    final subTextColor = isDark ? Colors.white60 : Colors.grey;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          "stats_title".tr(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.primary,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Highlight Overview Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "total_afforestation".tr(),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "trees_count_placeholder".tr(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(
                          Icons.trending_up,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "growth_rate_text".tr(),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // Section Header
              Text(
                "kpi_title".tr(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? const Color(0xFF81C784) : AppColors.primary,
                ),
              ),
              const SizedBox(height: 12),

              // Statistics Grid Items
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      title: "covered_areas".tr(),
                      value: "sites_count".tr(),
                      subtitle: "active_municipalities".tr(),
                      icon: Icons.map_outlined,
                      color: const Color(0xFF4CAF50),
                      surfaceColor: surfaceColor,
                      textColor: textColor,
                      subTextColor: subTextColor,
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricCard(
                      title: "survival_rate".tr(),
                      value: "94.2%",
                      subtitle: "successful_growth".tr(),
                      icon: Icons.favorite,
                      color: Colors.redAccent,
                      surfaceColor: surfaceColor,
                      textColor: textColor,
                      subTextColor: subTextColor,
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      title: "water_saving".tr(),
                      value: "liters_count".tr(),
                      subtitle: "smart_irrigation".tr(),
                      icon: Icons.water_drop_outlined,
                      color: Colors.cyan,
                      surfaceColor: surfaceColor,
                      textColor: textColor,
                      subTextColor: subTextColor,
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricCard(
                      title: "volunteers".tr(),
                      value: "+180",
                      subtitle: "active_participants".tr(),
                      icon: Icons.groups_outlined,
                      color: Colors.blueAccent,
                      surfaceColor: surfaceColor,
                      textColor: textColor,
                      subTextColor: subTextColor,
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // Weekly Rate Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? Colors.white12 : Colors.grey.shade200,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "weekly_rate".tr(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildChartBar(0.4, "day_sun".tr(), isDark, subTextColor),
                        _buildChartBar(0.7, "day_mon".tr(), isDark, subTextColor),
                        _buildChartBar(0.55, "day_tue".tr(), isDark, subTextColor),
                        _buildChartBar(0.9, "day_wed".tr(), isDark, subTextColor),
                        _buildChartBar(0.65, "day_thu".tr(), isDark, subTextColor),
                        _buildChartBar(0.3, "day_fri".tr(), isDark, subTextColor),
                        _buildChartBar(0.85, "day_sat".tr(), isDark, subTextColor),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color surfaceColor,
    required Color textColor,
    required Color subTextColor,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(fontSize: 11, color: subTextColor),
          ),
        ],
      ),
    );
  }

  Widget _buildChartBar(
    double heightFraction,
    String label,
    bool isDark,
    Color subTextColor,
  ) {
    return Column(
      children: [
        Container(
          width: 14,
          height: 100 * heightFraction,
          decoration: BoxDecoration(
            color: const Color(0xFF53B157),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 10, color: subTextColor),
        ),
      ],
    );
  }
}
