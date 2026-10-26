import 'package:afforestation_app/core/functions/extenstion.dart';
import 'package:afforestation_app/core/styles/colors.dart';
import 'package:afforestation_app/features/add_affrostation/presentation/cubit/add_afforestation_cubit.dart';
import 'package:afforestation_app/features/add_affrostation/presentation/cubit/add_afforestation_state.dart';
import 'package:afforestation_app/features/dashboard/data/models/loc_names_response.dart';
import 'package:afforestation_app/features/dashboard/data/models/loc_types_response.dart';
import 'package:afforestation_app/features/dashboard/data/models/plant_names_response.dart';
import 'package:afforestation_app/features/dashboard/data/models/plant_types_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewOperationScreen extends StatefulWidget {
  const AddNewOperationScreen({super.key});

  @override
  State<AddNewOperationScreen> createState() => _AddNewOperationScreenState();
}

class _AddNewOperationScreenState extends State<AddNewOperationScreen> {
  final _formKey = GlobalKey<FormState>();

  DateTime _selectedDate = DateTime.now();
  late TextEditingController _dateController;
  final TextEditingController _plantCountController =
      TextEditingController(text: '1');

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController(text: _formatDate(_selectedDate));
  }

  @override
  void dispose() {
    _dateController.dispose();
    _plantCountController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = _formatDate(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg =
        isDark ? const Color(0xFF121212) : const Color(0xFFF7F9FA);
    final surfaceColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    return BlocProvider(
      create: (context) => AddAfforestationCubit()..loadInitialData(),
      child: Scaffold(
        backgroundColor: scaffoldBg,
        appBar: AppBar(
          backgroundColor: surfaceColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: isDark ? Colors.white : Colors.black,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'add_new_operation'.tr(),
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF4CAF50).withValues(alpha: 0.18)
                    : const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.tune, color: Color(0xFF4CAF50), size: 20),
            ),
          ],
        ),
        body: BlocConsumer<AddAfforestationCubit, AddAfforestationState>(
          listener: (context, state) {
            if (state is AddAfforestationErrorState) {
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
            } else if (state is AddAfforestationSubmitSuccessState) {
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
            final cubit = context.read<AddAfforestationCubit>();

            if (state is AddAfforestationLoadingInitialState) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF56B76C),
                ),
              );
            }

            final isSubmitting = state is AddAfforestationSubmittingState;
            final isLoadingPlants = state is AddAfforestationLoadingPlantsState;
            final isLoadingLocations =
                state is AddAfforestationLoadingLocationsState;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF56B76C),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'add_new_afforestation_header'.tr(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'add_new_afforestation_en_sub'.tr(),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Plant Data Section
                    _buildSectionHeader('plant_data'.tr(), Icons.eco_outlined),
                    const SizedBox(height: 12),
                    _buildLabel('plant_type'.tr(), textColor),
                    _buildGenericDropdownField<PlantTypesResponse>(
                      hint: 'select_type_hint'.tr(),
                      value: cubit.selectedPlantType,
                      items: cubit.plantTypes,
                      getLabel: (item) => item.type ?? '',
                      onChanged: (val) => cubit.onPlantTypeChanged(val),
                      isDark: isDark,
                      surfaceColor: surfaceColor,
                    ),
                    const SizedBox(height: 16),
                    _buildLabel('plant_name'.tr(), textColor),
                    _buildGenericDropdownField<PlantNamesResponse>(
                      hint: isLoadingPlants
                          ? 'loading_plants'.tr()
                          : 'select_plant_name_hint'.tr(),
                      value: cubit.selectedPlantName,
                      items: cubit.plantNames,
                      getLabel: (item) => item.name ?? '',
                      onChanged: (val) => cubit.onPlantNameChanged(val),
                      isDark: isDark,
                      surfaceColor: surfaceColor,
                    ),

                    const SizedBox(height: 24),
                    Divider(
                      height: 1,
                      color: isDark ? Colors.white12 : Colors.black12,
                    ),
                    const SizedBox(height: 20),

                    // Location Data Section
                    _buildSectionHeader(
                      'location_data'.tr(),
                      Icons.location_on_outlined,
                    ),
                    const SizedBox(height: 12),
                    _buildLabel('location_type'.tr(), textColor),
                    _buildGenericDropdownField<LocTypesResponse>(
                      hint: 'select_location_type_hint'.tr(),
                      value: cubit.selectedLocationType,
                      items: cubit.locationTypes,
                      getLabel: (item) => item.locationType ?? '',
                      onChanged: (val) => cubit.onLocationTypeChanged(val),
                      isDark: isDark,
                      surfaceColor: surfaceColor,
                    ),
                    const SizedBox(height: 16),
                    _buildLabel('planting_location'.tr(), textColor),
                    _buildGenericDropdownField<LocNamesResponse>(
                      hint: isLoadingLocations
                          ? 'loading_locations'.tr()
                          : 'select_address_hint'.tr(),
                      value: cubit.selectedLocationAddress,
                      items: cubit.locations,
                      getLabel: (item) => item.name ?? '',
                      onChanged: (val) =>
                          cubit.onLocationAddressChanged(val),
                      isDark: isDark,
                      surfaceColor: surfaceColor,
                    ),

                    const SizedBox(height: 24),

                    // Date and Count Row
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('planting_date'.tr(), textColor),
                              GestureDetector(
                                onTap: _pickDate,
                                child: AbsorbPointer(
                                  child: _buildTextField(
                                    controller: _dateController,
                                    icon: Icons.calendar_month_outlined,
                                    isReadOnly: true,
                                    isDark: isDark,
                                    surfaceColor: surfaceColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('plant_count'.tr(), textColor),
                              _buildTextField(
                                controller: _plantCountController,
                                icon: Icons.unfold_more,
                                isCenter: true,
                                keyboardType: TextInputType.number,
                                isDark: isDark,
                                surfaceColor: surfaceColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // Submit Button
                    ElevatedButton(
                      onPressed: isSubmitting
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                final number = int.tryParse(
                                        _plantCountController.text.trim()) ??
                                    0;
                                cubit.submit(
                                  dateOfPlanted: _selectedDate,
                                  number: number,
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF56B76C),
                        minimumSize: const Size(double.infinity, 52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isSubmitting
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.add,
                                    color: Colors.white, size: 20),
                                const SizedBox(width: 6),
                                Text(
                                  'btn_submit_operation'.tr(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                    ),
                    const SizedBox(height: 24),

                    // Tip box
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF56B76C).withValues(
                          alpha: isDark ? 0.15 : 0.08,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF56B76C).withValues(
                            alpha: isDark ? 0.3 : 0.15,
                          ),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.tips_and_updates_outlined,
                            color: Color(0xFF56B76C),
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'quick_tip_title'.tr(),
                                  style: const TextStyle(
                                    color: Color(0xFF56B76C),
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'add_operation_tip_content'.tr(),
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.black54,
                                    fontSize: 11,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF56B76C), size: 18),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF56B76C),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildGenericDropdownField<T>({
    required String hint,
    required T? value,
    required List<T> items,
    required String Function(T) getLabel,
    required void Function(T?) onChanged,
    required bool isDark,
    required Color surfaceColor,
  }) {
    final borderColor = isDark ? Colors.white12 : Colors.grey.shade300;
    final itemTextColor = isDark ? Colors.white : Colors.black87;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: items.contains(value) ? value : null,
          hint: Text(
            hint,
            style: TextStyle(
              color: isDark ? Colors.white38 : Colors.grey.shade500,
              fontSize: 13,
            ),
          ),
          dropdownColor: surfaceColor,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: isDark ? Colors.white54 : Colors.grey.shade600,
          ),
          items: items.map((T item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(
                getLabel(item),
                style: TextStyle(fontSize: 13, color: itemTextColor),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    bool isReadOnly = false,
    bool isCenter = false,
    TextInputType keyboardType = TextInputType.text,
    required bool isDark,
    required Color surfaceColor,
    TextAlign textAlign = TextAlign.start,
  }) {
    final borderColor = isDark ? Colors.white12 : Colors.grey.shade300;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: TextFormField(
        controller: controller,
        readOnly: isReadOnly,
        textAlign: isCenter ? TextAlign.center : textAlign,
        keyboardType: keyboardType,
        style: TextStyle(
          color: textColor,
          fontSize: 13,
          fontWeight: isCenter ? FontWeight.bold : FontWeight.normal,
        ),
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          border: InputBorder.none,
          prefixIcon: Icon(
            icon,
            color: isDark ? Colors.white54 : Colors.grey.shade600,
            size: 18,
          ),
        ),
      ),
    );
  }
}
