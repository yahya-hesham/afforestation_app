import 'package:afforestation_app/features/location/cubit/location_cubit_state.dart/location_type_state.dart';
import 'package:afforestation_app/features/location/cubit/location_type_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class build_current_types_header extends StatelessWidget {
  const build_current_types_header({super.key, required this.context});

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'الأنواع الحالية',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            BlocBuilder<LocationTypeCubit, LocationTypeState>(
              builder: (context, state) {
                int count = 0;
                if (state is GetLocationTypesSuccess) {
                  count = state.locationTypes.length;
                }
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F3E8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$count تصنيفات',
                    style: const TextStyle(
                      color: Color(0xFF68B258),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF68B258)),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.transparent,
                ),
                child: const Row(
                  children: [
                    Icon(Icons.add, size: 14, color: Color(0xFF68B258)),
                    SizedBox(width: 4),
                    Text(
                      'إضافة نوع جديد',
                      style: TextStyle(
                        color: Color(0xFF68B258),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
