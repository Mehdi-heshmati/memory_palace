import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ExportOptionsWidget extends StatelessWidget {
  final Function(String) onExport;

  const ExportOptionsWidget({
    super.key,
    required this.onExport,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Text(
            'خروجی و پشتیبان‌گیری',
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
              _buildExportTile(
                icon: 'file_download',
                title: 'خروجی JSON',
                subtitle: 'دانلود تمام کاخ‌ها به فرمت JSON',
                format: 'JSON',
              ),
              Divider(
                height: 1,
                thickness: 0.5,
                indent: 16.w,
                endIndent: 4.w,
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
              ),
              _buildExportTile(
                icon: 'picture_as_pdf',
                title: 'خروجی PDF',
                subtitle: 'تولید گزارش کامل به فرمت PDF',
                format: 'PDF',
              ),
              Divider(
                height: 1,
                thickness: 0.5,
                indent: 16.w,
                endIndent: 4.w,
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
              ),
              _buildBackupTile(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExportTile({
    required String icon,
    required String title,
    required String subtitle,
    required String format,
  }) {
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
          iconName: icon,
          color: AppTheme.lightTheme.colorScheme.secondary,
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
      trailing: ElevatedButton(
        onPressed: () => onExport(format),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          'دانلود',
          style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildBackupTile() {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color:
              AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: CustomIconWidget(
          iconName: 'cloud_upload',
          color: AppTheme.lightTheme.colorScheme.tertiary,
          size: 20,
        ),
      ),
      title: Text(
        'پشتیبان‌گیری ابری',
        style: AppTheme.lightTheme.textTheme.titleMedium,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'آخرین پشتیبان‌گیری: امروز ۱۴:۳۰',
            style: AppTheme.lightTheme.textTheme.bodySmall,
          ),
          SizedBox(height: 0.5.h),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 1.w),
              Text(
                'همگام‌سازی خودکار فعال',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
      trailing: OutlinedButton(
        onPressed: () => onExport('BACKUP'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTheme.lightTheme.colorScheme.tertiary,
          side: BorderSide(color: AppTheme.lightTheme.colorScheme.tertiary),
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          'همگام‌سازی',
          style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.tertiary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
