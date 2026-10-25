import 'dart:io';
import 'package:afforestation_app/core/styles/colors.dart';
import 'package:afforestation_app/features/search/data/models/search_request_model.dart';
import 'package:afforestation_app/features/search/data/models/search_result_model.dart';
import 'package:afforestation_app/features/search/data/models/update_record_model.dart';
import 'package:afforestation_app/features/search/data/repo/search_repo.dart';
import 'package:afforestation_app/features/search/presentation/cubit/search_cubit.dart';
import 'package:afforestation_app/features/search/presentation/cubit/search_state.dart';
import 'package:afforestation_app/features/search/presentation/page/statistics_summary.dart';
import 'package:afforestation_app/features/search/presentation/widgets/record_card.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchResultsPage extends StatefulWidget {
  const SearchResultsPage({super.key});

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  static const int _pageSize = 10;
  int _currentPage = 0;
  bool _isExporting = false;

  Future<void> _exportToExcel() async {
    if (_isExporting) return;

    setState(() {
      _isExporting = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(color: AppColors.secondary),
                SizedBox(width: 20),
                Text("جاري تصدير ملف إكسل..."),
              ],
            ),
          ),
        );
      },
    );

    try {
      final searchCubit = context.read<SearchCubit>();
      final request = SearchRequestModel(
        fromDate: searchCubit.fromDate,
        toDate: searchCubit.toDate,
        selectedUserId: searchCubit.selectedUserId,
        selectedLocationId: searchCubit.selectedLocationId,
        selectedTreeId: searchCubit.selectedTreeId,
      );

      final bytes = await SearchRepo.exportExcel(request: request);

      final tempDir = await getTemporaryDirectory();
      final fromStr = request.fromDate != null
          ? "${request.fromDate!.day}-${request.fromDate!.month}-${request.fromDate!.year}"
          : "All";
      final toStr = request.toDate != null
          ? "${request.toDate!.day}-${request.toDate!.month}-${request.toDate!.year}"
          : "All";
      final fileName = "Afforestation($fromStr) to ($toStr).xlsx";
      final filePath = "${tempDir.path}/$fileName";
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      if (mounted) {
        Navigator.pop(context);
      }

      final xFile = XFile(filePath);
      await Share.shareXFiles([xFile], text: 'تقرير بيانات التشجير');
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("فشل التصدير: $e"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isExporting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg = isDark ? const Color(0xFF121212) : AppColors.background;
    final textColor = isDark ? Colors.white : AppColors.onSurface;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: textColor,
                size: 20,
              ),
              onPressed: () => Navigator.maybePop(context),
            ),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E3A1E) : const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.park, color: Color(0xFF4CAF50), size: 18),
                ),
                const SizedBox(width: 8),
                Text(
                  "Afforestation",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: textColor,
                  ),
                ),
              ],
            ),
            actions: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: isDark ? const Color(0xFF2C2C2C) : Colors.grey,
                    child: const Icon(Icons.person, size: 16, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "ADMIN",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(
                      Icons.logout,
                      color: textColor,
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
          child: BlocConsumer<SearchCubit, SearchState>(
            listener: (context, state) {
              if (state is SearchError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is SearchLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.secondary),
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
                          style: TextStyle(
                            fontSize: 16,
                            color: textColor,
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
                final allResults = state.results;

                if (allResults.isEmpty) {
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
                        Text(
                          "لا توجد نتائج",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textColor,
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

                return _buildResultsContent(context, allResults, isDark);
              }

              return const Center(
                child: CircularProgressIndicator(color: AppColors.secondary),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildResultsContent(
    BuildContext context,
    List<SearchResultModel> allResults,
    bool isDark,
  ) {
    final totalCount = allResults.length;
    final totalPages = (totalCount / _pageSize).ceil();
    if (_currentPage >= totalPages) {
      _currentPage = totalPages - 1;
    }
    if (_currentPage < 0) {
      _currentPage = 0;
    }
    final startIndex = _currentPage * _pageSize;
    final endIndex = (startIndex + _pageSize > totalCount)
        ? totalCount
        : startIndex + _pageSize;
    final pageResults = allResults.sublist(startIndex, endIndex);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Section
          Center(
            child: Column(
              children: [
                Text(
                  "نتائج البحث",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "سجلات التشجير بناءً على معايير البحث",
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white60 : Colors.grey,
                  ),
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
              onPressed: _exportToExcel,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 0,
              ),
              icon: const Icon(Icons.download, color: Colors.white, size: 20),
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
                    builder: (context) =>
                        StatisticsSummaryPage(results: allResults),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                foregroundColor: isDark ? const Color(0xFF81C784) : AppColors.primary,
                elevation: 0,
                side: const BorderSide(color: AppColors.secondary, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              icon: Icon(
                Icons.analytics_outlined,
                color: isDark ? const Color(0xFF81C784) : AppColors.primary,
                size: 20,
              ),
              label: Text(
                "عرض ملخص الإحصائيات",
                style: TextStyle(
                  color: isDark ? const Color(0xFF81C784) : AppColors.primary,
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
              Text(
                "صفحة ${_currentPage + 1} من $totalPages  ($totalCount سجل)",
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white60 : Colors.grey,
                ),
              ),
              Text(
                "أحدث السجلات",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Record Cards
          ...pageResults.map(
            (item) => RecordCard(
              plantName: item.treeName ?? "غير محدد",
              badgeText: item.treeTypeName ?? "",
              plantingDate:
                  "${item.dateOfPlanted.year}-${item.dateOfPlanted.month.toString().padLeft(2, '0')}-${item.dateOfPlanted.day.toString().padLeft(2, '0')}",
              scientificName: item.scientificName ?? "",
              location: item.locationName ?? "غير محدد",
              quantity: item.number.toString(),
              registeredBy: item.userName ?? "غير معروف",
              onEdit: () => _showEditDialog(context, item, isDark),
              onDelete: () => _showDeleteConfirmation(context, item, isDark),
            ),
          ),

          const SizedBox(height: 16),

          // Pagination Controls
          if (totalPages > 1)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _currentPage > 0
                      ? () {
                          setState(() => _currentPage--);
                        }
                      : null,
                  icon: const Icon(Icons.arrow_back_ios, size: 18),
                  color: isDark ? const Color(0xFF81C784) : AppColors.primary,
                  disabledColor: isDark ? Colors.white24 : Colors.grey.shade300,
                ),
                ...List.generate(totalPages > 5 ? 5 : totalPages, (i) {
                  int pageIndex;
                  if (totalPages <= 5) {
                    pageIndex = i;
                  } else if (_currentPage < 3) {
                    pageIndex = i;
                  } else if (_currentPage > totalPages - 4) {
                    pageIndex = totalPages - 5 + i;
                  } else {
                    pageIndex = _currentPage - 2 + i;
                  }
                  return GestureDetector(
                    onTap: () {
                      setState(() => _currentPage = pageIndex);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: _currentPage == pageIndex
                            ? AppColors.secondary
                            : (isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade100),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${pageIndex + 1}',
                        style: TextStyle(
                          color: _currentPage == pageIndex
                              ? Colors.white
                              : (isDark ? Colors.white : AppColors.onSurface),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                }),
                IconButton(
                  onPressed: _currentPage < totalPages - 1
                      ? () {
                          setState(() => _currentPage++);
                        }
                      : null,
                  icon: const Icon(Icons.arrow_forward_ios, size: 18),
                  color: isDark ? const Color(0xFF81C784) : AppColors.primary,
                  disabledColor: isDark ? Colors.white24 : Colors.grey.shade300,
                ),
              ],
            ),

          const SizedBox(height: 15),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    SearchResultModel item,
    bool isDark,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            "تأكيد الحذف",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? const Color(0xFF81C784) : AppColors.primary,
            ),
          ),
          content: Text(
            "هل أنت متأكد من حذف \"${item.treeName ?? ''}\"؟",
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("إلغاء", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                context.read<SearchCubit>().deleteRecord(item.id);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("حذف", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(
    BuildContext context,
    SearchResultModel item,
    bool isDark,
  ) {
    final numberController = TextEditingController(
      text: item.number.toString(),
    );
    DateTime? selectedDate = item.dateOfPlanted;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              "تعديل سجل التشجير",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDark ? const Color(0xFF81C784) : AppColors.primary,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.park, color: AppColors.secondary),
                    title: Text(
                      item.treeName ?? "غير محدد",
                      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                    ),
                    subtitle: Text(
                      item.scientificName ?? "",
                      style: TextStyle(color: isDark ? Colors.white60 : Colors.black54),
                    ),
                  ),
                  Divider(color: isDark ? Colors.white12 : Colors.black12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.calendar_today,
                      color: AppColors.secondary,
                    ),
                    title: Text(
                      "تاريخ الزراعة",
                      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                    ),
                    subtitle: Text(
                      "${selectedDate?.year}-${selectedDate?.month.toString().padLeft(2, '0')}-${selectedDate?.day.toString().padLeft(2, '0')}",
                      style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                    ),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: dialogContext,
                        initialDate: selectedDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                        builder: (ctx, child) => Theme(
                          data: isDark
                              ? Theme.of(ctx).copyWith(
                                  colorScheme: const ColorScheme.dark(
                                    primary: AppColors.secondary,
                                    onPrimary: Colors.white,
                                    surface: Color(0xFF1E1E1E),
                                    onSurface: Colors.white,
                                  ),
                                  dialogBackgroundColor: const Color(0xFF1E1E1E),
                                )
                              : Theme.of(ctx).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: AppColors.primary,
                                    onPrimary: Colors.white,
                                    onSurface: AppColors.onSurface,
                                  ),
                                ),
                          child: child!,
                        ),
                      );
                      if (picked != null) {
                        setDialogState(() => selectedDate = picked);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: numberController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                    decoration: const InputDecoration(
                      labelText: "الكمية",
                      prefixIcon: Icon(
                        Icons.numbers,
                        color: AppColors.secondary,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(
                          color: AppColors.secondary,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text(
                  "إلغاء",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final updateData = UpdateRecordModel(
                    id: item.id,
                    dateOfPlanted: selectedDate,
                    treeTypeId: item.treeTypeId,
                    treeNameId: item.treeNameId,
                    locationId: item.locationId,
                    locationTypeId: item.locationTypeId,
                    number: int.tryParse(numberController.text) ?? item.number,
                  );
                  Navigator.pop(dialogContext);
                  context.read<SearchCubit>().updateRecord(updateData);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "حفظ التعديلات",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
