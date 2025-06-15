import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_chip_widget.dart';
import './widgets/palace_card_widget.dart';

class PalaceDashboard extends StatefulWidget {
  const PalaceDashboard({super.key});

  @override
  State<PalaceDashboard> createState() => _PalaceDashboardState();
}

class _PalaceDashboardState extends State<PalaceDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final bool _isSearching = false;
  String _selectedFilter = 'همه';
  bool _isRefreshing = false;

  // Mock data for palace cards
  final List<Map<String, dynamic>> _palaceData = [
    {
      "id": 1,
      "name": "واژگان انگلیسی پایه",
      "category": "یادگیری زبان",
      "creationDate": "۱۴۰۳/۰۸/۱۵",
      "reviewStatus": "آماده برای مرور",
      "completionPercentage": 85,
      "imageUrl":
          "https://images.unsplash.com/photo-1481627834876-b7833e8f5570?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "isFavorite": true,
      "lastReviewed": "دیروز"
    },
    {
      "id": 2,
      "name": "تاریخ ایران باستان",
      "category": "تاریخ",
      "creationDate": "۱۴۰۳/۰۸/۱۰",
      "reviewStatus": "نیاز به مرور",
      "completionPercentage": 65,
      "imageUrl":
          "https://images.unsplash.com/photo-1578662996442-48f60103fc96?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "isFavorite": false,
      "lastReviewed": "۳ روز پیش"
    },
    {
      "id": 3,
      "name": "فرمول‌های شیمی آلی",
      "category": "علوم",
      "creationDate": "۱۴۰۳/۰۸/۰۵",
      "reviewStatus": "تکمیل شده",
      "completionPercentage": 100,
      "imageUrl":
          "https://images.unsplash.com/photo-1532094349884-543bc11b234d?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "isFavorite": true,
      "lastReviewed": "امروز"
    },
    {
      "id": 4,
      "name": "اصطلاحات پزشکی",
      "category": "یادگیری زبان",
      "creationDate": "۱۴۰۳/۰۷/۲۸",
      "reviewStatus": "در حال پیشرفت",
      "completionPercentage": 45,
      "imageUrl":
          "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "isFavorite": false,
      "lastReviewed": "هفته گذشته"
    },
    {
      "id": 5,
      "name": "جنگ‌های جهانی",
      "category": "تاریخ",
      "creationDate": "۱۴۰۳/۰۷/۲۰",
      "reviewStatus": "آماده برای مرور",
      "completionPercentage": 78,
      "imageUrl":
          "https://images.unsplash.com/photo-1553729459-efe14ef6055d?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "isFavorite": true,
      "lastReviewed": "۲ روز پیش"
    },
    {
      "id": 6,
      "name": "قوانین فیزیک کوانتوم",
      "category": "علوم",
      "creationDate": "۱۴۰۳/۰۷/۱۵",
      "reviewStatus": "شروع نشده",
      "completionPercentage": 20,
      "imageUrl":
          "https://images.unsplash.com/photo-1635070041078-e363dbe005cb?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "isFavorite": false,
      "lastReviewed": "هرگز"
    }
  ];

  final List<Map<String, dynamic>> _filterCategories = [
    {"name": "همه", "count": 6},
    {"name": "یادگیری زبان", "count": 2},
    {"name": "تاریخ", "count": 2},
    {"name": "علوم", "count": 2}
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredPalaces {
    List<Map<String, dynamic>> filtered = _palaceData;

    if (_selectedFilter != 'همه') {
      filtered = filtered
          .where((palace) => (palace['category'] as String) == _selectedFilter)
          .toList();
    }

    if (_searchController.text.isNotEmpty) {
      filtered = filtered
          .where((palace) =>
              (palace['name'] as String).contains(_searchController.text))
          .toList();
    }

    return filtered;
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _showPalaceContextMenu(
      BuildContext context, Map<String, dynamic> palace) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
        builder: (context) => Container(
            padding: const EdgeInsets.all(16),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.outline,
                      borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 16),
              Text(palace['name'] as String,
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                  textAlign: TextAlign.center),
              const SizedBox(height: 24),
              _buildContextMenuItem(
                  icon: 'edit',
                  title: 'ویرایش',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/palace-creation-studio');
                  }),
              _buildContextMenuItem(
                  icon: 'content_copy',
                  title: 'کپی کردن',
                  onTap: () => Navigator.pop(context)),
              _buildContextMenuItem(
                  icon: 'share',
                  title: 'اشتراک‌گذاری',
                  onTap: () => Navigator.pop(context)),
              _buildContextMenuItem(
                  icon: 'delete',
                  title: 'حذف',
                  onTap: () => Navigator.pop(context),
                  isDestructive: true),
              const SizedBox(height: 16),
            ])));
  }

  Widget _buildContextMenuItem({
    required String icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
        leading: CustomIconWidget(
            iconName: icon,
            color: isDestructive
                ? AppTheme.lightTheme.colorScheme.error
                : AppTheme.lightTheme.colorScheme.onSurface,
            size: 24),
        title: Text(title,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: isDestructive
                    ? AppTheme.lightTheme.colorScheme.error
                    : AppTheme.lightTheme.colorScheme.onSurface)),
        onTap: onTap);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
            body: SafeArea(
                child: Column(children: [
              // Sticky Header
              Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      boxShadow: [
                        BoxShadow(
                            color: AppTheme.lightTheme.colorScheme.shadow,
                            blurRadius: 4,
                            offset: const Offset(0, 2)),
                      ]),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Greeting and Filter
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('سلام، به کاخ حافظه خوش آمدید',
                                        style: AppTheme.lightTheme.textTheme
                                            .headlineSmall),
                                    const SizedBox(height: 4),
                                    Text('آماده برای تقویت حافظه هستید؟',
                                        style: AppTheme
                                            .lightTheme.textTheme.bodyMedium
                                            ?.copyWith(
                                                color: AppTheme
                                                    .lightTheme
                                                    .colorScheme
                                                    .onSurfaceVariant)),
                                  ]),
                              IconButton(
                                  onPressed: () {},
                                  icon: CustomIconWidget(
                                      iconName: 'filter_list',
                                      color: AppTheme
                                          .lightTheme.colorScheme.primary,
                                      size: 24)),
                            ]),
                        const SizedBox(height: 16),
                        // Search Bar
                        TextField(
                            controller: _searchController,
                            textDirection: TextDirection.rtl,
                            decoration: InputDecoration(
                                hintText: 'جستجو در کاخ‌های حافظه...',
                                prefixIcon: CustomIconWidget(
                                    iconName: 'search',
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                    size: 20),
                                suffixIcon: _searchController.text.isNotEmpty
                                    ? IconButton(
                                        onPressed: () {
                                          _searchController.clear();
                                          setState(() {});
                                        },
                                        icon: CustomIconWidget(
                                            iconName: 'clear',
                                            color: AppTheme.lightTheme
                                                .colorScheme.onSurfaceVariant,
                                            size: 20))
                                    : null),
                            onChanged: (value) => setState(() {})),
                      ])),

              // Filter Chips
              Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filterCategories.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final category = _filterCategories[index];
                        return FilterChipWidget(
                            label: category['name'] as String,
                            count: category['count'] as int,
                            isSelected: _selectedFilter == category['name'],
                            onTap: () {
                              setState(() {
                                _selectedFilter = category['name'] as String;
                              });
                            });
                      })),

              // Main Content
              Expanded(
                  child: _filteredPalaces.isEmpty
                      ? const EmptyStateWidget()
                      : RefreshIndicator(
                          onRefresh: _handleRefresh,
                          child: GridView.builder(
                              padding: const EdgeInsets.all(16),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:
                                          MediaQuery.of(context).size.width >
                                                  600
                                              ? 3
                                              : 2,
                                      crossAxisSpacing: 16,
                                      mainAxisSpacing: 16,
                                      childAspectRatio: 0.75),
                              itemCount: _filteredPalaces.length,
                              itemBuilder: (context, index) {
                                final palace = _filteredPalaces[index];
                                return PalaceCardWidget(
                                    palace: palace,
                                    onTap: () => Navigator.pushNamed(
                                        context, '/palace-review-session'),
                                    onLongPress: () =>
                                        _showPalaceContextMenu(context, palace),
                                    onFavoriteToggle: () {
                                      setState(() {
                                        palace['isFavorite'] =
                                            !(palace['isFavorite'] as bool);
                                      });
                                    },
                                    onQuickReview: () => Navigator.pushNamed(
                                        context, '/palace-review-session'));
                              }))),
            ])),

            // Bottom Navigation
            bottomNavigationBar: TabBar(
                controller: _tabController,
                indicatorColor: AppTheme.lightTheme.colorScheme.primary,
                labelColor: AppTheme.lightTheme.colorScheme.primary,
                unselectedLabelColor:
                    AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                tabs: [
                  Tab(
                      icon: CustomIconWidget(
                          iconName: 'dashboard',
                          color: _tabController.index == 0
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          size: 24),
                      text: 'داشبورد'),
                  Tab(
                      icon: CustomIconWidget(
                          iconName: 'add_circle_outline',
                          color: _tabController.index == 1
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          size: 24),
                      text: 'ایجاد'),
                  Tab(
                      icon: CustomIconWidget(
                          iconName: 'quiz',
                          color: _tabController.index == 2
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          size: 24),
                      text: 'مرور'),
                  Tab(
                      icon: CustomIconWidget(
                          iconName: 'library_books',
                          color: _tabController.index == 3
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          size: 24),
                      text: 'آرشیو'),
                  Tab(
                      icon: CustomIconWidget(
                          iconName: 'person',
                          color: _tabController.index == 4
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          size: 24),
                      text: 'پروفایل'),
                ],
                onTap: (index) {
                  switch (index) {
                    case 0:
                      // Already on dashboard
                      break;
                    case 1:
                      Navigator.pushNamed(context, '/palace-creation-studio');
                      break;
                    case 2:
                      Navigator.pushNamed(context, '/palace-review-session');
                      break;
                    case 3:
                      Navigator.pushNamed(context, '/learning-archive');
                      break;
                    case 4:
                      Navigator.pushNamed(context, '/user-profile-settings');
                      break;
                  }
                }),

            // Floating Action Button
            floatingActionButton: FloatingActionButton.extended(
                onPressed: () =>
                    Navigator.pushNamed(context, '/palace-creation-studio'),
                icon: CustomIconWidget(
                    iconName: 'add', color: Colors.white, size: 24),
                label: Text('کاخ جدید',
                    style: AppTheme.lightTheme.textTheme.labelLarge
                        ?.copyWith(color: Colors.white))),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.startFloat));
  }
}
