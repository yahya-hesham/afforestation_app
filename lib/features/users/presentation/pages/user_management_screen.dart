import 'package:afforestation_app/core/constants/app_assets.dart';
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
  String selectedFilter = 'الكل';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserCubit()..getUsers(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.background,
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                await pushTo(context, Routes.addUser);
                if (context.mounted) {
                  context.read<UserCubit>().getUsers();
                }
              },
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add, color: AppColors.onPrimary, size: 28),
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
                    .where((u) => u.roleId == 0 || u.role == 'مشرف')
                    .length;

                List<UserModel> filteredUsers;
                if (selectedFilter == 'مشرفون') {
                  filteredUsers = allUsers
                      .where((u) => u.roleId == 0 || u.role == 'مشرف')
                      .toList();
                } else if (selectedFilter == 'مستخدمون') {
                  filteredUsers = allUsers
                      .where((u) => u.roleId == 1 || u.role == 'مستخدم')
                      .toList();
                } else {
                  filteredUsers = allUsers;
                }

                return NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverAppBar(
                        backgroundColor: AppColors.surface,
                        elevation: 0,
                        pinned: true,
                        floating: true,
                        forceElevated: innerBoxIsScrolled,
                        leading: IconButton(
                          icon: const Icon(Icons.arrow_back,
                              color: AppColors.onSurface),
                          onPressed: () => pop(context),
                        ),
                        title: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'إدارة المستخدمين',
                              style: TextStyles.loginHeaderStyle.copyWith(
                                color: AppColors.onSurface,
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
                            margin: const EdgeInsets.all(8),
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
                                      'إجمالي المستخدمين',
                                      '$totalCount',
                                      AppAssets.treesvg,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildStatCard(
                                      'المشرفون',
                                      '$adminCount',
                                      AppAssets.plantCropssvg,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  _buildFilterButton('الكل'),
                                  const SizedBox(width: 8),
                                  _buildFilterButton('مشرفون'),
                                  const SizedBox(width: 8),
                                  _buildFilterButton('مستخدمون'),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'قائمة المستخدمين',
                                style: TextStyles.loginHeaderStyle.copyWith(
                                  color: AppColors.onSurface,
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
                                  const Text('لا يوجد مستخدمين في هذا القسم'),
                                  const SizedBox(height: 12),
                                  ElevatedButton(
                                    onPressed: () =>
                                        context.read<UserCubit>().getUsers(),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: AppColors.onPrimary,
                                    ),
                                    child: const Text('إعادة التحميل'),
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
                                return _buildUserCard(context, user);
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

  Widget _buildStatCard(String title, String count, String svgAsset) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.tertiary.withValues(alpha: 0.2)),
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
              color: AppColors.onSurfaceVariant,
            ),
          ),
          Text(
            count,
            style: TextStyles.loginHeaderStyle.copyWith(
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String text) {
    bool isSelected = selectedFilter == text;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = text;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : AppColors.tertiary.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          text,
          style: TextStyles.textButtonTextStyle.copyWith(
            color: isSelected ? AppColors.onPrimary : AppColors.onSurface,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, UserModel user) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.tertiary.withValues(alpha: 0.1)),
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
                          color: AppColors.onSurface,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        user.email,
                        style: TextStyles.hintTextStyle.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.role,
                        style: TextStyles.textButtonTextStyle.copyWith(
                          color: user.roleId == 0 || user.role == 'مشرف'
                              ? AppColors.primary
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
                icon: const Icon(
                  Icons.edit,
                  color: AppColors.onSurfaceVariant,
                  size: 20,
                ),
                onPressed: () => _showEditDialog(context, user),
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

  void _showEditDialog(BuildContext context, UserModel user) {
    final nameCtrl = TextEditingController(text: user.name);
    final emailCtrl = TextEditingController(text: user.email);
    int selectedRole = user.roleId;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('تعديل بيانات المستخدم'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameCtrl,
                      decoration:
                          const InputDecoration(labelText: 'الاسم الكامل'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: emailCtrl,
                      decoration:
                          const InputDecoration(labelText: 'البريد الإلكتروني'),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: selectedRole,
                      decoration:
                          const InputDecoration(labelText: 'الدور الوظيفي'),
                      items: const [
                        DropdownMenuItem(
                            value: 0, child: Text('مشرف (Admin)')),
                        DropdownMenuItem(
                            value: 1, child: Text('مستخدم (User)')),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setStateDialog(() {
                            selectedRole = val;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('إلغاء'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (user.id != null) {
                      context.read<UserCubit>().updateUser(
                            id: user.id!,
                            name: nameCtrl.text,
                            email: emailCtrl.text,
                            role: selectedRole,
                          );
                    }
                    Navigator.pop(dialogContext);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                  ),
                  child: const Text('حفظ'),
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
        return AlertDialog(
          title: const Text('تأكيد الحذف'),
          content: Text('هل أنت تأكد من حذف المستخدم "${user.name}"؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('إلغاء'),
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
              child: const Text('حذف'),
            ),
          ],
        );
      },
    );
  }
}
