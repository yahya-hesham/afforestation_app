import 'package:afforestation_app/core/functions/extenstion.dart';
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
  List<NotificationItem>? _notifications;
  String? _lastLanguageCode;

  List<NotificationItem> _initNotifications() {
    return [
      NotificationItem(
        title: "sample_notif_1_title".tr(),
        description: "sample_notif_1_desc".tr(),
        time: "sample_notif_1_time".tr(),
        avatarColor: AppColors.secondary.withValues(alpha: 0.15),
        isUnread: true,
        isSystem: false,
      ),
      NotificationItem(
        title: "sample_notif_2_title".tr(),
        description: "sample_notif_2_desc".tr(),
        time: "sample_notif_2_time".tr(),
        avatarColor: AppColors.primary.withValues(alpha: 0.15),
        isUnread: false,
        isSystem: true,
      ),
      NotificationItem(
        title: "sample_notif_3_title".tr(),
        description: "sample_notif_3_desc".tr(),
        time: "sample_notif_3_time".tr(),
        avatarColor: AppColors.secondary.withValues(alpha: 0.25),
        isUnread: true,
        isSystem: false,
      ),
    ];
  }

  List<NotificationItem> getNotifications(BuildContext context) {
    final currentLang = context.locale.languageCode;
    if (_notifications == null || _lastLanguageCode != currentLang) {
      _lastLanguageCode = currentLang;
      _notifications = _initNotifications();
    }
    return _notifications!;
  }

  List<NotificationItem> getFilteredNotifications(BuildContext context) {
    final notifs = getNotifications(context);
    if (selectedTab == 0) {
      return notifs;
    } else if (selectedTab == 1) {
      return notifs.where((n) => n.isUnread).toList();
    } else {
      return notifs.where((n) => n.isSystem).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = getFilteredNotifications(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg = isDark ? const Color(0xFF121212) : AppColors.background;

    return Scaffold(
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
                          color: isDark ? Colors.white38 : AppColors.onSurfaceVariant.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "no_notifications".tr(),
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
                            getNotifications(context).remove(item);
                          });
                        },
                        onMarkAsRead: () {
                          setState(() {
                            final notifs = getNotifications(context);
                            final targetIndex = notifs.indexOf(item);
                            if (targetIndex != -1) {
                              notifs[targetIndex] =
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
    );
  }

  Widget _buildFilterTabs(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : AppColors.onSurfaceVariant.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          _buildTabItem("tab_all".tr(), 0, isDark),
          _buildTabItem("tab_unread".tr(), 1, isDark),
          _buildTabItem("tab_system".tr(), 2, isDark),
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
                      color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
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
