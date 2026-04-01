import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'model/gmss_stone_model.dart';

//Round
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
      ..color = const Color(0xFF008080)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final guidePaint =
        Paint() // Added for the dashed guide lines
          ..color = Colors.grey.shade300
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = 80.0;
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
      Offset girdlePoint = Offset(
        center.dx + radius * math.cos(bezelAngle),
        center.dy + radius * math.sin(bezelAngle),
      );
      canvas.drawLine(tablePoints[i], girdlePoint, paint);
      double starAngle = (i * 45 + 22.5) * math.pi / 180;
      Offset starPoint = Offset(
        center.dx + radius * math.cos(starAngle),
        center.dy + radius * math.sin(starAngle),
      );
      canvas.drawLine(tablePoints[i], starPoint, paint);
      canvas.drawLine(tablePoints[(i + 1) % 8], starPoint, paint);
    }
    _drawDimensions(canvas, center, radius, infoPaint, guidePaint);
  }

  void _drawDimensions(
    Canvas canvas,
    Offset center,
    double radius,
    Paint infoPaint,
    Paint guidePaint,
  ) {
    double widthY = center.dy - radius - 35;
    Offset startW = Offset(center.dx - radius, widthY);
    Offset endW = Offset(center.dx + radius, widthY);
    // Draw dashed guides
    _drawDashedLine(
      canvas,
      Offset(startW.dx, startW.dy + 5),
      Offset(startW.dx, center.dy - radius),
      guidePaint,
    );
    _drawDashedLine(
      canvas,
      Offset(endW.dx, endW.dy + 5),
      Offset(endW.dx, center.dy - radius),
      guidePaint,
    );
    canvas.drawLine(startW, endW, infoPaint);
    _drawArrowHead(canvas, startW, 0, infoPaint);
    _drawArrowHead(canvas, endW, 180, infoPaint);
    _drawText(
      canvas,
      "Width: ${stone.width} mm",
      Offset(center.dx, widthY - 10),
    );
    double lengthX = center.dx + radius + 35;
    Offset topL = Offset(lengthX, center.dy - radius);
    Offset bottomL = Offset(lengthX, center.dy + radius);
    _drawDashedLine(
      canvas,
      Offset(topL.dx - 5, topL.dy),
      Offset(center.dx + radius, topL.dy),
      guidePaint,
    );
    _drawDashedLine(
      canvas,
      Offset(bottomL.dx - 5, bottomL.dy),
      Offset(center.dx + radius, bottomL.dy),
      guidePaint,
    );
    canvas.drawLine(topL, bottomL, infoPaint);
    _drawArrowHead(canvas, topL, 90, infoPaint);
    _drawArrowHead(canvas, bottomL, 270, infoPaint);
    _drawText(
      canvas,
      "Length: ${stone.length} mm",
      Offset(lengthX + 55, center.dy),
    );
    _drawText(
      canvas,
      "Length to Width: ${stone.ratio.toStringAsFixed(2)} to 1",
      Offset(center.dx, center.dy + radius + 40),
      isGrey: true,
    );
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    double dashWidth = 4, dashSpace = 4;
    double distance = (p2 - p1).distance;
    for (double i = 0; i < distance; i += dashWidth + dashSpace) {
      canvas.drawLine(
        Offset(
          p1.dx + (p2.dx - p1.dx) * i / distance,
          p1.dy + (p2.dy - p1.dy) * i / distance,
        ),
        Offset(
          p1.dx + (p2.dx - p1.dx) * (i + dashWidth) / distance,
          p1.dy + (p2.dy - p1.dy) * (i + dashWidth) / distance,
        ),
        paint,
      );
    }
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

//Princess
class PrincessTopViewPainter extends CustomPainter {
  final GmssStone stone;
  PrincessTopViewPainter({required this.stone});
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
    final guidePaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    final center = Offset(size.width / 2, size.height / 2);
    final double h = 160.0; // Fixed visual height
    final double w = 160.0; // Fixed visual width (Square)
    Rect outerRect = Rect.fromCenter(center: center, width: w, height: h);
    canvas.drawRect(outerRect, paint);
    final double tableW = w * 0.65;
    final double tableH = h * 0.65;
    Rect tableRect = Rect.fromCenter(
      center: center,
      width: tableW,
      height: tableH,
    );
    canvas.drawRect(tableRect, paint);
    _drawPrincessFacets(canvas, outerRect, tableRect, paint);
    _drawDimensions(canvas, center, w, h, infoPaint, guidePaint);
  }

  void _drawPrincessFacets(Canvas canvas, Rect outer, Rect inner, Paint paint) {
    canvas.drawLine(outer.topLeft, inner.topLeft, paint);
    canvas.drawLine(outer.topRight, inner.topRight, paint);
    canvas.drawLine(outer.bottomLeft, inner.bottomLeft, paint);
    canvas.drawLine(outer.bottomRight, inner.bottomRight, paint);
    Offset topMid = Offset(outer.center.dx, outer.top);
    Offset bottomMid = Offset(outer.center.dx, outer.bottom);
    Offset leftMid = Offset(outer.left, outer.center.dy);
    Offset rightMid = Offset(outer.right, outer.center.dy);
    canvas.drawLine(inner.topLeft, topMid, paint);
    canvas.drawLine(inner.topRight, topMid, paint);
    canvas.drawLine(inner.bottomLeft, bottomMid, paint);
    canvas.drawLine(inner.bottomRight, bottomMid, paint);
    canvas.drawLine(inner.topLeft, leftMid, paint);
    canvas.drawLine(inner.bottomLeft, leftMid, paint);
    canvas.drawLine(inner.topRight, rightMid, paint);
    canvas.drawLine(inner.bottomRight, rightMid, paint);
  }

  void _drawDimensions(
    Canvas canvas,
    Offset center,
    double w,
    double h,
    Paint infoPaint,
    Paint guidePaint,
  ) {
    double widthY = center.dy - h / 2 - 35;
    Offset startW = Offset(center.dx - w / 2, widthY);
    Offset endW = Offset(center.dx + w / 2, widthY);
    canvas.drawLine(startW, endW, infoPaint);
    _drawDashedLine(
      canvas,
      Offset(startW.dx, startW.dy + 5),
      Offset(startW.dx, center.dy - h / 2),
      guidePaint,
    );
    _drawDashedLine(
      canvas,
      Offset(endW.dx, endW.dy + 5),
      Offset(endW.dx, center.dy - h / 2),
      guidePaint,
    );
    canvas.drawLine(startW, endW, infoPaint);
    _drawArrowHead(canvas, startW, 0, infoPaint);
    _drawArrowHead(canvas, endW, 180, infoPaint);
    _drawText(
      canvas,
      "Width: ${stone.width} mm",
      Offset(center.dx, widthY - 10),
    );
    double lengthX = center.dx + w / 2 + 35;
    Offset topL = Offset(lengthX, center.dy - h / 2);
    Offset bottomL = Offset(lengthX, center.dy + h / 2);
    _drawDashedLine(
      canvas,
      Offset(topL.dx - 5, topL.dy),
      Offset(center.dx + w / 2, topL.dy),
      guidePaint,
    );
    _drawDashedLine(
      canvas,
      Offset(bottomL.dx - 5, bottomL.dy),
      Offset(center.dx + w / 2, bottomL.dy),
      guidePaint,
    );
    canvas.drawLine(topL, bottomL, infoPaint);
    _drawText(
      canvas,
      "Length: ${stone.length} mm",
      Offset(lengthX + 50, center.dy),
    );
    _drawText(
      canvas,
      "Length to Width: ${stone.ratio.toStringAsFixed(2)} to 1",
      Offset(center.dx, center.dy + h / 2 + 45),
      isGrey: true,
    );
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    double dashWidth = 4, dashSpace = 4;
    double distance = (p2 - p1).distance;
    for (double i = 0; i < distance; i += dashWidth + dashSpace) {
      canvas.drawLine(
        Offset(
          p1.dx + (p2.dx - p1.dx) * i / distance,
          p1.dy + (p2.dy - p1.dy) * i / distance,
        ),
        Offset(
          p1.dx + (p2.dx - p1.dx) * (i + dashWidth) / distance,
          p1.dy + (p2.dy - p1.dy) * (i + dashWidth) / distance,
        ),
        paint,
      );
    }
  }

  void _drawArrowHead(
    Canvas canvas,
    Offset point,
    double angleDegrees,
    Paint paint,
  ) {
    final double arrowSize = 6.0;
    final double angle = angleDegrees * (3.14159 / 180);
    Path path = Path()
      ..moveTo(point.dx, point.dy)
      ..lineTo(
        point.dx + arrowSize * math.cos(angle - 0.5),
        point.dy + arrowSize * math.sin(angle - 0.5),
      )
      ..moveTo(point.dx, point.dy)
      ..lineTo(
        point.dx + arrowSize * math.cos(angle + 0.5),
        point.dy + arrowSize * math.sin(angle + 0.5),
      );
    canvas.drawPath(path, paint);
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

//Emerald
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
    final guidePaint =
        Paint() // Added for dashed guide lines
          ..color = Colors.grey.shade300
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8;

    final center = Offset(size.width / 2, size.height / 2);

    // Fixed visual dimensions to keep diagram consistent
    const double visualH = 180.0;
    const double visualW = 130.0;

    Rect outerRect = Rect.fromCenter(
      center: center,
      width: visualW,
      height: visualH,
    );

    // 1. Draw Emerald Geometry
    _drawEmeraldRect(canvas, outerRect, 15, paint);
    _drawEmeraldRect(canvas, outerRect.deflate(10), 12, paint);
    _drawEmeraldRect(canvas, outerRect.deflate(20), 8, paint);
    _drawEmeraldRect(canvas, outerRect.deflate(35), 5, paint);
    _drawCornerLines(canvas, outerRect, outerRect.deflate(35), paint);

    // 2. Draw Dimensions with technical arrows and guides
    _drawDimensions(canvas, center, visualW, visualH, infoPaint, guidePaint);
  }

  void _drawEmeraldRect(Canvas canvas, Rect rect, double radius, Paint paint) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(radius)),
      paint,
    );
  }

  void _drawCornerLines(Canvas canvas, Rect outer, Rect inner, Paint paint) {
    canvas.drawLine(
      Offset(outer.left + 15, outer.top),
      Offset(inner.left + 5, inner.top),
      paint,
    );
    canvas.drawLine(
      Offset(outer.right - 15, outer.top),
      Offset(inner.right - 5, inner.top),
      paint,
    );
    canvas.drawLine(
      Offset(outer.left + 15, outer.bottom),
      Offset(inner.left + 5, inner.bottom),
      paint,
    );
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
    Paint guidePaint,
  ) {
    // --- 1. HORIZONTAL WIDTH ---
    double widthY = center.dy - h / 2 - 35;
    Offset startW = Offset(center.dx - w / 2, widthY);
    Offset endW = Offset(center.dx + w / 2, widthY);

    // Dashed Guides
    _drawDashedLine(
      canvas,
      Offset(startW.dx, startW.dy + 5),
      Offset(startW.dx, center.dy - h / 2),
      guidePaint,
    );
    _drawDashedLine(
      canvas,
      Offset(endW.dx, endW.dy + 5),
      Offset(endW.dx, center.dy - h / 2),
      guidePaint,
    );

    // Arrow Line
    canvas.drawLine(startW, endW, infoPaint);
    _drawArrowHead(canvas, startW, 0, infoPaint);
    _drawArrowHead(canvas, endW, 180, infoPaint);

    // Label on arrow
    _drawText(
      canvas,
      "Width: ${stone.width.toStringAsFixed(2)} mm",
      Offset(center.dx, widthY - 10),
    );

    // --- 2. VERTICAL LENGTH ---
    double lengthX = center.dx + w / 2 + 35;
    Offset topL = Offset(lengthX, center.dy - h / 2);
    Offset bottomL = Offset(lengthX, center.dy + h / 2);

    // Dashed Guides
    _drawDashedLine(
      canvas,
      Offset(topL.dx - 5, topL.dy),
      Offset(center.dx + w / 2, topL.dy),
      guidePaint,
    );
    _drawDashedLine(
      canvas,
      Offset(bottomL.dx - 5, bottomL.dy),
      Offset(center.dx + w / 2, bottomL.dy),
      guidePaint,
    );

    // Arrow Line
    canvas.drawLine(topL, bottomL, infoPaint);
    _drawArrowHead(canvas, topL, 90, infoPaint);
    _drawArrowHead(canvas, bottomL, 270, infoPaint);

    // Label to the right
    _drawText(
      canvas,
      "Length: ${stone.length.toStringAsFixed(2)} mm",
      Offset(lengthX + 55, center.dy),
    );

    // --- 3. RATIO ---
    _drawText(
      canvas,
      "Length to Width: ${stone.ratio.toStringAsFixed(2)} to 1",
      Offset(center.dx, center.dy + h / 2 + 45),
      isGrey: true,
    );
  }

  // HELPER: Draw dashed guide lines
  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    double dashWidth = 4, dashSpace = 4;
    double distance = (p2 - p1).distance;
    for (double i = 0; i < distance; i += dashWidth + dashSpace) {
      canvas.drawLine(
        Offset(
          p1.dx + (p2.dx - p1.dx) * i / distance,
          p1.dy + (p2.dy - p1.dy) * i / distance,
        ),
        Offset(
          p1.dx + (p2.dx - p1.dx) * (i + dashWidth) / distance,
          p1.dy + (p2.dy - p1.dy) * (i + dashWidth) / distance,
        ),
        paint,
      );
    }
  }

  // HELPER: Draw arrowheads
  void _drawArrowHead(
    Canvas canvas,
    Offset point,
    double angleDegrees,
    Paint paint,
  ) {
    final double arrowSize = 6.0;
    final double angle = angleDegrees * math.pi / 180;
    Path path = Path()
      ..moveTo(point.dx, point.dy)
      ..lineTo(
        point.dx + arrowSize * math.cos(angle - 0.5),
        point.dy + arrowSize * math.sin(angle - 0.5),
      )
      ..moveTo(point.dx, point.dy)
      ..lineTo(
        point.dx + arrowSize * math.cos(angle + 0.5),
        point.dy + arrowSize * math.sin(angle + 0.5),
      );
    canvas.drawPath(path, paint);
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

//Cushion
class CushionTopViewPainter extends CustomPainter {
  final GmssStone stone;
  CushionTopViewPainter({required this.stone});
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
    final guidePaint =
        Paint() // ADDED: Paint for the dashed gray lines
          ..color = Colors.grey.shade300
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8;
    final center = Offset(size.width / 2, size.height / 2);
    const double visualH = 160.0;
    const double visualW = 160.0; // Fixed square-ish cushion for diagram
    RRect outerRRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: visualW, height: visualH),
      const Radius.circular(35),
    );
    canvas.drawRRect(outerRRect, paint);
    final double tableW = visualW * 0.55;
    final double tableH = visualH * 0.55;
    RRect tableRRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: tableW, height: tableH),
      const Radius.circular(10),
    );
    canvas.drawRRect(tableRRect, paint);
    _drawCushionFacets(canvas, center, outerRRect, tableRRect, paint);
    _drawDimensions(canvas, center, visualW, visualH, infoPaint, guidePaint);
  }

  Offset _getPointOnBezier(Offset p0, Offset p1, Offset p2, double t) {
    double u = 1 - t;
    double tt = t * t;
    double uu = u * u;
    return Offset(
      (uu * p0.dx) + (2 * u * t * p1.dx) + (tt * p2.dx),
      (uu * p0.dy) + (2 * u * t * p1.dy) + (tt * p2.dy),
    );
  }

  void _drawCushionFacets(
    Canvas canvas,
    Offset center,
    RRect outer,
    RRect inner,
    Paint paint,
  ) {
    final Path mainPavilionPath = Path();

    // 1. Calculate mainMeetingPoint and pavilionMainMeetingPoint along center axises
    Offset mainMeetingPoint = Offset(
      center.dx,
      outer.top + (inner.top - outer.top) / 2.0,
    );
    Offset pavilionMainMeetingPoint = Offset(
      center.dx,
      outer.bottom - (outer.bottom - inner.bottom) / 2.0,
    );

    mainPavilionPath.moveTo(inner.center.dx, inner.top);
    mainPavilionPath.lineTo(mainMeetingPoint.dx, mainMeetingPoint.dy);
    mainPavilionPath.lineTo(center.dx, outer.top);

    mainPavilionPath.moveTo(inner.center.dx, inner.bottom);
    mainPavilionPath.lineTo(
      pavilionMainMeetingPoint.dx,
      pavilionMainMeetingPoint.dy,
    );
    mainPavilionPath.lineTo(center.dx, outer.bottom);

    // Horizontal meeting points
    Offset rightMainMeetingPoint = Offset(
      outer.right - (outer.right - inner.right) / 2.0,
      center.dy,
    );
    Offset leftMainMeetingPoint = Offset(
      outer.left + (inner.left - outer.left) / 2.0,
      center.dy,
    );

    mainPavilionPath.moveTo(inner.right, inner.center.dy);
    mainPavilionPath.lineTo(rightMainMeetingPoint.dx, rightMainMeetingPoint.dy);
    mainPavilionPath.lineTo(outer.right, center.dy);

    mainPavilionPath.moveTo(inner.left, inner.center.dy);
    mainPavilionPath.lineTo(leftMainMeetingPoint.dx, leftMainMeetingPoint.dy);
    mainPavilionPath.lineTo(outer.left, center.dy);

    // 2. Draw star and bezel points around the detailed shape
    for (int i = 0; i < 4; i++) {
      bool isTop = i < 2;
      bool isLeft = i % 2 == 0;

      // Define bezier points along the corner curves
      Offset bezierP0 = isLeft
          ? Offset(outer.left + 35, outer.top)
          : Offset(outer.right - 35, outer.top);
      Offset bezierP1 = isLeft
          ? Offset(outer.left, outer.top)
          : Offset(outer.right, outer.top);
      Offset bezierP2 = isLeft
          ? Offset(outer.left, outer.top + 35)
          : Offset(outer.right, outer.top + 35);

      // Invert points for bottom corners
      if (!isTop) {
        bezierP0 = isLeft
            ? Offset(outer.left + 35, outer.bottom)
            : Offset(outer.right - 35, outer.bottom);
        bezierP1 = isLeft
            ? Offset(outer.left, outer.bottom)
            : Offset(outer.right, outer.bottom);
        bezierP2 = isLeft
            ? Offset(outer.left, outer.bottom - 35)
            : Offset(outer.right, outer.bottom - 35);
      }

      // Meeting Point along the curve
      Offset curveMeetingPoint = _getPointOnBezier(
        bezierP0,
        bezierP1,
        bezierP2,
        0.5,
      );

      // meeting points along the bezel curves
      Offset curveStarPoint = _getPointOnBezier(
        bezierP0,
        bezierP1,
        bezierP2,
        0.3,
      );
      Offset curveStarMeetingPoint = _getPointOnBezier(
        bezierP0,
        bezierP1,
        bezierP2,
        0.7,
      );

      // Connect to inner table points
      Offset tableCorner;
      if (isTop) {
        tableCorner = isLeft
            ? Offset(inner.left, inner.top)
            : Offset(inner.right, inner.top);
      } else {
        tableCorner = isLeft
            ? Offset(inner.left, inner.bottom) // Instead of inner.bottomLeft
            : Offset(inner.right, inner.bottom); // Instead of inner.bottomRight
      }
      Offset horizontalMainPoint = isLeft
          ? leftMainMeetingPoint
          : rightMainMeetingPoint;
      Offset verticalMainPoint = isTop
          ? mainMeetingPoint
          : pavilionMainMeetingPoint;

      // Draw brilliant cut facets connecting corners and mains
      mainPavilionPath.moveTo(tableCorner.dx, tableCorner.dy);
      mainPavilionPath.lineTo(curveMeetingPoint.dx, curveMeetingPoint.dy);

      mainPavilionPath.moveTo(curveStarPoint.dx, curveStarPoint.dy);
      mainPavilionPath.lineTo(verticalMainPoint.dx, verticalMainPoint.dy);
      mainPavilionPath.lineTo(tableCorner.dx, tableCorner.dy);
      mainPavilionPath.lineTo(horizontalMainPoint.dx, horizontalMainPoint.dy);
      mainPavilionPath.lineTo(
        curveStarMeetingPoint.dx,
        curveStarMeetingPoint.dy,
      );
    }

    canvas.drawPath(mainPavilionPath, paint);
  }

  void _drawDimensions(
    Canvas canvas,
    Offset center,
    double w,
    double h,
    Paint infoPaint,
    Paint guidePaint,
  ) {
    double widthY = center.dy - h / 2 - 35;

    Offset startW = Offset(center.dx - w / 2, widthY);
    Offset endW = Offset(center.dx + w / 2, widthY);
    // Draw dashed guides for width
    _drawDashedLine(
      canvas,
      Offset(startW.dx, startW.dy + 5),
      Offset(startW.dx, center.dy - h / 2),
      guidePaint,
    );
    _drawDashedLine(
      canvas,
      Offset(endW.dx, endW.dy + 5),
      Offset(endW.dx, center.dy - h / 2),
      guidePaint,
    );
    canvas.drawLine(startW, endW, infoPaint);
    _drawArrowHead(canvas, startW, 0, infoPaint);
    _drawArrowHead(canvas, endW, 180, infoPaint);
    _drawText(
      canvas,
      "Width: ${stone.width} mm",
      Offset(center.dx, widthY - 10),
    );
    double lengthX = center.dx + w / 2 + 35;
    Offset topL = Offset(lengthX, center.dy - h / 2);
    Offset bottomL = Offset(lengthX, center.dy + h / 2);
    // Draw dashed guides for length
    _drawDashedLine(
      canvas,
      Offset(topL.dx - 5, topL.dy),
      Offset(center.dx + w / 2, topL.dy),
      guidePaint,
    );
    _drawDashedLine(
      canvas,
      Offset(bottomL.dx - 5, bottomL.dy),
      Offset(center.dx + w / 2, bottomL.dy),
      guidePaint,
    );
    canvas.drawLine(topL, bottomL, infoPaint);
    _drawArrowHead(canvas, topL, 90, infoPaint);
    _drawArrowHead(canvas, bottomL, 270, infoPaint);
    _drawText(
      canvas,
      "Length: ${stone.length} mm",
      Offset(lengthX + 50, center.dy),
    );

    _drawText(
      canvas,
      "Length to Width: ${stone.ratio.toStringAsFixed(2)} to 1",
      Offset(center.dx, center.dy + h / 2 + 45),
      isGrey: true,
    );
  }

  void _drawArrowHead(
    Canvas canvas,
    Offset point,
    double angleDegrees,
    Paint paint,
  ) {
    final double arrowSize = 6.0;
    final double angle = angleDegrees * (3.14159 / 180);
    Path path = Path()
      ..moveTo(point.dx, point.dy)
      ..lineTo(
        point.dx + arrowSize * math.cos(angle - 0.5),
        point.dy + arrowSize * math.sin(angle - 0.5),
      )
      ..moveTo(point.dx, point.dy)
      ..lineTo(
        point.dx + arrowSize * math.cos(angle + 0.5),
        point.dy + arrowSize * math.sin(angle + 0.5),
      );
    canvas.drawPath(path, paint);
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    double dashWidth = 4, dashSpace = 4;
    double distance = (p2 - p1).distance;
    for (double i = 0; i < distance; i += dashWidth + dashSpace) {
      canvas.drawLine(
        Offset(
          p1.dx + (p2.dx - p1.dx) * i / distance,
          p1.dy + (p2.dy - p1.dy) * i / distance,
        ),
        Offset(
          p1.dx + (p2.dx - p1.dx) * (i + dashWidth) / distance,
          p1.dy + (p2.dy - p1.dy) * (i + dashWidth) / distance,
        ),
        paint,
      );
    }
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

//Radiant
class RadiantTopViewPainter extends CustomPainter {
  final GmssStone stone;
  RadiantTopViewPainter({required this.stone});
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
    final guidePaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    final center = Offset(size.width / 2, size.height / 2);
    const double visualH = 180.0;
    const double visualW = 130.0; // Fixed width for the diagram

    final Path outerPath = _getRadiantPath(center, visualW, visualH, 15);
    canvas.drawPath(outerPath, paint);
    final double tableW = visualW * 0.5;
    final double tableH = visualH * 0.5;

    final Path tablePath = _getRadiantPath(center, tableW, tableH, 8);
    canvas.drawPath(tablePath, paint);
    _drawRadiantFacets(canvas, center, visualW, visualH, tableW, tableH, paint);
    _drawDimensions(canvas, center, visualW, visualH, infoPaint, guidePaint);
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

  void _drawRadiantFacets(
    Canvas canvas,
    Offset center,
    double w,
    double h,
    double tw,
    double th,
    Paint paint,
  ) {
    // Corner Facets (Connecting the cropped edges)
    canvas.drawLine(
      Offset(center.dx - w / 2 + 15, center.dy - h / 2),
      Offset(center.dx - tw / 2 + 8, center.dy - th / 2),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx + w / 2 - 15, center.dy - h / 2),
      Offset(center.dx + tw / 2 - 8, center.dy - th / 2),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx - w / 2 + 15, center.dy + h / 2),
      Offset(center.dx - tw / 2 + 8, center.dy + th / 2),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx + w / 2 - 15, center.dy + h / 2),
      Offset(center.dx + tw / 2 - 8, center.dy + th / 2),
      paint,
    );
    // // Inner Radiant "X" and center lines
    // canvas.drawLine(
    //   Offset(center.dx - tw / 2, center.dy - th / 2),
    //   Offset(center.dx + tw / 2, center.dy + th / 2),
    //   paint,
    // );
    // canvas.drawLine(
    //   Offset(center.dx + tw / 2, center.dy - th / 2),
    //   Offset(center.dx - tw / 2, center.dy + th / 2),
    //   paint,
    // );
    // Side Main Lines
    canvas.drawLine(
      Offset(center.dx - w / 2, center.dy),
      Offset(center.dx - tw / 2, center.dy),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx + w / 2, center.dy),
      Offset(center.dx + tw / 2, center.dy),
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

  void _drawDimensions(
    Canvas canvas,
    Offset center,
    double w,
    double h,
    Paint infoPaint,
    Paint guidePaint,
  ) {
    // --- WIDTH ---
    double widthY = center.dy - h / 2 - 35;
    Offset startW = Offset(center.dx - w / 2, widthY);
    Offset endW = Offset(center.dx + w / 2, widthY);

    _drawDashedLine(
      canvas,
      Offset(startW.dx, startW.dy + 5),
      Offset(startW.dx, center.dy - h / 2),
      guidePaint,
    );
    _drawDashedLine(
      canvas,
      Offset(endW.dx, endW.dy + 5),
      Offset(endW.dx, center.dy - h / 2),
      guidePaint,
    );

    canvas.drawLine(startW, endW, infoPaint);
    _drawArrowHead(canvas, startW, 0, infoPaint);
    _drawArrowHead(canvas, endW, 180, infoPaint);
    _drawText(
      canvas,
      "Width: ${stone.width.toStringAsFixed(2)} mm",
      Offset(center.dx, widthY - 10),
    );

    // --- LENGTH ---
    double lengthX = center.dx + w / 2 + 35;
    Offset topL = Offset(lengthX, center.dy - h / 2);
    Offset bottomL = Offset(lengthX, center.dy + h / 2);

    _drawDashedLine(
      canvas,
      Offset(topL.dx - 5, topL.dy),
      Offset(center.dx + w / 2, topL.dy),
      guidePaint,
    );
    _drawDashedLine(
      canvas,
      Offset(bottomL.dx - 5, bottomL.dy),
      Offset(center.dx + w / 2, bottomL.dy),
      guidePaint,
    );

    canvas.drawLine(topL, bottomL, infoPaint);
    _drawArrowHead(canvas, topL, 90, infoPaint);
    _drawArrowHead(canvas, bottomL, 270, infoPaint);
    _drawText(
      canvas,
      "Length: ${stone.length.toStringAsFixed(2)} mm",
      Offset(lengthX + 55, center.dy),
    );

    // --- RATIO ---
    _drawText(
      canvas,
      "Length to Width: ${stone.ratio.toStringAsFixed(2)} to 1",
      Offset(center.dx, center.dy + h / 2 + 45),
      isGrey: true,
    );
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    double dashWidth = 4, dashSpace = 4;
    double distance = (p2 - p1).distance;
    for (double i = 0; i < distance; i += dashWidth + dashSpace) {
      canvas.drawLine(
        Offset(
          p1.dx + (p2.dx - p1.dx) * i / distance,
          p1.dy + (p2.dy - p1.dy) * i / distance,
        ),
        Offset(
          p1.dx + (p2.dx - p1.dx) * (i + dashWidth) / distance,
          p1.dy + (p2.dy - p1.dy) * (i + dashWidth) / distance,
        ),
        paint,
      );
    }
  }

  void _drawArrowHead(
    Canvas canvas,
    Offset point,
    double angleDegrees,
    Paint paint,
  ) {
    final double arrowSize = 6.0;
    final double angle = angleDegrees * (3.14159 / 180);
    Path path = Path()
      ..moveTo(point.dx, point.dy)
      ..lineTo(
        point.dx + arrowSize * math.cos(angle - 0.5),
        point.dy + arrowSize * math.sin(angle - 0.5),
      )
      ..moveTo(point.dx, point.dy)
      ..lineTo(
        point.dx + arrowSize * math.cos(angle + 0.5),
        point.dy + arrowSize * math.sin(angle + 0.5),
      );
    canvas.drawPath(path, paint);
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

//Marquise
class MarquiseTopViewPainter extends CustomPainter {
  final GmssStone stone;
  MarquiseTopViewPainter({required this.stone});
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
    final guidePaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    final center = Offset(size.width / 2, size.height / 2);

    const double visualH = 220.0; // Increased for better Marquise look
    const double visualW = 110.0;
    final Path outerPath = Path();
    outerPath.moveTo(center.dx, center.dy - visualH / 2);
    outerPath.quadraticBezierTo(
      center.dx + visualW,
      center.dy,
      center.dx,
      center.dy + visualH / 2,
    );
    outerPath.quadraticBezierTo(
      center.dx - visualW,
      center.dy,
      center.dx,
      center.dy - visualH / 2,
    );
    canvas.drawPath(outerPath, paint);
    final double tableW = visualW * 0.4;
    final double tableH = visualH * 0.4;
    final Path tablePath = Path();
    tablePath.moveTo(center.dx, center.dy - tableH / 2);
    tablePath.lineTo(center.dx + tableW / 2, center.dy);
    tablePath.lineTo(center.dx, center.dy + tableH / 2);
    tablePath.lineTo(center.dx - tableW / 2, center.dy);
    tablePath.close();
    canvas.drawPath(tablePath, paint);
    _drawMarquiseFacets(
      canvas,
      center,
      visualW,
      visualH,
      tableW,
      tableH,
      paint,
    );
    // 2. Draw Internal Facets (Brilliant Pattern)
    _drawMarquiseBrilliantFacets(canvas, center, visualW, visualH, paint);

    // 3. Draw Dimensions with Arrows and Guides
    _drawDimensions(canvas, center, visualW, visualH, infoPaint, guidePaint);
  }

  void _drawMarquiseBrilliantFacets(
    Canvas canvas,
    Offset center,
    double w,
    double h,
    Paint paint,
  ) {
    double tw = w * 0.45;
    double th = h * 0.45;

    // Draw Table (Inner Diamond)
    final Path tablePath = Path();
    tablePath.moveTo(center.dx, center.dy - th / 2);
    tablePath.lineTo(center.dx + tw / 2, center.dy);
    tablePath.lineTo(center.dx, center.dy + th / 2);
    tablePath.lineTo(center.dx - tw / 2, center.dy);
    tablePath.close();
    canvas.drawPath(tablePath, paint);

    // Connecting Facets (The internal star pattern)
    // Points to table corners
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

    // Side points connecting to outer curve
    canvas.drawLine(
      Offset(center.dx + tw / 2, center.dy),
      Offset(center.dx + w / 2 * 0.9, center.dy),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx - tw / 2, center.dy),
      Offset(center.dx - w / 2 * 0.9, center.dy),
      paint,
    );

    // Chevron lines (the diagonal internal facets)
    canvas.drawLine(
      Offset(center.dx - tw / 4, center.dy - th / 4),
      Offset(center.dx - w / 2 * 0.6, center.dy - h / 4),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx + tw / 4, center.dy - th / 4),
      Offset(center.dx + w / 2 * 0.6, center.dy - h / 4),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx - tw / 4, center.dy + th / 4),
      Offset(center.dx - w / 2 * 0.6, center.dy + h / 4),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx + tw / 4, center.dy + th / 4),
      Offset(center.dx + w / 2 * 0.6, center.dy + h / 4),
      paint,
    );
  }

  void _drawMarquiseFacets(
    Canvas canvas,
    Offset center,
    double w,
    double h,
    double tw,
    double th,
    Paint paint,
  ) {
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
    canvas.drawLine(
      Offset(center.dx + tw / 2, center.dy),
      Offset(center.dx + w / 2, center.dy),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx - tw / 2, center.dy),
      Offset(center.dx - w / 2, center.dy),
      paint,
    );
  }

  void _drawDimensions(
    Canvas canvas,
    Offset center,
    double w,
    double h,
    Paint infoPaint,
    Paint guidePaint,
  ) {
    // --- WIDTH ---
    double widthY = center.dy - h / 2 - 35;
    Offset startW = Offset(
      center.dx - w / 2 * 0.8,
      widthY,
    ); // Adjusted for Marquise curve
    Offset endW = Offset(center.dx + w / 2 * 0.8, widthY);

    _drawDashedLine(
      canvas,
      Offset(startW.dx, startW.dy + 5),
      Offset(startW.dx, center.dy - h * 0.15),
      guidePaint,
    );
    _drawDashedLine(
      canvas,
      Offset(endW.dx, endW.dy + 5),
      Offset(endW.dx, center.dy - h * 0.15),
      guidePaint,
    );

    canvas.drawLine(startW, endW, infoPaint);
    _drawArrowHead(canvas, startW, 0, infoPaint);
    _drawArrowHead(canvas, endW, 180, infoPaint);
    _drawText(
      canvas,
      "Width: ${stone.width.toStringAsFixed(2)} mm",
      Offset(center.dx, widthY - 10),
    );

    // --- LENGTH ---
    double lengthX = center.dx + w / 2 + 35;
    Offset topL = Offset(lengthX, center.dy - h / 2);
    Offset bottomL = Offset(lengthX, center.dy + h / 2);

    _drawDashedLine(
      canvas,
      Offset(topL.dx - 5, topL.dy),
      Offset(center.dx, topL.dy),
      guidePaint,
    );
    _drawDashedLine(
      canvas,
      Offset(bottomL.dx - 5, bottomL.dy),
      Offset(center.dx, bottomL.dy),
      guidePaint,
    );

    canvas.drawLine(topL, bottomL, infoPaint);
    _drawArrowHead(canvas, topL, 90, infoPaint);
    _drawArrowHead(canvas, bottomL, 270, infoPaint);
    _drawText(
      canvas,
      "Length: ${stone.length.toStringAsFixed(2)} mm",
      Offset(lengthX + 55, center.dy),
    );

    // --- RATIO ---
    _drawText(
      canvas,
      "Length to Width: ${stone.ratio.toStringAsFixed(2)} to 1",
      Offset(center.dx, center.dy + h / 2 + 45),
      isGrey: true,
    );
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    double dashWidth = 4, dashSpace = 4;
    double distance = (p2 - p1).distance;
    for (double i = 0; i < distance; i += dashWidth + dashSpace) {
      canvas.drawLine(
        Offset(
          p1.dx + (p2.dx - p1.dx) * i / distance,
          p1.dy + (p2.dy - p1.dy) * i / distance,
        ),
        Offset(
          p1.dx + (p2.dx - p1.dx) * (i + dashWidth) / distance,
          p1.dy + (p2.dy - p1.dy) * (i + dashWidth) / distance,
        ),
        paint,
      );
    }
  }

  void _drawArrowHead(
    Canvas canvas,
    Offset point,
    double angleDegrees,
    Paint paint,
  ) {
    final double arrowSize = 6.0;
    final double angle = angleDegrees * (3.14159 / 180);
    Path path = Path()
      ..moveTo(point.dx, point.dy)
      ..lineTo(
        point.dx + arrowSize * math.cos(angle - 0.5),
        point.dy + arrowSize * math.sin(angle - 0.5),
      )
      ..moveTo(point.dx, point.dy)
      ..lineTo(
        point.dx + arrowSize * math.cos(angle + 0.5),
        point.dy + arrowSize * math.sin(angle + 0.5),
      );
    canvas.drawPath(path, paint);
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

//Pear
class PearTopViewPainter extends CustomPainter {
  final GmssStone stone;
  PearTopViewPainter({required this.stone});
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
    final dashedPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    final center = Offset(size.width / 2, size.height / 2);

    // Freeze dimensions to keep diagram consistent
    const double visualH = 200.0;
    const double visualW = 130.0; // Slightly wider visual base for better shape
    // ------------------------xed ratio for drawing (approx 1.5)
    _drawDashedBoundary(canvas, center, visualW, visualH, dashedPaint);

    final Path outerPath = Path();
    double headRadius = visualW / 2;
    double headCenterY = center.dy - (visualH * 0.18); // Pulled head

    // A. Draw the smooth rounded Head (unchanged path logic)
    outerPath.addArc(
      Rect.fromCircle(
        center: Offset(center.dx, headCenterY),
        radius: headRadius,
      ),
      math.pi,
      math.pi,
    );

    // B. DRAW THE SWELLING BODY USING CUBIC BEZIER (NEW)
    outerPath.moveTo(center.dx - headRadius, headCenterY);
    // These create the 'swell' and pull back to the center point.
    outerPath.cubicTo(
      center.dx - headRadius, // Control 1: x-aligned with head
      center.dy + (visualH * 0.15), // Control 1: swelling y position
      center.dx - (visualW * 0.1), // Control 2: y-aligned with tip, slightly in
      center.dy + (visualH * 0.45), // Control 2: pulling towards x-center
      center.dx, // End point: x-center
      center.dy + (visualH * 0.5), // End point: exact bottom y position
    );

    // Mirror for the right side
    outerPath.cubicTo(
      center.dx + (visualW * 0.1),
      center.dy + (visualH * 0.45),
      center.dx + headRadius,
      center.dy + (visualH * 0.15),
      center.dx + headRadius,
      headCenterY,
    );

    canvas.drawPath(outerPath, paint);
    // Update facets and dimensions to use these frozen visual coordinates
    _drawPearFacets(canvas, center, visualW, visualH, headCenterY, paint);
    _drawDimensions(canvas, center, visualW, visualH, infoPaint);
  }

  // void _drawPearBrilliantFacets(
  //   Canvas canvas,
  //   Offset center,
  //   double w,
  //   double h,
  //   double headY,
  //   double radius,
  //   Paint paint,
  // ) {
  //   // Table (Inner teardrop shape)
  //   double tw = w * 0.45;
  //   double th = h * 0.45;
  //   Offset tableCenter = Offset(center.dx, headY + 5);
  //
  //   // Internal Table Path
  //   final Path tablePath = Path();
  //   tablePath.addOval(
  //     Rect.fromCenter(center: tableCenter, width: tw, height: th * 0.8),
  //   );
  //   canvas.drawPath(tablePath, paint);
  //
  //   // Main Facet Lines (The "X" pattern)
  //   // To Head
  //   canvas.drawLine(
  //     Offset(center.dx, headY - radius),
  //     Offset(center.dx, tableCenter.dy - (th * 0.35)),
  //     paint,
  //   );
  //   // To Point
  //   canvas.drawLine(
  //     Offset(center.dx, center.dy + h * 0.5),
  //     Offset(center.dx, tableCenter.dy + (th * 0.4)),
  //     paint,
  //   );
  //
  //   // Star Facets
  //   for (int i = 0; i < 4; i++) {
  //     double angle = (210 + i * 40) * math.pi / 180;
  //     canvas.drawLine(
  //       Offset(
  //         center.dx + (w / 2) * math.cos(angle),
  //         headY + (w / 2) * math.sin(angle),
  //       ),
  //       Offset(
  //         center.dx + (tw / 2) * math.cos(angle),
  //         tableCenter.dy + (th / 3) * math.sin(angle),
  //       ),
  //       paint,
  //     );
  //   }
  // }

  void _drawPearFacets(
    Canvas canvas,
    Offset center,
    double w,
    double h,
    double headY,
    Paint paint,
  ) {
    double tableR = w * 0.22;
    Offset tableCenter = Offset(center.dx, headY);
    canvas.drawCircle(tableCenter, tableR, paint);
    for (int i = 0; i < 6; i++) {
      double angle = (180 + i * 36) * math.pi / 180;
      canvas.drawLine(
        Offset(
          tableCenter.dx + tableR * math.cos(angle),
          tableCenter.dy + tableR * math.sin(angle),
        ),
        Offset(
          tableCenter.dx + (w / 2) * math.cos(angle),
          tableCenter.dy + (w / 2) * math.sin(angle),
        ),
        paint,
      );
    }
    canvas.drawLine(
      Offset(center.dx, headY + tableR),
      Offset(center.dx, center.dy + h * 0.45),
      paint,
    );
  }

  void _drawDashedBoundary(
    Canvas canvas,
    Offset center,
    double w,
    double h,
    Paint paint,
  ) {
    double top = center.dy - h * 0.4;
    double bottom = center.dy + h * 0.45;
    double left = center.dx - w / 2;
    double right = center.dx + w / 2;
    void drawD(Offset p1, Offset p2) {
      double dist = (p2 - p1).distance;
      for (double i = 0; i < dist; i += 8) {
        canvas.drawLine(
          Offset(
            p1.dx + (p2.dx - p1.dx) * i / dist,
            p1.dy + (p2.dy - p1.dy) * i / dist,
          ),
          Offset(
            p1.dx + (p2.dx - p1.dx) * (i + 4) / dist,
            p1.dy + (p2.dy - p1.dy) * (i + 4) / dist,
          ),
          paint,
        );
      }
    }

    drawD(Offset(left, top), Offset(right + 40, top));
    drawD(Offset(right, top - 40), Offset(right, bottom));
  }

  void _drawDimensions(
    Canvas canvas,
    Offset center,
    double w, // Pass visualW here
    double h, // Pass visualH here
    Paint infoPaint,
  ) {
    // 1. HORIZONTAL WIDTH MEASUREMENT
    // Calculate the Y-position relative to the frozen visual height
    double widthY = center.dy - (h * 0.45) - 35;
    Offset startLine = Offset(center.dx - w / 2, widthY);
    Offset endLine = Offset(center.dx + w / 2, widthY);

    canvas.drawLine(startLine, endLine, infoPaint);
    _drawArrowHead(canvas, startLine, 0, infoPaint);
    _drawArrowHead(canvas, endLine, 180, infoPaint);

    // Align text directly above the line (Width sits on line logic)
    _drawText(
      canvas,
      // THE CHANGE: Number updates, line stays the same
      "Width: ${stone.width.toStringAsFixed(2)} mm",
      Offset(center.dx, widthY - 10), // Sitting nicely on the arrow line
    );

    // 2. VERTICAL LENGTH MEASUREMENT
    // Declare the variable lengthX first
    double lengthX = center.dx + w / 2 + 35;
    Offset topLPoint = Offset(lengthX, center.dy - h * 0.45);
    Offset bottomLPoint = Offset(lengthX, center.dy + h * 0.5);

    canvas.drawLine(topLPoint, bottomLPoint, infoPaint);
    _drawArrowHead(canvas, topLPoint, 90, infoPaint);
    _drawArrowHead(canvas, bottomLPoint, 270, infoPaint);

    // Use lengthX here after it's been declared
    _drawText(
      canvas,
      "Length: ${stone.length.toStringAsFixed(2)} mm",
      Offset(lengthX + 55, center.dy), // Pushed right to make room
    );

    // 3. RATIO (Bottom Label)
    _drawText(
      canvas,
      "Length to Width: ${stone.ratio.toStringAsFixed(2)} to 1",
      Offset(center.dx, center.dy + h * 0.5 + 45), // Position below tip
      isGrey: true,
    );
  }

  // void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
  //   double dashWidth = 4, dashSpace = 4;
  //   double distance = (p2 - p1).distance;
  //   for (double i = 0; i < distance; i += dashWidth + dashSpace) {
  //     canvas.drawLine(
  //       Offset(
  //         p1.dx + (p2.dx - p1.dx) * i / distance,
  //         p1.dy + (p2.dy - p1.dy) * i / distance,
  //       ),
  //       Offset(
  //         p1.dx + (p2.dx - p1.dx) * (i + dashWidth) / distance,
  //         p1.dy + (p2.dy - p1.dy) * (i + dashWidth) / distance,
  //       ),
  //       paint,
  //     );
  //   }
  // }

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
  bool shouldRepaint(covariant CustomPainter old) => false;
}

