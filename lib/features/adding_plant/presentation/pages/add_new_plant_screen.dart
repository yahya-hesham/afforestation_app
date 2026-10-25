import 'package:afforestation_app/core/constants/app_assets.dart';
import 'package:afforestation_app/core/functions/extenstion.dart';
import 'package:afforestation_app/core/styles/colors.dart';
import 'package:afforestation_app/core/styles/text_styles.dart';
import 'package:afforestation_app/features/adding_plant/presentation/cubit/add_plant_cubit.dart';
import 'package:afforestation_app/features/adding_plant/presentation/cubit/add_plant_state.dart';
import 'package:afforestation_app/features/dashboard/data/models/plant_types_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddNewPlantScreen extends StatefulWidget {
  const AddNewPlantScreen({super.key});

  @override
  State<AddNewPlantScreen> createState() => _AddNewPlantScreenState();
}

class _AddNewPlantScreenState extends State<AddNewPlantScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _arabicNameController = TextEditingController();
  final TextEditingController _scientificNameController =
      TextEditingController();
  PlantTypesResponse? _selectedType;

  @override
  void dispose() {
    _arabicNameController.dispose();
    _scientificNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg = isDark ? const Color(0xFF121212) : AppColors.background;
    final surfaceColor = isDark ? const Color(0xFF1E1E1E) : AppColors.surface;

    return BlocProvider(
      create: (context) => AddPlantCubit()..fetchPlantTypes(),
      child: Scaffold(
        backgroundColor: scaffoldBg,
        appBar: AppBar(
          backgroundColor: surfaceColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: isDark ? Colors.white : AppColors.onSurface,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'add_new_plant_header'.tr(),
            style: TextStyles.loginHeaderStyle.copyWith(
              color: isDark ? Colors.white : AppColors.onSurface,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
          actions: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SvgPicture.asset(
                AppAssets.bellsvg,
                colorFilter: const ColorFilter.mode(
                  AppColors.onSecondary,
                  BlendMode.srcIn,
                ),
                width: 20,
                height: 20,
              ),
            ),
          ],
        ),
        body: BlocConsumer<AddPlantCubit, AddPlantState>(
          listener: (context, state) {
            if (state is AddPlantErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.message.isNotEmpty
                        ? state.message
                        : 'unexpected_error'.tr(),
                  ),
                  backgroundColor: AppColors.error,
                ),
              );
            } else if (state is AddPlantSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: const Color(0xFF56B76C),
                ),
              );
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            final cubit = context.read<AddPlantCubit>();
            final isLoadingTypes = state is AddPlantLoadingTypesState;
            final isSubmitting = state is AddPlantSubmittingState;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 24,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor:
                                Colors.white.withValues(alpha: 0.2),
                            child: SvgPicture.asset(
                              AppAssets.plantCropssvg,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                              width: 32,
                              height: 32,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'add_new_plant_header'.tr(),
                            style: TextStyles.loginHeaderStyle.copyWith(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'add_plant_instructions'.tr(),
                            style: TextStyles.hintTextStyle.copyWith(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel(
                          'plant_name_arabic'.tr(),
                          Icons.edit,
                          isDark,
                        ),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: _arabicNameController,
                          hint: 'plant_name_arabic_hint'.tr(),
                          isDark: isDark,
                          surfaceColor: surfaceColor,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'plant_name_is_required'.tr();
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        _buildLabel(
                          'scientific_name_label'.tr(),
                          Icons.language,
                          isDark,
                        ),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: _scientificNameController,
                          hint: 'scientific_name_hint'.tr(),
                          isEnglish: true,
                          isDark: isDark,
                          surfaceColor: surfaceColor,
                        ),
                        const SizedBox(height: 20),

                        _buildLabel(
                          'choose_plant_type'.tr(),
                          Icons.forest_outlined,
                          isDark,
                        ),
                        const SizedBox(height: 8),
                        _buildDropdownField(
                          cubit: cubit,
                          isLoading: isLoadingTypes,
                          isDark: isDark,
                          surfaceColor: surfaceColor,
                        ),
                        const SizedBox(height: 32),

                        ElevatedButton(
                          onPressed: isSubmitting
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    if (_selectedType == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'please_choose_plant_type'.tr(),
                                          ),
                                          backgroundColor: AppColors.error,
                                        ),
                                      );
                                      return;
                                    }
                                    cubit.addPlant(
                                      arabicName:
                                          _arabicNameController.text.trim(),
                                      scientificName:
                                          _scientificNameController.text
                                              .trim(),
                                    );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                            minimumSize: const Size(double.infinity, 52),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: isSubmitting
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  'btn_add_plant_submit'.tr(),
                                  style: TextStyles.buttonTextStyle.copyWith(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: Directionality(
          textDirection: TextDirection.rtl,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: surfaceColor,
            selectedItemColor:
                isDark ? const Color(0xFF81C784) : AppColors.primary,
            unselectedItemColor: isDark ? Colors.white60 : Colors.grey,
            currentIndex: 1,
            onTap: (index) {
              if (index == 0) Navigator.pop(context);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'الرئيسية',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.forest),
                label: 'نباتاتنا',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, IconData icon, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.secondary),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyles.screenHeaderTitleStyle.copyWith(
            fontSize: 13,
            color: isDark ? Colors.white : AppColors.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool isEnglish = false,
    String? Function(String?)? validator,
    required bool isDark,
    required Color surfaceColor,
  }) {
    return TextFormField(
      controller: controller,
      textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
      textAlign: isEnglish ? TextAlign.left : TextAlign.right,
      validator: validator,
      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyles.hintTextStyle.copyWith(
          color: isDark ? Colors.white38 : Colors.grey.shade400,
          fontSize: 13,
        ),
        filled: true,
        fillColor: surfaceColor,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: isDark ? Colors.white12 : Colors.grey.shade300,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: isDark ? Colors.white12 : Colors.grey.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required AddPlantCubit cubit,
    required bool isLoading,
    required bool isDark,
    required Color surfaceColor,
  }) {
    final textColor = isDark ? Colors.white : Colors.black87;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.grey.shade300,
        ),
      ),
      child: isLoading
          ? Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: const Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'جاري تحميل أنواع النباتات...',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            )
          : DropdownButtonHideUnderline(
              child: DropdownButton<PlantTypesResponse>(
                value: _selectedType,
                hint: Text(
                  '-- اضغط لاختيار النوع --',
                  style: TextStyle(
                    color: isDark ? Colors.white38 : Colors.grey.shade400,
                    fontSize: 13,
                  ),
                ),
                dropdownColor: surfaceColor,
                isExpanded: true,
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey,
                ),
                items: cubit.plantTypes.map((PlantTypesResponse type) {
                  return DropdownMenuItem<PlantTypesResponse>(
                    value: type,
                    child: Text(
                      type.type ?? '',
                      style: TextStyle(
                        fontSize: 13,
                        color: textColor,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (PlantTypesResponse? value) {
                  setState(() => _selectedType = value);
                  cubit.onPlantTypeChanged(value);
                },
              ),
            ),
    );
  }
}
