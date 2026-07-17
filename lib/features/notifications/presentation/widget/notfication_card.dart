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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withOpacity(0.02),
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
              decoration: const BoxDecoration(
                color: AppColors.primary,
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
                Text(item.title, style: TextStyles.listRowTitleStyle),
                const SizedBox(height: 4),
                Text(
                  item.description,
                  style: TextStyles.listRowSubtitleStyle.copyWith(height: 1.4),
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
                        color: AppColors.onSurfaceVariant.withOpacity(0.6),
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
              color: item.avatarColor,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}