//Oval
class OvalTopViewPainter extends CustomPainter {
  final GmssStone stone;
  OvalTopViewPainter({required this.stone});
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
    final dashedPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    final guidePaint =
        Paint() // Added for the technical guide lines
          ..color = Colors.grey.shade300
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8;
    final center = Offset(size.width / 2, size.height / 2);
    const double visualH = 180.0;
    const double visualW = 130.0; // Fixed width for the diagram
    // Draw the Oval
    Rect ovalRect = Rect.fromCenter(
      center: center,
      width: visualW,
      height: visualH,
    );
    canvas.drawOval(ovalRect, paint);

    // 1. Draw Brilliant Facets
    _drawOvalBrilliantFacets(canvas, center, visualW, visualH, paint);

    // 2. Draw Dimensions with technical arrows and guides
    _drawDimensions(canvas, center, visualW, visualH, infoPaint, guidePaint);
  }

  void _drawOvalBrilliantFacets(
    Canvas canvas,
    Offset center,
    double w,
    double h,
    Paint paint,
  ) {
    double tableW = w * 0.55;
    double tableH = h * 0.55;

    // Draw Inner Table (Octagonal/Oval hybrid look)
    canvas.drawOval(
      Rect.fromCenter(center: center, width: tableW, height: tableH),
      paint,
    );

    // Draw the Bezel and Star facets
    for (int i = 0; i < 8; i++) {
      double angle = (i * 45) * math.pi / 180;
      double nextAngle = ((i + 1) * 45) * math.pi / 180;
      double midAngle = (i * 45 + 22.5) * math.pi / 180;

      // Lines from table to girdle
      canvas.drawLine(
        Offset(
          center.dx + (tableW / 2) * math.cos(angle),
          center.dy + (tableH / 2) * math.sin(angle),
        ),
        Offset(
          center.dx + (w / 2) * math.cos(angle),
          center.dy + (h / 2) * math.sin(angle),
        ),
        paint,
      );

      // Star connection points
      canvas.drawLine(
        Offset(
          center.dx + (tableW / 2) * math.cos(angle),
          center.dy + (tableH / 2) * math.sin(angle),
        ),
        Offset(
          center.dx + (w / 2) * math.cos(midAngle),
          center.dy + (h / 2) * math.sin(midAngle),
        ),
        paint,
      );
      canvas.drawLine(
        Offset(
          center.dx + (tableW / 2) * math.cos(nextAngle),
          center.dy + (tableH / 2) * math.sin(nextAngle),
        ),
        Offset(
          center.dx + (w / 2) * math.cos(midAngle),
          center.dy + (h / 2) * math.sin(midAngle),
        ),
        paint,
      );
    }
  }

  // void _drawDashedBoundary(
  //   Canvas canvas,
  //   Offset center,
  //   double w,
  //   double h,
  //   Paint paint,
  // ) {
  //   double top = center.dy - h / 2;
  //   double bottom = center.dy + h / 2;
  //   double left = center.dx - w / 2;
  //   double right = center.dx + w / 2;
  //   void drawD(Offset p1, Offset p2) {
  //     double dist = (p2 - p1).distance;
  //     for (double i = 0; i < dist; i += 8) {
  //       canvas.drawLine(
  //         Offset(
  //           p1.dx + (p2.dx - p1.dx) * i / dist,
  //           p1.dy + (p2.dy - p1.dy) * i / dist,
  //         ),
  //         Offset(
  //           p1.dx + (p2.dx - p1.dx) * (i + 4) / dist,
  //           p1.dy + (p2.dy - p1.dy) * (i + 4) / dist,
  //         ),
  //         paint,
  //       );
  //     }
  //   }
  //
  //   drawD(Offset(left, top), Offset(right + 40, top));
  //   drawD(Offset(right, top - 40), Offset(right, bottom));
  // }

  void _drawDimensions(
    Canvas canvas,
    Offset center,
    double w,
    double h,
    Paint infoPaint,
    Paint guidePaint,
  ) {
    // --- HORIZONTAL WIDTH ---
    double widthY = center.dy - h / 2 - 35;
    Offset startW = Offset(center.dx - w / 2, widthY);
    Offset endW = Offset(center.dx + w / 2, widthY);

    // Dashed Guides
    _drawDashedLine(
      canvas,
      Offset(startW.dx, startW.dy + 5),
      Offset(startW.dx, center.dy - h / 4),
      guidePaint,
    );
    _drawDashedLine(
      canvas,
      Offset(endW.dx, endW.dy + 5),
      Offset(endW.dx, center.dy - h / 4),
      guidePaint,
    );

    // Arrow Line
    canvas.drawLine(startW, endW, infoPaint);
    _drawArrowHead(canvas, startW, 0, infoPaint);
    _drawArrowHead(canvas, endW, 180, infoPaint);

    // Label on arrow
    _drawText(
      canvas,
      "Width: ${stone.width.toStringAsFixed(2)} mm",
      Offset(center.dx, widthY - 10),
    );

    // --- VERTICAL LENGTH ---
    double lengthX = center.dx + w / 2 + 35;
    Offset topL = Offset(lengthX, center.dy - h / 2);
    Offset bottomL = Offset(lengthX, center.dy + h / 2);

    // Dashed Guides
    _drawDashedLine(
      canvas,
      Offset(topL.dx - 5, topL.dy),
      Offset(center.dx + w / 4, topL.dy),
      guidePaint,
    );
    _drawDashedLine(
      canvas,
      Offset(bottomL.dx - 5, bottomL.dy),
      Offset(center.dx + w / 4, bottomL.dy),
      guidePaint,
    );

    // Arrow Line
    canvas.drawLine(topL, bottomL, infoPaint);
    _drawArrowHead(canvas, topL, 90, infoPaint);
    _drawArrowHead(canvas, bottomL, 270, infoPaint);

    _drawText(
      canvas,
      "Length: ${stone.length.toStringAsFixed(2)} mm",
      Offset(lengthX + 55, center.dy),
    );

    // --- RATIO ---
    _drawText(
      canvas,
      "Length to Width: ${stone.ratio.toStringAsFixed(2)} to 1",
      Offset(center.dx, center.dy + h / 2 + 45),
      isGrey: true,
    );
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    double dashWidth = 4, dashSpace = 4;
    double distance = (p2 - p1).distance;
    for (double i = 0; i < distance; i += dashWidth + dashSpace) {
      canvas.drawLine(
        Offset(
          p1.dx + (p2.dx - p1.dx) * i / distance,
          p1.dy + (p2.dy - p1.dy) * i / distance,
        ),
        Offset(
          p1.dx + (p2.dx - p1.dx) * (i + dashWidth) / distance,
          p1.dy + (p2.dy - p1.dy) * (i + dashWidth) / distance,
        ),
        paint,
      );
    }
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
  bool shouldRepaint(covariant CustomPainter old) => false;
}

