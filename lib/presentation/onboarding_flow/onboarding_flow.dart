import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import './widgets/interactive_palace_widget.dart';
import './widgets/onboarding_page_widget.dart';
import './widgets/progress_indicator_widget.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _progressController;
  late AnimationController _fadeController;
  int _currentPage = 0;
  bool _isVoiceNarrationEnabled = false;
  bool _isPlaying = false;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      "id": 1,
      "title": "به کاخ حافظه خوش آمدید",
      "description":
          "روش کاخ حافظه یا Method of Loci تکنیکی باستانی است که به شما کمک می‌کند اطلاعات را به صورت تصویری و مکانی در ذهن ذخیره کنید.",
      "illustration":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800&h=600&fit=crop",
      "type": "introduction"
    },
    {
      "id": 2,
      "title": "انتخاب مکان‌های آشنا",
      "description":
          "ابتدا مکانی آشنا مانند خانه، مدرسه یا محل کار خود را انتخاب کنید. این مکان پایه کاخ حافظه شما خواهد بود.",
      "illustration":
          "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800&h=600&fit=crop",
      "type": "location"
    },
    {
      "id": 3,
      "title": "ایجاد ارتباطات حسی",
      "description":
          "هر اطلاعات را با حواس پنج‌گانه ترکیب کنید. بو، طعم، صدا، لمس و رنگ‌ها به تقویت حافظه کمک می‌کنند.",
      "illustration":
          "https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=800&h=600&fit=crop",
      "type": "sensory"
    },
    {
      "id": 4,
      "title": "تمرین تعاملی",
      "description":
          "حالا خودتان امتحان کنید! روی نقاط مختلف خانه ضربه بزنید و اطلاعات را در آن‌ها قرار دهید.",
      "illustration":
          "https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=800&h=600&fit=crop",
      "type": "interactive"
    }
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _progressController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      HapticFeedback.lightImpact();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      HapticFeedback.lightImpact();
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipOnboarding() {
    _showExitConfirmation();
  }

  void _completeOnboarding() {
    // Store onboarding completion status
    Navigator.pushReplacementNamed(context, '/palace-dashboard');
  }

  void _showExitConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text(
              'خروج از آموزش',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            content: Text(
              'آیا مطمئن هستید که می‌خواهید از آموزش خارج شوید؟',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('ادامه آموزش'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _completeOnboarding();
                },
                child: Text('خروج'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _toggleVoiceNarration() {
    setState(() {
      _isVoiceNarrationEnabled = !_isVoiceNarrationEnabled;
      _isPlaying = _isVoiceNarrationEnabled;
    });
    HapticFeedback.selectionClick();
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
              // Top section with progress and skip button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Skip button (top-right for RTL)
                    TextButton(
                      onPressed: _skipOnboarding,
                      child: Text(
                        'رد کردن',
                        style:
                            AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    // Progress indicator
                    ProgressIndicatorWidget(
                      currentStep: _currentPage + 1,
                      totalSteps: _onboardingData.length,
                    ),
                  ],
                ),
              ),

              // Voice narration controls
              if (_isVoiceNarrationEnabled)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: _toggleVoiceNarration,
                        icon: CustomIconWidget(
                          iconName: _isPlaying ? 'pause' : 'play_arrow',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 24,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        _isPlaying ? 'در حال پخش...' : 'متوقف شده',
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _isVoiceNarrationEnabled = false;
                            _isPlaying = false;
                          });
                        },
                        icon: CustomIconWidget(
                          iconName: 'close',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),

              SizedBox(height: 16),

              // Main content area
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                    _progressController.animateTo(
                      (index + 1) / _onboardingData.length,
                    );
                  },
                  itemCount: _onboardingData.length,
                  itemBuilder: (context, index) {
                    final data = _onboardingData[index];

                    if (data["type"] == "interactive") {
                      return InteractivePalaceWidget(
                        title: data["title"],
                        description: data["description"],
                        illustration: data["illustration"],
                        onComplete: _nextPage,
                      );
                    }

                    return OnboardingPageWidget(
                      title: data["title"],
                      description: data["description"],
                      illustration: data["illustration"],
                      pageType: data["type"],
                    );
                  },
                ),
              ),

              // Bottom navigation section
              Container(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Voice narration toggle
                    IconButton(
                      onPressed: _toggleVoiceNarration,
                      icon: CustomIconWidget(
                        iconName: _isVoiceNarrationEnabled
                            ? 'volume_up'
                            : 'volume_off',
                        color: _isVoiceNarrationEnabled
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 24,
                      ),
                    ),

                    // Navigation buttons
                    Row(
                      children: [
                        // Back button
                        if (_currentPage > 0)
                          IconButton(
                            onPressed: _previousPage,
                            icon: CustomIconWidget(
                              iconName: 'arrow_forward',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 24,
                            ),
                          ),

                        SizedBox(width: 16),

                        // Next/Complete button
                        ElevatedButton(
                          onPressed: _nextPage,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _currentPage == _onboardingData.length - 1
                                    ? 'شروع کنید'
                                    : 'بعدی',
                                style: AppTheme.lightTheme.textTheme.labelLarge
                                    ?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 8),
                              CustomIconWidget(
                                iconName:
                                    _currentPage == _onboardingData.length - 1
                                        ? 'check'
                                        : 'arrow_back',
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
