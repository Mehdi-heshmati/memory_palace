import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class LociPlacementWidget extends StatelessWidget {
  final Function(Map<String, dynamic>) onLociPlaced;

  const LociPlacementWidget({
    super.key,
    required this.onLociPlaced,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> lociTypes = [
      {
        "id": "entrance",
        "name": "ورودی",
        "icon": "door_front",
        "color": const Color(0xFF2E7D5A),
        "description": "نقطه ورود به کاخ حافظه"
      },
      {
        "id": "room",
        "name": "اتاق",
        "icon": "meeting_room",
        "color": const Color(0xFFF4A261),
        "description": "فضای اصلی برای ذخیره اطلاعات"
      },
      {
        "id": "furniture",
        "name": "مبل",
        "icon": "chair",
        "color": const Color(0xFFE76F51),
        "description": "اشیاء قابل تعامل"
      },
      {
        "id": "window",
        "name": "پنجره",
        "icon": "window",
        "color": const Color(0xFF3182CE),
        "description": "نقاط مشاهده و نور"
      },
      {
        "id": "decoration",
        "name": "تزئین",
        "icon": "palette",
        "color": const Color(0xFF9F7AEA),
        "description": "عناصر بصری کمکی"
      },
      {
        "id": "path",
        "name": "مسیر",
        "icon": "timeline",
        "color": const Color(0xFFF9C74F),
        "description": "مسیر حرکت در کاخ"
      },
    ];

    return Container(
      width: 80,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: const BorderRadius.horizontal(left: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.shadowColor,
            blurRadius: 4,
            offset: const Offset(-2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(12),
            child: Text(
              'نقاط حافظه',
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          Divider(
            color: AppTheme.lightTheme.dividerColor,
            height: 1,
          ),

          // Loci Types List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: lociTypes.length,
              itemBuilder: (context, index) {
                final loci = lociTypes[index];
                return _buildLociItem(loci);
              },
            ),
          ),

          // Quick Actions
          Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                _buildQuickActionButton(
                  'clear_all',
                  'پاک کردن همه',
                  () => _showClearConfirmation(context),
                ),
                const SizedBox(height: 8),
                _buildQuickActionButton(
                  'grid_on',
                  'نمایش شبکه',
                  () => _toggleGrid(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLociItem(Map<String, dynamic> loci) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Draggable<Map<String, dynamic>>(
        data: loci,
        feedback: Material(
          color: Colors.transparent,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: loci["color"] as Color,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: loci["icon"] as String,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ),
        childWhenDragging: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: (loci["color"] as Color).withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.lightTheme.dividerColor,
              style: BorderStyle.solid,
            ),
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: loci["icon"] as String,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
          ),
        ),
        child: GestureDetector(
          onTap: () => onLociPlaced(loci),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: loci["color"] as Color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: loci["icon"] as String,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
      String iconName, String tooltip, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 60,
        height: 40,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppTheme.lightTheme.dividerColor,
          ),
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: iconName,
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 20,
          ),
        ),
      ),
    );
  }

  void _showClearConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'پاک کردن همه نقاط',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        content: Text(
          'آیا مطمئن هستید که می‌خواهید همه نقاط حافظه را پاک کنید؟',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('لغو'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Clear all loci
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text('پاک کردن'),
          ),
        ],
      ),
    );
  }

  void _toggleGrid() {
    // Toggle grid visibility
  }
}
