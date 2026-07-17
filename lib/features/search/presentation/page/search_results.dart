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

    // Show a loading dialog
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

      // Fetch bytes from API
      final bytes = await SearchRepo.exportExcel(request: request);

      // Save to a temporary file
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

      // Close the loading dialog
      if (mounted) {
        Navigator.pop(context);
      }

      // Share the file using share_plus
      final xFile = XFile(filePath);
      await Share.shareXFiles([xFile], text: 'تقرير بيانات التشجير');
    } catch (e) {
      // Close the loading dialog
      if (mounted) {
        Navigator.pop(context);
      }

      // Show error snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("فشل التصدير: ${e.toString()}"),
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
    return Scaffold(
      backgroundColor: AppColors.background,
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

                return _buildResultsContent(context, allResults);
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
  ) {
    // UI-side pagination
    final totalCount = allResults.length;
    final totalPages = (totalCount / _pageSize).ceil();
    // Clamp current page
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
                    // ✅ Passing the actual search results to the statistics page
                    builder: (context) =>
                        StatisticsSummaryPage(results: allResults),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                elevation: 0,
                side: const BorderSide(color: AppColors.secondary, width: 1.5),
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
              Text(
                "صفحة ${_currentPage + 1} من $totalPages  ($totalCount سجل)",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
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

          // Record Cards — current page only
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
              onEdit: () => _showEditDialog(context, item),
              onDelete: () => _showDeleteConfirmation(context, item),
            ),
          ),

          const SizedBox(height: 16),

          // Pagination Controls
          if (totalPages > 1)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Previous
                IconButton(
                  onPressed: _currentPage > 0
                      ? () {
                          setState(() => _currentPage--);
                        }
                      : null,
                  icon: const Icon(Icons.arrow_back_ios, size: 18),
                  color: AppColors.primary,
                  disabledColor: Colors.grey.shade300,
                ),
                // Page numbers
                ...List.generate(totalPages > 5 ? 5 : totalPages, (i) {
                  // Show pages around current
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
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${pageIndex + 1}',
                        style: TextStyle(
                          color: _currentPage == pageIndex
                              ? Colors.white
                              : AppColors.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                }),
                // Next
                IconButton(
                  onPressed: _currentPage < totalPages - 1
                      ? () {
                          setState(() => _currentPage++);
                        }
                      : null,
                  icon: const Icon(Icons.arrow_forward_ios, size: 18),
                  color: AppColors.primary,
                  disabledColor: Colors.grey.shade300,
                ),
              ],
            ),

          const SizedBox(height: 15),
        ],
      ),
    );
  }

  // ─── Delete Confirmation Dialog ───
  void _showDeleteConfirmation(BuildContext context, SearchResultModel item) {
    showDialog(
      context: context,
      builder: (dialogContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "تأكيد الحذف",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          content: Text(
            "هل أنت متأكد من حذف سجل \"${item.treeName ?? ''}\"؟\nلا يمكن التراجع عن هذا الإجراء.",
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

  // ─── Edit Dialog ───
  void _showEditDialog(BuildContext context, SearchResultModel item) {
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              "تعديل السجل",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Plant name (read-only info)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.park, color: AppColors.secondary),
                    title: Text(item.treeName ?? "غير محدد"),
                    subtitle: Text(item.scientificName ?? ""),
                  ),
                  const Divider(),
                  // Date picker
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.calendar_today,
                      color: AppColors.secondary,
                    ),
                    title: const Text("تاريخ الزراعة"),
                    subtitle: Text(
                      "${selectedDate?.year}-${selectedDate?.month.toString().padLeft(2, '0')}-${selectedDate?.day.toString().padLeft(2, '0')}",
                    ),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: dialogContext,
                        initialDate: selectedDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                        builder: (ctx, child) => Theme(
                          data: Theme.of(ctx).copyWith(
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
                  // Quantity
                  TextField(
                    controller: numberController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "الكمية",
                      prefixIcon: const Icon(
                        Icons.numbers,
                        color: AppColors.secondary,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
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
