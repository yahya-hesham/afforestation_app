import 'package:afforestation_app/core/styles/colors.dart';
import 'package:flutter/material.dart';

class RecordCard extends StatelessWidget {
  final String plantName;
  final String badgeText;
  final String plantingDate;
  final String scientificName;
  final String location;
  final String quantity;
  final String registeredBy;
  final String? userAvatarUrl;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const RecordCard({
    super.key,
    required this.plantName,
    required this.badgeText,
    required this.plantingDate,
    required this.scientificName,
    required this.location,
    required this.quantity,
    required this.registeredBy,
    this.userAvatarUrl,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? const Color(0xFF1E1E1E) : AppColors.surface;
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFEFEFEF);
    final primaryTextColor = isDark ? Colors.white : AppColors.onSurface;
    final labelColor = isDark ? Colors.white60 : Colors.grey;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white12 : AppColors.tertiary.withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF56B76C).withValues(alpha: 0.15)
                  : AppColors.secondary.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (badgeText.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          badgeText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    const SizedBox(width: 8),
                    Text(
                      plantName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.primary,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.park_outlined,
                  color: isDark ? const Color(0xFF81C784) : AppColors.primary,
                  size: 20,
                ),
              ],
            ),
          ),

          // Content Row (Grid-like)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    // تاريخ الزراعة
                    Expanded(
                      child: _buildInfoItem(
                        label: "تاريخ الزراعة",
                        value: plantingDate,
                        icon: Icons.calendar_today_outlined,
                        isDark: isDark,
                        primaryTextColor: primaryTextColor,
                        labelColor: labelColor,
                      ),
                    ),
                    // الاسم العلمي
                    Expanded(
                      child: _buildInfoItem(
                        label: "الاسم العلمي",
                        value: scientificName,
                        icon: Icons.language,
                        isDark: isDark,
                        primaryTextColor: primaryTextColor,
                        labelColor: labelColor,
                        valueStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: primaryTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    // الموقع
                    Expanded(
                      child: _buildInfoItem(
                        label: "الموقع",
                        value: location,
                        icon: Icons.location_on_outlined,
                        isDark: isDark,
                        primaryTextColor: primaryTextColor,
                        labelColor: labelColor,
                      ),
                    ),
                    // الكمية
                    Expanded(
                      child: _buildInfoItem(
                        label: "الكمية",
                        value: quantity,
                        icon: Icons.storage_outlined,
                        isDark: isDark,
                        primaryTextColor: primaryTextColor,
                        labelColor: labelColor,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                Divider(height: 1, color: dividerColor),
                const SizedBox(height: 12),

                // Registered By Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "مسجل بواسطة $registeredBy",
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? Colors.white70
                            : AppColors.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildAvatar(isDark),
                  ],
                ),
              ],
            ),
          ),

          // Action buttons divider
          Divider(height: 1, color: dividerColor),

          // Actions Edit/Delete
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // تعديل
                TextButton.icon(
                  onPressed: onEdit,
                  icon: Icon(
                    Icons.edit_outlined,
                    color: isDark ? Colors.white70 : AppColors.tertiary,
                    size: 16,
                  ),
                  label: Text(
                    "تعديل",
                    style: TextStyle(
                      color: isDark ? Colors.white70 : AppColors.tertiary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Divider
                Container(width: 1, height: 20, color: dividerColor),
                // حذف
                TextButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.delete_outline,
                    color: AppColors.error,
                    size: 16,
                  ),
                  label: const Text(
                    "حذف",
                    style: TextStyle(
                      color: AppColors.error,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(bool isDark) {
    return CircleAvatar(
      radius: 14,
      backgroundColor: AppColors.secondary.withValues(
        alpha: isDark ? 0.3 : 0.2,
      ),
      backgroundImage:
          userAvatarUrl != null ? NetworkImage(userAvatarUrl!) : null,
      child: userAvatarUrl == null
          ? Icon(
              Icons.person,
              size: 16,
              color: isDark ? Colors.white : AppColors.primary,
            )
          : null,
    );
  }

  Widget _buildInfoItem({
    required String label,
    required String value,
    required IconData icon,
    required bool isDark,
    required Color primaryTextColor,
    required Color labelColor,
    TextStyle? valueStyle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 11, color: labelColor),
            ),
            const SizedBox(width: 6),
            Icon(
              icon,
              size: 14,
              color: isDark
                  ? const Color(0xFF81C784)
                  : AppColors.primary.withValues(alpha: 0.7),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: valueStyle ??
              TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: primaryTextColor,
              ),
          textAlign: TextAlign.end,
        ),
      ],
    );
  }
}
