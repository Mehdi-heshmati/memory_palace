import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class ToolPaletteWidget extends StatelessWidget {
  final bool isVisible;
  final String selectedTool;
  final Color selectedColor;
  final double brushSize;
  final Function(String) onToolSelected;
  final Function(Color) onColorSelected;
  final Function(double) onBrushSizeChanged;

  const ToolPaletteWidget({
    super.key,
    required this.isVisible,
    required this.selectedTool,
    required this.selectedColor,
    required this.brushSize,
    required this.onToolSelected,
    required this.onColorSelected,
    required this.onBrushSizeChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Tool Selection Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildToolButton('brush', 'brush', 'قلم مو'),
                      _buildToolButton('pen', 'edit', 'خودکار'),
                      _buildToolButton('eraser', 'cleaning_services', 'پاک کن'),
                      _buildToolButton('text', 'text_fields', 'متن'),
                      _buildToolButton('shape', 'crop_square', 'شکل'),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Brush Size Slider
                  Row(
                    children: [
                      Text(
                        'اندازه:',
                        style: AppTheme.lightTheme.textTheme.bodyMedium,
                      ),
                      Expanded(
                        child: Slider(
                          value: brushSize,
                          min: 1.0,
                          max: 20.0,
                          divisions: 19,
                          onChanged: onBrushSizeChanged,
                        ),
                      ),
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: selectedColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Container(
                            width: brushSize.clamp(2, 20),
                            height: brushSize.clamp(2, 20),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Color Palette
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildColorButton(const Color(0xFF000000), 'سیاه'),
                      _buildColorButton(const Color(0xFF2E7D5A), 'سبز جنگلی'),
                      _buildColorButton(const Color(0xFFF4A261), 'نارنجی'),
                      _buildColorButton(const Color(0xFFE76F51), 'قرمز'),
                      _buildColorButton(const Color(0xFF3182CE), 'آبی'),
                      _buildColorButton(const Color(0xFF9F7AEA), 'بنفش'),
                      _buildColorButton(const Color(0xFFF9C74F), 'زرد'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolButton(String tool, String iconName, String label) {
    final isSelected = selectedTool == tool;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => onToolSelected(tool),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.dividerColor,
                width: 2,
              ),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: iconName,
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.onPrimary
                    : AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildColorButton(Color color, String label) {
    final isSelected = selectedColor == color;

    return GestureDetector(
      onTap: () => onColorSelected(color),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.dividerColor,
            width: isSelected ? 3 : 1,
          ),
        ),
        child: isSelected
            ? Center(
                child: CustomIconWidget(
                  iconName: 'check',
                  color: color.computeLuminance() > 0.5
                      ? Colors.black
                      : Colors.white,
                  size: 16,
                ),
              )
            : null,
      ),
    );
  }
}
