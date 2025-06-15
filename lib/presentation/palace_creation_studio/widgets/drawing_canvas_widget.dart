import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class DrawingCanvasWidget extends StatefulWidget {
  final String selectedTool;
  final Color selectedColor;
  final double brushSize;
  final VoidCallback onCanvasChanged;

  const DrawingCanvasWidget({
    super.key,
    required this.selectedTool,
    required this.selectedColor,
    required this.brushSize,
    required this.onCanvasChanged,
  });

  @override
  State<DrawingCanvasWidget> createState() => _DrawingCanvasWidgetState();
}

class _DrawingCanvasWidgetState extends State<DrawingCanvasWidget> {
  final List<DrawnPath> _paths = [];
  final List<PlacedLoci> _loci = [];
  final TransformationController _transformationController =
      TransformationController();

  DrawnPath? _currentPath;
  bool _isDrawing = false;

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppTheme.lightTheme.scaffoldBackgroundColor,
      child: InteractiveViewer(
        transformationController: _transformationController,
        boundaryMargin: const EdgeInsets.all(20),
        minScale: 0.5,
        maxScale: 4.0,
        child: GestureDetector(
          onPanStart: _onPanStart,
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          child: CustomPaint(
            painter: CanvasPainter(
              paths: _paths,
              currentPath: _currentPath,
              loci: _loci,
            ),
            size: Size.infinite,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 2,
              height: MediaQuery.of(context).size.height * 2,
            ),
          ),
        ),
      ),
    );
  }

  void _onPanStart(DragStartDetails details) {
    if (widget.selectedTool == 'brush' || widget.selectedTool == 'pen') {
      setState(() {
        _isDrawing = true;
        _currentPath = DrawnPath(
          path: Path()
            ..moveTo(details.localPosition.dx, details.localPosition.dy),
          paint: Paint()
            ..color = widget.selectedColor
            ..strokeWidth = widget.brushSize
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round,
        );
      });
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_isDrawing && _currentPath != null) {
      setState(() {
        _currentPath!.path
            .lineTo(details.localPosition.dx, details.localPosition.dy);
      });
    }
  }

  void _onPanEnd(DragEndDetails details) {
    if (_isDrawing && _currentPath != null) {
      setState(() {
        _paths.add(_currentPath!);
        _currentPath = null;
        _isDrawing = false;
      });
      widget.onCanvasChanged();
    }
  }

  void addLoci(PlacedLoci loci) {
    setState(() {
      _loci.add(loci);
    });
    widget.onCanvasChanged();
  }

  void clearCanvas() {
    setState(() {
      _paths.clear();
      _loci.clear();
      _currentPath = null;
    });
    widget.onCanvasChanged();
  }
}

class CanvasPainter extends CustomPainter {
  final List<DrawnPath> paths;
  final DrawnPath? currentPath;
  final List<PlacedLoci> loci;

  CanvasPainter({
    required this.paths,
    this.currentPath,
    required this.loci,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw grid background
    _drawGrid(canvas, size);

    // Draw completed paths
    for (final path in paths) {
      canvas.drawPath(path.path, path.paint);
    }

    // Draw current path being drawn
    if (currentPath != null) {
      canvas.drawPath(currentPath!.path, currentPath!.paint);
    }

    // Draw placed loci
    for (final locus in loci) {
      _drawLocus(canvas, locus);
    }
  }

  void _drawGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.lightTheme.dividerColor.withValues(alpha: 0.3)
      ..strokeWidth = 0.5;

    const gridSize = 20.0;

    // Draw vertical lines
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Draw horizontal lines
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  void _drawLocus(Canvas canvas, PlacedLoci locus) {
    // Draw locus circle
    final paint = Paint()
      ..color = locus.color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(locus.position, 20, paint);

    // Draw border
    final borderPaint = Paint()
      ..color = AppTheme.lightTheme.colorScheme.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(locus.position, 20, borderPaint);

    // Draw icon or number
    final textPainter = TextPainter(
      text: TextSpan(
        text: locus.label,
        style: TextStyle(
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.rtl,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        locus.position.dx - textPainter.width / 2,
        locus.position.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class DrawnPath {
  final Path path;
  final Paint paint;

  DrawnPath({required this.path, required this.paint});
}

class PlacedLoci {
  final Offset position;
  final String label;
  final Color color;
  final String? description;
  final List<String> sensoryTags;

  PlacedLoci({
    required this.position,
    required this.label,
    required this.color,
    this.description,
    this.sensoryTags = const [],
  });
}