//Heart
class HeartTopViewPainter extends CustomPainter {
  final GmssStone stone;
  HeartTopViewPainter({required this.stone});
  @override
  void paint(Canvas canvas, Size size) {
    final facetPaint = Paint()
      ..color = Colors.grey.shade700
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final dimensionPaint = Paint()
      ..color = const Color(0xFF008080)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    final guidePaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    final center = Offset(size.width / 2, size.height / 2);
    const double visualH = 170.0;
    const double visualW = 180.0; // Fixed width for a standard heart shape
    double cleftY = center.dy - visualH * 0.18;
    double bottomY = center.dy + visualH * 0.45;
    double lobeTopY = center.dy - visualH * 0.5;
    final Path heartPath = Path();

    heartPath.moveTo(center.dx, cleftY);
    heartPath.cubicTo(
      center.dx - visualW * 0.5,
      lobeTopY,
      center.dx - visualW * 0.65,
      center.dy + visualH * 0.1,
      center.dx,
      bottomY,
    );
    heartPath.moveTo(center.dx, cleftY);
    heartPath.cubicTo(
      center.dx + visualW * 0.5,
      lobeTopY,
      center.dx + visualW * 0.65,
      center.dy + visualH * 0.1,
      center.dx,
      bottomY,
    );
    canvas.drawPath(heartPath, facetPaint);

    // Draw Internal brilliance facets
    _drawHeartBrilliance(
      canvas,
      center,
      visualW,
      visualH,
      cleftY,
      bottomY,
      facetPaint,
    );

    // Draw Dimensions with Arrows and Dashed Guides
    _drawDimensions(
      canvas,
      center,
      visualW,
      visualH,
      dimensionPaint,
      guidePaint,
    );
  }

