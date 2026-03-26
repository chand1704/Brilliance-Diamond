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
      ..color = const Color(0xFF008080)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width * 0.45) / 2;
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
    _drawDimensions(canvas, center, radius, infoPaint);
  }

  void _drawDimensions(
    Canvas canvas,
    Offset center,
    double radius,
    Paint infoPaint,
  ) {
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
    final center = Offset(size.width / 2, size.height / 2);
    final double h = size.height * 0.5;
    final double w = h / (stone.ratio > 0 ? stone.ratio : 1.0);
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
    _drawDimensions(canvas, center, w, h, infoPaint);
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
  ) {
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
    final double h = size.height * 0.5;
    final double w = h / 1.4;
    Rect outerRect = Rect.fromCenter(center: center, width: w, height: h);
    _drawEmeraldRect(canvas, outerRect, 15, paint);
    _drawEmeraldRect(canvas, outerRect.deflate(10), 12, paint);
    _drawEmeraldRect(canvas, outerRect.deflate(20), 8, paint);
    _drawEmeraldRect(canvas, outerRect.deflate(35), 5, paint);
    _drawCornerLines(canvas, outerRect, outerRect.deflate(35), paint);
    _drawDimensions(canvas, center, w, h, infoPaint);
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
  ) {
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
    final center = Offset(size.width / 2, size.height / 2);
    final double h = size.height * 0.45;
    final double w = h / (stone.ratio > 0 ? stone.ratio : 1.0);
    RRect outerRRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: w, height: h),
      const Radius.circular(35),
    );
    canvas.drawRRect(outerRRect, paint);
    final double tableW = w * 0.55;
    final double tableH = h * 0.55;
    RRect tableRRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: tableW, height: tableH),
      const Radius.circular(10),
    );
    canvas.drawRRect(tableRRect, paint);
    _drawCushionFacets(canvas, outerRRect, tableRRect, paint);
    _drawDimensions(canvas, center, w, h, infoPaint);
  }

  void _drawCushionFacets(
    Canvas canvas,
    RRect outer,
    RRect inner,
    Paint paint,
  ) {
    canvas.drawLine(
      Offset(outer.left + 15, outer.top + 15),
      Offset(inner.left, inner.top),
      paint,
    );
    canvas.drawLine(
      Offset(outer.right - 15, outer.top + 15),
      Offset(inner.right, inner.top),
      paint,
    );
    canvas.drawLine(
      Offset(outer.left + 15, outer.bottom - 15),
      Offset(inner.left, inner.bottom),
      paint,
    );
    canvas.drawLine(
      Offset(outer.right - 15, outer.bottom - 15),
      Offset(inner.right, inner.bottom),
      paint,
    );
    canvas.drawLine(
      Offset(outer.center.dx, outer.top),
      Offset(inner.center.dx, inner.top),
      paint,
    );
    canvas.drawLine(
      Offset(outer.center.dx, outer.bottom),
      Offset(inner.center.dx, inner.bottom),
      paint,
    );
    canvas.drawLine(
      Offset(outer.left, outer.center.dy),
      Offset(inner.left, inner.center.dy),
      paint,
    );
    canvas.drawLine(
      Offset(outer.right, outer.center.dy),
      Offset(inner.right, inner.center.dy),
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
    final center = Offset(size.width / 2, size.height / 2);
    final double h = size.height * 0.5;
    final double w = h / (stone.ratio > 0 ? stone.ratio : 1.4);
    final Path outerPath = _getRadiantPath(center, w, h, 15);
    canvas.drawPath(outerPath, paint);
    final double tableW = w * 0.5;
    final double tableH = h * 0.5;
    final Path tablePath = _getRadiantPath(center, tableW, tableH, 8);
    canvas.drawPath(tablePath, paint);
    _drawRadiantFacets(canvas, center, w, h, tableW, tableH, paint);
    _drawDimensions(canvas, center, w, h, infoPaint);
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
      Offset(center.dx - w / 2, center.dy),
      Offset(center.dx - tw / 2, center.dy),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx + w / 2, center.dy),
      Offset(center.dx + tw / 2, center.dy),
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
    final center = Offset(size.width / 2, size.height / 2);
    final double h = size.height * 0.6;
    final double w = h / (stone.ratio > 0 ? stone.ratio : 2.0);
    final Path outerPath = Path();
    outerPath.moveTo(center.dx, center.dy - h / 2);
    outerPath.quadraticBezierTo(
      center.dx + w,
      center.dy,
      center.dx,
      center.dy + h / 2,
    );
    outerPath.quadraticBezierTo(
      center.dx - w,
      center.dy,
      center.dx,
      center.dy - h / 2,
    );
    canvas.drawPath(outerPath, paint);
    final double tableW = w * 0.4;
    final double tableH = h * 0.4;
    final Path tablePath = Path();
    tablePath.moveTo(center.dx, center.dy - tableH / 2);
    tablePath.lineTo(center.dx + tableW / 2, center.dy);
    tablePath.lineTo(center.dx, center.dy + tableH / 2);
    tablePath.lineTo(center.dx - tableW / 2, center.dy);
    tablePath.close();
    canvas.drawPath(tablePath, paint);
    _drawMarquiseFacets(canvas, center, w, h, tableW, tableH, paint);
    _drawDimensions(canvas, center, w, h, infoPaint);
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
  ) {
    double widthY = center.dy - h / 2 - 20;
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
    double lengthX = center.dx + w / 2 + 40;
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
    _drawText(
      canvas,
      "Length to Width: ${stone.ratio.toStringAsFixed(2)} to 1",
      Offset(center.dx, center.dy + h / 2 + 40),
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
    final double h = size.height * 0.58;
    final double w = h / (stone.ratio > 0 ? stone.ratio : 1.55);
    _drawDashedBoundary(canvas, center, w, h, dashedPaint);
    final Path outerPath = Path();
    double headRadius = w / 2;
    double headCenterY = center.dy - (h * 0.15);
    outerPath.addArc(
      Rect.fromCircle(
        center: Offset(center.dx, headCenterY),
        radius: headRadius,
      ),
      math.pi,
      math.pi,
    );
    outerPath.moveTo(center.dx - headRadius, headCenterY);
    outerPath.quadraticBezierTo(
      center.dx - headRadius,
      center.dy + (h * 0.1),
      center.dx,
      center.dy + (h * 0.45),
    );
    outerPath.quadraticBezierTo(
      center.dx + headRadius,
      center.dy + (h * 0.1),
      center.dx + headRadius,
      headCenterY,
    );
    canvas.drawPath(outerPath, paint);
    _drawPearFacets(canvas, center, w, h, headCenterY, paint);
    _drawDimensions(canvas, center, w, h, infoPaint);
  }

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
    double w,
    double h,
    Paint infoPaint,
  ) {
    double widthY = center.dy - (h * 0.4) - 35;
    canvas.drawLine(
      Offset(center.dx - w / 2, widthY),
      Offset(center.dx + w / 2, widthY),
      infoPaint,
    );
    _drawArrowHead(canvas, Offset(center.dx - w / 2, widthY), 0, infoPaint);
    _drawArrowHead(canvas, Offset(center.dx + w / 2, widthY), 180, infoPaint);
    _drawText(
      canvas,
      "Width: ${stone.width} mm",
      Offset(center.dx, widthY - 15),
    );
    double lengthX = center.dx + w / 2 + 35;
    canvas.drawLine(
      Offset(lengthX, center.dy - h * 0.4),
      Offset(lengthX, center.dy + h * 0.45),
      infoPaint,
    );
    _drawArrowHead(canvas, Offset(lengthX, center.dy - h * 0.4), 90, infoPaint);
    _drawArrowHead(
      canvas,
      Offset(lengthX, center.dy + h * 0.45),
      270,
      infoPaint,
    );
    _drawText(
      canvas,
      "Length: ${stone.length} mm",
      Offset(lengthX + 50, center.dy),
    );
    _drawText(
      canvas,
      "Length to Width: ${stone.ratio.toStringAsFixed(2)} to 1",
      Offset(center.dx, center.dy + h * 0.45 + 40),
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
    final center = Offset(size.width / 2, size.height / 2);
    final double h = size.height * 0.55;
    final double w = h / (stone.ratio > 0 ? stone.ratio : 1.40);
    _drawDashedBoundary(canvas, center, w, h, dashedPaint);
    Rect ovalRect = Rect.fromCenter(center: center, width: w, height: h);
    canvas.drawOval(ovalRect, paint);
    _drawOvalFacets(canvas, center, w, h, paint);
    _drawDimensions(canvas, center, w, h, infoPaint);
  }

  void _drawOvalFacets(
    Canvas canvas,
    Offset center,
    double w,
    double h,
    Paint paint,
  ) {
    double tableW = w * 0.5;
    double tableH = h * 0.5;
    canvas.drawOval(
      Rect.fromCenter(center: center, width: tableW, height: tableH),
      paint,
    );
    for (int i = 0; i < 8; i++) {
      double angle = (i * 45) * math.pi / 180;
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
    }
  }

  void _drawDashedBoundary(
    Canvas canvas,
    Offset center,
    double w,
    double h,
    Paint paint,
  ) {
    double top = center.dy - h / 2;
    double bottom = center.dy + h / 2;
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
    double w,
    double h,
    Paint infoPaint,
  ) {
    double widthY = center.dy - h / 2 - 35;
    canvas.drawLine(
      Offset(center.dx - w / 2, widthY),
      Offset(center.dx + w / 2, widthY),
      infoPaint,
    );
    _drawArrowHead(canvas, Offset(center.dx - w / 2, widthY), 0, infoPaint);
    _drawArrowHead(canvas, Offset(center.dx + w / 2, widthY), 180, infoPaint);
    _drawText(
      canvas,
      "Width: ${stone.width} mm",
      Offset(center.dx, widthY - 15),
    );
    double lengthX = center.dx + w / 2 + 35;
    canvas.drawLine(
      Offset(lengthX, center.dy - h / 2),
      Offset(lengthX, center.dy + h / 2),
      infoPaint,
    );
    _drawArrowHead(canvas, Offset(lengthX, center.dy - h / 2), 90, infoPaint);
    _drawArrowHead(canvas, Offset(lengthX, center.dy + h / 2), 270, infoPaint);
    _drawText(
      canvas,
      "Length: ${stone.length} mm",
      Offset(lengthX + 55, center.dy),
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
    final double h = size.height * 0.52;
    final double w = h / (stone.ratio > 0 ? stone.ratio : 1.14);
    _drawDashedBoundary(canvas, center, w, h, guidePaint);
    final Path heartPath = Path();
    double cleftY = center.dy - h * 0.18;
    double bottomY = center.dy + h * 0.5;
    double lobeTopY = center.dy - h * 0.48;
    heartPath.moveTo(center.dx, cleftY);
    heartPath.cubicTo(
      center.dx - w * 0.5,
      lobeTopY,
      center.dx - w * 0.65,
      center.dy + h * 0.1,
      center.dx,
      bottomY,
    );
    heartPath.moveTo(center.dx, cleftY);
    heartPath.cubicTo(
      center.dx + w * 0.5,
      lobeTopY,
      center.dx + w * 0.65,
      center.dy + h * 0.1,
      center.dx,
      bottomY,
    );
    canvas.drawPath(heartPath, facetPaint);
    _drawHeartBrilliance(canvas, center, w, h, cleftY, bottomY, facetPaint);
    _drawDimensions(canvas, center, w, h, dimensionPaint);
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

  void _drawDashedBoundary(
    Canvas canvas,
    Offset center,
    double w,
    double h,
    Paint paint,
  ) {
    double top = center.dy - h * 0.45;
    double bottom = center.dy + h * 0.5;
    double left = center.dx - w * 0.5;
    double right = center.dx + w * 0.5;
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

    drawD(Offset(left, top), Offset(right + 45, top));
    drawD(Offset(right, top - 45), Offset(right, bottom));
  }

  void _drawDimensions(
    Canvas canvas,
    Offset center,
    double w,
    double h,
    Paint infoPaint,
  ) {
    double widthY = center.dy - h * 0.45 - 35;
    canvas.drawLine(
      Offset(center.dx - w * 0.5, widthY),
      Offset(center.dx + w * 0.5, widthY),
      infoPaint,
    );
    _drawArrowHead(canvas, Offset(center.dx - w * 0.5, widthY), 0, infoPaint);
    _drawArrowHead(canvas, Offset(center.dx + w * 0.5, widthY), 180, infoPaint);
    _drawText(
      canvas,
      "Width: ${stone.width} mm",
      Offset(center.dx, widthY - 15),
    );
    double lengthX = center.dx + w * 0.5 + 35;
    canvas.drawLine(
      Offset(lengthX, center.dy - h * 0.45),
      Offset(lengthX, center.dy + h * 0.5),
      infoPaint,
    );
    _drawArrowHead(
      canvas,
      Offset(lengthX, center.dy - h * 0.45),
      90,
      infoPaint,
    );
    _drawArrowHead(
      canvas,
      Offset(lengthX, center.dy + h * 0.5),
      270,
      infoPaint,
    );
    _drawText(
      canvas,
      "Length: ${stone.length} mm",
      Offset(lengthX + 55, center.dy),
    );
    _drawText(
      canvas,
      "Length to Width: ${stone.ratio.toStringAsFixed(2)} to 1",
      Offset(center.dx, center.dy + h * 0.5 + 45),
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
    final double width = size.width * 0.55;
    final double centerX = size.width / 2;
    final double startY = 70.0;
    final double tableWidth = width * (stone.table / 100);
    final double totalHeight = width * (stone.depth / 100);
    final double crownHeight = totalHeight * 0.25;
    _drawDashedRect(canvas, centerX, width, startY, totalHeight, dashedPaint);
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
