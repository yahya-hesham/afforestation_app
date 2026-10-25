import 'package:afforestation_app/features/notifications/presentation/widget/buildheader.dart';
import 'package:afforestation_app/features/notifications/presentation/widget/notfication_card.dart';
import 'package:flutter/material.dart';
import 'package:afforestation_app/features/dashboard/presentation/widgets/plant_bottom_nav_bar.dart';
import 'package:afforestation_app/core/styles/colors.dart';
import 'package:afforestation_app/core/styles/text_styles.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int selectedTab = 0;
  List<NotificationItem> notifications = [
    NotificationItem(
      title: "تنبيه زراعة جديد",
      description: "تم إضافة 50 شتلة لافندر في منطقة المشرف عبده.",
      time: "قبل 5 دقائق",
      avatarColor: AppColors.secondary.withOpacity(0.15),
      isUnread: true,
      isSystem: false,
    ),
    NotificationItem(
      title: "تحديث حالة النظام",
      description: "تم تحديث سجلات التشجير الأسبوعية بنجاح",
      time: "قبل 2 ساعة",
      avatarColor: AppColors.primary.withOpacity(0.15),
      isUnread: false,
      isSystem: true,
    ),
    NotificationItem(
      title: "تنبيه ري",
      description: "يرجى مراجعة جدول الري لمنطقة لافندر اليوم.",
      time: "قبل 4 ساعات",
      avatarColor: AppColors.secondary.withOpacity(0.25),
      isUnread: true,
      isSystem: false,
    ),
  ];

  List<NotificationItem> getFilteredNotifications() {
    if (selectedTab == 0) {
      return notifications;
    } else if (selectedTab == 1) {
      return notifications.where((n) => n.isUnread).toList();
    } else {
      return notifications.where((n) => n.isSystem).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = getFilteredNotifications();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg = isDark ? const Color(0xFF121212) : AppColors.background;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: scaffoldBg,
        body: Column(
          children: [
            buildHeader(context: context),

            const buildsearchrow(),

            _buildFilterTabs(isDark),

            Expanded(
              child: filteredList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_off_outlined,
                            size: 64,
                            color: isDark ? Colors.white38 : AppColors.onSurfaceVariant.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "لا توجد إشعارات حالياً",
                            style: TextStyles.listRowSubtitleStyle.copyWith(
                              fontSize: 15,
                              color: isDark ? Colors.white60 : null,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final item = filteredList[index];
                        return NotificationCard(
                          item: item,
                          onDelete: () {
                            setState(() {
                              notifications.remove(item);
                            });
                          },
                          onMarkAsRead: () {
                            setState(() {
                              final targetIndex = notifications.indexOf(item);
                              if (targetIndex != -1) {
                                notifications[targetIndex] =
                                    NotificationItem(
                                  title: item.title,
                                  description: item.description,
                                  time: item.time,
                                  avatarColor: item.avatarColor,
                                  isUnread: false,
                                  isSystem: item.isSystem,
                                );
                              }
                            });
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
        bottomNavigationBar: const PlantBottomNavigationBar(),
      ),
    );
  }

  Widget _buildFilterTabs(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : AppColors.onSurfaceVariant.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          _buildTabItem("الكل", 0, isDark),
          _buildTabItem("غير مقروءة", 1, isDark),
          _buildTabItem("تنبيهات النظام", 2, isDark),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title, int index, bool isDark) {
    bool isSelected = selectedTab == index;
    final surfaceColor = isDark ? const Color(0xFF1E1E1E) : AppColors.surface;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = index;
          });
        },
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? surfaceColor : Colors.transparent,
            borderRadius: BorderRadius.circular(15),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : [],
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: isSelected
                ? TextStyles.listRowTitleStyle.copyWith(
                    color: isDark ? const Color(0xFF81C784) : AppColors.primary,
                    fontSize: 13,
                  )
                : TextStyles.listRowSubtitleStyle.copyWith(
                    fontSize: 13,
                    color: isDark ? Colors.white60 : null,
                  ),
          ),
        ),
      ),
    );
  }
}
