import 'package:afforestation_app/core/constants/app_assets.dart';
import 'package:afforestation_app/core/styles/colors.dart';
import 'package:afforestation_app/core/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddNewPlantScreen extends StatefulWidget {
  const AddNewPlantScreen({super.key});

  @override
  State<AddNewPlantScreen> createState() => _AddNewPlantScreenState();
}

class _AddNewPlantScreenState extends State<AddNewPlantScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _arabicNameController = TextEditingController();
  final TextEditingController _scientificNameController = TextEditingController();
  String? _selectedPlantType;

  final List<String> _plantTypes = ['أشجار', 'شجيرات', 'نباتات عشبية', 'متسلقات'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
            onPressed: () => Navigator.pop(context),
          ),
        ],
        title: Text(
          'إضافة نبات جديد',
          style: TextStyles.loginHeaderStyle.copyWith(color: AppColors.onSurface, fontSize: 18),
        ),
        centerTitle: true,
        leading: Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: SvgPicture.asset(
            AppAssets.bellsvg,
            colorFilter: const ColorFilter.mode(AppColors.onSecondary, BlendMode.srcIn),
            width: 20,
            height: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      child: SvgPicture.asset(
                        AppAssets.plantCropssvg,
                        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                        width: 32,
                        height: 32,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'إضافة نبات جديد',
                      style: TextStyles.loginHeaderStyle.copyWith(color: Colors.white, fontSize: 20),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'أدخل تفاصيل النبات بدقة في الحقول أدناه',
                      style: TextStyles.hintTextStyle.copyWith(color: Colors.white.withOpacity(0.8), fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

             
              Align(
                alignment: Alignment.centerRight,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('اسم النبات باللغة العربية', Icons.edit),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _arabicNameController,
                        hint: 'أدخل اسم النبات هنا...',
                      ),
                      const SizedBox(height: 20),
                      
                      _buildLabel('الاسم العلمي Scientific Name', Icons.language),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _scientificNameController,
                        hint: 'مثال: Acacia arabica...',
                        isEnglish: true,
                      ),
                      const SizedBox(height: 20),
                      
                      _buildLabel('اختر نوع النبتة', Icons.eco),
                      const SizedBox(height: 8),
                      _buildDropdownField(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_circle_outline, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      'إضافة النبات',
                      style: TextStyles.buttonTextStyle.copyWith(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              Text(
                '© 2026 - afforestationPlant',
                style: TextStyles.hintTextStyle.copyWith(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.onSurfaceVariant.withOpacity(0.6),
        currentIndex: 1,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'الإحصائيات',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AppAssets.treesvg,
              colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
              width: 24,
              height: 24,
            ),
            label: 'نباتاتنا',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'الرئيسية',
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyles.buttonTextStyle.copyWith(color: AppColors.onSurface, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool isEnglish = false,
  }) {
    return TextFormField(
      controller: controller,
      textAlign: isEnglish ? TextAlign.left : TextAlign.right,
      textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyles.hintTextStyle.copyWith(fontSize: 13),
        fillColor: AppColors.surface,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.tertiary.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.tertiary.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      value: _selectedPlantType,
      hint: Align(
        alignment: Alignment.centerRight,
        child: Text(
          '-- اضغط لاختيار النوع --',
          style: TextStyles.hintTextStyle.copyWith(fontSize: 13),
        ),
      ),
      isExpanded: true,
      alignment: Alignment.centerRight,
      decoration: InputDecoration(
        fillColor: AppColors.surface,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.tertiary.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.tertiary.withOpacity(0.2)),
        ),
      ),
      items: _plantTypes.map((String type) {
        return DropdownMenuItem<String>(
          value: type,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(type, style: TextStyles.buttonTextStyle.copyWith(fontSize: 14)),
          ),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _selectedPlantType = newValue;
        });
      },
    );
  }
}