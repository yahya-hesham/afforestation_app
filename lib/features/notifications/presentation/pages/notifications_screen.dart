import 'package:afforestation_app/core/styles/themes.dart';
import 'package:afforestation_app/features/notifications/presentation/widget/buildheader.dart';
import 'package:afforestation_app/features/notifications/presentation/widget/notfication_card.dart';
import 'package:flutter/material.dart';
import 'package:afforestation_app/features/dashboard/presentation/widgets/plant_bottom_nav_bar.dart';
import 'package:afforestation_app/core/styles/colors.dart';
import 'package:afforestation_app/core/styles/text_styles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notifications Screen',
      theme: AppThemes.lightTheme,
      home: const NotificationsScreen(),
    );
  }
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int selectedTab = 0;
  final List<NotificationItem> allNotifications = [
    NotificationItem(
      title: "تنبيه زراعة جديد",
      description: "بواسطة ||| تمت إضافة 50 شتلة لافندر في منطقة المشرف عبده.",
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
      return allNotifications; // عرض الكل
    } else if (selectedTab == 1) {
      return allNotifications
          .where((n) => n.isUnread)
          .toList(); // غير مقروءة فقط
    } else {
      return allNotifications
          .where((n) => n.isSystem)
          .toList(); // تنبيهات النظام فقط
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = getFilteredNotifications();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            buildHeader(context: context),

            buildsearchrow(),

            _buildFilterTabs(),

            Expanded(
              child: filteredList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_off_outlined,
                            size: 64,
                            color: AppColors.onSurfaceVariant.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "لا توجد تنبيهات حالياً في هذا القسم",
                            style: TextStyles.listRowSubtitleStyle.copyWith(
                              fontSize: 15,
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
                              allNotifications.remove(item);
                            });
                          },
                          onMarkAsRead: () {
                            setState(() {
                              final targetIndex = allNotifications.indexOf(
                                item,
                              );
                              if (targetIndex != -1) {
                                allNotifications[targetIndex] =
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

  Widget _buildFilterTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.onSurfaceVariant.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          _buildTabItem("الكل", 0),
          _buildTabItem("غير مقروءة", 1),
          _buildTabItem("تنبيهات النظام", 2),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title, int index) {
    bool isSelected = selectedTab == index;
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
            color: isSelected ? AppColors.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(15),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.onSurface.withOpacity(0.04),
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
                    color: AppColors.primary,
                    fontSize: 13,
                  )
                : TextStyles.listRowSubtitleStyle.copyWith(fontSize: 13),
          ),
        ),
      ),
    );
  }
}
