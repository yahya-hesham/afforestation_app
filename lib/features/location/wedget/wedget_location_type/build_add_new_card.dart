import 'package:afforestation_app/features/location/page/add_new_location.dart';
import 'package:afforestation_app/features/location/cubit/location_type_cubit.dart';
import 'package:afforestation_app/features/location/cubit/location_cubit_state.dart/location_type_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class build_add_new_card extends StatefulWidget {
  const build_add_new_card({super.key});

  @override
  State<build_add_new_card> createState() => _build_add_new_cardState();
}

class _build_add_new_cardState extends State<build_add_new_card> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    'إضافة نوع جديد',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    'أدخل مسمى التصنيف الجديد للموقع',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LocationDetailsScreen(),
                    ),
                  );
                },
                child: const CircleAvatar(
                  backgroundColor: Color(0xFF68B258),
                  radius: 20,
                  child: Icon(Icons.add, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text('اسم نوع الموقع', style: TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'مثال: محميات طبيعية...',
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              prefixIcon: const Icon(
                Icons.location_on_outlined,
                color: Colors.grey,
              ),
              filled: true,
              fillColor: const Color(0xFFF9FDF9),
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
            ),
          ),
          const SizedBox(height: 16),

          BlocConsumer<LocationTypeCubit, LocationTypeState>(
            listener: (context, state) {
              if (state is AddLocationTypeSuccess) {
                _controller.clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم إضافة نوع الموقع بنجاح! 🎉'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else if (state is AddLocationTypeFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('عطل في الحفظ: ${state.errorMessage}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is AddLocationTypeLoading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: CircularProgressIndicator(color: Color(0xFF68B258)),
                  ),
                );
              }

              return SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    final text = _controller.text.trim();
                    if (text.isNotEmpty) {
                      context.read<LocationTypeCubit>().addNewType(text);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('من فضلك ادخل اسم النوع أولاً'),
                        ),
                      );
                    }
                  },
                  icon: const Icon(
                    Icons.check_circle_outline,
                    color: Colors.white,
                    size: 20,
                  ),
                  label: const Text(
                    'حفظ وإضافة النوع',
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
}
