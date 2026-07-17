import 'package:afforestation_app/features/dashboard/data/models/loc_names_response.dart';
import 'package:afforestation_app/features/dashboard/presentation/cubit/location_mange_cubit/loc_manage_cubit.dart';
import 'package:afforestation_app/features/dashboard/presentation/cubit/location_mange_cubit/loc_manage_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class _AppColors {
  static const background = Color(0xFFF2F9F2);
  static const primaryGreen = Color(0xFF4CAF6B);
  static const darkGreen = Color(0xFF2E7D4F);
  static const cardWhite = Colors.white;
  static const chipBorder = Color(0xFFBFE3C4);
  static const editBg = Color(0xFFFCEBB6);
  static const editText = Color(0xFF9A7B1E);
  static const deleteBg = Color(0xFFF9D4D4);
  static const deleteText = Color(0xFFC0392B);
  static const textDark = Color(0xFF2B2B2B);
  static const textGrey = Color(0xFF8C978D);
}

class LocationManagementScreen extends StatelessWidget {
  const LocationManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LocationManageCubit()..loadDashboard(),
      child: const _LocationManagementView(),
    );
  }
}

class _LocationManagementView extends StatelessWidget {
  const _LocationManagementView();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _AppColors.background,
        body: SafeArea(
          child: BlocConsumer<LocationManageCubit, LocationManagementState>(
            listener: (context, state) {
              if (state is LocationManagementFailure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text(state.errorMessage)));
              }
            },
            builder: (context, state) {
              if (state is LocationManagementLoading ||
                  state is LocationManagementInitial) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: _AppColors.primaryGreen,
                  ),
                );
              }
              if (state is LocationManagementFailure) {
                return _ErrorView(message: state.errorMessage);
              }
              if (state is LocationManagementSuccess) {
                return _DashboardBody(state: state);
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              color: _AppColors.deleteText,
              size: 40,
            ),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () =>
                  context.read<LocationManageCubit>().loadDashboard(),
              style: ElevatedButton.styleFrom(
                backgroundColor: _AppColors.primaryGreen,
              ),
              child: const Text(
                'إعادة المحاولة',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  final LocationManagementSuccess state;
  const _DashboardBody({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _Header(),
        Expanded(
          child: RefreshIndicator(
            color: _AppColors.primaryGreen,
            onRefresh: () => context.read<LocationManageCubit>().loadDashboard(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    'جميع المواقع',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: _AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'تصفح وإدارة المواقع حسب النوع',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: _AppColors.textGrey),
                  ),
                  const SizedBox(height: 16),
                  _TypesCard(state: state),
                  const SizedBox(height: 16),
                  _SelectedCategoryHeader(state: state),
                  _LocationsList(state: state),
                  const SizedBox(height: 16),
                  _TotalSummaryCard(count: state.totalLocationsCount),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_right, color: _AppColors.textDark),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          const Expanded(
            child: Text(
              'إدارة المواقع',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: _AppColors.textDark,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search, color: _AppColors.primaryGreen),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _TypesCard extends StatelessWidget {
  final LocationManagementSuccess state;
  const _TypesCard({required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _AppColors.cardWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text(
                'أنواع المواقع',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: _AppColors.textDark,
                ),
              ),
              Spacer(),
              Icon(
                Icons.location_on_outlined,
                color: _AppColors.primaryGreen,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (state.categories.isEmpty)
            const Text(
              'لا توجد أنواع مواقع بعد',
              style: TextStyle(color: _AppColors.textGrey, fontSize: 13),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: state.categories.map((category) {
                final isSelected = category.id == state.selectedCategory.id;
                return _TypeChip(
                  label: category.locationType ?? '',
                  isSelected: isSelected,
                  onTap: () {
                    if (!isSelected) {
                      context
                          .read<LocationManageCubit>()
                          .selectCategory(category);
                    }
                  },
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? _AppColors.primaryGreen : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? _AppColors.primaryGreen : _AppColors.chipBorder,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : _AppColors.darkGreen,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _SelectedCategoryHeader extends StatelessWidget {
  final LocationManagementSuccess state;
  const _SelectedCategoryHeader({required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        color: _AppColors.primaryGreen,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        children: [
          // First child sits at the RTL "start" (visually the right side),
          // matching the category name being on the right in the mock.
          Text(
            state.selectedCategory.locationType ?? '',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: () => _showAddLocationSheet(context),
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            icon: const Icon(Icons.add, size: 16, color: _AppColors.primaryGreen),
            label: const Text(
              'إضافة موقع',
              style: TextStyle(
                color: _AppColors.primaryGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationsList extends StatelessWidget {
  final LocationManagementSuccess state;
  const _LocationsList({required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: _AppColors.cardWhite,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            children: [
              Expanded(
                child: Text(
                  'اسم الموقع',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: _AppColors.textGrey,
                    fontSize: 13,
                  ),
                ),
              ),
              Text(
                'إدارة',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: _AppColors.textGrey,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          if (state.locations.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Text(
                'لا توجد مواقع من هذا النوع بعد',
                textAlign: TextAlign.center,
                style: TextStyle(color: _AppColors.textGrey),
              ),
            )
          else
            ...state.locations.map(
              (loc) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: _LocationRow(location: loc),
              ),
            ),
          if (state.isMutating)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: LinearProgressIndicator(
                color: _AppColors.primaryGreen,
                minHeight: 2,
              ),
            ),
        ],
      ),
    );
  }
}

class _LocationRow extends StatelessWidget {
  final LocNamesResponse location;
  const _LocationRow({required this.location});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Start (right side in RTL): the name, expanded.
        Expanded(
          child: Text(
            location.name ?? '',
            style: const TextStyle(
              fontSize: 14,
              color: _AppColors.textDark,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        _PillButton(
          label: 'تعديل',
          background: _AppColors.editBg,
          foreground: _AppColors.editText,
          onTap: () => _showEditLocationSheet(context, location),
        ),
        const SizedBox(width: 8),
        _PillButton(
          label: 'حذف',
          background: _AppColors.deleteBg,
          foreground: _AppColors.deleteText,
          onTap: () => _confirmDelete(context, location),
        ),
      ],
    );
  }
}

class _PillButton extends StatelessWidget {
  final String label;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;

  const _PillButton({
    required this.label,
    required this.background,
    required this.foreground,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: foreground,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _TotalSummaryCard extends StatelessWidget {
  final int count;
  const _TotalSummaryCard({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF8EF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Text(
            'إجمالي المواقع المسجلة',
            style: TextStyle(
              color: _AppColors.textDark,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Text(
                'موقعاً $count',
                style: const TextStyle(
                  color: _AppColors.darkGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.bar_chart_rounded, color: _AppColors.primaryGreen),
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> _showAddLocationSheet(BuildContext context) async {
  // Capture the cubit from the calling context (a descendant of the
  // screen's BlocProvider) - safer than trying to read it again from the
  // bottom sheet's own context.
  final cubit = context.read<LocationManageCubit>();
  final controller = TextEditingController();

  final result = await showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) {
      return Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20,
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'إضافة موقع جديد',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'اسم الموقع',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    Navigator.of(sheetContext).pop(controller.text.trim()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _AppColors.primaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'إضافة',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );

  if (result != null && result.isNotEmpty) {
    cubit.addLocation(result);
  }
}

Future<void> _showEditLocationSheet(
  BuildContext context,
  LocNamesResponse location,
) async {
  final cubit = context.read<LocationManageCubit>();
  final controller = TextEditingController(text: location.name);

  final result = await showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) {
      return Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20,
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'تعديل اسم الموقع',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'اسم الموقع',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    Navigator.of(sheetContext).pop(controller.text.trim()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _AppColors.editText,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('حفظ', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    },
  );

  if (result != null && result.isNotEmpty && result != location.name) {
    cubit.editLocation(id: location.id ?? 0, newName: result);
  }
}

Future<void> _confirmDelete(
  BuildContext context,
  LocNamesResponse location,
) async {
  final cubit = context.read<LocationManageCubit>();

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: const Text('حذف الموقع'),
        content: Text('هل أنت متأكد أنك تريد حذف "${location.name ?? ''}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('حذف', style: TextStyle(color: _AppColors.deleteText)),
          ),
        ],
      ),
    ),
  );

  if (confirmed == true) {
    cubit.deleteLocation(location.id ?? 0);
  }
}