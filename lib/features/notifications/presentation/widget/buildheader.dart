import 'package:flutter/material.dart';

class buildHeader extends StatelessWidget {
  const buildHeader({super.key, required this.context});

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 24, right: 24, left: 24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E3A1E) : const Color(0xFF72C366),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "الإشعارات",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "آخر التنبيهات والرسائل المرتبطة بالتطبيق",
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white70 : const Color(0xFFE2FBE7),
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () {
              Navigator.maybePop(context);
            },
          ),
        ],
      ),
    );
  }
}

class buildsearchrow extends StatelessWidget {
  const buildsearchrow({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final searchBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final clearColor = isDark ? const Color(0xFF81C784) : const Color(0xFF1E5624);
    final borderColor = isDark ? Colors.white12 : Colors.grey.shade200;

    return Padding(
      padding: const EdgeInsets.only(top: 16, right: 16, left: 16, bottom: 8),
      child: Row(
        children: [
          TextButton(
            onPressed: () {},
            child: Text(
              "مسح الكل",
              style: TextStyle(
                color: clearColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: searchBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderColor),
              ),
              child: TextField(
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 13,
                ),
                decoration: InputDecoration(
                  hintText: "...بحث في التنبيهات",
                  hintStyle: TextStyle(
                    color: isDark ? Colors.white38 : Colors.grey,
                    fontSize: 13,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: isDark ? Colors.white54 : Colors.grey,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
