import 'package:afforestation_app/core/constants/app_assets.dart';
import 'package:afforestation_app/core/functions/extenstion.dart';
import 'package:afforestation_app/core/functions/navigations.dart';
import 'package:afforestation_app/core/routes/routes.dart';
import 'package:afforestation_app/core/styles/colors.dart';
import 'package:afforestation_app/core/styles/text_styles.dart';
import 'package:afforestation_app/features/users/data/models/user_model.dart';
import 'package:afforestation_app/features/users/presentation/cubit/user_cubit.dart';
import 'package:afforestation_app/features/users/presentation/cubit/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  String selectedFilter = 'all';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg = isDark ? const Color(0xFF121212) : AppColors.background;
    final surfaceColor = isDark ? const Color(0xFF1E1E1E) : AppColors.surface;
    final textColor = isDark ? Colors.white : AppColors.onSurface;

    return BlocProvider(
      create: (context) => UserCubit()..getUsers(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: scaffoldBg,
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                await pushTo(context, Routes.addUser);
                if (context.mounted) {
                  context.read<UserCubit>().getUsers();
                }
              },
              backgroundColor: AppColors.primary,
              child: const Icon(
                Icons.add,
                color: AppColors.onPrimary,
                size: 28,
              ),
            ),
            body: BlocConsumer<UserCubit, UserState>(
              listener: (context, state) {
                if (state is UserErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: AppColors.error,
                    ),
                  );
                } else if (state is UserActionSuccessState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: const Color(0xFF53B157),
                    ),
                  );
                }
              },
              builder: (context, state) {
                final cubit = context.read<UserCubit>();
                final allUsers = cubit.usersList;

                int totalCount = allUsers.length;
                int adminCount = allUsers
                    .where(
                      (u) =>
                          u.roleId == 0 ||
                          u.role == 'مشرف' ||
                          u.role.toLowerCase() == 'admin',
                    )
                    .length;

                List<UserModel> filteredUsers;
                if (selectedFilter == 'admins') {
                  filteredUsers = allUsers
                      .where(
                        (u) =>
                            u.roleId == 0 ||
                            u.role == 'مشرف' ||
                            u.role.toLowerCase() == 'admin',
                      )
                      .toList();
                } else if (selectedFilter == 'users') {
                  filteredUsers = allUsers
                      .where(
                        (u) =>
                            u.roleId == 1 ||
                            u.role == 'مستخدم' ||
                            u.role.toLowerCase() == 'user',
                      )
                      .toList();
                } else {
                  filteredUsers = allUsers;
                }

                return NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                        return <Widget>[
                          SliverAppBar(
                            backgroundColor: surfaceColor,
                            elevation: 0,
                            pinned: true,
                            floating: true,
                            forceElevated: innerBoxIsScrolled,
                            leading: IconButton(
                              icon: Icon(Icons.arrow_back, color: textColor),
                              onPressed: () => pop(context),
                            ),
                            title: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'user_management_title'.tr(),
                                  style: TextStyles.loginHeaderStyle.copyWith(
                                    color: textColor,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                SvgPicture.asset(
                                  AppAssets.treesvg,
                                  colorFilter: const ColorFilter.mode(
                                    AppColors.primary,
                                    BlendMode.srcIn,
                                  ),
                                  width: 24,
                                  height: 24,
                                ),
                              ],
                            ),
                            centerTitle: true,
                            actions: [
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.secondary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: SvgPicture.asset(
                                  AppAssets.bellsvg,
                                  colorFilter: const ColorFilter.mode(
                                    AppColors.onSecondary,
                                    BlendMode.srcIn,
                                  ),
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                            ],
                          ),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildStatCard(
                                          'total_users_stat'.tr(),
                                          '$totalCount',
                                          AppAssets.treesvg,
                                          isDark,
                                          surfaceColor,
                                          textColor,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: _buildStatCard(
                                          'admins_stat'.tr(),
                                          '$adminCount',
                                          AppAssets.plantCropssvg,
                                          isDark,
                                          surfaceColor,
                                          textColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      _buildFilterButton(
                                        'all',
                                        'filter_all'.tr(),
                                        isDark,
                                        surfaceColor,
                                        textColor,
                                      ),
                                      const SizedBox(width: 8),
                                      _buildFilterButton(
                                        'admins',
                                        'filter_admins'.tr(),
                                        isDark,
                                        surfaceColor,
                                        textColor,
                                      ),
                                      const SizedBox(width: 8),
                                      _buildFilterButton(
                                        'users',
                                        'filter_users'.tr(),
                                        isDark,
                                        surfaceColor,
                                        textColor,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    'users_list_title'.tr(),
                                    style: TextStyles.loginHeaderStyle.copyWith(
                                      color: textColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ];
                      },
                  body: state is UserLoadingState
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        )
                      : filteredUsers.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'no_users_in_section'.tr(),
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: () =>
                                    context.read<UserCubit>().getUsers(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: AppColors.onPrimary,
                                ),
                                child: Text('retry'.tr()),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          itemCount: filteredUsers.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final user = filteredUsers[index];
                            return _buildUserCard(
                              context,
                              user,
                              isDark,
                              surfaceColor,
                              textColor,
                            );
                          },
                        ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String count,
    String svgAsset,
    bool isDark,
    Color surfaceColor,
    Color textColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? Colors.white12
              : AppColors.tertiary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          SvgPicture.asset(
            svgAsset,
            colorFilter: const ColorFilter.mode(
              AppColors.secondary,
              BlendMode.srcIn,
            ),
            width: 28,
            height: 28,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyles.footerTextTextStyle.copyWith(
              color: isDark ? Colors.white70 : AppColors.onSurfaceVariant,
            ),
          ),
          Text(
            count,
            style: TextStyles.loginHeaderStyle.copyWith(color: textColor),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(
    String key,
    String text,
    bool isDark,
    Color surfaceColor,
    Color textColor,
  ) {
    bool isSelected = selectedFilter == key;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = key;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : surfaceColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : (isDark
                      ? Colors.white12
                      : AppColors.tertiary.withValues(alpha: 0.3)),
          ),
        ),
        child: Text(
          text,
          style: TextStyles.textButtonTextStyle.copyWith(
            color: isSelected ? AppColors.onPrimary : textColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard(
    BuildContext context,
    UserModel user,
    bool isDark,
    Color surfaceColor,
    Color textColor,
  ) {
    final isAdmin =
        user.roleId == 0 ||
        user.role == 'مشرف' ||
        user.role.toLowerCase() == 'admin';
    final roleText = isAdmin ? 'role_admin'.tr() : 'role_user'.tr();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? Colors.white12
              : AppColors.tertiary.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  backgroundImage:
                      user.avatar != null && user.avatar!.isNotEmpty
                      ? NetworkImage(user.avatar!)
                      : null,
                  child: user.avatar == null || user.avatar!.isEmpty
                      ? Text(
                          user.name.isNotEmpty
                              ? user.name[0].toUpperCase()
                              : 'U',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: TextStyles.buttonTextStyle.copyWith(
                          color: textColor,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        user.email,
                        style: TextStyles.hintTextStyle.copyWith(
                          color: isDark
                              ? Colors.white60
                              : AppColors.onSurfaceVariant,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        roleText,
                        style: TextStyles.textButtonTextStyle.copyWith(
                          color: isAdmin
                              ? (isDark
                                    ? const Color(0xFF81C784)
                                    : AppColors.primary)
                              : AppColors.secondary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: isDark ? Colors.white70 : AppColors.onSurfaceVariant,
                  size: 20,
                ),
                onPressed: () => _showEditDialog(context, user, isDark),
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: AppColors.error,
                  size: 20,
                ),
                onPressed: () => _showDeleteConfirmation(context, user),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, UserModel user, bool isDark) {
    final passwordCtrl = TextEditingController();
    bool isObscured = true;
    final formKeyDialog = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              title: Text(
                'change_password'.tr(),
                style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: formKeyDialog,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(
                            alpha: isDark ? 0.2 : 0.08,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            Text(
                              user.email,
                              style: TextStyle(
                                color: isDark ? Colors.white60 : Colors.grey,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: passwordCtrl,
                        obscureText: isObscured,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'please_enter_new_password'.tr();
                          }
                          if (value.trim().length < 6) {
                            return 'password_min_6_chars'.tr();
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'new_password'.tr(),
                          prefixIcon: const Icon(Icons.lock_outline, size: 20),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isObscured
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              size: 20,
                            ),
                            onPressed: () {
                              setStateDialog(() {
                                isObscured = !isObscured;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text('cancel'.tr()),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKeyDialog.currentState!.validate()) {
                      if (user.id != null) {
                        context.read<UserCubit>().updateUserPassword(
                          id: user.id!,
                          password: passwordCtrl.text.trim(),
                        );
                      }
                      Navigator.pop(dialogContext);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                  ),
                  child: Text('save'.tr()),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final isDark = Theme.of(dialogContext).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          title: Text(
            'confirm_delete_user'.tr(),
            style: TextStyle(color: isDark ? Colors.white : Colors.black87),
          ),
          content: Text(
            'delete_user_question'.tr(args: [user.name]),
            style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('cancel'.tr()),
            ),
            ElevatedButton(
              onPressed: () {
                if (user.id != null) {
                  context.read<UserCubit>().deleteUser(user.id!);
                }
                Navigator.pop(dialogContext);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
              ),
              child: Text('delete'.tr()),
            ),
          ],
        );
      },
    );
  }
}
