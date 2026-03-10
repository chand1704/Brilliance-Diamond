import 'dart:math' as math;

import 'package:flutter/material.dart';

// BASE CLASS FOR MINIMAL SHAPES
abstract class MinimalShapePainter extends CustomPainter {
  final Color color;
  MinimalShapePainter({this.color = const Color(0xFF616161)});

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// 1. ROUND
class MinimalRoundPainter extends MinimalShapePainter {
  MinimalRoundPainter({super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;
    canvas.drawCircle(center, radius, paint);
    final double tableRadius = radius * 0.55;
    List<Offset> tablePoints = List.generate(8, (i) {
      double angle = (i * 45 - 22.5) * math.pi / 180;
      return Offset(
        center.dx + tableRadius * math.cos(angle),
        center.dy + tableRadius * math.sin(angle),
      );
    });
    canvas.drawPath(Path()..addPolygon(tablePoints, true), paint);
    for (int i = 0; i < 8; i++) {
      double bezelAngle = (i * 45 - 22.5) * math.pi / 180;
      canvas.drawLine(
        tablePoints[i],
        Offset(
          center.dx + radius * math.cos(bezelAngle),
          center.dy + radius * math.sin(bezelAngle),
        ),
        paint,
      );
      double starAngle = (i * 45 + 22.5) * math.pi / 180;
      Offset starPoint = Offset(
        center.dx + radius * math.cos(starAngle),
        center.dy + radius * math.sin(starAngle),
      );
      canvas.drawLine(tablePoints[i], starPoint, paint);
      canvas.drawLine(tablePoints[(i + 1) % 8], starPoint, paint);
    }
  }
}

// 2. EMERALD
class MinimalEmeraldPainter extends MinimalShapePainter {
  MinimalEmeraldPainter({super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final center = Offset(size.width / 2, size.height / 2);
    final w = size.width * 0.6;
    final h = size.height * 0.8;
    Rect rect = Rect.fromCenter(center: center, width: w, height: h);
    for (double i in [0.0, 8.0, 16.0, 28.0]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect.deflate(i), Radius.circular(15 - (i / 2))),
        paint,
      );
    }
    canvas.drawLine(
      Offset(rect.left + 15, rect.top),
      Offset(rect.left + 38, rect.top + 28),
      paint,
    );
    canvas.drawLine(
      Offset(rect.right - 15, rect.top),
      Offset(rect.right - 38, rect.top + 28),
      paint,
    );
    canvas.drawLine(
      Offset(rect.left + 15, rect.bottom),
      Offset(rect.left + 38, rect.bottom - 28),
      paint,
    );
    canvas.drawLine(
      Offset(rect.right - 15, rect.bottom),
      Offset(rect.right - 38, rect.bottom - 28),
      paint,
    );
  }
}

// 3. PRINCESS
class MinimalPrincessPainter extends MinimalShapePainter {
  MinimalPrincessPainter({super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final center = Offset(size.width / 2, size.height / 2);
    final s = size.width * 0.75;
    Rect outer = Rect.fromCenter(center: center, width: s, height: s);
    Rect inner = Rect.fromCenter(
      center: center,
      width: s * 0.65,
      height: s * 0.65,
    );
    canvas.drawRect(outer, paint);
    canvas.drawRect(inner, paint);
    canvas.drawLine(outer.topLeft, inner.topLeft, paint);
    canvas.drawLine(outer.topRight, inner.topRight, paint);
    canvas.drawLine(outer.bottomLeft, inner.bottomLeft, paint);
    canvas.drawLine(outer.bottomRight, inner.bottomRight, paint);
    canvas.drawLine(inner.topLeft, Offset(center.dx, outer.top), paint);
    canvas.drawLine(inner.topRight, Offset(center.dx, outer.top), paint);
  }
}

// 4. CUSHION
class MinimalCushionPainter extends MinimalShapePainter {
  MinimalCushionPainter({super.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final center = Offset(size.width / 2, size.height / 2);
    final double h = size.height * 0.7;
    final double w = h * 0.9; // Slightly less than square for cushion look

    // Outer Girdle (Rounded Rectangle / Pillow Shape)
    RRect outerRRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: w, height: h),
      const Radius.circular(20), // Soft rounded corners
    );
    canvas.drawRRect(outerRRect, paint);

    // Table Facet (Inner Octagon-like shape)
    final double tableW = w * 0.55;
    final double tableH = h * 0.55;
    RRect tableRRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: tableW, height: tableH),
      const Radius.circular(8),
    );
    canvas.drawRRect(tableRRect, paint);

    // Facet Lines (Connecting table to the curved corners)
    // Corner Lines
    canvas.drawLine(
      Offset(outerRRect.left + 10, outerRRect.top + 10),
      Offset(tableRRect.left, tableRRect.top),
      paint,
    );
    canvas.drawLine(
      Offset(outerRRect.right - 10, outerRRect.top + 10),
      Offset(tableRRect.right, tableRRect.top),
      paint,
    );
    canvas.drawLine(
      Offset(outerRRect.left + 10, outerRRect.bottom - 10),
      Offset(tableRRect.left, tableRRect.bottom),
      paint,
    );
    canvas.drawLine(
      Offset(outerRRect.right - 10, outerRRect.bottom - 10),
      Offset(tableRRect.right, tableRRect.bottom),
      paint,
    );

