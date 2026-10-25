import 'package:afforestation_app/core/functions/extenstion.dart';
import 'package:afforestation_app/core/styles/colors.dart';
import 'package:flutter/material.dart';

class CategorySummaryItem {
  final String nameAr;
  final String nameEn;
  final int quantity;

  const CategorySummaryItem({
    required this.nameAr,
    required this.nameEn,
    required this.quantity,
  });
}

class CategorySummaryCard extends StatelessWidget {
  final String categoryTitle;
  final IconData categoryIcon;
  final List<CategorySummaryItem> items;
  final int subtotal;
  final Color? bannerColor;

  const CategorySummaryCard({
    super.key,
    required this.categoryTitle,
    required this.categoryIcon,
    required this.items,
    required this.subtotal,
    this.bannerColor,
  });

  String _formatNumber(int number) {
    final RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return number.toString().replaceAllMapped(
      reg,
      (Match match) => '${match[1]},',
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? const Color(0xFF1E1E1E) : AppColors.surface;
    final textColor = isDark ? Colors.white : AppColors.onSurface;
    final subheadColor = isDark ? const Color(0xFF2C2C2C) : Colors.grey.withValues(alpha: 0.05);
    final dividerColor = isDark ? Colors.white12 : Colors.black12.withValues(alpha: 0.05);
    final Color activeBannerColor = bannerColor ?? AppColors.secondary;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.black12.withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Category Banner Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: activeBannerColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(22),
                topRight: Radius.circular(22),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(categoryIcon, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  categoryTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Table Sub-header Row
          Container(
            color: subheadColor,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "plant_name".tr(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white60 : Colors.grey,
                  ),
                ),
                Text(
                  "quantity".tr(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white60 : Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          // List of Plant Items
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              thickness: 1,
              color: dividerColor,
            ),
            itemBuilder: (context, index) {
              final item = items[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.nameAr,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          if (item.nameEn.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              item.nameEn,
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? Colors.white60 : Colors.grey.shade600,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Text(
                      _formatNumber(item.quantity),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Subtotal Row Footer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF2C2C2C)
                  : Colors.grey.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(22),
                bottomRight: Radius.circular(22),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "category_total".tr(),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isDark ? const Color(0xFF81C784) : AppColors.primary,
                  ),
                ),
                Text(
                  _formatNumber(subtotal),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? const Color(0xFF81C784) : AppColors.primary,
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
