import 'package:afforestation_app/features/location/cubit/location_cubit.dart';
import 'package:afforestation_app/features/location/cubit/location_cubit_state.dart/location_state.dart';
import 'package:afforestation_app/features/location/cubit/location_cubit_state.dart/location_type_state.dart';
import 'package:afforestation_app/features/location/cubit/location_type_cubit.dart';
import 'package:afforestation_app/features/location/data/model/location_model.dart';
import 'package:afforestation_app/features/location/data/model/location_type_model.dart';
import 'package:afforestation_app/features/location/wedget/add_location/build_current_types_header.dart';
import 'package:afforestation_app/features/location/wedget/wedget_location_type/build_app_bar.dart';
import 'package:afforestation_app/features/location/wedget/wedget_location_type/build_location_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocationDetailsScreen extends StatefulWidget {
  const LocationDetailsScreen({super.key});

  @override
  State<LocationDetailsScreen> createState() => _LocationDetailsScreenState();
}

class _LocationDetailsScreenState extends State<LocationDetailsScreen> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _latController = TextEditingController();
  final _longController = TextEditingController();
  final _notesController = TextEditingController();
  int? _selectedLocationTypeId;

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _latController.dispose();
    _longController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LocationTypeCubit()..fetchAllTypes()),
        BlocProvider(create: (context) => LocationCubit()),
      ],
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const build_app_bar(),
              const Divider(height: 1, color: Color(0xFFE0E0E0)),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildScreenTitles(),
                      const SizedBox(height: 24),
                      _buildAddLocationForm(),
                      const SizedBox(height: 32),
                      build_current_types_header(context: context),
                      const SizedBox(height: 16),

                      BlocBuilder<LocationTypeCubit, LocationTypeState>(
                        buildWhen: (previous, current) =>
                            current is GetLocationTypesLoading ||
                            current is GetLocationTypesSuccess ||
                            current is GetLocationTypesFailure,
                        builder: (context, state) {
                          if (state is GetLocationTypesLoading) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF68B258),
                              ),
                            );
                          } else if (state is GetLocationTypesFailure) {
                            return Center(
                              child: Text(
                                'عطل في تحميل الأنواع: ${state.errorMessage}',
                                style: const TextStyle(color: Colors.red),
                              ),
                            );
                          } else if (state is GetLocationTypesSuccess) {
                            final types = state.locationTypes;
                            if (types.isEmpty) {
                              return const Center(
                                child: Text('لا توجد أنواع حالية'),
                              );
                            }
                            return Column(
                              children: types.map((item) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12.0),
                                  child: build_location_card(
                                    title: item.locationType ?? 'بدون اسم',
                                    date: item.createdAt ?? '17-07-2026',
                                    locationsCount: item.locationsCount ?? 0,
                                    progress: item.progress ?? 0.0,
                                  ),
                                );
                              }).toList(),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScreenTitles() {
    return const Column(
      children: [
        Center(
          child: Text(
            'تخصيص المواقع',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 8),
        Center(
          child: Text(
            'قم بإضافة وتصنيف أنواع المواقع لتنظيم عمليات التشجير.',
            style: TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildAddLocationForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'إضافة موقع جديد',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    'أدخل تفاصيل الموقع الجديد في النظام',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              const CircleAvatar(
                backgroundColor: Color(0xFF68B258),
                radius: 20,
                child: Icon(Icons.add, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 24),

          _buildFieldLabel('اسم الموقع'),
          _buildTextField(
            hint: 'مثال: مشتل الرياض الرئيسي',
            controller: _nameController,
          ),

          const SizedBox(height: 16),
          _buildFieldLabel('نوع الموقع'),

          BlocBuilder<LocationTypeCubit, LocationTypeState>(
            builder: (context, state) {
              List<LocationTypeModel> types = [];
              bool isLoading = state is GetLocationTypesLoading;
              String? errorMessage;

              if (state is GetLocationTypesSuccess) {
                types = state.locationTypes;
              } else if (state is GetLocationTypesFailure) {
                errorMessage = state.errorMessage;
              }

              return _buildDropdownField(
                types,
                isLoading: isLoading,
                errorMessage: errorMessage,
              );
            },
          ),

          const SizedBox(height: 16),
          _buildFieldLabel('العنوان'),
          _buildTextField(
            hint: 'الحي، الشارع، رقم المبنى',
            prefixIcon: Icons.location_on_outlined,
            controller: _addressController,
          ),

          const SizedBox(height: 16),
          _buildFieldLabel('الإحداثيات'),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  hint: 'خط العرض (Latitude)',
                  textAlign: TextAlign.start,
                  controller: _latController,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  hint: 'خط الطول (Longitude)',
                  textAlign: TextAlign.start,
                  controller: _longController,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          _buildFieldLabel('ملاحظات'),
          _buildTextField(
            hint: 'أي معلومات إضافية عن الموقع...',
            maxLines: 4,
            controller: _notesController,
          ),

          const SizedBox(height: 24),

          BlocConsumer<LocationCubit, LocationState>(
            listener: (context, state) {
              if (state is AddLocationSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم إضافة الموقع بنجاح! 🌴'),
                    backgroundColor: Colors.green,
                  ),
                );
                _nameController.clear();
                _addressController.clear();
                _latController.clear();
                _longController.clear();
                _notesController.clear();
                setState(() {
                  _selectedLocationTypeId = null;
                });
              } else if (state is AddLocationFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('عطل في إضافة الموقع: ${state.errorMessage}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is AddLocationLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF68B258)),
                );
              }

              return SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    final name = _nameController.text.trim();
                    final address = _addressController.text.trim();
                    final latStr = _latController.text.trim();
                    final longStr = _longController.text.trim();
                    final notes = _notesController.text.trim();

                    if (name.isEmpty ||
                        address.isEmpty ||
                        latStr.isEmpty ||
                        longStr.isEmpty ||
                        _selectedLocationTypeId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'برجاء ملء جميع الحقول المطلوبة واختيار النوع',
                          ),
                        ),
                      );
                      return;
                    }

                    final lat = double.tryParse(latStr);
                    final long = double.tryParse(longStr);

                    if (lat == null || long == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('برجاء إدخال إحداثيات صحيحة'),
                        ),
                      );
                      return;
                    }

                    final newLocation = LocationModel(
                      name: name,
                      locationTypeId: _selectedLocationTypeId!,
                      address: address,
                      latitude: lat,
                      longitude: long,
                      notes: notes,
                    );

                    context.read<LocationCubit>().addNewLocation(newLocation);
                  },
                  icon: const Icon(Icons.add, color: Colors.white, size: 20),
                  label: const Text(
                    'إضافة الموقع',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF68B258),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, right: 4.0),
      child: Text(
        label,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required TextEditingController controller,
    IconData? prefixIcon,
    int maxLines = 1,
    TextAlign textAlign = TextAlign.start,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      textAlign: textAlign,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 13),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: Colors.grey.shade400)
            : null,
        filled: true,
        fillColor: const Color(0xFFF9FDF9),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFF68B258)),
        ),
      ),
    );
  }

  Widget _buildDropdownField(
    List<LocationTypeModel> types, {
    bool isLoading = false,
    String? errorMessage,
  }) {
    String hintText = 'اختر نوع الموقع';
    if (isLoading) {
      hintText = 'جاري تحميل الأنواع من السيرفر... 🔄';
    } else if (errorMessage != null) {
      hintText = 'عطل في التحميل! اسحب لتحديث الصفحة ⚠️';
    } else if (types.isEmpty) {
      hintText = 'لا توجد أنواع حالية، أضف نوعاً أولاً';
    }

    return DropdownButtonFormField<int>(
      value: _selectedLocationTypeId,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF9FDF9),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      icon: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFF68B258),
              ),
            )
          : const Icon(Icons.keyboard_arrow_down, color: Colors.black87),
      hint: Text(
        hintText,
        style: TextStyle(
          color: errorMessage != null
              ? Colors.red.shade400
              : Colors.grey.shade500,
          fontSize: 13,
        ),
      ),
      items: (isLoading || types.isEmpty)
          ? null
          : types
                .map(
                  (type) => DropdownMenuItem<int>(
                    value: type.id,
                    child: Text(type.locationType ?? ''),
                  ),
                )
                .toList(),
      onChanged: (isLoading || types.isEmpty)
          ? null
          : (value) {
              setState(() {
                _selectedLocationTypeId = value;
              });
            },
    );
  }
}
