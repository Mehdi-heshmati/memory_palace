import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import './widgets/completion_screen_widget.dart';
import './widgets/hint_overlay_widget.dart';
import './widgets/memory_card_widget.dart';
import './widgets/session_controls_widget.dart';
import './widgets/session_progress_widget.dart';

class PalaceReviewSession extends StatefulWidget {
  const PalaceReviewSession({super.key});

  @override
  State<PalaceReviewSession> createState() => _PalaceReviewSessionState();
}

class _PalaceReviewSessionState extends State<PalaceReviewSession>
    with TickerProviderStateMixin {
  late AnimationController _cardAnimationController;
  late AnimationController _progressAnimationController;
  late Animation<double> _cardSlideAnimation;
  late Animation<double> _progressAnimation;

  int _currentIndex = 0;
  int _correctAnswers = 0;
  int _totalAnswers = 0;
  int _currentStreak = 0;
  bool _isSessionCompleted = false;
  bool _isAnswerRevealed = false;
  bool _isHintVisible = false;
  bool _isPaused = false;
  DateTime _sessionStartTime = DateTime.now();

  // Mock review data
  final List<Map<String, dynamic>> _reviewItems = [
    {
      "id": 1,
      "palaceName": "خانه کودکی",
      "lociName": "اتاق نشیمن",
      "memoryItem": "فرمول شیمی آب",
      "answer": "H2O",
      "visualCue":
          "https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=400",
      "audioDescription": "صدای قطره‌های آب",
      "sensoryTags": ["خنک", "شفاف", "بی‌بو"],
      "difficulty": "متوسط",
      "lastReviewed": "۲ روز پیش",
      "nextReview": "فردا",
      "hints": [
        "این ماده حیات را ممکن می‌سازد",
        "از دو عنصر تشکیل شده است",
        "هیدروژن و اکسیژن"
      ]
    },
    {
      "id": 2,
      "palaceName": "مدرسه قدیم",
      "lociName": "کلاس ریاضی",
      "memoryItem": "قضیه فیثاغورس",
      "answer": "a² + b² = c²",
      "visualCue":
          "https://images.unsplash.com/photo-1635070041078-e363dbe005cb?w=400",
      "audioDescription": "صدای گچ روی تخته",
      "sensoryTags": ["سفید", "پودری", "خشک"],
      "difficulty": "آسان",
      "lastReviewed": "۱ روز پیش",
      "nextReview": "۳ روز دیگر",
      "hints": [
        "مربوط به مثلث قائم‌الزاویه است",
        "رابطه بین اضلاع مثلث",
        "مجموع مربع دو ضلع برابر مربع وتر"
      ]
    },
    {
      "id": 3,
      "palaceName": "پارک محله",
      "lociName": "نیمکت چوبی",
      "memoryItem": "پایتخت فرانسه",
      "answer": "پاریس",
      "visualCue":
          "https://images.unsplash.com/photo-1502602898536-47ad22581b52?w=400",
      "audioDescription": "صدای برگ‌های درختان",
      "sensoryTags": ["سبز", "آرام", "طبیعی"],
      "difficulty": "آسان",
      "lastReviewed": "۳ روز پیش",
      "nextReview": "امروز",
      "hints": [
        "شهر عشق و نور",
        "برج ایفل در آن قرار دارد",
        "شهری در اروپای غربی"
      ]
    }
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _enterFullScreenMode();
    _sessionStartTime = DateTime.now();
  }

  void _initializeAnimations() {
    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _cardSlideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cardAnimationController,
      curve: Curves.easeInOut,
    ));

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressAnimationController,
      curve: Curves.easeOut,
    ));

    _cardAnimationController.forward();
    _updateProgress();
  }

  void _enterFullScreenMode() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  void _exitFullScreenMode() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  void _updateProgress() {
    final progress = _currentIndex / _reviewItems.length;
    _progressAnimationController.animateTo(progress);
  }

  void _handleAnswer(String difficulty) {
    if (_isAnswerRevealed) {
      setState(() {
        _totalAnswers++;
        if (difficulty == 'Easy' || difficulty == 'Good') {
          _correctAnswers++;
          _currentStreak++;
        } else {
          _currentStreak = 0;
        }
        _isAnswerRevealed = false;
        _isHintVisible = false;
      });

      _nextCard();
      _provideFeedback(difficulty);
    }
  }

  void _nextCard() {
    if (_currentIndex < _reviewItems.length - 1) {
      _cardAnimationController.reset();
      setState(() {
        _currentIndex++;
      });
      _cardAnimationController.forward();
      _updateProgress();
    } else {
      _completeSession();
    }
  }

  void _completeSession() {
    setState(() {
      _isSessionCompleted = true;
    });
    _exitFullScreenMode();
  }

  void _provideFeedback(String difficulty) {
    HapticFeedback.lightImpact();
    Color feedbackColor;
    String message;

    switch (difficulty) {
      case 'Easy':
        feedbackColor = AppTheme.lightTheme.colorScheme.tertiary;
        message = 'عالی!';
        break;
      case 'Good':
        feedbackColor = AppTheme.lightTheme.colorScheme.secondary;
        message = 'خوب!';
        break;
      default:
        feedbackColor = AppTheme.lightTheme.colorScheme.error;
        message = 'دوباره تلاش کنید';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
          ),
          textDirection: TextDirection.rtl,
        ),
        backgroundColor: feedbackColor,
        duration: const Duration(milliseconds: 1000),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _toggleHint() {
    setState(() {
      _isHintVisible = !_isHintVisible;
    });
  }

  void _pauseSession() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _skipCard() {
    setState(() {
      _totalAnswers++;
      _currentStreak = 0;
      _isAnswerRevealed = false;
      _isHintVisible = false;
    });
    _nextCard();
  }

  void _restartSession() {
    setState(() {
      _currentIndex = 0;
      _correctAnswers = 0;
      _totalAnswers = 0;
      _currentStreak = 0;
      _isSessionCompleted = false;
      _isAnswerRevealed = false;
      _isHintVisible = false;
      _isPaused = false;
      _sessionStartTime = DateTime.now();
    });
    _cardAnimationController.reset();
    _progressAnimationController.reset();
    _cardAnimationController.forward();
    _updateProgress();
    _enterFullScreenMode();
  }

  @override
  void dispose() {
    _cardAnimationController.dispose();
    _progressAnimationController.dispose();
    _exitFullScreenMode();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        body: _isSessionCompleted
            ? CompletionScreenWidget(
                correctAnswers: _correctAnswers,
                totalAnswers: _totalAnswers,
                sessionDuration: DateTime.now().difference(_sessionStartTime),
                onRestart: _restartSession,
                onExit: () => Navigator.pop(context),
              )
            : _isPaused
                ? _buildPauseScreen()
                : _buildActiveSession(),
      ),
    );
  }

  Widget _buildActiveSession() {
    final currentItem = _reviewItems[_currentIndex];

    return SafeArea(
      child: Stack(
        children: [
          Column(
            children: [
              // Progress Section
              SessionProgressWidget(
                currentIndex: _currentIndex,
                totalItems: _reviewItems.length,
                correctAnswers: _correctAnswers,
                currentStreak: _currentStreak,
                animation: _progressAnimation,
              ),

              // Main Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AnimatedBuilder(
                    animation: _cardSlideAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(
                          0,
                          (1 - _cardSlideAnimation.value) * 50,
                        ),
                        child: Opacity(
                          opacity: _cardSlideAnimation.value,
                          child: MemoryCardWidget(
                            item: currentItem,
                            isAnswerRevealed: _isAnswerRevealed,
                            onRevealAnswer: () {
                              setState(() {
                                _isAnswerRevealed = true;
                              });
                            },
                            onSwipeAnswer: _handleAnswer,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Controls Section
              SessionControlsWidget(
                onPause: _pauseSession,
                onHint: _toggleHint,
                onSkip: _skipCard,
                isAnswerRevealed: _isAnswerRevealed,
              ),

              const SizedBox(height: 16),
            ],
          ),

          // Hint Overlay
          if (_isHintVisible)
            HintOverlayWidget(
              hints: (currentItem["hints"] as List).cast<String>(),
              onClose: () => setState(() => _isHintVisible = false),
            ),
        ],
      ),
    );
  }

  Widget _buildPauseScreen() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppTheme.lightShadow,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'pause_circle_filled',
              size: 64,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'جلسه متوقف شده',
              style: AppTheme.lightTheme.textTheme.headlineSmall,
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 16),
            Text(
              'پیشرفت شما ذخیره شده است',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _pauseSession,
                  icon: CustomIconWidget(
                    iconName: 'play_arrow',
                    size: 20,
                    color: Colors.white,
                  ),
                  label: const Text('ادامه'),
                ),
                OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'exit_to_app',
                    size: 20,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                  label: const Text('خروج'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
