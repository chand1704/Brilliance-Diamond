import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'model/gmss_stone_model.dart';

class RoundTopViewPainter extends CustomPainter {
  final GmssStone stone;
  RoundTopViewPainter({required this.stone});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade600
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final infoPaint = Paint()
      ..color =
          const Color(0xFF008080) // Teal color from reference
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width * 0.45) / 2;

    // 1. Girdle (Outer Circle)
    canvas.drawCircle(center, radius, paint);

    // 2. Table Facets (The Center Octagon)
    final double tableRadius = radius * 0.55;
    List<Offset> tablePoints = List.generate(8, (i) {
      double angle = (i * 45 - 22.5) * math.pi / 180;
      return Offset(
        center.dx + tableRadius * math.cos(angle),
        center.dy + tableRadius * math.sin(angle),
      );
    });
    canvas.drawPath(Path()..addPolygon(tablePoints, true), paint);

    // 3. Star, Bezel, and Girdle Facets
    for (int i = 0; i < 8; i++) {
      // Main Bezel Lines (Connects table corners to girdle)
      double bezelAngle = (i * 45 - 22.5) * math.pi / 180;
      Offset girdlePoint = Offset(
        center.dx + radius * math.cos(bezelAngle),
        center.dy + radius * math.sin(bezelAngle),
      );
      canvas.drawLine(tablePoints[i], girdlePoint, paint);

      // Star Facet Points (The "V" shape between table edges)
      double starAngle = (i * 45 + 22.5) * math.pi / 180;
      Offset starPoint = Offset(
        center.dx + radius * math.cos(starAngle),
        center.dy + radius * math.sin(starAngle),
      );

      // Connect adjacent table corners to the star point on the girdle
      canvas.drawLine(tablePoints[i], starPoint, paint);
      canvas.drawLine(tablePoints[(i + 1) % 8], starPoint, paint);
    }

    // 4. Dimension Indicators (Width & Length)
    _drawDimensions(canvas, center, radius, infoPaint);
  }

  void _drawDimensions(
    Canvas canvas,
    Offset center,
    double radius,
    Paint infoPaint,
  ) {
    // Width Indicator (Top)
    canvas.drawLine(
      Offset(center.dx - radius, center.dy - radius - 25),
      Offset(center.dx + radius, center.dy - radius - 25),
      infoPaint,
    );
    _drawText(
      canvas,
      "Width: ${stone.width} mm",
      Offset(center.dx, center.dy - radius - 40),
    );

    // Length Indicator (Right)
    canvas.drawLine(
      Offset(center.dx + radius + 25, center.dy - radius),
      Offset(center.dx + radius + 25, center.dy + radius),
      infoPaint,
    );
    _drawText(
      canvas,
      "Length: ${stone.length} mm",
      Offset(center.dx + radius + 70, center.dy),
    );

    // Ratio Text (Bottom)
    _drawText(
      canvas,
      "Length to Width: ${stone.ratio.toStringAsFixed(2)} to 1",
      Offset(center.dx, center.dy + radius + 40),
      isGrey: true,
    );
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset pos, {
    bool isGrey = false,
  }) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: isGrey ? Colors.grey.shade700 : const Color(0xFF008080),
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(pos.dx - tp.width / 2, pos.dy - tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class EmeraldTopViewPainter extends CustomPainter {
  final GmssStone stone;
  EmeraldTopViewPainter({required this.stone});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade600
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final infoPaint = Paint()
      ..color = const Color(0xFF008080)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final center = Offset(size.width / 2, size.height / 2);
    // Scale based on the 1.40 to 1 ratio typically seen in emeralds
    final double h = size.height * 0.5;
    final double w = h / 1.4;

    // 1. Outer Girdle (Octagon)
    Rect outerRect = Rect.fromCenter(center: center, width: w, height: h);
    _drawEmeraldRect(canvas, outerRect, 15, paint);

    // 2. Nested Step Facets ( Hall of Mirrors effect)
    _drawEmeraldRect(canvas, outerRect.deflate(10), 12, paint);
    _drawEmeraldRect(canvas, outerRect.deflate(20), 8, paint);

    // 3. Table (Inner Center Rectangle)
    _drawEmeraldRect(canvas, outerRect.deflate(35), 5, paint);

    // 4. Connecting Corner Lines
    _drawCornerLines(canvas, outerRect, outerRect.deflate(35), paint);

    // 5. Dimension Indicators
    _drawDimensions(canvas, center, w, h, infoPaint);
  }

  void _drawEmeraldRect(Canvas canvas, Rect rect, double radius, Paint paint) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(radius)),
      paint,
    );
  }

  void _drawCornerLines(Canvas canvas, Rect outer, Rect inner, Paint paint) {
    // Top-Left to Center
    canvas.drawLine(
      Offset(outer.left + 15, outer.top),
      Offset(inner.left + 5, inner.top),
      paint,
    );
    // Top-Right to Center
    canvas.drawLine(
      Offset(outer.right - 15, outer.top),
      Offset(inner.right - 5, inner.top),
      paint,
    );
    // Bottom-Left to Center
    canvas.drawLine(
      Offset(outer.left + 15, outer.bottom),
      Offset(inner.left + 5, inner.bottom),
      paint,
    );
    // Bottom-Right to Center
    canvas.drawLine(
      Offset(outer.right - 15, outer.bottom),
      Offset(inner.right - 5, inner.bottom),
      paint,
    );
  }

  void _drawDimensions(
    Canvas canvas,
    Offset center,
    double w,
    double h,
    Paint infoPaint,
  ) {
    // Width Bar (Top)
    double widthY = center.dy - h / 2 - 30;
    canvas.drawLine(
      Offset(center.dx - w / 2, widthY),
      Offset(center.dx + w / 2, widthY),
      infoPaint,
    );
    _drawText(
      canvas,
      "Width: ${stone.width} mm",
      Offset(center.dx, widthY - 15),
    );

    // Length Bar (Right)
    double lengthX = center.dx + w / 2 + 35;
    canvas.drawLine(
      Offset(lengthX, center.dy - h / 2),
      Offset(lengthX, center.dy + h / 2),
      infoPaint,
    );
    _drawText(
      canvas,
      "Length: ${stone.length} mm",
      Offset(lengthX + 50, center.dy),
    );

    // Ratio Label (Bottom)
    _drawText(
      canvas,
      "Length to Width: ${stone.ratio.toStringAsFixed(2)} to 1",
      Offset(center.dx, center.dy + h / 2 + 45),
      isGrey: true,
    );
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset pos, {
    bool isGrey = false,
  }) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: isGrey ? Colors.grey.shade700 : const Color(0xFF008080),
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(pos.dx - tp.width / 2, pos.dy - tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DiamondProfilePainter extends CustomPainter {
  final GmssStone stone;
  DiamondProfilePainter({required this.stone});

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.grey.shade600
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final infoPaint = Paint()
      ..color = const Color(0xFF008080)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final dashedPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    // Adjust multipliers to ensure text doesn't go off-screen
    final double width = size.width * 0.55;
    final double centerX = size.width / 2;
    final double startY = 70.0;

    final double tableWidth = width * (stone.table / 100);
    final double totalHeight = width * (stone.depth / 100);
    final double crownHeight = totalHeight * 0.25;

    // 1. Draw Dashed Boundary Box
    _drawDashedRect(canvas, centerX, width, startY, totalHeight, dashedPaint);

    // 2. Draw Diamond Shape
    final Path path = Path();
    path.moveTo(centerX - tableWidth / 2, startY);
    path.lineTo(centerX + tableWidth / 2, startY);
    path.lineTo(centerX + width / 2, startY + crownHeight);
    path.lineTo(centerX + width / 2, startY + crownHeight + 4);
    path.lineTo(centerX, startY + totalHeight);
    path.lineTo(centerX - width / 2, startY + crownHeight + 4);
    path.lineTo(centerX - width / 2, startY + crownHeight);
    path.close();
    canvas.drawPath(path, linePaint);

    // 3. Table % Indicator with Arrows
    double tableLineY = startY - 15;
    canvas.drawLine(
      Offset(centerX - tableWidth / 2, tableLineY),
      Offset(centerX + tableWidth / 2, tableLineY),
      infoPaint,
    );
    _drawArrowHead(
      canvas,
      Offset(centerX - tableWidth / 2, tableLineY),
      0,
      infoPaint,
    );
    _drawArrowHead(
      canvas,
      Offset(centerX + tableWidth / 2, tableLineY),
      180,
      infoPaint,
    );
    _drawText(
      canvas,
      "Table %: ${stone.table.toInt()}%",
      Offset(centerX, tableLineY - 15),
    );

    // 4. Depth % Indicator with Arrows
    double depthX = centerX + width / 2 + 35;
    canvas.drawLine(
      Offset(depthX, startY),
      Offset(depthX, startY + totalHeight),
      infoPaint,
    );
    _drawArrowHead(canvas, Offset(depthX, startY), 90, infoPaint);
    _drawArrowHead(
      canvas,
      Offset(depthX, startY + totalHeight),
      270,
      infoPaint,
    );
    _drawText(
      canvas,
      "Depth %: ${stone.depth}%",
      Offset(depthX + 45, startY + totalHeight / 2 - 10),
    );
    _drawText(
      canvas,
      "Depth: ${stone.length} mm",
      Offset(depthX + 45, startY + totalHeight / 2 + 10),
    );

    // 5. Girdle Callout
    _drawIndicator(
      canvas,
      Offset(centerX + width / 4, startY + crownHeight + 2),
      "Girdle: ${stone.gridle_condition}",
      infoPaint,
      true,
    );

    // 6. Culet Callout
    _drawIndicator(
      canvas,
      Offset(centerX - 5, startY + totalHeight - 5),
      "Culet: ${stone.culet_size}",
      infoPaint,
      false,
    );
  }

  void _drawDashedRect(
    Canvas canvas,
    double cx,
    double w,
    double sy,
    double h,
    Paint paint,
  ) {
    double dashWidth = 4, dashSpace = 4;
    // Top dashed line
    for (
      double i = cx + w / 2;
      i < cx + w / 2 + 35;
      i += dashWidth + dashSpace
    ) {
      canvas.drawLine(Offset(i, sy), Offset(i + dashWidth, sy), paint);
    }
    // Bottom dashed line
    for (double i = cx; i < cx + w / 2 + 35; i += dashWidth + dashSpace) {
      canvas.drawLine(Offset(i, sy + h), Offset(i + dashWidth, sy + h), paint);
    }
  }

  void _drawIndicator(
    Canvas canvas,
    Offset point,
    String text,
    Paint paint,
    bool isGirdle,
  ) {
    canvas.drawCircle(point, 12, paint);
    Offset endPoint = isGirdle
        ? Offset(point.dx + 20, point.dy + 80)
        : Offset(point.dx - 40, point.dy + 40);
    canvas.drawLine(point, endPoint, paint);
    _drawText(canvas, text, Offset(endPoint.dx, endPoint.dy + 10));
  }

  void _drawArrowHead(
    Canvas canvas,
    Offset point,
    double angleDegrees,
    Paint paint,
  ) {
    final double arrowSize = 6.0;
    final double angle = angleDegrees * math.pi / 180;
    Path path = Path();
    path.moveTo(point.dx, point.dy);
    path.lineTo(
      point.dx + arrowSize * math.cos(angle - 0.5),
      point.dy + arrowSize * math.sin(angle - 0.5),
    );
    path.moveTo(point.dx, point.dy);
    path.lineTo(
      point.dx + arrowSize * math.cos(angle + 0.5),
      point.dy + arrowSize * math.sin(angle + 0.5),
    );
    canvas.drawPath(path, paint);
  }

  void _drawText(Canvas canvas, String text, Offset pos) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Color(0xFF008080),
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(pos.dx - tp.width / 2, pos.dy - tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
