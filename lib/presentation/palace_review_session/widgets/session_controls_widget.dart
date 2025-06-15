import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class SessionControlsWidget extends StatelessWidget {
  final VoidCallback onPause;
  final VoidCallback onHint;
  final VoidCallback onSkip;
  final bool isAnswerRevealed;

  const SessionControlsWidget({
    super.key,
    required this.onPause,
    required this.onHint,
    required this.onSkip,
    required this.isAnswerRevealed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(
            icon: 'pause',
            label: 'توقف',
            onPressed: onPause,
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
          _buildControlButton(
            icon: 'lightbulb_outline',
            label: 'راهنما',
            onPressed: onHint,
            color: AppTheme.lightTheme.colorScheme.secondary,
            isEnabled: !isAnswerRevealed,
          ),
          _buildControlButton(
            icon: 'skip_next',
            label: 'رد کردن',
            onPressed: onSkip,
            color: AppTheme.lightTheme.colorScheme.error,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required String icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
    bool isEnabled = true,
  }) {
    return Opacity(
      opacity: isEnabled ? 1.0 : 0.5,
      child: InkWell(
        onTap: isEnabled ? onPressed : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: icon,
                size: 24,
                color: color,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
                textDirection: TextDirection.rtl,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
