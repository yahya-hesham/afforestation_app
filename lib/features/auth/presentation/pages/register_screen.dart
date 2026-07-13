import 'package:afforestation_app/core/styles/colors.dart';
import 'package:afforestation_app/core/widgets/build_field_label.dart';
import 'package:afforestation_app/core/widgets/custom_textForm_field.dart';
import 'package:afforestation_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:afforestation_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:afforestation_app/features/auth/presentation/pages/login.dart';
import 'package:afforestation_app/features/auth/presentation/widgets/app_bar.dart';
import 'package:afforestation_app/features/auth/presentation/widgets/drop_down.dart';
import 'package:afforestation_app/features/auth/presentation/widgets/form_footer.dart';
import 'package:afforestation_app/features/auth/presentation/widgets/form_header.dart';
import 'package:afforestation_app/features/auth/presentation/widgets/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddUserScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();

  AddUserScreen({super.key});

  // Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Dropdown Configuration
  // yahya
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
            child: Column(
              children: [
                Container(
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
                              const BuiledFieldLabel.BuildFieldLabel(
                                labelText: 'الاسم الكامل',
                                icon: Icons.person_outline,
                              ),
                              const SizedBox(height: 8),
                              CustomTextFormField(
                                controller: nameController,
                                hintText: '...أدخل الاسم الكامل',
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'الاسم الكامل مطلوب';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),

                              // --- Email Field ---
                              const BuiledFieldLabel.BuildFieldLabel(
                                labelText: 'البريد الإلكتروني',
                                icon: Icons.mail_outline,
                              ),
                              const SizedBox(height: 8),
                              CustomTextFormField(
                                controller: emailController,
                                hintText: 'example@domain.com',
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().isEmpty ||
                                      !value.contains("@") ||
                                      !value.endsWith(".com")) {
                                    return 'البريد الإلكتروني مطلوب';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),

                              // --- Password Field ---
                              const BuiledFieldLabel.BuildFieldLabel(
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
                              const SizedBox(height: 20),

                              // --- Role Dropdown ---
                              const BuiledFieldLabel.BuildFieldLabel(
                                labelText: 'اختر الدور الوظيفي',
                                icon: Icons.shield_outlined,
                              ),
                              const SizedBox(height: 8),
                              BlocBuilder<AuthCubit, AuthState>(
                                buildWhen: (previous, current) =>
                                    current is RoleChangedState,
                                builder: (context, state) {
                                  var cubit = context.read<AuthCubit>();
                                  // if (state is RoleChangedState) {
                                  //   selectedRole = state.selectedRole;
                                  // }
                                  return RoleDropdownField(
                                    selectedRole: cubit.currentRole,
                                    roles: cubit.roles,
                                    onChanged: (newValue) {
                                      if (newValue != null) {
                                        cubit.changeRole(newValue);
                                        //selectedRole = newValue;
                                        //log(newValue);
                                      }
                                    },
                                  );
                                },
                              ),
                              const SizedBox(height: 32),

                              // --- Submit Button ---
                              BlocConsumer<AuthCubit, AuthState>(
                                listener: (context, state) {
                                  if (state is AuthSucess) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const LoginView(),
                                      ),
                                    );
                                  }
                                  if (state is AuthError) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(state.message)),
                                    );
                                  }
                                },
                                builder: (context, state) {
                                  var cubit = context.read<AuthCubit>();
                                  return state is! AuthLoading
                                      ? BuildSubmitButton(
                                          onTap: () {
                                            if (formKey.currentState!
                                                .validate()) {
                                              cubit.register(
                                                fullName: nameController.text,
                                                email: emailController.text,
                                                password:
                                                    passwordController.text,
                                                role: cubit.currentRole,
                                              );
                                            }
                                          },
                                        )
                                      : const Center(
                                          child: CircularProgressIndicator(),
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
                // --- Moved Footer inside the scroll view here ---
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: FormFooter(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
