import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/ai_recommendation_card_widget.dart';
import './widgets/article_card_widget.dart';
import './widgets/filter_chip_widget.dart';

class LearningArchive extends StatefulWidget {
  const LearningArchive({super.key});

  @override
  State<LearningArchive> createState() => _LearningArchiveState();
}

class _LearningArchiveState extends State<LearningArchive>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSearching = false;
  String _selectedFilter = 'همه';
  bool _isRefreshing = false;

  // Mock data for articles
  final List<Map<String, dynamic>> _articles = [
    {
      "id": 1,
      "title": "تکنیک کاخ حافظه برای یادگیری زبان انگلیسی",
      "source": "مجله علوم شناختی",
      "readingTime": "۱۲ دقیقه",
      "tags": ["زبان", "حافظه", "یادگیری"],
      "type": "مقاله",
      "difficulty": "متوسط",
      "imageUrl":
          "https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400&h=200&fit=crop",
      "isBookmarked": false,
      "isRead": false,
      "publishDate": "۱۴۰۳/۰۸/۱۵",
      "description":
          "روش‌های نوین استفاده از تکنیک کاخ حافظه برای یادگیری سریع‌تر واژگان زبان انگلیسی و بهبود مهارت‌های زبانی.",
    },
    {
      "id": 2,
      "title": "علم عصب‌شناسی و تقویت حافظه",
      "source": "دانشگاه تهران",
      "readingTime": "۸ دقیقه",
      "tags": ["علم", "مغز", "تحقیق"],
      "type": "تحقیق",
      "difficulty": "پیشرفته",
      "imageUrl":
          "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400&h=200&fit=crop",
      "isBookmarked": true,
      "isRead": false,
      "publishDate": "۱۴۰۳/۰۸/۱۰",
      "description":
          "بررسی جدیدترین یافته‌های علمی در زمینه نحوه عملکرد حافظه و روش‌های بهبود آن از منظر عصب‌شناسی.",
    },
    {
      "id": 3,
      "title": "آموزش گام به گام ساخت کاخ حافظه",
      "source": "آکادمی یادگیری",
      "readingTime": "۱۵ دقیقه",
      "tags": ["آموزش", "عملی", "مبتدی"],
      "type": "آموزش",
      "difficulty": "مبتدی",
      "imageUrl":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=200&fit=crop",
      "isBookmarked": false,
      "isRead": true,
      "publishDate": "۱۴۰۳/۰۸/۰۵",
      "description":
          "راهنمای کامل و عملی برای ساخت اولین کاخ حافظه شما با مثال‌های کاربردی و تمرین‌های تعاملی.",
    },
    {
      "id": 4,
      "title": "تکنیک‌های حافظه در فرهنگ ایرانی",
      "source": "پژوهشگاه علوم انسانی",
      "readingTime": "۲۰ دقیقه",
      "tags": ["فرهنگ", "تاریخ", "ایران"],
      "type": "مقاله",
      "difficulty": "متوسط",
      "imageUrl":
          "https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400&h=200&fit=crop",
      "isBookmarked": false,
      "isRead": false,
      "publishDate": "۱۴۰۳/۰۷/۲۸",
      "description":
          "بررسی روش‌های سنتی تقویت حافظه در فرهنگ ایرانی و تطبیق آن‌ها با تکنیک‌های مدرن یادگیری.",
    },
    {
      "id": 5,
      "title": "ویدیو: تمرین‌های عملی تقویت حافظه",
      "source": "کانال یادگیری آنلاین",
      "readingTime": "۲۵ دقیقه",
      "tags": ["ویدیو", "تمرین", "عملی"],
      "type": "ویدیو",
      "difficulty": "متوسط",
      "imageUrl":
          "https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=400&h=200&fit=crop",
      "isBookmarked": true,
      "isRead": false,
      "publishDate": "۱۴۰۳/۰۷/۲۰",
      "description":
          "مجموعه ویدیوهای آموزشی برای تمرین تکنیک‌های مختلف تقویت حافظه با راهنمایی گام به گام.",
    },
  ];

  // AI recommendations mock data
  final List<Map<String, dynamic>> _aiRecommendations = [
    {
      "id": 1,
      "title": "بر اساس کاخ‌های شما: تکنیک‌های پیشرفته",
      "reason": "با توجه به علاقه شما به تاریخ",
      "confidence": 0.92,
      "imageUrl":
          "https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=300&h=150&fit=crop",
    },
    {
      "id": 2,
      "title": "روش‌های بهبود عملکرد در آزمون‌ها",
      "reason": "بر اساس الگوی مرور شما",
      "confidence": 0.87,
      "imageUrl":
          "https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=300&h=150&fit=crop",
    },
  ];

  final List<String> _filterOptions = [
    'همه',
    'مقاله',
    'ویدیو',
    'تحقیق',
    'آموزش'
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
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

  void _toggleBookmark(int articleId) {
    setState(() {
      final articleIndex =
          _articles.indexWhere((article) => article['id'] == articleId);
      if (articleIndex != -1) {
        _articles[articleIndex]['isBookmarked'] =
            !_articles[articleIndex]['isBookmarked'];
      }
    });
  }

  void _markAsRead(int articleId) {
    setState(() {
      final articleIndex =
          _articles.indexWhere((article) => article['id'] == articleId);
      if (articleIndex != -1) {
        _articles[articleIndex]['isRead'] = true;
      }
    });
  }

  List<Map<String, dynamic>> get _filteredArticles {
    List<Map<String, dynamic>> filtered = _articles;

    if (_selectedFilter != 'همه') {
      filtered = filtered
          .where((article) => article['type'] == _selectedFilter)
          .toList();
    }

    if (_searchController.text.isNotEmpty) {
      final searchTerm = _searchController.text.toLowerCase();
      filtered = filtered.where((article) {
        return article['title'].toString().toLowerCase().contains(searchTerm) ||
            (article['tags'] as List).any(
                (tag) => tag.toString().toLowerCase().contains(searchTerm));
      }).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              // Sticky Header with Search
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Header with title and voice search
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'آرشیو یادگیری',
                            style: AppTheme.lightTheme.textTheme.headlineSmall
                                ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            // Voice search functionality
                          },
                          icon: CustomIconWidget(
                            iconName: 'mic',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    // Search bar
                    TextField(
                      controller: _searchController,
                      textDirection: TextDirection.rtl,
                      onChanged: (value) {
                        setState(() {
                          _isSearching = value.isNotEmpty;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'جستجو در مقالات و منابع...',
                        hintTextDirection: TextDirection.rtl,
                        prefixIcon: CustomIconWidget(
                          iconName: 'search',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                        suffixIcon: _isSearching
                            ? IconButton(
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _isSearching = false;
                                  });
                                },
                                icon: CustomIconWidget(
                                  iconName: 'clear',
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                  size: 20,
                                ),
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: AppTheme.lightTheme.colorScheme.surface
                            .withValues(alpha: 0.5),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    // Filter chips
                    SizedBox(
                      height: 5.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _filterOptions.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(width: 2.w),
                        itemBuilder: (context, index) {
                          final filter = _filterOptions[index];
                          final count = filter == 'همه'
                              ? _articles.length
                              : _articles
                                  .where((article) => article['type'] == filter)
                                  .length;

                          return FilterChipWidget(
                            label: filter,
                            count: count,
                            isSelected: _selectedFilter == filter,
                            onTap: () {
                              setState(() {
                                _selectedFilter = filter;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _handleRefresh,
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      // AI Recommendations Section
                      if (!_isSearching) ...[
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.all(4.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'auto_awesome',
                                      color: AppTheme
                                          .lightTheme.colorScheme.secondary,
                                      size: 20,
                                    ),
                                    SizedBox(width: 2.w),
                                    Text(
                                      'پیشنهادات هوشمند',
                                      style: AppTheme
                                          .lightTheme.textTheme.titleMedium
                                          ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 2.h),
                                SizedBox(
                                  height: 20.h,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _aiRecommendations.length,
                                    separatorBuilder: (context, index) =>
                                        SizedBox(width: 3.w),
                                    itemBuilder: (context, index) {
                                      return AIRecommendationCardWidget(
                                        recommendation:
                                            _aiRecommendations[index],
                                        onTap: () {
                                          // Handle AI recommendation tap
                                        },
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(height: 3.h),
                                Divider(
                                  color: AppTheme.lightTheme.colorScheme.outline
                                      .withValues(alpha: 0.3),
                                ),
                                SizedBox(height: 2.h),
                              ],
                            ),
                          ),
                        ),
                      ],
                      // Articles List
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        sliver: _filteredArticles.isEmpty
                            ? SliverToBoxAdapter(
                                child: Center(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.h),
                                    child: Column(
                                      children: [
                                        CustomIconWidget(
                                          iconName: 'search_off',
                                          color: AppTheme.lightTheme.colorScheme
                                              .onSurfaceVariant,
                                          size: 48,
                                        ),
                                        SizedBox(height: 2.h),
                                        Text(
                                          'نتیجه‌ای یافت نشد',
                                          style: AppTheme
                                              .lightTheme.textTheme.titleMedium,
                                        ),
                                        SizedBox(height: 1.h),
                                        Text(
                                          'لطفاً کلمات کلیدی دیگری امتحان کنید',
                                          style: AppTheme
                                              .lightTheme.textTheme.bodyMedium
                                              ?.copyWith(
                                            color: AppTheme.lightTheme
                                                .colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    final article = _filteredArticles[index];
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 2.h),
                                      child: ArticleCardWidget(
                                        article: article,
                                        onTap: () {
                                          _markAsRead(article['id']);
                                          // Navigate to full article reader
                                        },
                                        onBookmarkToggle: () {
                                          _toggleBookmark(article['id']);
                                        },
                                        onShare: () {
                                          // Handle share functionality
                                        },
                                      ),
                                    );
                                  },
                                  childCount: _filteredArticles.length,
                                ),
                              ),
                      ),
                      // Bottom padding
                      SliverToBoxAdapter(
                        child: SizedBox(height: 10.h),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // Bottom Navigation Bar
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: 4, // Learning Archive is at index 4
          onTap: (index) {
            switch (index) {
              case 0:
                Navigator.pushNamed(context, '/onboarding-flow');
                break;
              case 1:
                Navigator.pushNamed(context, '/palace-dashboard');
                break;
              case 2:
                Navigator.pushNamed(context, '/palace-creation-studio');
                break;
              case 3:
                Navigator.pushNamed(context, '/palace-review-session');
                break;
              case 4:
                // Current screen - Learning Archive
                break;
              case 5:
                Navigator.pushNamed(context, '/user-profile-settings');
                break;
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'school',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              activeIcon: CustomIconWidget(
                iconName: 'school',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              label: 'آموزش',
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'dashboard',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              activeIcon: CustomIconWidget(
                iconName: 'dashboard',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              label: 'داشبورد',
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'add_circle',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              activeIcon: CustomIconWidget(
                iconName: 'add_circle',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              label: 'ساخت',
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'quiz',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              activeIcon: CustomIconWidget(
                iconName: 'quiz',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              label: 'مرور',
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'library_books',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              activeIcon: CustomIconWidget(
                iconName: 'library_books',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              label: 'آرشیو',
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'person',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              activeIcon: CustomIconWidget(
                iconName: 'person',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              label: 'پروفایل',
            ),
          ],
        ),
      ),
    );
  }
}
