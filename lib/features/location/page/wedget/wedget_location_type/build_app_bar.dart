import 'package:flutter/material.dart';

class build_app_bar extends StatelessWidget {
  const build_app_bar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFF68B258),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.eco_outlined,
              color: Colors.white,
              size: 24,
            ),
          ),
          const Text(
            'إدارة أنواع المواقع',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Icon(Icons.chevron_left, size: 30),
        ],
      ),
    );
  }
}
