import 'package:afforestation_app/core/constants/app_assets.dart';
import 'package:afforestation_app/core/styles/colors.dart';
import 'package:afforestation_app/core/styles/text_styles.dart';
import 'package:afforestation_app/features/add/adding_plant/presentation/pages/add_new_plant_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  String selectedFilter = 'الكل';

  final List<Map<String, String>> allUsers = [
    {
      'name': 'أحمد محمود',
      'email': 'ahmed@gmail.com',
      'role': 'مشرف',
      'avatar':
          'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?q=80&w=120',
    },
    {
      'name': 'سارة كمال',
      'email': 'sara.k@afforest.sa',
      'role': 'مستخدم',
      'avatar':
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=120',
    },
    {
      'name': 'ياسين علي',
      'email': 'yassin.a@outlook.com',
      'role': 'مستخدم',
      'avatar':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=120',
    },
    {
      'name': 'ليلى حسن',
      'email': 'layla.h@afforest.sa',
      'role': 'مستخدم',
      'avatar':
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=120',
    },
    {
      'name': 'فهد العتيبي',
      'email': 'fahad.o@gmail.com',
      'role': 'مشرف',
      'avatar':
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=120',
    },
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredUsers = selectedFilter == 'الكل'
        ? allUsers
        : allUsers
              .where(
                (user) => user['role'] == selectedFilter.replaceAll('ون', ''),
              )
              .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddNewPlantScreen()),
          );
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.onPrimary, size: 28),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: AppColors.surface,
              elevation: 0,
              pinned: true,
              floating: true,
              forceElevated: innerBoxIsScrolled,
              actions: [
                const Icon(Icons.arrow_back, color: AppColors.onSurface),
                const SizedBox(width: 16),
              ],
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
              leading: Container(
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
                            '128',
                            AppAssets.treesvg,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard(
                            'المشرفون',
                            '12',
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
        body: filteredUsers.isEmpty
            ? const Center(child: Text('لا يوجد مستخدمين في هذا القسم'))
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
                    user['name']!,
                    user['email']!,
                    user['role']!,
                    user['avatar']!,
                  );
                },
              ),
      ),
    );
  }

  Widget _buildStatCard(String title, String count, String svgAsset) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.tertiary.withOpacity(0.2)),
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
                : AppColors.tertiary.withOpacity(0.3),
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

  Widget _buildUserCard(
    String name,
    String email,
    String role,
    String avatarUrl,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.tertiary.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.background,
                backgroundImage: NetworkImage(avatarUrl),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyles.buttonTextStyle.copyWith(
                      color: AppColors.onSurface,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    email,
                    style: TextStyles.hintTextStyle.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    role,
                    style: TextStyles.textButtonTextStyle.copyWith(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: AppColors.onSurfaceVariant,
                  size: 20,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: AppColors.error,
                  size: 20,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
