import 'package:afforestation_app/core/styles/colors.dart';
import 'package:afforestation_app/core/styles/text_styles.dart';
import 'package:afforestation_app/core/widgets/build_field_label.dart'; // Ensure correct spelling in your actual project
import 'package:afforestation_app/core/widgets/custom_textForm_field.dart';
import 'package:afforestation_app/feautures/auth/presentation/widgets/app_bar.dart';
import 'package:afforestation_app/feautures/auth/presentation/widgets/drop_down.dart';
import 'package:afforestation_app/feautures/auth/presentation/widgets/form_footer.dart';
import 'package:afforestation_app/feautures/auth/presentation/widgets/form_header.dart';
import 'package:afforestation_app/feautures/auth/presentation/widgets/submit_button.dart';
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

  // Dropdown Configuration
  String _selectedRole = 'مستخدم عادي (User)';
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
      appBar: buildAppBar(context),
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
                  const FormHeader(),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- Name Field ---
                        const BuiledFieldLabel(
                          labelText: 'الاسم الكامل',
                          icon: Icons.person_outline,
                        ),
                        const SizedBox(height: 8),
                        CustomTextFormField(
                          controller: _nameController,
                          hintText: '...أدخل الاسم الكامل',
                        ),
                        const SizedBox(height: 20),

                        // --- Email Field ---
                        const BuiledFieldLabel(
                          labelText: 'البريد الإلكتروني',
                          icon: Icons.mail_outline,
                        ),
                        const SizedBox(height: 8),
                        CustomTextFormField(
                          controller: _emailController,
                          hintText: 'example@domain.com',
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'البريد الإلكتروني مطلوب',
                          style: TextStyles.errorTextStyle.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // --- Password Field ---
                        const BuiledFieldLabel(
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
                        Text(
                          'كلمة المرور مطلوبة',
                          style: TextStyles.errorTextStyle.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // --- Role Dropdown ---
                        const BuiledFieldLabel(
                          labelText: 'اختر الدور الوظيفي',
                          icon: Icons.shield_outlined,
                        ),
                        const SizedBox(height: 8),
                        RoleDropdownField(
                          selectedRole: _selectedRole,
                          roles: _roles,
                          onChanged: (newValue) {
                            if (newValue != null) {
                              setState(() => _selectedRole = newValue);
                            }
                          },
                        ),
                        const SizedBox(height: 32),

                        // --- Submit Button ---
                        buildSubmitButton(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const SafeArea(child: FormFooter()),
    );
  }
}

