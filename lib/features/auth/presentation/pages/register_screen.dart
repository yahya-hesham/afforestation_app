import 'package:afforestation_app/core/functions/extenstion.dart';
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
  final bool isAdminMode;
  final formKey = GlobalKey<FormState>();

  AddUserScreen({super.key, this.isAdminMode = false});

  // Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg =
        isDark ? const Color(0xFF121212) : AppColors.background;
    final surfaceColor =
        isDark ? const Color(0xFF1E1E1E) : AppColors.surface;

    return BlocProvider(
      create: (context) => AuthCubit(),
      child: Scaffold(
        backgroundColor: scaffoldBg,
        appBar: buildAppBar(context, isAdminMode: isAdminMode),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 16.0,
          ),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: surfaceColor,
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
                      FormHeader(
                        title: isAdminMode
                            ? 'add_user_header'.tr()
                            : 'register_header'.tr(),
                        subtitle: isAdminMode
                            ? 'add_user_subtitle'.tr()
                            : 'register_subtitle'.tr(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // --- Name Field ---
                            BuiledFieldLabel.BuildFieldLabel(
                              labelText: 'full_name'.tr(),
                              icon: Icons.person_outline,
                            ),
                            const SizedBox(height: 8),
                            CustomTextFormField(
                              controller: nameController,
                              hintText: 'full_name_hint'.tr(),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'full_name_required'.tr();
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            // --- Email Field ---
                            BuiledFieldLabel.BuildFieldLabel(
                              labelText: 'email'.tr(),
                              icon: Icons.mail_outline,
                            ),
                            const SizedBox(height: 8),
                            CustomTextFormField(
                              controller: emailController,
                              hintText: 'example@email.com',
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty ||
                                    !value.contains("@") ||
                                    !value.endsWith(".com")) {
                                  return 'email_required'.tr();
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            // --- Password Field ---
                            BuiledFieldLabel.BuildFieldLabel(
                              labelText: 'password'.tr(),
                              icon: Icons.lock_outline,
                            ),
                            const SizedBox(height: 8),
                            CustomTextFormField(
                              controller: passwordController,
                              hintText: '••••••••',
                              isPassword: true,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'password_required'.tr();
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            // --- Role Dropdown ---
                            BuiledFieldLabel.BuildFieldLabel(
                              labelText: 'choose_role'.tr(),
                              icon: Icons.shield_outlined,
                            ),
                            const SizedBox(height: 8),
                            BlocBuilder<AuthCubit, AuthState>(
                              buildWhen: (previous, current) =>
                                  current is RoleChangedState,
                              builder: (context, state) {
                                var cubit = context.read<AuthCubit>();
                                return RoleDropdownField(
                                  selectedRole: cubit.currentRole,
                                  roles: cubit.roles,
                                  onChanged: (newValue) {
                                    if (newValue != null) {
                                      cubit.changeRole(newValue);
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
                                  if (isAdminMode) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('user_added_success'.tr()),
                                        backgroundColor: const Color(0xFF53B157),
                                      ),
                                    );
                                    nameController.clear();
                                    emailController.clear();
                                    passwordController.clear();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('account_created_success'.tr()),
                                        backgroundColor: const Color(0xFF53B157),
                                      ),
                                    );
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const LoginView(),
                                      ),
                                    );
                                  }
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
                                        buttonText: isAdminMode
                                            ? 'btn_add_user_submit'.tr()
                                            : null,
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
                                        child: CircularProgressIndicator(
                                          color: Color(0xFF53B157),
                                        ),
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
              if (!isAdminMode)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: FormFooter(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
