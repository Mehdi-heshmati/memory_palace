import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/app_export.dart';

class InteractivePalaceWidget extends StatefulWidget {
  final String title;
  final String description;
  final String illustration;
  final VoidCallback onComplete;

  const InteractivePalaceWidget({
    super.key,
    required this.title,
    required this.description,
    required this.illustration,
    required this.onComplete,
  });

  @override
  State<InteractivePalaceWidget> createState() =>
      _InteractivePalaceWidgetState();
}

class _InteractivePalaceWidgetState extends State<InteractivePalaceWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final List<Map<String, dynamic>> _touchZones = [
    {
      "id": 1,
      "name": "درب ورودی",
      "position": {"x": 0.5, "y": 0.7},
      "item": "کلید اول: نام خانواده",
      "isPlaced": false,
      "color": Colors.blue,
    },
    {
      "id": 2,
      "name": "پنجره سالن",
      "position": {"x": 0.3, "y": 0.4},
      "item": "کلید دوم: سن شخص",
      "isPlaced": false,
      "color": Colors.green,
    },
    {
      "id": 3,
      "name": "میز آشپزخانه",
      "position": {"x": 0.7, "y": 0.5},
      "item": "کلید سوم: شغل",
      "isPlaced": false,
      "color": Colors.orange,
    },
    {
      "id": 4,
      "name": "کاناپه",
      "position": {"x": 0.4, "y": 0.6},
      "item": "کلید چهارم: شهر محل زندگی",
      "isPlaced": false,
      "color": Colors.purple,
    },
  ];

  int _placedItems = 0;
  String? _selectedItem;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _onTouchZoneTap(int zoneId) {
    setState(() {
      final zoneIndex = _touchZones.indexWhere((zone) => zone["id"] == zoneId);
      if (zoneIndex != -1 && !_touchZones[zoneIndex]["isPlaced"]) {
        _touchZones[zoneIndex]["isPlaced"] = true;
        _placedItems++;

        HapticFeedback.mediumImpact();

        if (_placedItems == _touchZones.length) {
          _isCompleted = true;
          _pulseController.stop();
          Future.delayed(const Duration(milliseconds: 500), () {
            _showCompletionDialog();
          });
        }
      }
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Row(
              children: [
                CustomIconWidget(
                  iconName: 'celebration',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 8),
                Text(
                  'تبریک!',
                  style: AppTheme.lightTheme.textTheme.titleLarge,
                ),
              ],
            ),
            content: Text(
              'شما با موفقیت اولین کاخ حافظه خود را ساختید. حالا آماده‌اید تا کاخ‌های پیچیده‌تری بسازید.',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.onComplete();
                },
                child: Text('ادامه'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          // Title and description
          Text(
            widget.title,
            style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 16),

          Text(
            widget.description,
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 24),

          // Progress indicator
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primaryContainer
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Text(
              '$_placedItems از ${_touchZones.length} مورد قرار داده شده',
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ),

          SizedBox(height: 16),

          // Interactive house layout
          Expanded(
            child: Container(
              width: double.infinity,
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
                child: Stack(
                  children: [
                    // Background house image
                    CustomImageWidget(
                      imageUrl: widget.illustration,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),

                    // Touch zones overlay
                    ..._touchZones.map((zone) {
                      final position = zone["position"] as Map<String, double>;
                      final isPlaced = zone["isPlaced"] as bool;
                      final color = zone["color"] as Color;

                      return Positioned(
                        left:
                            MediaQuery.of(context).size.width * position["x"]! -
                                30,
                        top: MediaQuery.of(context).size.height *
                                0.3 *
                                position["y"]! -
                            30,
                        child: GestureDetector(
                          onTap: () => _onTouchZoneTap(zone["id"]),
                          child: AnimatedBuilder(
                            animation: _pulseAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: isPlaced ? 1.0 : _pulseAnimation.value,
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: isPlaced
                                        ? color.withValues(alpha: 0.8)
                                        : color.withValues(alpha: 0.3),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: color,
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: color.withValues(alpha: 0.3),
                                        blurRadius: 8.0,
                                        spreadRadius: 2.0,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: CustomIconWidget(
                                      iconName: isPlaced ? 'check' : 'add',
                                      color: Colors.white,
                                      size: isPlaced ? 24 : 20,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: 16),

          // Items to place
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              reverse: true, // RTL scrolling
              itemCount: _touchZones.length,
              itemBuilder: (context, index) {
                final zone = _touchZones[index];
                final isPlaced = zone["isPlaced"] as bool;
                final color = zone["color"] as Color;

                return Container(
                  width: 200,
                  margin: const EdgeInsets.only(left: 12.0),
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: isPlaced
                        ? color.withValues(alpha: 0.1)
                        : AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: isPlaced
                          ? color.withValues(alpha: 0.3)
                          : AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: CustomIconWidget(
                                iconName: isPlaced ? 'check' : 'location_on',
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              zone["name"],
                              style: AppTheme.lightTheme.textTheme.titleSmall
                                  ?.copyWith(
                                color: isPlaced ? color : null,
                                decoration: isPlaced
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        zone["item"],
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
