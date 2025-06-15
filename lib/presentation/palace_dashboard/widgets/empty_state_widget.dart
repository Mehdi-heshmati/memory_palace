import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'account_balance',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20.w,
              ),
            ),
            const SizedBox(height: 24),

            // Title
            Text(
              'اولین کاخ حافظه خود را بسازید',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Description
            Text(
              'با ایجاد کاخ‌های حافظه، یادگیری را آسان‌تر و مؤثرتر کنید. هر کاخ مکانی است برای ذخیره و سازماندهی اطلاعات مهم شما.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // CTA Button
            ElevatedButton.icon(
              onPressed: () =>
                  Navigator.pushNamed(context, '/palace-creation-studio'),
              icon: CustomIconWidget(
                iconName: 'add',
                color: Colors.white,
                size: 20,
              ),
              label: Text(
                'شروع کنید',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Secondary Action
            TextButton.icon(
              onPressed: () =>
                  Navigator.pushNamed(context, '/learning-archive'),
              icon: CustomIconWidget(
                iconName: 'library_books',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              label: Text(
                'مطالعه راهنما',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
