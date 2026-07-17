import 'package:afforestation_app/core/constants/app_assets.dart';
import 'package:afforestation_app/core/styles/colors.dart';
import 'package:afforestation_app/core/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:afforestation_app/core/services/apis/dio_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  String selectedFilter = 'الكل';
  bool isLoading = false;
  List<Map<String, dynamic>> allUsers = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await DioProvider.get(path: '/users'); 
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? response.data;
        setState(() {
          allUsers = data.map((user) => {
            'id': user['id']?.toString() ?? '',
            'name': user['name']?.toString() ?? '',
            'email': user['email']?.toString() ?? '',
            'role': user['role']?.toString() ?? 'مستخدم',
            'avatar': user['avatar']?.toString() ?? 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?q=80&w=120',
          }).toList();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ أثناء تحميل المستخدمين: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // ميثود لحذف مستخدم عن طريق الـ API
  Future<void> deleteUser(String userId, int index) async {
    try {
      final response = await DioProvider.post(
        path: '/users/delete',   
        data: {'id': userId},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          allUsers.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حذف المستخدم بنجاح')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل حذف المستخدم: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredUsers = selectedFilter == 'الكل'
        ? allUsers
        : allUsers
            .where(
              (user) => user['role'] == selectedFilter.replaceAll('ون', ''),
            )
            .toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/addNewUserScreen').then((value) {
              fetchUsers();
            });
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
                automaticallyImplyLeading: false,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_forward, color: AppColors.onSurface),
                  onPressed: () => Navigator.maybePop(context),
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                              allUsers.length.toString(), 
                              AppAssets.treesvg,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildStatCard(
                              'المشرفون',
                              allUsers.where((u) => u['role'] == 'مشرف').length.toString(),
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
          body: isLoading
              ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
              : filteredUsers.isEmpty
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
                          user['id']!,
                          user['name']!,
                          user['email']!,
                          user['role']!,
                          user['avatar']!,
                          index,
                        );
                      },
                    ),
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
        border: Border.all(
          color: AppColors.tertiary.withValues(alpha: 0.2),
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

  Widget _buildUserCard(
    String id,
    String name,
    String email,
    String role,
    String avatarUrl,
    int index,
  ) {
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
                  backgroundColor: AppColors.background,
                  backgroundImage: NetworkImage(avatarUrl),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyles.buttonTextStyle.copyWith(
                          color: AppColors.onSurface,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        email,
                        style: TextStyles.hintTextStyle.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: AppColors.onSurfaceVariant,
                  size: 20,
                ),
                onPressed: () {
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: AppColors.error,
                  size: 20,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => Directionality(
                      textDirection: TextDirection.rtl,
                      child: AlertDialog(
                        title: const Text('حذف مستخدم'),
                        content: Text('هل أنت متأكد من حذف المستخدم $name؟'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('إلغاء'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              deleteUser(id, index); 
                            },
                            child: const Text('حذف', style: TextStyle(color: AppColors.error)),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}