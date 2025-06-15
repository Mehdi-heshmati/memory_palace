import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class HintOverlayWidget extends StatefulWidget {
  final List<String> hints;
  final VoidCallback onClose;

  const HintOverlayWidget({
    super.key,
    required this.hints,
    required this.onClose,
  });

  @override
  State<HintOverlayWidget> createState() => _HintOverlayWidgetState();
}

class _HintOverlayWidgetState extends State<HintOverlayWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  int _currentHintIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();
  }

  void _showNextHint() {
    if (_currentHintIndex < widget.hints.length - 1) {
      setState(() {
        _currentHintIndex++;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Container(
            color: Colors.black.withValues(alpha: 0.7),
            child: Center(
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  margin: const EdgeInsets.all(24),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.cardColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'lightbulb',
                                size: 24,
                                color:
                                    AppTheme.lightTheme.colorScheme.secondary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'راهنما',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color:
                                      AppTheme.lightTheme.colorScheme.secondary,
                                ),
                                textDirection: TextDirection.rtl,
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: widget.onClose,
                            icon: CustomIconWidget(
                              iconName: 'close',
                              size: 20,
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Hint Progress Indicator
                      _buildHintProgress(),

                      const SizedBox(height: 20),

                      // Current Hint
                      _buildCurrentHint(),

                      const SizedBox(height: 24),

                      // Action Buttons
                      _buildActionButtons(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHintProgress() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'راهنما ${_currentHintIndex + 1} از ${widget.hints.length}',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textDirection: TextDirection.rtl,
            ),
            Text(
              '${((_currentHintIndex + 1) / widget.hints.length * 100).round()}%',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.secondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: (_currentHintIndex + 1) / widget.hints.length,
          backgroundColor:
              AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          valueColor: AlwaysStoppedAnimation<Color>(
            AppTheme.lightTheme.colorScheme.secondary,
          ),
          minHeight: 4,
        ),
      ],
    );
  }

  Widget _buildCurrentHint() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.1),
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
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${_currentHintIndex + 1}',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'سرنخ ${_currentHintIndex + 1}',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            widget.hints[_currentHintIndex],
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              height: 1.6,
            ),
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        if (_currentHintIndex < widget.hints.length - 1) ...[
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _showNextHint,
              icon: CustomIconWidget(
                iconName: 'arrow_forward',
                size: 18,
                color: Colors.white,
              ),
              label: const Text('راهنمای بعدی'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: OutlinedButton.icon(
            onPressed: widget.onClose,
            icon: CustomIconWidget(
              iconName: 'check',
              size: 18,
              color: AppTheme.lightTheme.colorScheme.tertiary,
            ),
            label: Text(
              _currentHintIndex == widget.hints.length - 1
                  ? 'متوجه شدم'
                  : 'بستن',
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.lightTheme.colorScheme.tertiary,
              side: BorderSide(
                color: AppTheme.lightTheme.colorScheme.tertiary,
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}
