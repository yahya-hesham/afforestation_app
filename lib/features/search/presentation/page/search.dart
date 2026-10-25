import 'package:afforestation_app/core/functions/extenstion.dart';
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
    if (!cubit.areDropdownsLoaded) {
      cubit.loadDropdowns();
    }
    if (!cubit.isSummaryLoaded) {
      cubit.loadLast30DaysSummary();
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: isDark
              ? Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.dark(
                    primary: AppColors.secondary,
                    onPrimary: Colors.white,
                    surface: Color(0xFF1E1E1E),
                    onSurface: Colors.white,
                  ),
                  dialogBackgroundColor: const Color(0xFF1E1E1E),
                )
              : Theme.of(context).copyWith(
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
    if (_startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("search_start_date_required".tr()),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final searchCubit = context.read<SearchCubit>();

    searchCubit.fromDate = _startDate;
    searchCubit.toDate = _endDate;
    searchCubit.selectedUserId = _selectedUser?.id;
    searchCubit.selectedLocationId = _selectedLocation?.id;
    searchCubit.selectedTreeId = _selectedPlant?.id;

    searchCubit.search();

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg = isDark ? const Color(0xFF121212) : AppColors.background;
    final surfaceColor = isDark ? const Color(0xFF1E1E1E) : AppColors.surface;
    final textColor = isDark ? Colors.white : AppColors.onSurface;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: textColor, size: 20),
            onPressed: () {
              if (widget.onBackToHome != null) {
                widget.onBackToHome!();
              } else {
                Navigator.maybePop(context);
              }
            },
          ),
          title: Text(
            "btn_advanced_search".tr(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          centerTitle: true,
          actions: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
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
      body: SafeArea(
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
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDark
                        ? Colors.white12
                        : Colors.black.withValues(alpha: 0.04),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.2 : 0.02,
                      ),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      "search_afforestation_data".tr(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? const Color(0xFF81C784)
                            : AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "filter_by_date_user_location".tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white60 : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Dates row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SearchDateField(
                                label: "from_date_label".tr(),
                                value: _formatDate(_startDate),
                                onTap: () => _selectDate(context, true),
                              ),
                              if (_startDate == null)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 4,
                                    right: 4,
                                  ),
                                  child: Text(
                                    "required".tr(),
                                    style: const TextStyle(
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
                            label: "to_date_label".tr(),
                            value: _formatDate(_endDate),
                            onTap: () => _selectDate(context, false),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Dropdowns
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
                                const Icon(
                                  Icons.error_outline,
                                  color: Colors.redAccent,
                                  size: 28,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "failed_to_load_data".tr(),
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isDark
                                        ? Colors.white60
                                        : Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextButton(
                                  onPressed: () => cubit.loadDropdowns(),
                                  child: Text("retry".tr()),
                                ),
                              ],
                            ),
                          );
                        }

                        final userItems = cubit.users;
                        final locationItems = cubit.locations;
                        final plantItems = cubit.treeNames;

                        return Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _buildApiDropdown(
                                    label: "user_name".tr(),
                                    allLabel: "all_users".tr(),
                                    items: userItems,
                                    selectedItem: _selectedUser,
                                    isDark: isDark,
                                    textColor: textColor,
                                    onChanged: (val) {
                                      setState(() => _selectedUser = val);
                                    },
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: _buildApiDropdown(
                                    label: "location".tr(),
                                    allLabel: "all_locations_dropdown".tr(),
                                    items: locationItems,
                                    selectedItem: _selectedLocation,
                                    isDark: isDark,
                                    textColor: textColor,
                                    onChanged: (val) {
                                      setState(() => _selectedLocation = val);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            _buildApiDropdown(
                              label: "plant_name".tr(),
                              allLabel: "all_plants_dropdown".tr(),
                              items: plantItems,
                              selectedItem: _selectedPlant,
                              isDark: isDark,
                              textColor: textColor,
                              onChanged: (val) {
                                setState(() => _selectedPlant = val);
                              },
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 30),

                    // Submit button
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.search,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "btn_search_data".tr(),
                              style: const TextStyle(
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
              const SizedBox(height: 20),

              // 2. Tip Box
              QuickTipCard(tipText: "export_excel_tip".tr()),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildApiDropdown({
  required String label,
  required String allLabel,
  required List<DropdownItemModel> items,
  required DropdownItemModel? selectedItem,
  required ValueChanged<DropdownItemModel?> onChanged,
  required bool isDark,
  required Color textColor,
}) {
  final borderColor = isDark ? Colors.white12 : Colors.grey.shade300;
  final dropdownBg = isDark ? const Color(0xFF2C2C2C) : Colors.white;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
      const SizedBox(height: 8),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: dropdownBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<DropdownItemModel?>(
            value: selectedItem,
            isExpanded: true,
            dropdownColor: dropdownBg,
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: isDark ? Colors.white54 : Colors.grey.shade600,
            ),
            items: [
              DropdownMenuItem<DropdownItemModel?>(
                value: null,
                child: Text(
                  allLabel,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
              ),
              ...items.map(
                (item) => DropdownMenuItem<DropdownItemModel?>(
                  value: item,
                  child: Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ),
            ],
            onChanged: onChanged,
          ),
        ),
      ),
    ],
  );
}
