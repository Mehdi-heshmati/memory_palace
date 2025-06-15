import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/app_export.dart';

class VoiceInputWidget extends StatefulWidget {
  final Function(String) onVoiceProcessed;

  const VoiceInputWidget({
    super.key,
    required this.onVoiceProcessed,
  });

  @override
  State<VoiceInputWidget> createState() => _VoiceInputWidgetState();
}

class _VoiceInputWidgetState extends State<VoiceInputWidget>
    with TickerProviderStateMixin {
  bool _isListening = false;
  bool _isProcessing = false;
  String _recognizedText = '';
  String _aiSuggestion = '';

  late AnimationController _pulseController;
  late AnimationController _waveController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _waveController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _waveController,
      curve: Curves.linear,
    ));

    _startListening();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  void _startListening() {
    setState(() {
      _isListening = true;
      _recognizedText = '';
    });

    _pulseController.repeat(reverse: true);
    _waveController.repeat();

    HapticFeedback.mediumImpact();

    // Simulate voice recognition
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _simulateVoiceRecognition();
      }
    });
  }

  void _simulateVoiceRecognition() {
    final List<String> sampleTexts = [
      'یک خانه بزرگ با حیاط وسط و چهار اتاق در اطراف آن',
      'باغی با درختان میوه و آبنمای کوچک در وسط',
      'بازار سنتی با مغازه‌های مختلف و راهروهای باریک',
      'کتابخانه‌ای با قفسه‌های بلند و میزهای مطالعه',
    ];

    setState(() {
      _isListening = false;
      _isProcessing = true;
      _recognizedText =
          sampleTexts[DateTime.now().millisecond % sampleTexts.length];
    });

    _pulseController.stop();
    _waveController.stop();

    // Simulate AI processing
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _generateAISuggestion();
      }
    });
  }

  void _generateAISuggestion() {
    final List<String> suggestions = [
      'پیشنهاد می‌کنم از رنگ‌های گرم برای اتاق‌ها و آبی برای حیاط استفاده کنید',
      'برای بهتر به یاد آوردن، عطر گل یاس را به باغ اضافه کنید',
      'صدای قدم زدن در راهروها و بوی ادویه‌ها را در نظر بگیرید',
      'نور طبیعی از پنجره‌ها و بوی کاغذ کتاب‌ها حس خوبی ایجاد می‌کند',
    ];

    setState(() {
      _isProcessing = false;
      _aiSuggestion =
          suggestions[DateTime.now().millisecond % suggestions.length];
    });
  }

  void _stopListening() {
    setState(() {
      _isListening = false;
    });
    _pulseController.stop();
    _waveController.stop();
  }

  void _retryListening() {
    setState(() {
      _recognizedText = '';
      _aiSuggestion = '';
    });
    _startListening();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.shadowColor,
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'mic',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'ورودی صوتی',
                  style: AppTheme.lightTheme.textTheme.titleLarge,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Voice Visualization
            if (_isListening) _buildVoiceVisualization(),

            // Processing Indicator
            if (_isProcessing) _buildProcessingIndicator(),

            // Recognized Text
            if (_recognizedText.isNotEmpty && !_isProcessing)
              _buildRecognizedText(),

            // AI Suggestion
            if (_aiSuggestion.isNotEmpty) _buildAISuggestion(),

            const SizedBox(height: 24),

            // Action Buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceVisualization() {
    return SizedBox(
      height: 120,
      child: Center(
        child: AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.3),
                      blurRadius: 20,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'mic',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 32,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProcessingIndicator() {
    return SizedBox(
      height: 120,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'در حال پردازش با هوش مصنوعی...',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecognizedText() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primaryContainer
            .withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'record_voice_over',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'متن شناسایی شده:',
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _recognizedText,
            style: AppTheme.lightTheme.textTheme.bodyMedium,
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }

  Widget _buildAISuggestion() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.secondaryContainer
            .withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'auto_awesome',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'پیشنهاد هوش مصنوعی:',
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _aiSuggestion,
            style: AppTheme.lightTheme.textTheme.bodyMedium,
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (_isListening)
          ElevatedButton.icon(
            onPressed: _stopListening,
            icon: CustomIconWidget(
              iconName: 'stop',
              color: AppTheme.lightTheme.colorScheme.onError,
              size: 16,
            ),
            label: Text('توقف'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
              foregroundColor: AppTheme.lightTheme.colorScheme.onError,
            ),
          ),
        if (!_isListening && !_isProcessing)
          OutlinedButton.icon(
            onPressed: _retryListening,
            icon: CustomIconWidget(
              iconName: 'refresh',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 16,
            ),
            label: Text('تکرار'),
          ),
        if (_aiSuggestion.isNotEmpty)
          ElevatedButton.icon(
            onPressed: () {
              widget.onVoiceProcessed(_recognizedText);
            },
            icon: CustomIconWidget(
              iconName: 'check',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 16,
            ),
            label: Text('اعمال'),
          ),
      ],
    );
  }
}
