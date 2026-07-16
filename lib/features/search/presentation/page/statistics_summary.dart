import 'package:afforestation_app/core/styles/colors.dart';
import 'package:afforestation_app/core/styles/text_styles.dart';
import 'package:afforestation_app/features/search/data/models/search_result_model.dart';
import 'package:afforestation_app/features/search/presentation/widgets/category_summary_card.dart';
import 'package:afforestation_app/features/search/presentation/widgets/grand_total_card.dart';
import 'package:afforestation_app/features/search/presentation/widgets/smart_alert_card.dart';
import 'package:flutter/material.dart';

class StatisticsSummaryPage extends StatelessWidget {
  /// ✅ The actual search results passed from the search results page
  final List<SearchResultModel> results;

  const StatisticsSummaryPage({super.key, required this.results});

  /// Groups search results by treeTypeName and builds category data
  /// Returns a list of maps, each containing:
  ///   - 'typeName': the tree type category name
  ///   - 'items': list of CategorySummaryItem (plant names + quantities)
  ///   - 'subtotal': total quantity for this category
  List<Map<String, dynamic>> _buildCategoryData() {
    // Group results by treeTypeName
    final Map<String, Map<String, int>> grouped = {};

    for (final result in results) {
      final typeName = result.treeTypeName ?? 'غير مصنف';
      final plantName = result.treeName ?? 'غير محدد';
      final scientificName = result.scientificName ?? '';

      // Use "plantName|scientificName" as key to keep both values
      final itemKey = '$plantName|$scientificName';

      grouped.putIfAbsent(typeName, () => {});
      grouped[typeName]!.update(
        itemKey,
        (existing) => existing + result.number,
        ifAbsent: () => result.number,
      );
    }

    // Convert to list of category data
    final categories = <Map<String, dynamic>>[];
    for (final entry in grouped.entries) {
      final items = <CategorySummaryItem>[];
      int subtotal = 0;

      for (final plantEntry in entry.value.entries) {
        final parts = plantEntry.key.split('|');
        final nameAr = parts[0];
        final nameEn = parts.length > 1 ? parts[1] : '';

        items.add(CategorySummaryItem(
          nameAr: nameAr,
          nameEn: nameEn,
          quantity: plantEntry.value,
        ));
        subtotal += plantEntry.value;
      }

      categories.add({
        'typeName': entry.key,
        'items': items,
        'subtotal': subtotal,
      });
    }

    return categories;
  }

  /// Assigns a different green shade to each category for visual variety
  Color _getCategoryColor(int index) {
    const colors = [
      AppColors.secondary,
      Color(0xFF5CA34C),
      Color(0xFF458536),
      Color(0xFF2E7D32),
      Color(0xFF388E3C),
      Color(0xFF43A047),
    ];
    return colors[index % colors.length];
  }

  /// Picks an icon for each category
  IconData _getCategoryIcon(int index) {
    const icons = [
      Icons.spa,
      Icons.park,
      Icons.forest,
      Icons.eco,
      Icons.grass,
      Icons.local_florist,
    ];
    return icons[index % icons.length];
  }

  @override
  Widget build(BuildContext context) {
    final categories = _buildCategoryData();
    final grandTotal = categories.fold<int>(
      0,
      (sum, cat) => sum + (cat['subtotal'] as int),
    );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'ملخص حسب نوع النبات',
            style: TextStyles.appBarTitleStyle,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
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
                    color: AppColors.secondary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.eco,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: results.isEmpty
              ? const Center(
                  child: Text(
                    'لا توجد بيانات لعرض الملخص',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
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
                      // Header section
                      const Text(
                        "إحصائيات التشجير",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "عرض توزيع النباتات والكميات المزروعة حسب الفئة العلمية (${results.length} سجل)",
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 25),

                      // Dynamic Category Cards — built from actual search results
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

                      // Grand Total Card
                      GrandTotalCard(totalCount: grandTotal),
                      const SizedBox(height: 20),

                      // Smart Alert Card
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
