import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF68B258),
        scaffoldBackgroundColor: const Color(0xFFF5FAF5),
        fontFamily: 'Cairo',
      ),
      builder: (context, child) {
        return Directionality(textDirection: TextDirection.rtl, child: child!);
      },
      home: const LocationDetailsScreen(),
    );
  }
}

class LocationDetailsScreen extends StatelessWidget {
  const LocationDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
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
                    _buildCurrentTypesHeader(),
                    const SizedBox(height: 16),
                    _buildLocationCard(
                      title: 'مشاتل مركزية',
                      date: '01-10-2023',
                      locationsCount: 12,
                      progress: 0.3,
                    ),
                    const SizedBox(height: 12),
                    _buildLocationCard(
                      title: 'طرق سريعة',
                      date: '05-10-2023',
                      locationsCount: 45,
                      progress: 0.8,
                    ),
                    const SizedBox(height: 12),
                    _buildLocationCard(
                      title: 'حدائق عامة',
                      date: '12-10-2023',
                      locationsCount: 8,
                      progress: 0.2,
                    ),
                    const SizedBox(height: 12),
                    _buildLocationCard(
                      title: 'مزارع خاصة',
                      date: '15-10-2023',
                      locationsCount: 23,
                      progress: 0.45,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFF68B258),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.eco_outlined,
              color: Colors.white,
              size: 24,
            ),
          ),
          const Text(
            'إدارة أنواع المواقع',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Icon(Icons.chevron_left, size: 30),
        ],
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
          // عنوان الكارد
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

          // الحقول النصية
          _buildFieldLabel('اسم الموقع'),
          _buildTextField(hint: 'مثال: مشتل الرياض الرئيسي'),

          const SizedBox(height: 16),
          _buildFieldLabel('نوع الموقع'),
          _buildDropdownField(),

          const SizedBox(height: 16),
          _buildFieldLabel('العنوان'),
          _buildTextField(
            hint: 'الحي، الشارع، رقم المبنى',
            prefixIcon: Icons.location_on_outlined,
          ),

          const SizedBox(height: 16),
          _buildFieldLabel('الإحداثيات'),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  hint: 'خط العرض (Latitude)',
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  hint: 'خط الطول (Longitude)',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          _buildFieldLabel('ملاحظات'),
          _buildTextField(hint: 'أي معلومات إضافية عن الموقع...', maxLines: 4),

          const SizedBox(height: 24),

          // زر الحفظ
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
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
    IconData? prefixIcon,
    int maxLines = 1,
    TextAlign textAlign = TextAlign.start,
  }) {
    return TextField(
      maxLines: maxLines,
      textAlign: textAlign,
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

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
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
      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black87),
      hint: Text(
        'اختر نوع الموقع',
        style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
      ),
      items: ['مشاتل مركزية', 'طرق سريعة', 'حدائق عامة', 'مزارع خاصة']
          .map((type) => DropdownMenuItem(value: type, child: Text(type)))
          .toList(),
      onChanged: (value) {},
    );
  }

  Widget _buildCurrentTypesHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'الأنواع الحالية',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F3E8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '4 تصنيفات',
                style: TextStyle(
                  color: Color(0xFF68B258),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
          ],
        ),
      ],
    );
  }

  Widget _buildLocationCard({
    required String title,
    required String date,
    required int locationsCount,
    required double progress,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F7F0),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.grid_view_rounded,
                  color: Color(0xFF68B258),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'تاريخ الإنشاء: $date',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              CircleAvatar(
                backgroundColor: Colors.grey.shade100,
                radius: 18,
                child: Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(width: 8),
              const CircleAvatar(
                backgroundColor: Color(0xFFFFF0F0),
                radius: 18,
                child: Icon(
                  Icons.delete_outline,
                  size: 18,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'الاستخدام:',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF68B258),
                    ),
                    minHeight: 6,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$locationsCount موقع',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
