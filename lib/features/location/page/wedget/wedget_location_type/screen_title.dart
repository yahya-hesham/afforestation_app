import 'package:flutter/material.dart';

class screen_title extends StatelessWidget {
  const screen_title({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Center(
          child: Text(
            'تخصيص المواقع',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 8),
        Center(
          child: Text(
            'قم بإضافة وتصنيف أنواع المواقع لتنظيم عمليات التشجير.',
            style: TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
