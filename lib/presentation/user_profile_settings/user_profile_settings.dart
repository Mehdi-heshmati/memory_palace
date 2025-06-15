import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/export_options_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/settings_section_widget.dart';
import './widgets/statistics_dashboard_widget.dart';
import './widgets/support_section_widget.dart';

class UserProfileSettings extends StatefulWidget {
  const UserProfileSettings({super.key});

  @override
  State<UserProfileSettings> createState() => _UserProfileSettingsState();
}

class _UserProfileSettingsState extends State<UserProfileSettings> {
  bool isDarkMode = false;
  bool notificationsEnabled = true;
  bool cloudSyncEnabled = true;
  bool analyticsEnabled = true;
  double fontSizeMultiplier = 1.0;
  int dailyReviewGoal = 5;
  String selectedLanguage = 'Persian';

  // Mock user data
  final Map<String, dynamic> userData = {
    "name": "علی احمدی",
    "email": "ali.ahmadi@example.com",
    "avatar":
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
    "learningStreak": 15,
    "joinDate": "۱۴۰۲/۰۸/۱۵",
    "totalPalaces": 12,
    "reviewSessions": 89,
    "accuracy": 87.5,
    "achievements": ["مبتدی", "مداوم", "دقیق"]
  };

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
            appBar: AppBar(
                title: Text('پروفایل و تنظیمات',
                    style: AppTheme.lightTheme.textTheme.titleLarge),
                backgroundColor:
                    AppTheme.lightTheme.appBarTheme.backgroundColor,
                elevation: 0,
                leading: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                        iconName: 'arrow_back',
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        size: 24))),
            body: SafeArea(
                child: SingleChildScrollView(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Profile Header
                          ProfileHeaderWidget(
                              userData: userData,
                              onEditProfile: _handleEditProfile),

                          SizedBox(height: 3.h),

                          // Account Settings Section
                          SettingsSectionWidget(
                              title: 'حساب کاربری',
                              children: [
                                _buildSettingsTile(
                                    icon: 'person',
                                    title: 'ویرایش پروفایل',
                                    subtitle: 'تغییر نام، عکس و اطلاعات شخصی',
                                    onTap: _handleEditProfile),
                                _buildSettingsTile(
                                    icon: 'lock',
                                    title: 'تغییر رمز عبور',
                                    subtitle: 'به‌روزرسانی رمز عبور حساب',
                                    onTap: _handleChangePassword),
                                _buildSwitchTile(
                                    icon: 'cloud_sync',
                                    title: 'همگام‌سازی ابری',
                                    subtitle: cloudSyncEnabled
                                        ? 'فعال - آخرین همگام‌سازی: امروز'
                                        : 'غیرفعال',
                                    value: cloudSyncEnabled,
                                    onChanged: (value) => setState(
                                        () => cloudSyncEnabled = value)),
                              ]),

                          SizedBox(height: 2.h),

                          // Learning Preferences Section
                          SettingsSectionWidget(
                              title: 'تنظیمات یادگیری',
                              children: [
                                _buildSliderTile(
                                    icon: 'schedule',
                                    title: 'هدف مرور روزانه',
                                    subtitle: '$dailyReviewGoal کاخ در روز',
                                    value: dailyReviewGoal.toDouble(),
                                    min: 1,
                                    max: 20,
                                    divisions: 19,
                                    onChanged: (value) => setState(
                                        () => dailyReviewGoal = value.round())),
                                _buildSwitchTile(
                                    icon: 'notifications',
                                    title: 'اعلان‌های یادآوری',
                                    subtitle: notificationsEnabled
                                        ? 'فعال - ساعت ۲۰:۰۰'
                                        : 'غیرفعال',
                                    value: notificationsEnabled,
                                    onChanged: (value) => setState(
                                        () => notificationsEnabled = value)),
                                _buildSettingsTile(
                                    icon: 'calendar_today',
                                    title: 'برنامه‌ریزی مرور',
                                    subtitle: 'تنظیم زمان‌های مرور هفتگی',
                                    onTap: _handleScheduleSettings),
                              ]),

                          SizedBox(height: 2.h),

                          // Appearance Settings Section
                          SettingsSectionWidget(
                              title: 'ظاهر برنامه',
                              children: [
                                _buildSwitchTile(
                                    icon: 'dark_mode',
                                    title: 'حالت تاریک',
                                    subtitle: isDarkMode ? 'فعال' : 'غیرفعال',
                                    value: isDarkMode,
                                    onChanged: (value) =>
                                        setState(() => isDarkMode = value)),
                                _buildSliderTile(
                                    icon: 'text_fields',
                                    title: 'اندازه فونت',
                                    subtitle:
                                        _getFontSizeLabel(fontSizeMultiplier),
                                    value: fontSizeMultiplier,
                                    min: 0.8,
                                    max: 1.4,
                                    divisions: 6,
                                    onChanged: (value) => setState(
                                        () => fontSizeMultiplier = value)),
                                _buildSettingsTile(
                                    icon: 'language',
                                    title: 'زبان برنامه',
                                    subtitle: 'فارسی (پیش‌فرض)',
                                    onTap: _handleLanguageSettings),
                              ]),

                          SizedBox(height: 2.h),

                          // Statistics Dashboard
                          StatisticsDashboardWidget(userData: userData),

                          SizedBox(height: 2.h),

                          // Privacy Settings Section
                          SettingsSectionWidget(title: 'حریم خصوصی', children: [
                            _buildSwitchTile(
                                icon: 'analytics',
                                title: 'تجزیه و تحلیل',
                                subtitle: analyticsEnabled
                                    ? 'مشارکت در بهبود برنامه'
                                    : 'عدم مشارکت',
                                value: analyticsEnabled,
                                onChanged: (value) =>
                                    setState(() => analyticsEnabled = value)),
                            _buildSettingsTile(
                                icon: 'privacy_tip',
                                title: 'سیاست حریم خصوصی',
                                subtitle: 'مطالعه قوانین و مقررات',
                                onTap: _handlePrivacyPolicy),
                            _buildSettingsTile(
                                icon: 'delete_forever',
                                title: 'حذف حساب کاربری',
                                subtitle: 'حذف دائمی تمام اطلاعات',
                                onTap: _handleDeleteAccount,
                                isDestructive: true),
                          ]),

                          SizedBox(height: 2.h),

                          // Export Options
                          ExportOptionsWidget(onExport: _handleExport),

                          SizedBox(height: 2.h),

                          // Support Section
                          SupportSectionWidget(
                              onViewFAQ: _handleViewFAQ,
                              onContactSupport: _handleContactSupport),

                          SizedBox(height: 4.h),
                        ])))));
  }

  Widget _buildSettingsTile({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: isDestructive
                    ? AppTheme.lightTheme.colorScheme.error
                        .withValues(alpha: 0.1)
                    : AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8)),
            child: CustomIconWidget(
                iconName: icon,
                color: isDestructive
                    ? AppTheme.lightTheme.colorScheme.error
                    : AppTheme.lightTheme.colorScheme.primary,
                size: 20)),
        title: Text(title,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: isDestructive
                    ? AppTheme.lightTheme.colorScheme.error
                    : null)),
        subtitle:
            Text(subtitle, style: AppTheme.lightTheme.textTheme.bodySmall),
        trailing: CustomIconWidget(
            iconName: 'chevron_left',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 20),
        onTap: onTap);
  }

  Widget _buildSwitchTile({
    required String icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8)),
            child: CustomIconWidget(
                iconName: icon,
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20)),
        title: Text(title, style: AppTheme.lightTheme.textTheme.titleMedium),
        subtitle:
            Text(subtitle, style: AppTheme.lightTheme.textTheme.bodySmall),
        trailing: Switch(value: value, onChanged: onChanged));
  }

  Widget _buildSliderTile({
    required String icon,
    required String title,
    required String subtitle,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
  }) {
    return Column(children: [
      ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8)),
              child: CustomIconWidget(
                  iconName: icon,
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20)),
          title: Text(title, style: AppTheme.lightTheme.textTheme.titleMedium),
          subtitle:
              Text(subtitle, style: AppTheme.lightTheme.textTheme.bodySmall)),
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged)),
    ]);
  }

  String _getFontSizeLabel(double multiplier) {
    if (multiplier <= 0.9) return 'کوچک';
    if (multiplier <= 1.1) return 'متوسط';
    if (multiplier <= 1.3) return 'بزرگ';
    return 'خیلی بزرگ';
  }

  void _handleEditProfile() {
    // Navigate to profile editing screen
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ویرایش پروفایل در حال توسعه است')));
  }

  void _handleChangePassword() {
    // Navigate to password change screen
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تغییر رمز عبور در حال توسعه است')));
  }

  void _handleScheduleSettings() {
    // Navigate to schedule settings
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تنظیمات برنامه‌ریزی در حال توسعه است')));
  }

  void _handleLanguageSettings() {
    // Show language selection dialog
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('تنظیمات زبان در حال توسعه است')));
  }

  void _handlePrivacyPolicy() {
    // Navigate to privacy policy screen
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('سیاست حریم خصوصی در حال توسعه است')));
  }

  void _handleDeleteAccount() {
    // Show confirmation dialog for account deletion
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: Text('حذف حساب کاربری'),
                content: Text(
                    'آیا مطمئن هستید که می‌خواهید حساب کاربری خود را حذف کنید؟ این عمل غیرقابل بازگشت است.'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('انصراف')),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('حذف حساب کاربری در حال توسعه است')));
                      },
                      child: Text('حذف',
                          style: TextStyle(
                              color: AppTheme.lightTheme.colorScheme.error))),
                ]));
  }

  void _handleExport(String format) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('خروجی گرفتن به فرمت $format در حال توسعه است')));
  }

  void _handleContactSupport() {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تماس با پشتیبانی در حال توسعه است')));
  }

  void _handleViewFAQ() {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('سوالات متداول در حال توسعه است')));
  }
}