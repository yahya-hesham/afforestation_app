import 'package:afforestation_app/feautures/notifiction/buildheader.dart';
import 'package:flutter/material.dart';

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
      locale: const Locale('ar', 'EG'),
      supportedLocales: const [Locale('ar', 'EG')],
      theme: ThemeData(
        fontFamily: 'Cairo',
        scaffoldBackgroundColor: const Color(0xFFF3F7F3),
      ),
      home: const NotificationsScreen(),
    );
  }
}

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

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int selectedTab = 0;
  int selectedBottomNav = 1;

  final List<NotificationItem> allNotifications = [
    NotificationItem(
      title: "تنبيه زراعة جديد",
      description: "بواسطة ||| تمت إضافة 50 شتلة لافندر في منطقة المشرف عبده.",
      time: "قبل 5 دقائق",
      avatarColor: const Color(0xFFE2FBE7),
      isUnread: true,
      isSystem: false,
    ),
    NotificationItem(
      title: "تحديث حالة النظام",
      description: "تم تحديث سجلات التشجير الأسبوعية بنجاح",
      time: "قبل 2 ساعة",
      avatarColor: const Color(0xFFE2EBFB),
      isUnread: false,
      isSystem: true,
    ),
    NotificationItem(
      title: "تنبيه ري",
      description: "يرجى مراجعة جدول الري لمنطقة لافندر اليوم.",
      time: "قبل 4 ساعات",
      avatarColor: const Color(0xFFFBECE2),
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
        body: Column(
          children: [
            buildHeader(context: context),

            buildsearchrow(),

            _buildFilterTabs(),

            // قائمة الإشعارات بعد الفلترة والربط الديناميكي
            Expanded(
              child: filteredList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_off_outlined,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "لا توجد تنبيهات حالياً في هذا القسم",
                            style: TextStyle(
                              color: Colors.grey.shade600,
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
                        return _buildNotificationCard(item);
                      },
                    ),
            ),
          ],
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  // التابات مع التأكد من التوسيط التام والتصميم النظيف المتطابق مع الكبسولة في الصورة
  Widget _buildFilterTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFEDF2ED),
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
            selectedTab = index; // تغيير الفلتر ديناميكياً لتحديث القائمة
          });
        },
        child: Container(
          // 'alignment: Alignment.center' تضمن توسيط الكلام بشكل مثالي في نص الحاوية
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(15),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : [],
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected
                  ? const Color(0xFF1E5624)
                  : Colors.grey.shade600,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // علامة الإشعار غير المقروء (النقطة الخضراء) على اليسار تظهر حسب حالة العنصر
          if (item.isUnread)
            Container(
              margin: const EdgeInsets.only(top: 6),
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFF27AE60),
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
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.description,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                    height: 1.4,
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
                          icon: Icon(
                            Icons.delete_outline,
                            color: Colors.grey.shade400,
                            size: 20,
                          ),
                          onPressed: () {},
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.done_all,
                            color: Colors.grey.shade400,
                            size: 20,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    Text(
                      item.time,
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // الدائرة الملونة على اليمين
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

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
      ),
      child: BottomNavigationBar(
        currentIndex: selectedBottomNav,
        onTap: (index) => setState(() => selectedBottomNav = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF1E5624),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "حسابي",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "إحصائيات",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: "المواقع",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "الرئيسية",
          ),
        ],
      ),
    );
  }
}
