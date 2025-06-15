import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SupportSectionWidget extends StatelessWidget {
  final VoidCallback onContactSupport;
  final VoidCallback onViewFAQ;

  const SupportSectionWidget({
    super.key,
    required this.onContactSupport,
    required this.onViewFAQ,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Text(
            'پشتیبانی و راهنما',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
        ),
        Card(
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              _buildSupportTile(
                icon: 'help_outline',
                title: 'سوالات متداول',
                subtitle: 'پاسخ سوالات رایج کاربران',
                onTap: onViewFAQ,
              ),
              Divider(
                height: 1,
                thickness: 0.5,
                indent: 16.w,
                endIndent: 4.w,
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
              ),
              _buildSupportTile(
                icon: 'support_agent',
                title: 'تماس با پشتیبانی',
                subtitle: 'ارسال پیام به تیم پشتیبانی',
                onTap: onContactSupport,
              ),
              Divider(
                height: 1,
                thickness: 0.5,
                indent: 16.w,
                endIndent: 4.w,
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
              ),
              _buildInfoTile(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSupportTile({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: CustomIconWidget(
          iconName: icon,
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.titleMedium,
      ),
      subtitle: Text(
        subtitle,
        style: AppTheme.lightTheme.textTheme.bodySmall,
      ),
      trailing: CustomIconWidget(
        iconName: 'chevron_left',
        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        size: 20,
      ),
      onTap: onTap,
    );
  }

  Widget _buildInfoTile() {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color:
              AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: CustomIconWidget(
          iconName: 'info_outline',
          color: AppTheme.lightTheme.colorScheme.secondary,
          size: 20,
        ),
      ),
      title: Text(
        'درباره برنامه',
        style: AppTheme.lightTheme.textTheme.titleMedium,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'کاخ حافظه - نسخه ۱.۲.۳',
            style: AppTheme.lightTheme.textTheme.bodySmall,
          ),
          SizedBox(height: 0.5.h),
          Text(
            'ساخته شده با ❤️ برای یادگیری بهتر',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.secondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
