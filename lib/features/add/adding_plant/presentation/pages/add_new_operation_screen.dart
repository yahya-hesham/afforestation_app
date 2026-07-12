import 'package:flutter/material.dart';

class AddNewOperationScreen extends StatefulWidget {
  const AddNewOperationScreen({super.key});

  @override
  State<AddNewOperationScreen> createState() => _AddNewOperationScreenState();
}

class _AddNewOperationScreenState extends State<AddNewOperationScreen> {
  final _formKey = GlobalKey<FormState>();
  
  String? _selectedPlantType;
  String? _selectedPlantName;
  String? _selectedLocationType;
  String? _selectedLocationAddress;
  final TextEditingController _plantCountController = TextEditingController(text: '0');
  final TextEditingController _dateController = TextEditingController(text: '2024-05-21');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, color: Colors.black, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
        ],
        title: const Text(
          'إضافة عملية جديدة',
          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // الكارت الأخضر العلوي
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF56B76C),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        'إضافة عملية تشجير جديدة',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'ADD A NEW AFFORESTATION OPERATION',
                        style: TextStyle(color: Colors.white70, fontSize: 10, letterSpacing: 0.5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // القسم الأول: بيانات النبات
                _buildSectionHeader('بيانات النبات', Icons.eco_outlined),
                const SizedBox(height: 12),
                _buildLabel('نوع النبات'),
                _buildDropdownField('-- اختر النوع --', _selectedPlantType, ['أشجار', 'شجيرات'], (val) => setState(() => _selectedPlantType = val)),
                const SizedBox(height: 16),
                _buildLabel('اسم النبات'),
                _buildDropdownField('-- اختر اسم النبات --', _selectedPlantName, ['جاكراندا', 'بونسيانا'], (val) => setState(() => _selectedPlantName = val)),
                
                const SizedBox(height: 24),
                const Divider(height: 1, color: Colors.black12),
                const SizedBox(height: 20),

                // القسم الثاني: بيانات الموقع
                _buildSectionHeader('بيانات الموقع', Icons.location_on_outlined),
                const SizedBox(height: 12),
                _buildLabel('نوع الموقع'),
                _buildDropdownField('-- اختر نوع الموقع --', _selectedLocationType, ['حديقة عامة', 'طريق رئيسي'], (val) => setState(() => _selectedLocationType = val)),
                const SizedBox(height: 16),
                _buildLabel('موقع الزراعة'),
                _buildDropdownField('-- اختر العنوان المباشر --', _selectedLocationAddress, ['المنطقة الشمالية', 'المنطقة الجنوبية'], (val) => setState(() => _selectedLocationAddress = val)),
                
                const SizedBox(height: 24),

                // صف (تاريخ الزراعة وعدد النباتات)
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('تاريخ الزراعة'),
                          _buildTextField(controller: _dateController, icon: Icons.calendar_month_outlined, isReadOnly: true),
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
                          _buildTextField(controller: _plantCountController, icon: Icons.unfold_more, isCenter: true),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // زرار إضافة العملية
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {}
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF56B76C),
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: Colors.white, size: 20),
                      SizedBox(width: 6),
                      Text(
                        'إضافة العملية',
                        style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // نصيحة سريعة
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF56B76C).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF56B76C).withOpacity(0.15)),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.tips_and_updates_outlined, color: Color(0xFF56B76C), size: 18),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('نصيحة سريعة', style: TextStyle(color: Color(0xFF56B76C), fontSize: 13, fontWeight: FontWeight.bold)),
                            SizedBox(height: 4),
                            Text(
                              'تأكد من اختيار نوع النبات المناسب للموقع الجغرافي لضمان نجاح عملية الاستزراع واستدامة الغطاء النباتي.',
                              style: TextStyle(color: Colors.black54, fontSize: 11, height: 1.4),
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
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF56B76C),
        unselectedItemColor: Colors.black26,
        currentIndex: 2,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'حسابي'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_none), label: 'الطلبات'),
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'الرئيسية'),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF56B76C)),
        const SizedBox(width: 6),
Text(title, style: const TextStyle(color: Color(0xFF56B76C), fontSize: 14, fontWeight: FontWeight.bold)),      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, right: 4),
      child: Text(text, style: const TextStyle(color: Colors.black87, fontSize: 12)),
    );
  }

  Widget _buildDropdownField(String hint, String? value, List<String> items, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      hint: Text(hint, style: const TextStyle(fontSize: 12, color: Colors.black38)),
      isExpanded: true,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black12)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black12)),
      ),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13)))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildTextField({required TextEditingController controller, required IconData icon, bool isReadOnly = false, bool isCenter = false}) {
    return TextFormField(
      controller: controller,
      readOnly: isReadOnly,
      textAlign: isCenter ? TextAlign.center : TextAlign.right,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        suffixIcon: Icon(icon, size: 18, color: Colors.black38),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black12)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black12)),
      ),
    );
  }
}