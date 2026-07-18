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
    return BlocProvider(
      create: (context) => AddAfforestationCubit()..loadInitialData(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F9FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
                size: 18,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
          title: const Text(
            'إضافة عملية جديدة',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          leading: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.tune, color: Color(0xFF4CAF50), size: 20),
          ),
        ),
        body: BlocConsumer<AddAfforestationCubit, AddAfforestationState>(
          listener: (context, state) {
            if (state is AddAfforestationErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.message.isNotEmpty
                        ? state.message
                        : 'حدث خطأ غير متوقع',
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
                child: Directionality(
                  textDirection: TextDirection.rtl,
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
                        child: const Column(
                          children: [
                            Text(
                              'إضافة عملية تشجير جديدة',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'ADD A NEW AFFORESTATION OPERATION',
                              style: TextStyle(
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
                      _buildSectionHeader('بيانات النبات', Icons.eco_outlined),
                      const SizedBox(height: 12),
                      _buildLabel('نوع النبات'),
                      _buildGenericDropdownField<PlantTypesResponse>(
                        hint: '-- اختر النوع --',
                        value: cubit.selectedPlantType,
                        items: cubit.plantTypes,
                        getLabel: (item) => item.type ?? '',
                        onChanged: (val) => cubit.onPlantTypeChanged(val),
                      ),
                      const SizedBox(height: 16),
                      _buildLabel('اسم النبات'),
                      _buildGenericDropdownField<PlantNamesResponse>(
                        hint: isLoadingPlants
                            ? 'جاري تحميل أسماء النباتات...'
                            : '-- اختر اسم النبات --',
                        value: cubit.selectedPlantName,
                        items: cubit.plantNames,
                        getLabel: (item) => item.name ?? '',
                        onChanged: (val) => cubit.onPlantNameChanged(val),
                      ),

                      const SizedBox(height: 24),
                      const Divider(height: 1, color: Colors.black12),
                      const SizedBox(height: 20),

                      // Location Data Section
                      _buildSectionHeader(
                        'بيانات الموقع',
                        Icons.location_on_outlined,
                      ),
                      const SizedBox(height: 12),
                      _buildLabel('نوع الموقع'),
                      _buildGenericDropdownField<LocTypesResponse>(
                        hint: '-- اختر نوع الموقع --',
                        value: cubit.selectedLocationType,
                        items: cubit.locationTypes,
                        getLabel: (item) => item.locationType ?? '',
                        onChanged: (val) => cubit.onLocationTypeChanged(val),
                      ),
                      const SizedBox(height: 16),
                      _buildLabel('موقع الزراعة'),
                      _buildGenericDropdownField<LocNamesResponse>(
                        hint: isLoadingLocations
                            ? 'جاري تحميل المواقع...'
                            : '-- اختر العنوان المباشر --',
                        value: cubit.selectedLocationAddress,
                        items: cubit.locations,
                        getLabel: (item) => item.name ?? '',
                        onChanged: (val) => cubit.onLocationAddressChanged(val),
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
                                _buildLabel('تاريخ الزراعة'),
                                GestureDetector(
                                  onTap: _pickDate,
                                  child: AbsorbPointer(
                                    child: _buildTextField(
                                      controller: _dateController,
                                      icon: Icons.calendar_month_outlined,
                                      isReadOnly: true,
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
                                _buildLabel('عدد النباتات'),
                                _buildTextField(
                                  controller: _plantCountController,
                                  icon: Icons.unfold_more,
                                  isCenter: true,
                                  keyboardType: TextInputType.number,
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
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add,
                                      color: Colors.white, size: 20),
                                  SizedBox(width: 6),
                                  Text(
                                    'إضافة العملية',
                                    style: TextStyle(
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
                          color: const Color(0xFF56B76C).withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                const Color(0xFF56B76C).withValues(alpha: 0.15),
                          ),
                        ),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.tips_and_updates_outlined,
                              color: Color(0xFF56B76C),
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'نصيحة سريعة',
                                    style: TextStyle(
                                      color: Color(0xFF56B76C),
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'تأكد من اختيار نوع النبات المناسب للموقع الجغرافي لضمان نجاح عملية الاستزراع واستدامة الغطاء النباتي.',
                                    style: TextStyle(
                                      color: Colors.black54,
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
        Icon(icon, size: 18, color: const Color(0xFF56B76C)),
        const SizedBox(width: 6),
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

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, right: 4),
      child: Text(
        text,
        style: const TextStyle(color: Colors.black87, fontSize: 12),
      ),
    );
  }

  Widget _buildGenericDropdownField<T>({
    required String hint,
    required T? value,
    required List<T> items,
    required String Function(T) getLabel,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      dropdownColor: Colors.white,
      style: const TextStyle(color: Colors.black87, fontSize: 13),
      initialValue: value,
      hint: Text(
        hint,
        style: const TextStyle(fontSize: 12, color: Colors.black38),
      ),
      isExpanded: true,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black12),
        ),
      ),
      items: items
          .map(
            (e) => DropdownMenuItem<T>(
              value: e,
              child: Text(
                getLabel(e),
                style: const TextStyle(fontSize: 13, color: Colors.black87),
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    bool isReadOnly = false,
    bool isCenter = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: isReadOnly,
      keyboardType: keyboardType,
      textAlign: isCenter ? TextAlign.center : TextAlign.right,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        suffixIcon: Icon(icon, size: 18, color: Colors.black38),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black12),
        ),
      ),
    );
  }
}
