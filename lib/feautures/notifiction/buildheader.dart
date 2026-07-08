import 'package:flutter/material.dart';

class buildHeader extends StatelessWidget {
  const buildHeader({super.key, required this.context});

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 24, right: 24, left: 24),
      decoration: const BoxDecoration(
        color: Color(0xFF72C366),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "الإشعارات",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "آخر التنبيهات والرسائل المرتبطة بالتطبيق",
                style: TextStyle(fontSize: 12, color: Color(0xFFE2FBE7)),
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
    return Padding(
      padding: const EdgeInsets.only(top: 16, right: 16, left: 16, bottom: 8),
      child: Row(
        children: [
          TextButton(
            onPressed: () {},
            child: const Text(
              "مسح الكل",
              style: TextStyle(
                color: Color(0xFF1E5624),
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: const TextField(
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: "...بحث في التنبيهات",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
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