    // Side Midpoint Lines
    canvas.drawLine(
      Offset(center.dx, outerRRect.top),
      Offset(center.dx, tableRRect.top),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx, outerRRect.bottom),
      Offset(center.dx, tableRRect.bottom),
      paint,
    );
    canvas.drawLine(
      Offset(outerRRect.left, center.dy),
      Offset(tableRRect.left, center.dy),
      paint,
    );
    canvas.drawLine(
      Offset(outerRRect.right, center.dy),
      Offset(tableRRect.right, center.dy),
      paint,
    );
  }
}

// 5. RADIANT
class MinimalRadiantPainter extends MinimalShapePainter {
  MinimalRadiantPainter({super.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final center = Offset(size.width / 2, size.height / 2);

    // Radiant cuts are typically rectangular (Ratio ~1.3 to 1.4)
    final double h = size.height * 0.75;
    final double w = h / 1.35;
    final double crop = 12.0; // The size of the clipped corners

    // 1. Outer Girdle (Rectangular with Cropped Corners)
    final Path outerPath = _getRadiantPath(center, w, h, crop);
    canvas.drawPath(outerPath, paint);

    // 2. Table Facet (Inner Cropped Rectangle)
    final double tw = w * 0.5;
    final double th = h * 0.5;
    final double tCrop = crop * 0.5;
    final Path tablePath = _getRadiantPath(center, tw, th, tCrop);
    canvas.drawPath(tablePath, paint);

    // 3. Facet Lines (Connecting table corners to girdle corners)
    // Top-Left Corner
    canvas.drawLine(
      Offset(center.dx - tw / 2 + tCrop, center.dy - th / 2),
      Offset(center.dx - w / 2 + crop, center.dy - h / 2),
      paint,
    );
    // Top-Right Corner
    canvas.drawLine(
      Offset(center.dx + tw / 2 - tCrop, center.dy - th / 2),
      Offset(center.dx + w / 2 - crop, center.dy - h / 2),
      paint,
    );
    // Bottom-Left Corner
    canvas.drawLine(
      Offset(center.dx - tw / 2 + tCrop, center.dy + th / 2),
      Offset(center.dx - w / 2 + crop, center.dy + h / 2),
      paint,
    );
    // Bottom-Right Corner
    canvas.drawLine(
      Offset(center.dx + tw / 2 - tCrop, center.dy + th / 2),
      Offset(center.dx + w / 2 - crop, center.dy + h / 2),
      paint,
    );

    // Side Midpoints (Cross-hair effect)
    canvas.drawLine(
      Offset(center.dx, center.dy - th / 2),
      Offset(center.dx, center.dy - h / 2),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy + th / 2),
      Offset(center.dx, center.dy + h / 2),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx - tw / 2, center.dy),
      Offset(center.dx - w / 2, center.dy),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx + tw / 2, center.dy),
      Offset(center.dx + w / 2, center.dy),
      paint,
    );
  }

  Path _getRadiantPath(Offset center, double w, double h, double crop) {
    return Path()
      ..moveTo(center.dx - w / 2 + crop, center.dy - h / 2)
      ..lineTo(center.dx + w / 2 - crop, center.dy - h / 2)
      ..lineTo(center.dx + w / 2, center.dy - h / 2 + crop)
      ..lineTo(center.dx + w / 2, center.dy + h / 2 - crop)
      ..lineTo(center.dx + w / 2 - crop, center.dy + h / 2)
      ..lineTo(center.dx - w / 2 + crop, center.dy + h / 2)
      ..lineTo(center.dx - w / 2, center.dy + h / 2 - crop)
      ..lineTo(center.dx - w / 2, center.dy - h / 2 + crop)
      ..close();
  }
}

// 6. MARQUISE
class MinimalMarquisePainter extends MinimalShapePainter {
  MinimalMarquisePainter({super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final center = Offset(size.width / 2, size.height / 2);
    final double h = size.height * 0.8;
    final double w = h / 2.0;

    final Path outer = Path();
    outer.moveTo(center.dx, center.dy - h / 2);
    outer.quadraticBezierTo(
      center.dx + w,
      center.dy,
      center.dx,
      center.dy + h / 2,
    );
    outer.quadraticBezierTo(
      center.dx - w,
      center.dy,
      center.dx,
      center.dy - h / 2,
    );
    canvas.drawPath(outer, paint);

    final double tw = w * 0.4;
    final double th = h * 0.4;
    canvas.drawLine(
      Offset(center.dx, center.dy - th / 2),
      Offset(center.dx + tw / 2, center.dy),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx + tw / 2, center.dy),
      Offset(center.dx, center.dy + th / 2),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy + th / 2),
      Offset(center.dx - tw / 2, center.dy),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx - tw / 2, center.dy),
      Offset(center.dx, center.dy - th / 2),
      paint,
    );

    canvas.drawLine(
      Offset(center.dx, center.dy - h / 2),
      Offset(center.dx, center.dy - th / 2),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy + h / 2),
      Offset(center.dx, center.dy + th / 2),
      paint,
    );
  }
}

