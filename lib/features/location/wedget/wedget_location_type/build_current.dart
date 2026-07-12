import 'package:flutter/material.dart';

class build_current_type_header extends StatelessWidget {
  const build_current_type_header({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F3E8),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            '4 تصنيفات',
            style: TextStyle(
              color: Color(0xFF68B258),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Expanded(
          child: Center(
            child: Text(
              'الأنواع الحالية',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(width: 80), // To balance the center alignment
      ],
    );
  }
}