  void _drawHeartBrilliance(
    Canvas canvas,
    Offset center,
    double w,
    double h,
    double cleftY,
    double bottomY,
    Paint paint,
  ) {
    final double tw = w * 0.4;
    final double th = h * 0.35;
    final Path table = Path();
    table.moveTo(center.dx, center.dy - th * 0.45);
    table.lineTo(center.dx + tw * 0.5, center.dy - th * 0.1);
    table.lineTo(center.dx, center.dy + th * 0.65);
    table.lineTo(center.dx - tw * 0.5, center.dy - th * 0.1);
    table.close();
    canvas.drawPath(table, paint);
    canvas.drawLine(
      Offset(center.dx, cleftY),
      Offset(center.dx, center.dy - th * 0.45),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx, bottomY),
      Offset(center.dx, center.dy + th * 0.65),
      paint,
    );
  }

  // void _drawDashedBoundary(
  //   Canvas canvas,
  //   Offset center,
  //   double w,
  //   double h,
  //   Paint paint,
  // ) {
  //   double top = center.dy - h * 0.45;
  //   double bottom = center.dy + h * 0.5;
  //   double left = center.dx - w * 0.5;
  //   double right = center.dx + w * 0.5;
  //   void drawD(Offset p1, Offset p2) {
  //     double dist = (p2 - p1).distance;
  //     for (double i = 0; i < dist; i += 8) {
  //       canvas.drawLine(
  //         Offset(
  //           p1.dx + (p2.dx - p1.dx) * i / dist,
  //           p1.dy + (p2.dy - p1.dy) * i / dist,
  //         ),
  //         Offset(
  //           p1.dx + (p2.dx - p1.dx) * (i + 4) / dist,
  //           p1.dy + (p2.dy - p1.dy) * (i + 4) / dist,
  //         ),
  //         paint,
  //       );
  //     }
  //   }
  //
  //   drawD(Offset(left, top), Offset(right + 45, top));
  //   drawD(Offset(right, top - 45), Offset(right, bottom));
  // }

  void _drawDimensions(
    Canvas canvas,
    Offset center,
    double w,
    double h,
    Paint infoPaint,
    Paint guidePaint,
  ) {
    // --- WIDTH ---
    double widthY = center.dy - h * 0.45 - 35;
    Offset startW = Offset(center.dx - w * 0.45, widthY);
    Offset endW = Offset(center.dx + w * 0.45, widthY);

    // Dashed Guides for Width
    _drawDashedLine(
      canvas,
      Offset(startW.dx, startW.dy + 5),
      Offset(startW.dx, center.dy - h * 0.1),
      guidePaint,
    );
    _drawDashedLine(
      canvas,
      Offset(endW.dx, endW.dy + 5),
      Offset(endW.dx, center.dy - h * 0.1),
      guidePaint,
    );

    canvas.drawLine(startW, endW, infoPaint);
    _drawArrowHead(canvas, startW, 0, infoPaint);
    _drawArrowHead(canvas, endW, 180, infoPaint);
    _drawText(
      canvas,
      "Width: ${stone.width.toStringAsFixed(2)} mm",
      Offset(center.dx, widthY - 10),
    );

    // --- LENGTH ---
    double lengthX = center.dx + w * 0.5 + 35;
    Offset topL = Offset(lengthX, center.dy - h * 0.45);
    Offset bottomL = Offset(lengthX, center.dy + h * 0.45);

    // Dashed Guides for Length
    _drawDashedLine(
      canvas,
      Offset(topL.dx - 5, topL.dy),
      Offset(center.dx, topL.dy),
      guidePaint,
    );
    _drawDashedLine(
      canvas,
      Offset(bottomL.dx - 5, bottomL.dy),
      Offset(center.dx, bottomL.dy),
      guidePaint,
    );

    canvas.drawLine(topL, bottomL, infoPaint);
    _drawArrowHead(canvas, topL, 90, infoPaint);
    _drawArrowHead(canvas, bottomL, 270, infoPaint);
    _drawText(
      canvas,
      "Length: ${stone.length.toStringAsFixed(2)} mm",
      Offset(lengthX + 55, center.dy),
    );

    // --- RATIO ---
    _drawText(
      canvas,
      "Length to Width: ${stone.ratio.toStringAsFixed(2)} to 1",
      Offset(center.dx, center.dy + h * 0.45 + 40),
      isGrey: true,
    );
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    double dashWidth = 4, dashSpace = 4;
    double distance = (p2 - p1).distance;
    for (double i = 0; i < distance; i += dashWidth + dashSpace) {
      canvas.drawLine(
        Offset(
          p1.dx + (p2.dx - p1.dx) * i / distance,
          p1.dy + (p2.dy - p1.dy) * i / distance,
        ),
        Offset(
          p1.dx + (p2.dx - p1.dx) * (i + dashWidth) / distance,
          p1.dy + (p2.dy - p1.dy) * (i + dashWidth) / distance,
        ),
        paint,
      );
    }
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
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class BaguetteTopViewPainter extends CustomPainter {
  final GmssStone stone;
  BaguetteTopViewPainter({required this.stone});
  @override
  void paint(Canvas canvas, Size size) {
    final facetPaint = Paint()
      ..color = Colors.grey.shade700
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;
    final filledPaint = Paint()
      ..color = const Color(0xFF008080).withValues(alpha: 0.05)
      ..style = PaintingStyle.fill;
    final dimensionPaint = Paint()
      ..color = const Color(0xFF008080)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    final guidePaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    final center = Offset(size.width / 2, size.height / 2);
    final double radius = (size.width * 0.45) / 2;
    final double h = radius * 2;
    final double w = h / (stone.ratio > 0 ? stone.ratio : 1.0);
    _drawDashedBoundary(canvas, center, w, h, guidePaint);
    List<Offset> outerPoints = [];
    for (int i = 0; i < 6; i++) {
      double angle = (i * 60) * math.pi / 180;
      outerPoints.add(
        Offset(
          center.dx + radius * math.cos(angle),
          center.dy + radius * math.sin(angle),
        ),
      );
    }
    final double tableRadius = radius * 0.45;
    List<Offset> tablePoints = [];
    for (int i = 0; i < 6; i++) {
      double angle = (i * 60) * math.pi / 180;
      tablePoints.add(
        Offset(
          center.dx + tableRadius * math.cos(angle),
          center.dy + tableRadius * math.sin(angle),
        ),
      );
    }
    final Path hexPath = Path()..addPolygon(outerPoints, true);
    canvas.drawPath(hexPath, filledPaint);
    canvas.drawPath(hexPath, facetPaint);
    canvas.drawPath(Path()..addPolygon(tablePoints, true), facetPaint);
    for (int i = 0; i < 6; i++) {
      canvas.drawLine(tablePoints[i], outerPoints[i], facetPaint);
      double midAngle = (i * 60 + 30) * math.pi / 180;
      Offset girdleMid = Offset(
        center.dx + (radius * 0.866) * math.cos(midAngle),
        center.dy + (radius * 0.866) * math.sin(midAngle),
      );
      canvas.drawLine(tablePoints[i], girdleMid, facetPaint);
      canvas.drawLine(tablePoints[(i + 1) % 6], girdleMid, facetPaint);
      canvas.drawLine(center, tablePoints[i], facetPaint);
    }
    _drawDimensions(canvas, center, radius, dimensionPaint);
  }

  void _drawDashedBoundary(
    Canvas canvas,
    Offset center,
    double w,
    double h,
    Paint paint,
  ) {
    final double top = center.dy - h / 2;
    final double bottom = center.dy + h / 2;
    final double left = center.dx - w / 2;
    final double right = center.dx + w / 2;
    const double ext = 15.0;
    void drawLine(Offset p1, Offset p2) {
      double dist = (p2 - p1).distance;
      for (double i = 0; i < dist; i += 8) {
        canvas.drawLine(
          Offset(
            p1.dx + (p2.dx - p1.dx) * i / dist,
            p1.dy + (p2.dy - p1.dy) * i / dist,
          ),
          Offset(
            p1.dx + (p2.dx - p1.dx) * (i + 4) / dist,
            p1.dy + (p2.dy - p1.dy) * (i + 4) / dist,
          ),
          paint,
        );
      }
    }

    drawLine(Offset(left - ext, top), Offset(left, top));
    drawLine(Offset(left, top - ext), Offset(left, top));
    drawLine(Offset(right, top), Offset(right + ext, top));
    drawLine(Offset(right, top - ext), Offset(right, top));
    drawLine(Offset(left - ext, bottom), Offset(left, bottom));
    drawLine(Offset(left, bottom), Offset(left, bottom + ext));
    drawLine(Offset(right, bottom), Offset(right + ext, bottom));
    drawLine(Offset(right, bottom), Offset(right, bottom + ext));
  }

  void _drawDimensions(
    Canvas canvas,
    Offset center,
    double radius,
    Paint infoPaint,
  ) {
    double widthY = center.dy - radius - 35;
    canvas.drawLine(
      Offset(center.dx - radius, widthY),
      Offset(center.dx + radius, widthY),
      infoPaint,
    );
    _drawArrow(canvas, Offset(center.dx - radius, widthY), 0, infoPaint);
    _drawArrow(canvas, Offset(center.dx + radius, widthY), 180, infoPaint);
    _drawText(
      canvas,
      "Width: ${stone.width} mm",
      Offset(center.dx, widthY - 15),
    );
    double lengthX = center.dx + radius + 35;
    canvas.drawLine(
      Offset(lengthX, center.dy - radius),
      Offset(lengthX, center.dy + radius),
      infoPaint,
    );
    _drawArrow(canvas, Offset(lengthX, center.dy - radius), 90, infoPaint);
    _drawArrow(canvas, Offset(lengthX, center.dy + radius), 270, infoPaint);
    _drawText(
      canvas,
      "Length: ${stone.length} mm",
      Offset(lengthX + 55, center.dy),
    );
    _drawText(
      canvas,
      "Ratio: ${stone.ratio.toStringAsFixed(2)} to 1",
      Offset(center.dx, center.dy + radius + 45),
      isGrey: true,
    );
  }

  void _drawArrow(Canvas canvas, Offset point, double angleDeg, Paint paint) {
    double angle = angleDeg * math.pi / 180;
    Path p = Path()
      ..moveTo(point.dx, point.dy)
      ..lineTo(
        point.dx + 6 * math.cos(angle - 0.5),
        point.dy + 6 * math.sin(angle - 0.5),
      )
      ..moveTo(point.dx, point.dy)
      ..lineTo(
        point.dx + 6 * math.cos(angle + 0.5),
        point.dy + 6 * math.sin(angle + 0.5),
      );
    canvas.drawPath(p, paint);
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
  bool shouldRepaint(covariant CustomPainter old) => false;
}

//Diamonds
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
    // --- APPLY THE CHANGE HERE ---
    // 1. Define Fixed Visual Dimensions
    const double visualWidth = 200.0;
    const double visualTotalHeight = 130.0;
    final double centerX = size.width / 2;
    final double startY = 100.0; // Pushed down slightly for labels

    // 2. Define Fixed Drawing Proportions (Visual Only)
    final double drawTableWidth = visualWidth * 0.55;
    final double drawCrownHeight = visualTotalHeight * 0.25;
    // ----------------------------
    final double width = size.width * 0.55;
    // final double centerX = size.width / 2;
    // final double startY = 70.0;
    final double tableWidth = width * (stone.table / 100);
    final double totalHeight = width * (stone.depth / 100);

    final double crownHeight = totalHeight * 0.25;
    _drawDashedRect(
      canvas,
      centerX,
      visualWidth,
      startY,
      visualTotalHeight,
      dashedPaint,
    );
    final Path path = Path();
    path.moveTo(centerX - drawTableWidth / 2, startY);
    path.lineTo(centerX + drawTableWidth / 2, startY);
    path.lineTo(centerX + visualWidth / 2, startY + drawCrownHeight);
    path.lineTo(centerX + visualWidth / 2, startY + drawCrownHeight + 4);
    path.lineTo(centerX, startY + visualTotalHeight);
    path.lineTo(centerX - visualWidth / 2, startY + drawCrownHeight + 4);
    path.lineTo(centerX - visualWidth / 2, startY + drawCrownHeight);
    path.close();
    canvas.drawPath(path, linePaint);
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
    _drawIndicator(
      canvas,
      Offset(centerX + width / 4, startY + crownHeight + 2),
      "Girdle: ${stone.gridle_condition}",
      infoPaint,
      true,
    );
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
    for (
      double i = cx + w / 2;
      i < cx + w / 2 + 35;
      i += dashWidth + dashSpace
    ) {
      canvas.drawLine(Offset(i, sy), Offset(i + dashWidth, sy), paint);
    }
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
