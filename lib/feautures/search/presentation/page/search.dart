import 'package:afforestation_app/core/styles/colors.dart';
import 'package:afforestation_app/feautures/search/presentation/widgets/quick_tip_card.dart';
import 'package:afforestation_app/feautures/search/presentation/widgets/search_date_field.dart';
import 'package:afforestation_app/feautures/search/presentation/widgets/search_dropdown_field.dart';
import 'package:afforestation_app/feautures/search/presentation/widgets/summary_card.dart';
import 'package:flutter/material.dart';
import 'search_results.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  DateTime? _startDate;
  DateTime? _endDate = DateTime(2026, 1, 24); // Mock default date: 24/01/2026

  String _selectedUser = "كل المستخدمين";
  String _selectedLocation = "كل المواقع";
  String _selectedPlant = "كل النباتات";

  final List<String> _usersList = ["كل المستخدمين", "أحمد", "سارة", "خالد", "مريم"];
  final List<String> _locationsList = ["كل المواقع", "موقع الشمال", "موقع الجنوب", "المنطقة الوسطى"];
  final List<String> _plantsList = ["كل النباتات", "شجرة السدر", "شجرة الغاف", "النخيل", "شجر السمر"];

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
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: AppColors.onSurface, size: 20),
              onPressed: () => Navigator.maybePop(context),
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
                child: const Icon(Icons.park_outlined, color: Colors.white, size: 20),
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
                    border: Border.all(color: Colors.black.withValues(alpha: 0.04)),
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
                            child: SearchDateField(
                              label: "من تاريخ",
                              value: _formatDate(_startDate),
                              onTap: () => _selectDate(context, true),
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

                      // اسم المستخدم والموقع Row
                      Row(
                        children: [
                          Expanded(
                            child: SearchDropdownField<String>(
                              label: "اسم المستخدم",
                              value: _selectedUser,
                              items: _usersList,
                              onChanged: (val) {
                                if (val != null) setState(() => _selectedUser = val);
                              },
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: SearchDropdownField<String>(
                              label: "الموقع",
                              value: _selectedLocation,
                              items: _locationsList,
                              onChanged: (val) {
                                if (val != null) setState(() => _selectedLocation = val);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // اسم النبات
                      SearchDropdownField<String>(
                        label: "اسم النبات",
                        value: _selectedPlant,
                        items: _plantsList,
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedPlant = val);
                        },
                      ),
                      const SizedBox(height: 30),

                      // بحث البيانات Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SearchResultsPage(),
                              ),
                            );
                          },
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

                // 2. Summary Section
                const Text(
                  "ملخص آخر 30 يوماً",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "نظرة عامة على أنشطة التشجير في الشهر الماضي",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 16),

                // Summary Stats Cards Row
                const Row(
                  children: [
                    Expanded(
                      child: SummaryCard(
                        title: "حسب اسم النبات",
                        value: "1,250",
                        icon: Icons.park_outlined,
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: SummaryCard(
                        title: "حسب نوع النبات",
                        value: "5,430",
                        icon: Icons.location_on_outlined,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),

                // 3. Quick Tip Card
                const QuickTipCard(
                  tipText: "يمكنك استخدام ميزة \"تصدير إلى إكسل\" من صفحة النتائج لحفظ التقارير على جهازك.",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
