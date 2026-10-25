import 'package:afforestation_app/core/functions/extenstion.dart';
import 'package:flutter/material.dart';

class buildHeader extends StatelessWidget {
  const buildHeader({super.key, required this.context});

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 50, bottom: 20, right: 16, left: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E3A1E) : const Color(0xFF72C366),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 22,
            ),
            onPressed: () {
              Navigator.maybePop(context);
            },
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "notifications".tr(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "notifications_subtitle".tr(),
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white70 : const Color(0xFFE2FBE7),
                  ),
                ),
              ],
            ),
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
          Expanded(
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: searchBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderColor),
              ),
              child: TextField(
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 13,
                ),
                decoration: InputDecoration(
                  hintText: "search_in_notifications".tr(),
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
          const SizedBox(width: 8),
          TextButton(
            onPressed: () {},
            child: Text(
              "clear_all".tr(),
              style: TextStyle(
                color: clearColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
