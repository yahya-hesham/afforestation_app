import 'package:afforestation_app/core/styles/colors.dart';
import 'package:afforestation_app/features/search/data/models/dropdown_item_model.dart';
import 'package:afforestation_app/features/search/presentation/cubit/search_cubit.dart';
import 'package:afforestation_app/features/search/presentation/cubit/search_state.dart';
import 'package:afforestation_app/features/search/presentation/widgets/quick_tip_card.dart';
import 'package:afforestation_app/features/search/presentation/widgets/search_date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'search_results.dart';

class Search extends StatefulWidget {
  final VoidCallback? onBackToHome;

  const Search({super.key, this.onBackToHome});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  DateTime? _startDate;
  DateTime? _endDate;

  DropdownItemModel? _selectedUser;
  DropdownItemModel? _selectedLocation;
  DropdownItemModel? _selectedPlant;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<SearchCubit>();
    // Load dropdowns and 30-day summary from API
    if (!cubit.areDropdownsLoaded) {
      cubit.loadDropdowns();
    }
    if (!cubit.isSummaryLoaded) {
      cubit.loadLast30DaysSummary();
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "dd/mm/yyyy";
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  void _performSearch() {
    // Validate: from date is required
    if (_startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("يجب تحديد تاريخ البداية قبل البحث"),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final searchCubit = context.read<SearchCubit>();

    // Set date filters on the cubit
    searchCubit.fromDate = _startDate;
    searchCubit.toDate = _endDate;

    // Set selected IDs from dropdown items (null means "all")
    searchCubit.selectedUserId = _selectedUser?.id;
    searchCubit.selectedLocationId = _selectedLocation?.id;
    searchCubit.selectedTreeId = _selectedPlant?.id;

    // Trigger the search
    searchCubit.search();

    // Navigate to results page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: searchCubit,
          child: const SearchResultsPage(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SearchCubit>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: AppColors.onSurface,
                size: 20,
              ),
              onPressed: () {
                if (widget.onBackToHome != null) {
                  widget.onBackToHome!();
                } else {
                  Navigator.maybePop(context);
                }
              },
            ),
            title: const Text(
              "البحث المتقدم",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
            centerTitle: true,
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.park_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Advanced Search Form Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.black.withValues(alpha: 0.04),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "بحث بيانات التشجير",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "تصفية حسب نطاق التاريخ والمستخدم والموقع",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 25),

                      // Dates row (من تاريخ / إلى تاريخ)
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SearchDateField(
                                  label: "من تاريخ *",
                                  value: _formatDate(_startDate),
                                  onTap: () => _selectDate(context, true),
                                ),
                                if (_startDate == null)
                                  const Padding(
                                    padding: EdgeInsets.only(top: 4, right: 4),
                                    child: Text(
                                      "مطلوب",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: SearchDateField(
                              label: "إلى تاريخ",
                              value: _formatDate(_endDate),
                              onTap: () => _selectDate(context, false),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Dropdowns populated from API
                      BlocBuilder<SearchCubit, SearchState>(
                        buildWhen: (prev, curr) =>
                            curr is DropdownsLoading ||
                            curr is DropdownsLoaded ||
                            curr is DropdownsError,
                        builder: (context, state) {
                          if (state is DropdownsLoading) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.secondary,
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          }

                          if (state is DropdownsError) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Column(
                                children: [
                                  const Icon(Icons.error_outline,
                                      color: Colors.redAccent, size: 28),
                                  const SizedBox(height: 8),
                                  Text(
                                    "فشل في تحميل البيانات",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextButton(
                                    onPressed: () => cubit.loadDropdowns(),
                                    child: const Text("إعادة المحاولة"),
                                  ),
                                ],
                              ),
                            );
                          }

                          // Build dropdowns from loaded data
                          final userItems = cubit.users;
                          final locationItems = cubit.locations;
                          final plantItems = cubit.treeNames;

                          return Column(
                            children: [
                              // اسم المستخدم والموقع Row
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildApiDropdown(
                                      label: "اسم المستخدم",
                                      allLabel: "كل المستخدمين",
                                      items: userItems,
                                      selectedItem: _selectedUser,
                                      onChanged: (val) {
                                        setState(() => _selectedUser = val);
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: _buildApiDropdown(
                                      label: "الموقع",
                                      allLabel: "كل المواقع",
                                      items: locationItems,
                                      selectedItem: _selectedLocation,
                                      onChanged: (val) {
                                        setState(
                                            () => _selectedLocation = val);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),

                              // اسم النبات
                              _buildApiDropdown(
                                label: "اسم النبات",
                                allLabel: "كل النباتات",
                                items: plantItems,
                                selectedItem: _selectedPlant,
                                onChanged: (val) {
                                  setState(() => _selectedPlant = val);
                                },
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 30),

                      // بحث البيانات Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _performSearch,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26),
                            ),
                            elevation: 0,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search, color: Colors.white, size: 20),
                              SizedBox(width: 8),
                              Text(
                                "بحث البيانات",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 35),

               
                   

                  
                const SizedBox(height: 25),

                // 3. Quick Tip Card
                const QuickTipCard(
                  tipText:
                      "يمكنك استخدام ميزة \"تصدير إلى إكسل\" من صفحة النتائج لحفظ التقارير على جهازك.",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

 
  /// Build a dropdown field for API-loaded data with an "all" option
  Widget _buildApiDropdown({
    required String label,
    required String allLabel,
    required List<DropdownItemModel> items,
    required DropdownItemModel? selectedItem,
    required ValueChanged<DropdownItemModel?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<DropdownItemModel?>(
              value: selectedItem,
              isExpanded: true,
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.black.withValues(alpha: 0.5),
              ),
              items: [
                // "All" option
                DropdownMenuItem<DropdownItemModel?>(
                  value: null,
                  child: Text(
                    allLabel,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.onSurface,
                    ),
                  ),
                ),
                // API items
                ...items.map((item) {
                  return DropdownMenuItem<DropdownItemModel?>(
                    value: item,
                    child: Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.onSurface,
                      ),
                    ),
                  );
                }),
              ],
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
