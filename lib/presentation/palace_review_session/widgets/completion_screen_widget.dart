import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class CompletionScreenWidget extends StatelessWidget {
  final int correctAnswers;
  final int totalAnswers;
  final Duration sessionDuration;
  final VoidCallback onRestart;
  final VoidCallback onExit;

  const CompletionScreenWidget({
    super.key,
    required this.correctAnswers,
    required this.totalAnswers,
    required this.sessionDuration,
    required this.onRestart,
    required this.onExit,
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

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${_convertToPersianNumbers(minutes.toString())}:${_convertToPersianNumbers(seconds.toString().padLeft(2, '0'))}';
  }

  String _getEncouragingMessage() {
    final accuracy =
        totalAnswers > 0 ? (correctAnswers / totalAnswers * 100).round() : 0;

    if (accuracy >= 90) {
      return 'عالی! شما استاد حافظه هستید! 🎉';
    } else if (accuracy >= 75) {
      return 'خیلی خوب! در حال پیشرفت هستید! 👏';
    } else if (accuracy >= 50) {
      return 'خوب است! با تمرین بهتر خواهید شد! 💪';
    } else {
      return 'نگران نباشید، تمرین کلید موفقیت است! 🌟';
    }
  }

  @override
  Widget build(BuildContext context) {
    final accuracy =
        totalAnswers > 0 ? (correctAnswers / totalAnswers * 100).round() : 0;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 40),

                        // Completion Icon
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.tertiary
                                .withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: CustomIconWidget(
                            iconName: 'celebration',
                            size: 60,
                            color: AppTheme.lightTheme.colorScheme.tertiary,
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Completion Message
                        Text(
                          'جلسه مرور تمام شد!',
                          style: AppTheme.lightTheme.textTheme.headlineMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.lightTheme.colorScheme.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 16),

                        Text(
                          _getEncouragingMessage(),
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 40),

                        // Statistics Cards
                        _buildStatisticsSection(accuracy),

                        const SizedBox(height: 32),

                        // Next Review Schedule
                        _buildNextReviewSection(),
                      ],
                    ),
                  ),
                ),

                // Action Buttons
                _buildActionButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsSection(int accuracy) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.lightShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'آمار جلسه',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: 'check_circle',
                  title: 'پاسخ صحیح',
                  value: _convertToPersianNumbers(correctAnswers.toString()),
                  subtitle:
                      'از ${_convertToPersianNumbers(totalAnswers.toString())} سوال',
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  icon: 'percent',
                  title: 'دقت',
                  value: '${_convertToPersianNumbers(accuracy.toString())}%',
                  subtitle: 'میانگین عملکرد',
                  color: AppTheme.lightTheme.colorScheme.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: 'schedule',
                  title: 'زمان جلسه',
                  value: _formatDuration(sessionDuration),
                  subtitle: 'دقیقه:ثانیه',
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  icon: 'speed',
                  title: 'سرعت میانگین',
                  value:
                      '${_convertToPersianNumbers((sessionDuration.inSeconds / totalAnswers).round().toString())}ث',
                  subtitle: 'هر سوال',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String icon,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: icon,
                size: 20,
                color: color,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            subtitle,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextReviewSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primaryContainer
            .withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'event',
                size: 24,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Text(
                'برنامه مرور بعدی',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'فردا',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${_convertToPersianNumbers('5')} کارت برای مرور',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.secondary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'آماده',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onRestart,
                icon: CustomIconWidget(
                  iconName: 'refresh',
                  size: 20,
                  color: Colors.white,
                ),
                label: const Text('مرور مجدد'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onExit,
                icon: CustomIconWidget(
                  iconName: 'home',
                  size: 20,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
                label: const Text('بازگشت'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextButton.icon(
          onPressed: () {
            // Navigate to palace dashboard
            Navigator.pushNamed(context, '/palace-dashboard');
          },
          icon: CustomIconWidget(
            iconName: 'dashboard',
            size: 20,
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
          label: const Text('مشاهده همه کاخ‌ها'),
        ),
      ],
    );
  }
}
