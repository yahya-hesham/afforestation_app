import 'package:flutter/material.dart';

class build_app_bar extends StatelessWidget {
  const build_app_bar({super.key, required this.context});

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {},
            child: const CircleAvatar(
              backgroundColor: Color(0xFF68B258),
              radius: 20,
              child: Icon(Icons.eco_outlined, color: Colors.white, size: 24),
            ),
          ),
          const Text(
            'إدارة أنواع المواقع',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.chevron_left, size: 30),
          ),
        ],
      ),
    );
  }
}