// 7. PEAR
class MinimalPearPainter extends MinimalShapePainter {
  MinimalPearPainter({super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final center = Offset(size.width / 2, size.height / 2);
    final double h = size.height * 0.7;
    final double w = h / 1.5;
    final double headY = center.dy - (h * 0.15);

    final Path outer = Path();
    outer.addArc(
      Rect.fromCircle(center: Offset(center.dx, headY), radius: w / 2),
      math.pi,
      math.pi,
    );
    outer.moveTo(center.dx - w / 2, headY);
    outer.quadraticBezierTo(
      center.dx - w / 2,
      center.dy + (h * 0.1),
      center.dx,
      center.dy + (h * 0.45),
    );
    outer.quadraticBezierTo(
      center.dx + w / 2,
      center.dy + (h * 0.1),
      center.dx + w / 2,
      headY,
    );
    canvas.drawPath(outer, paint);
    canvas.drawCircle(Offset(center.dx, headY), w * 0.22, paint);
    canvas.drawLine(
      Offset(center.dx, headY + (w * 0.22)),
      Offset(center.dx, center.dy + h * 0.45),
      paint,
    );
  }
}

// 8. OVAL
class MinimalOvalPainter extends MinimalShapePainter {
  MinimalOvalPainter({super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final center = Offset(size.width / 2, size.height / 2);
    final double h = size.height * 0.75;
    final double w = h / 1.4;

    canvas.drawOval(
      Rect.fromCenter(center: center, width: w, height: h),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: center, width: w * 0.5, height: h * 0.5),
      paint,
    );
    for (int i = 0; i < 8; i++) {
      double angle = (i * 45) * math.pi / 180;
      canvas.drawLine(
        Offset(
          center.dx + (w * 0.25) * math.cos(angle),
          center.dy + (h * 0.25) * math.sin(angle),
        ),
        Offset(
          center.dx + (w * 0.5) * math.cos(angle),
          center.dy + (h * 0.5) * math.sin(angle),
        ),
        paint,
      );
    }
  }
}

// 9. HEART
class MinimalHeartPainter extends MinimalShapePainter {
  MinimalHeartPainter({super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final center = Offset(size.width / 2, size.height / 2);
    final double h = size.height * 0.7;
    final double w = h / 1.1;

    final Path heart = Path();
    double cleftY = center.dy - h * 0.2;
    heart.moveTo(center.dx, cleftY);
    heart.cubicTo(
      center.dx - w * 0.5,
      center.dy - h * 0.5,
      center.dx - w * 0.7,
      center.dy + h * 0.1,
      center.dx,
      center.dy + h * 0.5,
    );
    heart.moveTo(center.dx, cleftY);
    heart.cubicTo(
      center.dx + w * 0.5,
      center.dy - h * 0.5,
      center.dx + w * 0.7,
      center.dy + h * 0.1,
      center.dx,
      center.dy + h * 0.5,
    );
    canvas.drawPath(heart, paint);

    // Minimal table facet
    canvas.drawLine(
      Offset(center.dx, center.dy - h * 0.05),
      Offset(center.dx + w * 0.15, center.dy + h * 0.1),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx + w * 0.15, center.dy + h * 0.1),
      Offset(center.dx, center.dy + h * 0.3),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy + h * 0.3),
      Offset(center.dx - w * 0.15, center.dy + h * 0.1),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx - w * 0.15, center.dy + h * 0.1),
      Offset(center.dx, center.dy - h * 0.05),
      paint,
    );
  }
}

// 10. ASSCHER
class MinimalAsscherPainter extends MinimalShapePainter {
  MinimalAsscherPainter({super.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final center = Offset(size.width / 2, size.height / 2);
    final double s = size.width * 0.7;
    final double crop = s * 0.25;

    Path getAsscher(double side, double c) {
      return Path()
        ..moveTo(center.dx - side / 2 + c, center.dy - side / 2)
        ..lineTo(center.dx + side / 2 - c, center.dy - side / 2)
        ..lineTo(center.dx + side / 2, center.dy - side / 2 + c)
        ..lineTo(center.dx + side / 2, center.dy + side / 2 - c)
        ..lineTo(center.dx + side / 2 - c, center.dy + side / 2)
        ..lineTo(center.dx - side / 2 + c, center.dy + side / 2)
        ..lineTo(center.dx - side / 2, center.dy + side / 2 - c)
        ..lineTo(center.dx - side / 2, center.dy - side / 2 + c)
        ..close();
    }

    canvas.drawPath(getAsscher(s, crop), paint);
    canvas.drawPath(getAsscher(s * 0.7, crop * 0.7), paint);
    canvas.drawPath(getAsscher(s * 0.4, crop * 0.4), paint);

    // Connect corners for step-cut look
    canvas.drawLine(
      Offset(center.dx - s / 2 + crop, center.dy - s / 2),
      Offset(center.dx - s * 0.2 + crop * 0.4, center.dy - s * 0.2),
      paint,
    );
  }
}
