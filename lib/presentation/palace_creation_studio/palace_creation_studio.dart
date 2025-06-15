import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import './widgets/drawing_canvas_widget.dart';
import './widgets/loci_placement_widget.dart';
import './widgets/sensory_tag_widget.dart';
import './widgets/template_library_widget.dart';
import './widgets/tool_palette_widget.dart';
import './widgets/voice_input_widget.dart';

class PalaceCreationStudio extends StatefulWidget {
  const PalaceCreationStudio({super.key});

  @override
  State<PalaceCreationStudio> createState() => _PalaceCreationStudioState();
}

class _PalaceCreationStudioState extends State<PalaceCreationStudio>
    with TickerProviderStateMixin {
  final TextEditingController _titleController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isToolPaletteVisible = false;
  bool _isSensoryTagVisible = false;
  bool _isTemplateLibraryVisible = false;
  bool _isVoiceInputActive = false;
  bool _isPublished = false;

  String _selectedTool = 'brush';
  Color _selectedColor = const Color(0xFF2E7D5A);
  double _brushSize = 5.0;

  late AnimationController _toolPaletteController;
  late AnimationController _sensoryTagController;
  late Animation<double> _toolPaletteAnimation;
  late Animation<double> _sensoryTagAnimation;

  // Mock data for palace templates
  final List<Map<String, dynamic>> _palaceTemplates = [
    {
      "id": 1,
      "name": "خانه سنتی ایرانی",
      "description": "خانه سنتی با حیاط مرکزی و اتاق‌های مختلف",
      "thumbnail":
          "https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=300&h=200&fit=crop",
      "category": "traditional",
      "lociCount": 12
    },
    {
      "id": 2,
      "name": "بازار تهران",
      "description": "بازار سنتی با راسته‌های مختلف و مغازه‌ها",
      "thumbnail":
          "https://images.unsplash.com/photo-1541888946425-d81bb19240f5?w=300&h=200&fit=crop",
      "category": "marketplace",
      "lociCount": 20
    },
    {
      "id": 3,
      "name": "باغ ایرانی",
      "description": "باغ چهارباغ با آبنما و درختان میوه",
      "thumbnail":
          "https://images.unsplash.com/photo-1585320806297-9794b3e4eeae?w=300&h=200&fit=crop",
      "category": "garden",
      "lociCount": 15
    }
  ];

  // Mock data for sensory tags
  final List<Map<String, dynamic>> _sensoryTags = [
    {
      "category": "عطر و بو",
      "tags": ["یاس", "لاوندر", "رز", "دارچین", "قهوه", "نان تازه"]
    },
    {
      "category": "صدا",
      "tags": ["باران", "موسیقی", "خنده", "باد", "آب جاری", "پرندگان"]
    },
    {
      "category": "لمس",
      "tags": ["ابریشم", "چوب", "سنگ", "گرم", "سرد", "نرم"]
    }
  ];

  @override
  void initState() {
    super.initState();
    _titleController.text = "کاخ حافظه جدید";

    _toolPaletteController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _sensoryTagController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _toolPaletteAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _toolPaletteController,
      curve: Curves.easeInOut,
    ));

    _sensoryTagAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _sensoryTagController,
      curve: Curves.easeInOut,
    ));

    // Auto-save every 30 seconds
    _startAutoSave();
  }

  void _startAutoSave() {
    Future.delayed(const Duration(seconds: 30), () {
      if (mounted) {
        _autoSave();
        _startAutoSave();
      }
    });
  }

  void _autoSave() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'cloud_done',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              'ذخیره خودکار انجام شد',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onPrimary,
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _toggleToolPalette() {
    setState(() {
      _isToolPaletteVisible = !_isToolPaletteVisible;
    });

    if (_isToolPaletteVisible) {
      _toolPaletteController.forward();
    } else {
      _toolPaletteController.reverse();
    }

    HapticFeedback.selectionClick();
  }

  void _showSensoryTags() {
    setState(() {
      _isSensoryTagVisible = true;
    });
    _sensoryTagController.forward();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SensoryTagWidget(
        sensoryTags: _sensoryTags,
        onTagSelected: (tag) {
          HapticFeedback.lightImpact();
          Navigator.pop(context);
          setState(() {
            _isSensoryTagVisible = false;
          });
          _sensoryTagController.reverse();
        },
      ),
    );
  }

  void _showTemplateLibrary() {
    setState(() {
      _isTemplateLibraryVisible = true;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TemplateLibraryWidget(
        templates: _palaceTemplates,
        onTemplateSelected: (template) {
          HapticFeedback.lightImpact();
          Navigator.pop(context);
          setState(() {
            _isTemplateLibraryVisible = false;
            _titleController.text = template["name"] as String;
          });
        },
      ),
    );
  }

  void _toggleVoiceInput() {
    setState(() {
      _isVoiceInputActive = !_isVoiceInputActive;
    });

    if (_isVoiceInputActive) {
      HapticFeedback.mediumImpact();
      _showVoiceInputDialog();
    }
  }

  void _showVoiceInputDialog() {
    showDialog(
      context: context,
      builder: (context) => VoiceInputWidget(
        onVoiceProcessed: (description) {
          setState(() {
            _isVoiceInputActive = false;
          });
          Navigator.pop(context);

          // Show AI suggestions
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'پیشنهادات هوش مصنوعی بر اساس توضیحات شما ایجاد شد',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                ),
              ),
              duration: const Duration(seconds: 3),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _toolPaletteController.dispose();
    _sensoryTagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              // Top Toolbar
              _buildTopToolbar(),

              // Main Content Area
              Expanded(
                child: Stack(
                  children: [
                    // Drawing Canvas
                    Positioned.fill(
                      child: DrawingCanvasWidget(
                        selectedTool: _selectedTool,
                        selectedColor: _selectedColor,
                        brushSize: _brushSize,
                        onCanvasChanged: () {
                          // Handle canvas changes
                        },
                      ),
                    ),

                    // Loci Placement Sidebar
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 80,
                      child: LociPlacementWidget(
                        onLociPlaced: (loci) {
                          HapticFeedback.lightImpact();
                        },
                      ),
                    ),

                    // Bottom Tool Palette
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: AnimatedBuilder(
                        animation: _toolPaletteAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(
                              0,
                              (1 - _toolPaletteAnimation.value) * 200,
                            ),
                            child: ToolPaletteWidget(
                              isVisible: _isToolPaletteVisible,
                              selectedTool: _selectedTool,
                              selectedColor: _selectedColor,
                              brushSize: _brushSize,
                              onToolSelected: (tool) {
                                setState(() {
                                  _selectedTool = tool;
                                });
                                HapticFeedback.selectionClick();
                              },
                              onColorSelected: (color) {
                                setState(() {
                                  _selectedColor = color;
                                });
                                HapticFeedback.selectionClick();
                              },
                              onBrushSizeChanged: (size) {
                                setState(() {
                                  _brushSize = size;
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Floating Action Buttons
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Voice Input FAB
            FloatingActionButton(
              heroTag: "voice",
              onPressed: _toggleVoiceInput,
              backgroundColor: _isVoiceInputActive
                  ? AppTheme.lightTheme.colorScheme.error
                  : AppTheme
                      .lightTheme.floatingActionButtonTheme.backgroundColor,
              child: CustomIconWidget(
                iconName: _isVoiceInputActive ? 'mic_off' : 'mic',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 24,
              ),
            ),

            const SizedBox(height: 16),

            // Tool Palette Toggle FAB
            FloatingActionButton(
              heroTag: "tools",
              onPressed: _toggleToolPalette,
              backgroundColor: _isToolPaletteVisible
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme
                      .lightTheme.floatingActionButtonTheme.backgroundColor,
              child: CustomIconWidget(
                iconName: _isToolPaletteVisible ? 'expand_more' : 'build',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 24,
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      ),
    );
  }

  Widget _buildTopToolbar() {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.shadowColor,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Back Button
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: CustomIconWidget(
              iconName: 'arrow_forward',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),

          const SizedBox(width: 16),

          // Palace Title Input
          Expanded(
            child: TextField(
              controller: _titleController,
              textDirection: TextDirection.rtl,
              style: AppTheme.lightTheme.textTheme.titleMedium,
              decoration: InputDecoration(
                hintText: 'نام کاخ حافظه',
                hintStyle: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Template Library Button
          IconButton(
            onPressed: _showTemplateLibrary,
            icon: CustomIconWidget(
              iconName: 'library_books',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
          ),

          // Sensory Tags Button
          IconButton(
            onPressed: _showSensoryTags,
            icon: CustomIconWidget(
              iconName: 'psychology',
              color: AppTheme.lightTheme.colorScheme.secondary,
              size: 24,
            ),
          ),

          // Save/Publish Toggle
          Switch(
            value: _isPublished,
            onChanged: (value) {
              setState(() {
                _isPublished = value;
              });
              HapticFeedback.lightImpact();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _isPublished
                        ? 'کاخ حافظه منتشر شد'
                        : 'کاخ حافظه به حالت پیش‌نویس تغییر کرد',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                    ),
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
