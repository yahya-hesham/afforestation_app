import 'package:afforestation_app/core/styles/colors.dart';
import 'package:afforestation_app/core/styles/text_styles.dart';
import 'package:afforestation_app/features/search/data/models/search_result_model.dart';
import 'package:afforestation_app/features/search/presentation/widgets/category_summary_card.dart';
import 'package:afforestation_app/features/search/presentation/widgets/grand_total_card.dart';
import 'package:afforestation_app/features/search/presentation/widgets/smart_alert_card.dart';
import 'package:flutter/material.dart';

class StatisticsSummaryPage extends StatelessWidget {
  final List<SearchResultModel> results;

  const StatisticsSummaryPage({super.key, required this.results});

  List<Map<String, dynamic>> _buildCategoryData() {
    final Map<String, Map<String, int>> grouped = {};

    for (final item in results) {
      final type = (item.treeTypeName != null && item.treeTypeName!.isNotEmpty)
          ? item.treeTypeName!
          : "غير مصنف";
      final name = (item.treeName != null && item.treeName!.isNotEmpty)
          ? item.treeName!
          : "غير معروف";

      grouped.putIfAbsent(type, () => {});
      grouped[type]![name] = (grouped[type]![name] ?? 0) + item.number;
    }

    final List<Map<String, dynamic>> categories = [];
    grouped.forEach((typeName, itemsMap) {
      final items = itemsMap.entries.map((e) {
        return CategorySummaryItem(
          nameAr: e.key,
          nameEn: "",
          quantity: e.value,
        );
      }).toList();

      final subtotal = items.fold<int>(0, (sum, it) => sum + it.quantity);

      categories.add({
        'typeName': typeName,
        'items': items,
        'subtotal': subtotal,
      });
    });

    return categories;
  }

  Color _getCategoryColor(int index) {
    const colors = [
      AppColors.secondary,
      Color(0xFF2E7D32),
      Color(0xFF388E3C),
      Color(0xFF66BB6A),
    ];
    return colors[index % colors.length];
  }

  IconData _getCategoryIcon(int index) {
    const icons = [
      Icons.forest,
      Icons.eco,
      Icons.grass,
      Icons.local_florist,
    ];
    return icons[index % icons.length];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg = isDark ? const Color(0xFF121212) : AppColors.background;
    final textColor = isDark ? Colors.white : AppColors.onSurface;

    final categories = _buildCategoryData();
    final grandTotal = categories.fold<int>(
      0,
      (sum, cat) => sum + (cat['subtotal'] as int),
    );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: scaffoldBg,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'ملخص حسب نوع النبات',
            style: TextStyles.appBarTitleStyle.copyWith(
              color: textColor,
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: textColor,
            ),
            onPressed: () => Navigator.maybePop(context),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(
                      alpha: isDark ? 0.25 : 0.15,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.eco,
                    color: isDark ? const Color(0xFF81C784) : AppColors.primary,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: results.isEmpty
              ? Center(
                  child: Text(
                    'لا توجد بيانات لعرض الملخص',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? Colors.white60 : Colors.grey,
                    ),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 15.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "إحصائيات التشجير",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "عرض توزيع النباتات والكميات المزروعة حسب الفئة العلمية (${results.length} سجل)",
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white60 : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 25),

                      ...categories.asMap().entries.map((entry) {
                        final index = entry.key;
                        final cat = entry.value;
                        return CategorySummaryCard(
                          categoryTitle: cat['typeName'] as String,
                          categoryIcon: _getCategoryIcon(index),
                          items: cat['items'] as List<CategorySummaryItem>,
                          subtotal: cat['subtotal'] as int,
                          bannerColor: _getCategoryColor(index),
                        );
                      }),

                      GrandTotalCard(totalCount: grandTotal),
                      const SizedBox(height: 20),

                      SmartAlertCard(
                        title: "ملخص",
                        message:
                            "تم العثور على ${results.length} سجل بإجمالي $grandTotal شتلة موزعة على ${categories.length} فئة.",
                      ),
                      const SizedBox(height: 25),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
