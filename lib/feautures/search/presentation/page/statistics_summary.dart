import 'package:afforestation_app/core/styles/colors.dart';
import 'package:afforestation_app/core/styles/text_styles.dart';
import 'package:afforestation_app/feautures/search/presentation/widgets/category_summary_card.dart';
import 'package:afforestation_app/feautures/search/presentation/widgets/grand_total_card.dart';
import 'package:afforestation_app/feautures/search/presentation/widgets/smart_alert_card.dart';
import 'package:flutter/material.dart';

class StatisticsSummaryPage extends StatelessWidget {
  const StatisticsSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample category data from mockup
    final greenCovers = [
      const CategorySummaryItem(nameAr: 'روبينيا', nameEn: 'Ruellia', quantity: 7152),
      const CategorySummaryItem(nameAr: 'اريسين', nameEn: 'Iresine', quantity: 13092),
      const CategorySummaryItem(nameAr: 'ويدليا', nameEn: 'Wedelia', quantity: 6800),
    ];

    final trees = [
      const CategorySummaryItem(nameAr: 'اللوز الهندي - غاف البحر', nameEn: 'Prosopis juliflora', quantity: 30),
      const CategorySummaryItem(nameAr: 'اللبخ', nameEn: 'Albizia lebbeck', quantity: 85),
      const CategorySummaryItem(nameAr: 'النيم', nameEn: 'Azadirachta indica', quantity: 146),
    ];

    final shrubs = [
      const CategorySummaryItem(nameAr: 'كف مريم', nameEn: 'Vitex agnus-castus', quantity: 8),
      const CategorySummaryItem(nameAr: 'اكاسيا جلوكا', nameEn: 'Acacia glauca', quantity: 235),
      const CategorySummaryItem(nameAr: 'الجافتروفا', nameEn: 'Jatropha', quantity: 200),
      const CategorySummaryItem(nameAr: 'القنب - الوايتكس', nameEn: 'Vitex', quantity: 773),
    ];

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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
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
                const Text(
                  "عرض توزيع النباتات والكميات المزروعة حسب الفئة العلمية",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 25),

                // Category 1: Green Covers
                CategorySummaryCard(
                  categoryTitle: "أغلفة خضراء",
                  categoryIcon: Icons.spa,
                  items: greenCovers,
                  subtotal: 27044,
                  bannerColor: AppColors.secondary,
                ),

                // Category 2: Trees
                CategorySummaryCard(
                  categoryTitle: "الأشجار",
                  categoryIcon: Icons.park,
                  items: trees,
                  subtotal: 261,
                  bannerColor: const Color(0xFF5CA34C),
                ),

                // Category 3: Shrubs
                CategorySummaryCard(
                  categoryTitle: "شجيرات / أشجار فرعية",
                  categoryIcon: Icons.forest,
                  items: shrubs,
                  subtotal: 1216,
                  bannerColor: const Color(0xFF458536),
                ),

                // Grand Total Card
                const GrandTotalCard(totalCount: 28521),
                const SizedBox(height: 20),

                // Smart Alert Card
                const SmartAlertCard(
                  title: "تنبيه ذكي",
                  message: "تمت زيادة معدل التشجير في منطقة \"أغلفة خضراء\" بنسبة 12% مقارنة بالشهر الماضي.",
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
