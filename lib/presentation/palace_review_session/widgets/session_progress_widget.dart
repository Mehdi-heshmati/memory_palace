import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class SessionProgressWidget extends StatelessWidget {
  final int currentIndex;
  final int totalItems;
  final int correctAnswers;
  final int currentStreak;
  final Animation<double> animation;

  const SessionProgressWidget({
    super.key,
    required this.currentIndex,
    required this.totalItems,
    required this.correctAnswers,
    required this.currentStreak,
    required this.animation,
  });

  String _convertToPersianNumbers(String input) {
    const englishNumbers = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const persianNumbers = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];

    String result = input;
    for (int i = 0; i < englishNumbers.length; i++) {
      result = result.replaceAll(englishNumbers[i], persianNumbers[i]);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final remainingItems = totalItems - currentIndex;
    final accuracy =
        currentIndex > 0 ? (correctAnswers / currentIndex * 100).round() : 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Welcome message and remaining count
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'مرور امروز',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textDirection: TextDirection.rtl,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${_convertToPersianNumbers(remainingItems.toString())} باقی‌مانده',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w500,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Progress bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_convertToPersianNumbers((currentIndex + 1).toString())} از ${_convertToPersianNumbers(totalItems.toString())}',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  Text(
                    '${_convertToPersianNumbers(accuracy.toString())}% دقت',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      fontWeight: FontWeight.w500,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              AnimatedBuilder(
                animation: animation,
                builder: (context, child) {
                  return LinearProgressIndicator(
                    value: animation.value,
                    backgroundColor: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.lightTheme.colorScheme.primary,
                    ),
                    minHeight: 6,
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Statistics row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                icon: 'check_circle',
                label: 'صحیح',
                value: _convertToPersianNumbers(correctAnswers.toString()),
                color: AppTheme.lightTheme.colorScheme.tertiary,
              ),
              _buildStatItem(
                icon: 'local_fire_department',
                label: 'پیاپی',
                value: _convertToPersianNumbers(currentStreak.toString()),
                color: AppTheme.lightTheme.colorScheme.secondary,
              ),
              _buildStatItem(
                icon: 'schedule',
                label: 'باقی‌مانده',
                value: _convertToPersianNumbers(remainingItems.toString()),
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: icon,
          size: 20,
          color: color,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
          textDirection: TextDirection.rtl,
        ),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
          textDirection: TextDirection.rtl,
        ),
      ],
    );
  }
}
