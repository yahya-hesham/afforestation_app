import 'package:afforestation_app/core/styles/colors.dart';
import 'package:afforestation_app/features/search/data/models/search_result_model.dart';
import 'package:afforestation_app/features/search/presentation/cubit/search_cubit.dart';
import 'package:afforestation_app/features/search/presentation/cubit/search_state.dart';
import 'package:afforestation_app/features/search/presentation/page/statistics_summary.dart';
import 'package:afforestation_app/features/search/presentation/widgets/record_card.dart';
import 'package:afforestation_app/features/search/presentation/widgets/summary_table.dart';
import 'package:afforestation_app/features/search/presentation/widgets/total_count_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchResultsPage extends StatelessWidget {
  const SearchResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // Custom LTR AppBar to position Title on Left and Admin Profile on Right
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            leadingWidth: 180,
            leading: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black12),
                    ),
                    child: const Icon(
                      Icons.park_outlined,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Afforestation",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, size: 16, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "ADMIN",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(
                      Icons.logout,
                      color: AppColors.onSurface,
                      size: 20,
                    ),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: BlocBuilder<SearchCubit, SearchState>(
            builder: (context, state) {
              if (state is SearchLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.secondary,
                  ),
                );
              }

              if (state is SearchError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: AppColors.error,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                          ),
                          child: const Text(
                            "العودة للبحث",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state is SearchSuccess) {
                final results = state.result.items;
                final totalCount = state.result.totalCount;

                if (results.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.search_off,
                          color: Colors.grey,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "لا توجد نتائج",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "جرب تعديل معايير البحث",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                          ),
                          child: const Text(
                            "العودة للبحث",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return _buildResultsContent(context, results, totalCount);
              }

              // Initial state — shouldn't normally be seen on this page
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.secondary,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildResultsContent(
    BuildContext context,
    List<SearchResultModel> results,
    int totalCount,
  ) {
    // Build summary data from results
    final treeTypeSummary = <String, int>{};
    for (final item in results) {
      final typeName = item.treeTypeName ?? "غير محدد";
      treeTypeSummary[typeName] = (treeTypeSummary[typeName] ?? 0) + item.number;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Section
          const Center(
            child: Column(
              children: [
                Text(
                  "نتائج البحث",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "سجلات التشجير بناءً على معايير البحث",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Export to Excel Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () {
                // Perform Excel Export Action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 0,
              ),
              icon: const Icon(
                Icons.download,
                color: Colors.white,
                size: 20,
              ),
              label: const Text(
                "تصدير إلى إكسل",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // View Statistics Summary Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StatisticsSummaryPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                elevation: 0,
                side: const BorderSide(
                  color: AppColors.secondary,
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              icon: const Icon(
                Icons.analytics_outlined,
                color: AppColors.primary,
                size: 20,
              ),
              label: const Text(
                "عرض ملخص الإحصائيات",
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Latest Records Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.search,
                  color: AppColors.primary,
                  size: 22,
                ),
                onPressed: () {},
              ),
              const Text(
                "أحدث السجلات",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Record Cards from API data
          ...results.map(
            (item) => RecordCard(
              plantName: item.treeName ?? "غير محدد",
              badgeText: item.treeTypeName ?? "",
              plantingDate: "${item.dateOfPlanted.year}-${item.dateOfPlanted.month.toString().padLeft(2, '0')}-${item.dateOfPlanted.day.toString().padLeft(2, '0')}",
              scientificName: item.scientificName ?? "",
              location: item.locationName ?? "غير محدد",
              quantity: item.number.toString(),
              registeredBy: item.userName ?? "غير معروف",
              onEdit: () {},
              onDelete: () {},
            ),
          ),

          const SizedBox(height: 12),
          const Center(
            child: Text(
              "نهاية النتائج",
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 25),

          // Summary Table — show first result summary or first tree type
          if (results.isNotEmpty)
            SummaryTable(
              plantType: results.first.treeTypeName ?? "",
              plantName: results.first.treeName ?? "",
              quantity: results.fold<int>(0, (sum, item) => sum + item.number).toString(),
            ),
          const SizedBox(height: 25),

          // Total Count Card
          TotalCountCard(totalCount: totalCount.toString()),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}
