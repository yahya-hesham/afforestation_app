import 'package:bookia/core/styles/colors.dart';
import 'package:bookia/core/styles/text_styles.dart';
import 'package:bookia/core/widgets/build_field_label.dart'; // Ensure correct spelling in your actual project
import 'package:bookia/core/widgets/custom_textForm_field.dart';
import 'package:bookia/feautures/auth/presentation/cubit/auth_cubit.dart';
import 'package:bookia/feautures/auth/presentation/cubit/auth_state.dart';
import 'package:bookia/feautures/auth/presentation/pages/login.dart';
import 'package:bookia/feautures/auth/presentation/widgets/app_bar.dart';
import 'package:bookia/feautures/auth/presentation/widgets/drop_down.dart';
import 'package:bookia/feautures/auth/presentation/widgets/form_footer.dart';
import 'package:bookia/feautures/auth/presentation/widgets/form_header.dart';
import 'package:bookia/feautures/auth/presentation/widgets/submit_button.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddUserScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();

  AddUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: buildAppBar(context),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
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
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
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
                            controller: nameController,
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
                            controller: emailController,
                            hintText: 'example@domain.com',
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'البريد الإلكتروني مطلوب';
                              }
                              return null; // Means no error
                            },
                          ),
                          const SizedBox(height: 4),

                          const SizedBox(height: 16),

                          // --- Password Field ---
                          const BuiledFieldLabel(
                            labelText: 'كلمة المرور',
                            icon: Icons.lock_outline,
                          ),
                          const SizedBox(height: 8),
                          CustomTextFormField(
                            controller: passwordController,
                            hintText: '••••••••',
                            isPassword: true,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'كلمة المرور مطلوبة';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 4),

                          const SizedBox(height: 16),

                          // --- Role Dropdown ---
                          const BuiledFieldLabel(
                            labelText: 'اختر الدور الوظيفي',
                            icon: Icons.shield_outlined,
                          ),
                          const SizedBox(height: 8),
                          RoleDropdownField(
                            selectedRole: selectedRole,
                            roles: roles,
                            onChanged: (newValue) {
                              if (newValue != null) {
                                // setState(() => selectedRole = newValue);
                              }
                            },
                          ),
                          const SizedBox(height: 32),

                          // --- Submit Button ---
                          BlocConsumer<AuthCubit, AuthState>(
                            listener: (context, state) {
                              // TODO: implement listener
                              if (state is RegisterSuccess) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginView(),
                                  ),
                                );
                              }
                              if (state is RegisterFailure) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(state.errorMessage)),
                                );
                              }
                            },
                            builder: (context, state) {
                              var cubit = context.read<AuthCubit>();
                              return BuildSubmitButton(
                                onTap: () {
                                  cubit.register(
                                    fullName: nameController.toString(),
                                    email: emailController.toString(),
                                    password: passwordController.toString(),
                                    role: selectedRole,
                                  );
                                },
                              );
                            },
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
        bottomNavigationBar: const SafeArea(child: FormFooter()),
      ),
    );
  }
  ////////////////////////////////////////////
  ///
  ////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////

  // Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Dropdown Configuration
  String selectedRole = 'مستخدم عادي (User)';
  final List<String> roles = ['مستخدم عادي (User)', 'مستخدم مسؤول (Admin)'];

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    //super.dispose();
  }
}
