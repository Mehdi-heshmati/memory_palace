import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class OnboardingPageWidget extends StatelessWidget {
  final String title;
  final String description;
  final String illustration;
  final String pageType;

  const OnboardingPageWidget({
    super.key,
    required this.title,
    required this.description,
    required this.illustration,
    required this.pageType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Large illustration
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.shadow
                      .withValues(alpha: 0.1),
                  blurRadius: 8.0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: CustomImageWidget(
                imageUrl: illustration,
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.4,
                fit: BoxFit.cover,
              ),
            ),
          ),

          SizedBox(height: 32),

          // Persian headline
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 16),

          // Descriptive text
          Text(
            description,
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 24),

          // Page-specific content
          if (pageType == "introduction") _buildIntroductionContent(),
          if (pageType == "location") _buildLocationContent(),
          if (pageType == "sensory") _buildSensoryContent(),
        ],
      ),
    );
  }

  Widget _buildIntroductionContent() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primaryContainer
            .withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'lightbulb',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 24,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'این روش توسط خطیبان یونان باستان برای به خاطر سپردن سخنرانی‌های طولانی استفاده می‌شد.',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationContent() {
    final List<Map<String, dynamic>> locationExamples = [
      {"name": "خانه", "icon": "home", "description": "اتاق‌ها و وسایل آشنا"},
      {"name": "مدرسه", "icon": "school", "description": "کلاس‌ها و راهروها"},
      {"name": "پارک", "icon": "park", "description": "مسیرهای پیاده‌روی"},
    ];

    return Column(
      children: locationExamples.map((location) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8.0),
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: location["icon"],
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 20,
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location["name"],
                    style: AppTheme.lightTheme.textTheme.titleSmall,
                  ),
                  Text(
                    location["description"],
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSensoryContent() {
    final List<Map<String, dynamic>> sensoryTags = [
      {
        "name": "بو",
        "icon": "local_florist",
        "example": "عطر لاوندر",
        "color": Colors.purple
      },
      {
        "name": "طعم",
        "icon": "restaurant",
        "example": "طعم سیب",
        "color": Colors.green
      },
      {
        "name": "صدا",
        "icon": "music_note",
        "example": "صدای باد",
        "color": Colors.blue
      },
      {
        "name": "لمس",
        "icon": "touch_app",
        "example": "سطح صاف",
        "color": Colors.orange
      },
      {
        "name": "رنگ",
        "icon": "palette",
        "example": "قرمز روشن",
        "color": Colors.red
      },
    ];

    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: sensoryTags.map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: (tag["color"] as Color).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(
              color: (tag["color"] as Color).withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: tag["icon"],
                color: tag["color"],
                size: 16,
              ),
              SizedBox(width: 6),
              Text(
                tag["name"],
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: tag["color"],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
