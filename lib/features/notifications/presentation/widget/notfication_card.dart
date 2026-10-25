import 'package:flutter/material.dart';
import 'package:afforestation_app/core/styles/colors.dart';
import 'package:afforestation_app/core/styles/text_styles.dart';

class NotificationItem {
  final String title;
  final String description;
  final String time;
  final Color avatarColor;
  final bool isUnread;
  final bool isSystem;

  NotificationItem({
    required this.title,
    required this.description,
    required this.time,
    required this.avatarColor,
    required this.isUnread,
    required this.isSystem,
  });
}

class NotificationCard extends StatelessWidget {
  final NotificationItem item;
  final VoidCallback? onDelete;
  final VoidCallback? onMarkAsRead;

  const NotificationCard({
    super.key,
    required this.item,
    this.onDelete,
    this.onMarkAsRead,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? const Color(0xFF1E1E1E) : AppColors.surface;
    final textColor = isDark ? Colors.white : AppColors.onSurface;
    final subtitleColor = isDark ? Colors.white70 : AppColors.onSurfaceVariant;
    final timeColor = isDark ? Colors.white38 : AppColors.onSurfaceVariant.withOpacity(0.6);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.transparent,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (item.isUnread)
            Container(
              margin: const EdgeInsets.only(top: 6),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF81C784) : AppColors.primary,
                shape: BoxShape.circle,
              ),
            )
          else
            const SizedBox(width: 8),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyles.listRowTitleStyle.copyWith(
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.description,
                  style: TextStyles.listRowSubtitleStyle.copyWith(
                    height: 1.4,
                    color: subtitleColor,
                  ),
                ),
                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.delete_outline,
                            color: AppColors.error,
                            size: 20,
                          ),
                          onPressed: onDelete,
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.done_all,
                            color: AppColors.secondary,
                            size: 20,
                          ),
                          onPressed: onMarkAsRead,
                        ),
                      ],
                    ),
                    Text(
                      item.time,
                      style: TextStyles.listRowSubtitleStyle.copyWith(
                        fontSize: 11,
                        color: timeColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: isDark
                  ? item.avatarColor.withValues(alpha: 0.25)
                  : item.avatarColor,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}
