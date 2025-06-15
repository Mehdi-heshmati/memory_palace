import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class MemoryCardWidget extends StatefulWidget {
  final Map<String, dynamic> item;
  final bool isAnswerRevealed;
  final VoidCallback onRevealAnswer;
  final Function(String) onSwipeAnswer;

  const MemoryCardWidget({
    super.key,
    required this.item,
    required this.isAnswerRevealed,
    required this.onRevealAnswer,
    required this.onSwipeAnswer,
  });

  @override
  State<MemoryCardWidget> createState() => _MemoryCardWidgetState();
}

class _MemoryCardWidgetState extends State<MemoryCardWidget> {
  double _dragOffset = 0.0;
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: widget.isAnswerRevealed ? _onPanStart : null,
      onPanUpdate: widget.isAnswerRevealed ? _onPanUpdate : null,
      onPanEnd: widget.isAnswerRevealed ? _onPanEnd : null,
      child: Transform.translate(
        offset: Offset(_dragOffset, 0),
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppTheme.lightShadow,
            border: _isDragging
                ? Border.all(
                    color: _getDragColor(),
                    width: 2,
                  )
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Palace and Loci Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primaryContainer
                      .withValues(alpha: 0.1),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'location_city',
                          size: 20,
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.item["palaceName"] as String,
                            style: AppTheme.lightTheme.textTheme.titleSmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'place',
                          size: 16,
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.item["lociName"] as String,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Visual Cue
              if (widget.item["visualCue"] != null)
                SizedBox(
                  height: 200,
                  child: CustomImageWidget(
                    imageUrl: widget.item["visualCue"] as String,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),

              // Memory Item and Answer Section
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Question
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.2),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'سوال:',
                              style: AppTheme.lightTheme.textTheme.labelMedium
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.item["memoryItem"] as String,
                              style: AppTheme.lightTheme.textTheme.titleLarge
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Answer Section
                      widget.isAnswerRevealed
                          ? _buildAnswerSection()
                          : _buildRevealButton(),

                      // Sensory Tags
                      if (widget.isAnswerRevealed &&
                          widget.item["sensoryTags"] != null)
                        _buildSensoryTags(),
                    ],
                  ),
                ),
              ),

              // Swipe Instructions
              if (widget.isAnswerRevealed) _buildSwipeInstructions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRevealButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: widget.onRevealAnswer,
        icon: CustomIconWidget(
          iconName: 'visibility',
          size: 24,
          color: Colors.white,
        ),
        label: const Text(
          'نمایش پاسخ',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Text(
            'پاسخ:',
            style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.tertiary,
            ),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 8),
          Text(
            widget.item["answer"] as String,
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.tertiary,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }

  Widget _buildSensoryTags() {
    final tags = (widget.item["sensoryTags"] as List).cast<String>();

    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'حواس پنج‌گانه:',
            style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags
                .map((tag) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.secondary
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.secondary
                              .withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        tag,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.secondary,
                          fontWeight: FontWeight.w500,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSwipeInstructions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSwipeOption(
            icon: 'thumb_down',
            label: 'دوباره',
            color: AppTheme.lightTheme.colorScheme.error,
            direction: 'چپ',
          ),
          _buildSwipeOption(
            icon: 'thumb_up',
            label: 'خوب',
            color: AppTheme.lightTheme.colorScheme.secondary,
            direction: 'راست',
          ),
          _buildSwipeOption(
            icon: 'trending_up',
            label: 'آسان',
            color: AppTheme.lightTheme.colorScheme.tertiary,
            direction: 'بالا',
          ),
        ],
      ),
    );
  }

  Widget _buildSwipeOption({
    required String icon,
    required String label,
    required Color color,
    required String direction,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomIconWidget(
          iconName: icon,
          size: 20,
          color: color,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w500,
          ),
          textDirection: TextDirection.rtl,
        ),
        Text(
          direction,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            fontSize: 10,
          ),
          textDirection: TextDirection.rtl,
        ),
      ],
    );
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _isDragging = true;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta.dx;
      _dragOffset = _dragOffset.clamp(-100.0, 100.0);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (_dragOffset.abs() > 50) {
      String difficulty;
      if (_dragOffset > 0) {
        difficulty = 'Good'; // Right swipe
      } else {
        difficulty = 'Again'; // Left swipe
      }

      // Check for upward swipe
      if (details.velocity.pixelsPerSecond.dy < -500) {
        difficulty = 'Easy';
      }

      widget.onSwipeAnswer(difficulty);
    }

    setState(() {
      _dragOffset = 0.0;
      _isDragging = false;
    });
  }

  Color _getDragColor() {
    if (_dragOffset > 30) {
      return AppTheme.lightTheme.colorScheme.secondary; // Good
    } else if (_dragOffset < -30) {
      return AppTheme.lightTheme.colorScheme.error; // Again
    }
    return AppTheme.lightTheme.colorScheme.outline;
  }
}
