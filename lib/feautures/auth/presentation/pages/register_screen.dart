import 'package:bookia/core/styles/colors.dart';
import 'package:bookia/core/styles/text_styles.dart';
import 'package:bookia/core/widgets/build_field_label.dart';
import 'package:bookia/core/widgets/custom_textForm_field.dart';
import 'package:flutter/material.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // States

  String _selectedRole = 'مستخدم عادي (User)';

  // Dropdown options
  final List<String> _roles = ['مستخدم عادي (User)', 'مستخدم مسؤول (Admin)'];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.onSurface,
            size: 20,
          ),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text(
          'إضافة مستخدم جديد',
          style: TextStyles.loginHeaderStyle.copyWith(
            color: AppColors.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Green Header Card Section
                  Container(
                    width: double.infinity,
                    color: AppColors.secondary,
                    padding: const EdgeInsets.symmetric(
                      vertical: 28.0,
                      horizontal: 16.0,
                    ),
                    child: Column(
                      children: [
                        Text(
                          'إنشاء حساب جديد',
                          style: TextStyles.loginHeaderStyle.copyWith(
                            color: AppColors.onSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'قم بإنشاء حساب جديد للانضمام إلى نظام التشجير',
                          style: TextStyles.footerTextTextStyle.copyWith(
                            color: AppColors.onSecondary,
                          ),
                          //textAlign: ,
                        ),
                      ],
                    ),
                  ),

                  // Form Fields Content
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- Name Field ---
                        BuiledFieldLabel(
                          labelText: 'الاسم الكامل',
                          icon: Icons.person_outline,
                        ),
                        const SizedBox(height: 8),
                        CustomTextFormField(
                          controller: _nameController,
                          hintText: '...أدخل الاسم الكامل',
                        ),
                        // TextFormField(
                        //   controller: _nameController,
                        //   style: TextStyles.hintTextStyle.copyWith(color: AppColors.onSurface, fontSize: 16),
                        //   decoration: _buildInputDecoration(hintText: '...أدخل الاسم الكامل'),
                        // ),
                        const SizedBox(height: 20),

                        // --- Email Field ---
                        BuiledFieldLabel(
                          labelText: 'البريد الإلكتروني',
                          icon: Icons.mail_outline,
                        ),
                        const SizedBox(height: 8),
                        CustomTextFormField(
                          controller: _emailController,
                          hintText: 'example@domain.com',
                        ),

                        // TextFormField(
                        //   controller: _emailController,
                        //   keyboardType: TextInputType.emailAddress,
                        //   style: TextStyles.hintTextStyle.copyWith(color: AppColors.onSurface, fontSize: 16),
                        //   // Simulated Error State border based on UI screenshot
                        //   decoration: _buildInputDecoration(
                        //     hintText: 'example@domain.com',
                        //     hasError: true,
                        //   ),
                        // ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Text(
                            'البريد الإلكتروني مطلوب',
                            style: TextStyles.errorTextStyle.copyWith(
                              color: AppColors.error,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // --- Password Field ---
                        BuiledFieldLabel(
                          labelText: 'كلمة المرور',
                          icon: Icons.lock_outline,
                        ),
                        const SizedBox(height: 8),
                        CustomTextFormField(
                          controller: _passwordController,
                          hintText: '••••••••',
                          isPassword: true,
                        ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),

                          child: Text(
                            'كلمة المرور مطلوبة',
                            style: TextStyles.errorTextStyle.copyWith(
                              color: AppColors.error,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // --- Role Dropdown ---
                        BuiledFieldLabel(
                          labelText: 'اختر الدور الوظيفي',
                          icon: Icons.shield_outlined,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(
                              color: AppColors.tertiary.withOpacity(0.3),
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedRole,
                              isExpanded: true,
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: AppColors.onSurface,
                              ),
                              items: _roles.map((String role) {
                                return DropdownMenuItem<String>(
                                  value: role,
                                  child: Text(
                                    role,
                                    style: TextStyles.hintTextStyle.copyWith(
                                      color: AppColors.onSurface,
                                      fontSize: 15,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    _selectedRole = newValue;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // --- Submit Button ---
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // Implement your add user action here
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secondary,
                              foregroundColor: AppColors.onSecondary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              elevation: 0,
                            ),
                            icon: const Icon(
                              Icons.person_add_alt_1_outlined,
                              size: 22,
                            ),
                            label: Text(
                              'تسجيل الحساب الجديد',
                              style: TextStyles.buttonTextStyle.copyWith(
                                color: AppColors.onSecondary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16.0, left: 24.0, right: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'بمجرد النقر على زر التسجيل، فإنك توافق على شروط\nالخدمة وسياسة الخصوصية الخاصة بنظام',
                style: TextStyles.footerTextTextStyle.copyWith(
                  color: AppColors.onSurfaceVariant,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                'AfforestationPanel.',
                style: TextStyles.footerTextTextStyle.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
