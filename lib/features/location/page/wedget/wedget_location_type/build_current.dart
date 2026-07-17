import 'package:afforestation_app/features/location/cubit/location_type_cubit.dart';
import 'package:afforestation_app/features/location/cubit/location_cubit_state.dart/location_type_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class build_current_type_header extends StatelessWidget {
  const build_current_type_header({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BlocBuilder<LocationTypeCubit, LocationTypeState>(
          builder: (context, state) {
            int count = 0;
            if (state is GetLocationTypesSuccess) {
              count = state.locationTypes.length;
            }
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
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
        const Expanded(
          child: Center(
            child: Text(
              'الأنواع الحالية',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(width: 80), // To balance the center alignment
      ],
    );
  }
}
