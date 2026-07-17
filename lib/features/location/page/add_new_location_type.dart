import 'package:afforestation_app/features/dashboard/presentation/widgets/plant_bottom_nav_bar.dart';
import 'package:afforestation_app/features/location/wedget/wedget_location_type/build_add_new_card.dart';
import 'package:afforestation_app/features/location/wedget/wedget_location_type/build_app_bar.dart';
import 'package:afforestation_app/features/location/wedget/wedget_location_type/build_current.dart';
import 'package:afforestation_app/features/location/wedget/wedget_location_type/build_location_card.dart';
import 'package:afforestation_app/features/location/wedget/wedget_location_type/screen_title.dart';
import 'package:afforestation_app/features/location/cubit/location_type_cubit.dart';
import 'package:afforestation_app/features/location/cubit/location_cubit_state.dart/location_type_state.dart';
import 'package:afforestation_app/features/location/data/model/location_type_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocationTypesScreen extends StatelessWidget {
  const LocationTypesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocationTypeCubit()..fetchAllTypes(),
      child: BlocListener<LocationTypeCubit, LocationTypeState>(
        listenWhen: (previous, current) =>
            current is DeleteLocationTypeSuccess ||
            current is DeleteLocationTypeFailure ||
            current is EditLocationTypeSuccess ||
            current is EditLocationTypeFailure,
        listener: (context, state) {
          if (state is DeleteLocationTypeSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم حذف النوع بنجاح 🗑️'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is DeleteLocationTypeFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('عطل في الحذف: ${state.errorMessage}'),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is EditLocationTypeSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم تعديل النوع بنجاح ✏️'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is EditLocationTypeFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('عطل في التعديل: ${state.errorMessage}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                build_app_bar(),
                const Divider(height: 1, color: Color(0xFFE0E0E0)),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        screen_title(),
                        const SizedBox(height: 24),
                        const build_add_new_card(),
                        const SizedBox(height: 32),
                        build_current_type_header(),
                        const SizedBox(height: 16),

                        BlocBuilder<LocationTypeCubit, LocationTypeState>(
                          buildWhen: (previous, current) =>
                              current is GetLocationTypesLoading ||
                              current is GetLocationTypesSuccess ||
                              current is GetLocationTypesFailure,
                          builder: (context, state) {
                            if (state is GetLocationTypesLoading) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF68B258),
                                  ),
                                ),
                              );
                            } else if (state is GetLocationTypesFailure) {
                              return Center(
                                child: Text(
                                  'عطل في جلب البيانات: ${state.errorMessage}',
                                  style: const TextStyle(color: Colors.red),
                                ),
                              );
                            } else if (state is GetLocationTypesSuccess) {
                              final types = state.locationTypes;
                              if (types.isEmpty) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: Text('لا توجد أنواع مضافة حالياً.'),
                                  ),
                                );
                              }

                              return Column(
                                children: types.map((item) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 12.0,
                                    ),
                                    child: build_location_card(
                                      title: item.locationType ?? 'بدون اسم',
                                      date: item.createdAt ?? '17-07-2026',
                                      locationsCount: item.locationsCount ?? 0,
                                      progress: item.progress ?? 0.0,
                                      onEdit: () =>
                                          _showEditDialog(context, item),
                                      onDelete: () =>
                                          _confirmDelete(context, item),
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
          bottomNavigationBar: const PlantBottomNavigationBar(),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, LocationTypeModel item) {
    final cubit = context.read<LocationTypeCubit>();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text(
          'هل أنت متأكد من حذف "${item.locationType ?? 'هذا النوع'}"؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              if (item.id != null) {
                cubit.deleteType(item.id!);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تعذر الحذف: معرف غير متوفر')),
                );
              }
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, LocationTypeModel item) {
    final cubit = context.read<LocationTypeCubit>();
    final controller = TextEditingController(text: item.locationType);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('تعديل نوع الموقع'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'اسم نوع الموقع'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.dispose();
              Navigator.pop(dialogContext);
            },
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              final newName = controller.text.trim();
              controller.dispose();
              Navigator.pop(dialogContext);
              if (newName.isEmpty) return;
              if (item.id != null) {
                cubit.editType(item.id!, newName);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تعذر التعديل: معرف غير متوفر')),
                );
              }
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }
}
