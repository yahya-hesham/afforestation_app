import 'package:flutter/material.dart';

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
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9FA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "لوحة المستخدم",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B3A1E)),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.redAccent),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "مرحباً مجدداً، $userName",
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B3A1E)),
                          ),
                          Text(
                            userEmail,
                            style: const TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      const CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      title: "إجمالي الأعمال",
                      value: "145",
                      unit: "شتلة",
                      icon: Icons.analytics_outlined,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildStatCard(
                      title: "نشاطك الأسبوعي",
                      value: "12",
                      unit: "عملية",
                      icon: Icons.insights_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                "العمليات السريعة",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B3A1E)),
              ),
              const SizedBox(height: 12),
              _buildActionCard(
                title: "إضافة عملية تشجير جديدة",
                subtitle: "سجل بيانات شتلات جديدة في المواقع الميدانية المعتمدة",
                icon: Icons.add_circle_outline,
                onTap: () {},
              ),
              const SizedBox(height: 25),
              const Text(
                "عرض البيانات المضافة",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B3A1E)),
              ),
              const SizedBox(height: 12),
              _buildActionCard(
                title: "عرض البيانات المضافة",
                subtitle: "راجع سجلاتك السابقة وتتبع حالة نمو النباتات التي قمت بزراعتها",
                icon: Icons.storage_outlined,
                onTap: () {},
              ),
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "تساهم جهودك في زيادة الغطاء النباتي. شكراً لمساهمتك في حماية البيئة وتطوير المناطق الخضراء.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Color(0xFF2E7D32), height: 1.5),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF53B157),
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        onTap: (index) {
          if (index == 3) {
            Navigator.pop(context);
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'الملف الشخصي'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), label: 'الإحصائيات'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'البحث'),
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'الرئيسية'),
        ],
      ),
    );
  }

  Widget _buildStatCard({required String title, required String value, required String unit, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEFEFEF)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: const Color(0xFF53B157), size: 20),
              Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(unit, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(width: 4),
              Text(value, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF1B3A1E))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({required String title, required String subtitle, required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFEFEFEF)),
        ),
        child: Row(
          children: [
            const Icon(Icons.arrow_back_ios, size: 14, color: Colors.grey),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1B3A1E))),
                  const SizedBox(height: 4),
                  Text(subtitle, textAlign: TextAlign.end, style: const TextStyle(fontSize: 12, color: Colors.grey, height: 1.4)),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xFF53B157), size: 24),
            ),
          ],
        ),
      ),
    );
  }
}