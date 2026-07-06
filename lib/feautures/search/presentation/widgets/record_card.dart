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
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.tertiary.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
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
              color: AppColors.secondary.withValues(alpha: 0.08),
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const Icon(Icons.park_outlined, color: AppColors.primary, size: 20),
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
                      ),
                    ),
                    // الاسم العلمي
                    Expanded(
                      child: _buildInfoItem(
                        label: "الاسم العلمي",
                        value: scientificName,
                        icon: Icons.language,
                        valueStyle: const TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
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
                      ),
                    ),
                    // الكمية
                    Expanded(
                      child: _buildInfoItem(
                        label: "الكمية",
                        value: quantity,
                        icon: Icons.storage_outlined,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                const Divider(height: 1, color: Color(0xFFEFEFEF)),
                const SizedBox(height: 12),

                // Registered By Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "مسجل بواسطة $registeredBy",
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: AppColors.secondary.withValues(alpha: 0.2),
                      backgroundImage: userAvatarUrl != null ? NetworkImage(userAvatarUrl!) : null,
                      child: userAvatarUrl == null
                          ? const Icon(Icons.person, size: 16, color: AppColors.primary)
                          : null,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Action buttons divider
          const Divider(height: 1, color: Color(0xFFEFEFEF)),

          // Actions Edit/Delete
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // تعديل (Edit)
                TextButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined, color: AppColors.tertiary, size: 16),
                  label: const Text(
                    "تعديل",
                    style: TextStyle(
                      color: AppColors.tertiary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Divider
                Container(width: 1, height: 20, color: const Color(0xFFEFEFEF)),
                // حذف (Delete)
                TextButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 16),
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

  Widget _buildInfoItem({
    required String label,
    required String value,
    required IconData icon,
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
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
            const SizedBox(width: 6),
            Icon(icon, size: 14, color: AppColors.primary.withValues(alpha: 0.7)),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          textAlign: TextAlign.end,
          style: valueStyle ??
              const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
        ),
      ],
    );
  }
}
