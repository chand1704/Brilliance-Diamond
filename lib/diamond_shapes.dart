import 'dart:math' as math;

import 'package:flutter/material.dart';

// BASE CLASS FOR MINIMAL SHAPES
abstract class MinimalShapePainter extends CustomPainter {
  final Color color;
  MinimalShapePainter({this.color = const Color(0xFF2D3142)});

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
    final radius = size.width * 0.42;

    // 1. Draw the Outer Girdle (The Circle)
    canvas.drawCircle(center, radius, paint);

    // 2. Define Points for the Inner Octagon (The Table)
    final double tableRadius = radius * 0.48;
    List<Offset> tablePoints = [];
    for (int i = 0; i < 8; i++) {
      // Offset by 22.5 degrees to align corners with standard diamond diagrams
      double angle = (i * 45 + 22.5) * math.pi / 180;
      tablePoints.add(
        Offset(
          center.dx + tableRadius * math.cos(angle),
          center.dy + tableRadius * math.sin(angle),
        ),
      );
    }

    // 3. Define Points for the Middle Ring (Bezel Facet intersection)
    final double middleRadius = radius * 0.75;
    List<Offset> middlePoints = [];
    for (int i = 0; i < 8; i++) {
      double angle = (i * 45 + 22.5) * math.pi / 180;
      middlePoints.add(
        Offset(
          center.dx + middleRadius * math.cos(angle),
          center.dy + middleRadius * math.sin(angle),
        ),
      );
    }

    // 4. Define Points on the Outer Circle (Girdle connection)
    List<Offset> outerPoints = [];
    for (int i = 0; i < 16; i++) {
      double angle = (i * 22.5 + 22.5) * math.pi / 180;
      outerPoints.add(
        Offset(
          center.dx + radius * math.cos(angle),
          center.dy + radius * math.sin(angle),
        ),
      );
    }

    // --- DRAWING THE FACETS ---

    // Draw the Table (Inner Octagon)
    canvas.drawPath(Path()..addPolygon(tablePoints, true), paint);

    for (int i = 0; i < 8; i++) {
      // A. Draw Star Facets (Triangles between table and middle ring)
      // Connects table corner to middle ring midpoint
      double starAngle = (i * 45 + 45 + 22.5) * math.pi / 180;
      Offset starMid = Offset(
        center.dx + middleRadius * math.cos(starAngle - (22.5 * math.pi / 180)),
        center.dy + middleRadius * math.sin(starAngle - (22.5 * math.pi / 180)),
      );

      canvas.drawLine(tablePoints[i], starMid, paint);
      canvas.drawLine(tablePoints[(i + 1) % 8], starMid, paint);

      // B. Draw Bezel Facets (Kite shapes)
      // Connect table points to girdle
      canvas.drawLine(tablePoints[i], outerPoints[i * 2], paint);

      // C. Draw Halves Facets (Outer triangles)
      // Connect middle ring midpoint to the two surrounding girdle points
      canvas.drawLine(starMid, outerPoints[i * 2], paint);
      canvas.drawLine(starMid, outerPoints[(i * 2 + 1) % 16], paint);
      canvas.drawLine(starMid, outerPoints[(i * 2 + 2) % 16], paint);
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

    // Emerald dimensions (Vertical Rectangle)
    final double outerW = size.width * 0.62;
    final double outerH = size.height * 0.85;

    // Define 4 layers of "steps" for the hall-of-mirrors effect
    List<double> scales = [1.0, 0.84, 0.68, 0.48];
    List<List<Offset>> layers = [];

    for (var scale in scales) {
      double w = outerW * scale;
      double h = outerH * scale;
      double c = 8.0 * scale; // Bevel/Crop size scaling with the step

      // Create the 8 points for a beveled rectangle
      List<Offset> points = [
        Offset(center.dx - w / 2 + c, center.dy - h / 2), // Top-left horizontal
        Offset(
          center.dx + w / 2 - c,
          center.dy - h / 2,
        ), // Top-right horizontal
        Offset(center.dx + w / 2, center.dy - h / 2 + c), // Top-right vertical
        Offset(
          center.dx + w / 2,
          center.dy + h / 2 - c,
        ), // Bottom-right vertical
        Offset(
          center.dx + w / 2 - c,
          center.dy + h / 2,
        ), // Bottom-right horizontal
        Offset(
          center.dx - w / 2 + c,
          center.dy + h / 2,
        ), // Bottom-left horizontal
        Offset(
          center.dx - w / 2,
          center.dy + h / 2 - c,
        ), // Bottom-left vertical
        Offset(center.dx - w / 2, center.dy - h / 2 + c), // Top-left vertical
      ];

      layers.add(points);
      canvas.drawPath(Path()..addPolygon(points, true), paint);
    }

    // Connect the 8 points of each step to the next to create the facets
    for (int i = 0; i < layers.length - 1; i++) {
      for (int j = 0; j < 8; j++) {
        canvas.drawLine(layers[i][j], layers[i + 1][j], paint);
      }
    }
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
    // Princess cut is a perfect square
    final double side = size.width * 0.75;

    // 1. Draw Outer Square (Girdle)
    Rect outer = Rect.fromCenter(center: center, width: side, height: side);
    canvas.drawRect(outer, paint);

    // 2. Draw Table (Inner Square)
    final double tableSide = side * 0.58;
    Rect table = Rect.fromCenter(
      center: center,
      width: tableSide,
      height: tableSide,
    );
    canvas.drawRect(table, paint);

    // 3. Main Corner Facet Lines (Connect outer corners to table corners)
    canvas.drawLine(outer.topLeft, table.topLeft, paint);
    canvas.drawLine(outer.topRight, table.topRight, paint);
    canvas.drawLine(outer.bottomLeft, table.bottomLeft, paint);
    canvas.drawLine(outer.bottomRight, table.bottomRight, paint);

    // 4. Side Faceting (The "Chevron" look from image_3ae9ec)
    // Points for the midpoint facets
    // double midOffset = side * 0.08;

    // --- TOP SIDE ---
    Offset topMid = Offset(center.dx, outer.top);
    canvas.drawLine(table.topLeft, topMid, paint);
    canvas.drawLine(table.topRight, topMid, paint);

    // --- BOTTOM SIDE ---
    Offset bottomMid = Offset(center.dx, outer.bottom);
    canvas.drawLine(table.bottomLeft, bottomMid, paint);
    canvas.drawLine(table.bottomRight, bottomMid, paint);

    // --- LEFT SIDE ---
    Offset leftMid = Offset(outer.left, center.dy);
    canvas.drawLine(table.topLeft, leftMid, paint);
    canvas.drawLine(table.bottomLeft, leftMid, paint);

    // --- RIGHT SIDE ---
    Offset rightMid = Offset(outer.right, center.dy);
    canvas.drawLine(table.topRight, rightMid, paint);
    canvas.drawLine(table.bottomRight, rightMid, paint);

    // 5. Secondary Facet Lines (Inner triangles as seen in image)
    // Horizontal/Vertical lines connecting the midpoint of the outer girdle
    // to the midpoint of the table facets
    canvas.drawLine(topMid, Offset(center.dx, table.top), paint);
    canvas.drawLine(bottomMid, Offset(center.dx, table.bottom), paint);
    canvas.drawLine(leftMid, Offset(table.left, center.dy), paint);
    canvas.drawLine(rightMid, Offset(table.right, center.dy), paint);
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
      ..strokeWidth = 1.0;
    final center = Offset(size.width / 2, size.height / 2);
    final w = size.width * 0.65;
    final h = size.height * 0.85;
    final c = 6.0; // crop size

    Path getRadiantPath(double width, double height, double crop) {
      return Path()
        ..moveTo(center.dx - width / 2 + crop, center.dy - height / 2)
        ..lineTo(center.dx + width / 2 - crop, center.dy - height / 2)
        ..lineTo(center.dx + width / 2, center.dy - height / 2 + crop)
        ..lineTo(center.dx + width / 2, center.dy + height / 2 - crop)
        ..lineTo(center.dx + width / 2 - crop, center.dy + height / 2)
        ..lineTo(center.dx - width / 2 + crop, center.dy + height / 2)
        ..lineTo(center.dx - width / 2, center.dy + height / 2 - crop)
        ..lineTo(center.dx - width / 2, center.dy - height / 2 + crop)
        ..close();
    }

    canvas.drawPath(getRadiantPath(w, h, c), paint); // Outer
    canvas.drawRect(
      Rect.fromCenter(center: center, width: w * 0.4, height: h * 0.4),
      paint,
    ); // Table

    // Midpoint facet lines
    canvas.drawLine(
      Offset(center.dx, center.dy - h / 2),
      Offset(center.dx, center.dy - h * 0.2),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy + h / 2),
      Offset(center.dx, center.dy + h * 0.2),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx - w / 2, center.dy),
      Offset(center.dx - w * 0.2, center.dy),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx + w / 2, center.dy),
      Offset(center.dx + w * 0.2, center.dy),
      paint,
    );
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
      ..strokeWidth = 1.3;

    final center = Offset(size.width / 2, size.height / 2);
    final double h = size.height * 0.85;
    final double w = h * 0.65;
    final double topY = center.dy - h * 0.45;
    final double bottomY = center.dy + h * 0.45;

    // 1. Draw the Outer Silhouette (Pear Path)
    final Path girdle = Path();
    girdle.moveTo(center.dx, topY); // The Point
    // Right side curve
    girdle.cubicTo(
      center.dx + w * 0.5,
      topY + h * 0.3,
      center.dx + w * 0.6,
      bottomY,
      center.dx,
      bottomY,
    );
    // Left side curve
    girdle.cubicTo(
      center.dx - w * 0.6,
      bottomY,
      center.dx - w * 0.5,
      topY + h * 0.3,
      center.dx,
      topY,
    );
    canvas.drawPath(girdle, paint);

    // 2. Define Table Points (Inner Teardrop)
    final double tw = w * 0.35;
    final double th = h * 0.4;
    final double tTopY = topY + h * 0.25;
    final double tBottomY = tTopY + th;

    // Table corners for connections
    final Offset tableTop = Offset(center.dx, tTopY);
    final Offset tableRight = Offset(
      center.dx + tw * 0.45,
      center.dy + h * 0.05,
    );
    final Offset tableLeft = Offset(
      center.dx - tw * 0.45,
      center.dy + h * 0.05,
    );
    final Offset tableBottom = Offset(center.dx, tBottomY);

    // 3. Define Girdle Connection Points (For facets)
    final Offset girdleMidRight = Offset(
      center.dx + w * 0.38,
      center.dy + h * 0.05,
    );
    final Offset girdleMidLeft = Offset(
      center.dx - w * 0.38,
      center.dy + h * 0.05,
    );
    final Offset girdleBottomRight = Offset(
      center.dx + w * 0.25,
      bottomY - h * 0.1,
    );
    final Offset girdleBottomLeft = Offset(
      center.dx - w * 0.25,
      bottomY - h * 0.1,
    );

    // --- DRAW INTERNAL FACETS ---

    // A. Main Vertical Center Line
    canvas.drawLine(tableTop, Offset(center.dx, topY), paint);
    canvas.drawLine(tableBottom, Offset(center.dx, bottomY), paint);

    // B. Table Perimeter
    final Path tablePath = Path();
    tablePath.moveTo(tableTop.dx, tableTop.dy);
    tablePath.quadraticBezierTo(
      tableRight.dx + 5,
      tableTop.dy + th * 0.5,
      tableBottom.dx,
      tableBottom.dy,
    );
    tablePath.quadraticBezierTo(
      tableLeft.dx - 5,
      tableTop.dy + th * 0.5,
      tableTop.dx,
      tableTop.dy,
    );
    canvas.drawPath(tablePath, paint);

    // C. Upper Facets (The Point)
    canvas.drawLine(
      tableTop,
      Offset(center.dx + w * 0.2, topY + h * 0.15),
      paint,
    );
    canvas.drawLine(
      tableTop,
      Offset(center.dx - w * 0.2, topY + h * 0.15),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx + w * 0.2, topY + h * 0.15),
      tableRight,
      paint,
    );
    canvas.drawLine(
      Offset(center.dx - w * 0.2, topY + h * 0.15),
      tableLeft,
      paint,
    );

    // D. Side Facets (The Belly)
    canvas.drawLine(tableRight, girdleMidRight, paint);
    canvas.drawLine(tableLeft, girdleMidLeft, paint);
    canvas.drawLine(tableRight, girdleBottomRight, paint);
    canvas.drawLine(tableLeft, girdleBottomLeft, paint);

    // E. Lower Star Facets (The Round Bottom)
    canvas.drawLine(tableBottom, girdleBottomRight, paint);
    canvas.drawLine(tableBottom, girdleBottomLeft, paint);
    canvas.drawLine(
      tableBottom,
      Offset(center.dx + w * 0.15, bottomY - h * 0.02),
      paint,
    );
    canvas.drawLine(
      tableBottom,
      Offset(center.dx - w * 0.15, bottomY - h * 0.02),
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
      ..strokeWidth = 1.3;

    final center = Offset(size.width / 2, size.height / 2);

    // 1. Dimensions: Standard Oval Ratio
    final double h = size.height * 0.9;
    final double w = h * 0.65;

    final Rect outerRect = Rect.fromCenter(center: center, width: w, height: h);
    final Rect tableRect = Rect.fromCenter(
      center: center,
      width: w * 0.45,
      height: h * 0.55,
    );

    // 2. Draw the Main Outlines
    canvas.drawOval(outerRect, paint); // Girdle
    canvas.drawOval(tableRect, paint); // Table

    // 3. Define Facet Connection Points
    // We use 8 points around the ellipses to create the brilliant pattern
    List<Offset> girdlePts = [];
    List<Offset> tablePts = [];
    List<Offset> starPts = []; // Mid-points between table and girdle

    for (int i = 0; i < 8; i++) {
      double angle = (i * 45 - 90) * math.pi / 180;

      // Girdle points
      girdlePts.add(
        Offset(
          center.dx + (w / 2) * math.cos(angle),
          center.dy + (h / 2) * math.sin(angle),
        ),
      );

      // Table points
      tablePts.add(
        Offset(
          center.dx + (tableRect.width / 2) * math.cos(angle),
          center.dy + (tableRect.height / 2) * math.sin(angle),
        ),
      );

      // Star/Bezel intersection points (outer ring midpoints)
      double midAngle = (i * 45 - 67.5) * math.pi / 180;
      starPts.add(
        Offset(
          center.dx + (w * 0.42) * math.cos(midAngle),
          center.dy + (h * 0.42) * math.sin(midAngle),
        ),
      );
    }

    // --- DRAW INTERNAL FACETS ---

    for (int i = 0; i < 8; i++) {
      int next = (i + 1) % 8;

      // A. Main Bezel Lines (Table corner to Girdle corner)
      canvas.drawLine(tablePts[i], girdlePts[i], paint);

      // B. Star Facets (Triangles pointing inward from girdle)
      canvas.drawLine(girdlePts[i], starPts[i], paint);
      canvas.drawLine(girdlePts[next], starPts[i], paint);

      // C. Connection to table to complete the "Kite" bezel facet
      canvas.drawLine(tablePts[i], starPts[i], paint);
      canvas.drawLine(tablePts[next], starPts[i], paint);
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

    // 1. Asscher is a square shape with deep cropped corners
    final double side = size.width * 0.8;

    // We draw 4 nested octagonal layers (the steps)
    List<double> scales = [1.0, 0.82, 0.64, 0.45];
    List<List<Offset>> layers = [];

    for (var scale in scales) {
      double s = side * scale;
      // Deep corner crops for the Asscher look
      double c = (s / 3.2);

      List<Offset> points = [
        Offset(center.dx - s / 2 + c, center.dy - s / 2), // Top-left horizontal
        Offset(
          center.dx + s / 2 - c,
          center.dy - s / 2,
        ), // Top-right horizontal
        Offset(center.dx + s / 2, center.dy - s / 2 + c), // Top-right vertical
        Offset(
          center.dx + s / 2,
          center.dy + s / 2 - c,
        ), // Bottom-right vertical
        Offset(
          center.dx + s / 2 - c,
          center.dy + s / 2,
        ), // Bottom-right horizontal
        Offset(
          center.dx - s / 2 + c,
          center.dy + s / 2,
        ), // Bottom-left horizontal
        Offset(
          center.dx - s / 2,
          center.dy + s / 2 - c,
        ), // Bottom-left vertical
        Offset(center.dx - s / 2, center.dy - s / 2 + c), // Top-left vertical
      ];

      layers.add(points);
      canvas.drawPath(Path()..addPolygon(points, true), paint);
    }

    // 2. Converging Facets (Lines to center from image_3d4709.png)
    // Connect the points of the innermost layer to the center point
    final innerLayer = layers.last;
    for (int j = 0; j < 8; j++) {
      canvas.drawLine(innerLayer[j], center, paint);
    }

    // 3. Connect the steps (Corner structural lines)
    for (int i = 0; i < layers.length - 1; i++) {
      for (int j = 0; j < 8; j++) {
        canvas.drawLine(layers[i][j], layers[i + 1][j], paint);
      }
    }
  }
}

// 11. ROSE CUT
class MinimalRosePainter extends MinimalShapePainter {
  MinimalRosePainter({super.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final center = Offset(size.width / 2, size.height / 2);
    final double radius = size.width * 0.42;

    // 1. Calculate the 6 vertices of the outer Hexagon
    List<Offset> outerPoints = [];
    for (int i = 0; i < 6; i++) {
      double angle =
          (i * 60 - 30) * math.pi / 180; // Adjusted for flat-top look
      outerPoints.add(
        Offset(
          center.dx + radius * math.cos(angle),
          center.dy + radius * math.sin(angle),
        ),
      );
    }

    // 2. Calculate the 6 vertices of the inner Hexagon (the crown)
    final double innerRadius = radius * 0.45;
    List<Offset> innerPoints = [];
    for (int i = 0; i < 6; i++) {
      double angle = (i * 60 - 30) * math.pi / 180;
      innerPoints.add(
        Offset(
          center.dx + innerRadius * math.cos(angle),
          center.dy + innerRadius * math.sin(angle),
        ),
      );
    }

    // 3. Draw Outer Hexagon
    canvas.drawPath(Path()..addPolygon(outerPoints, true), paint);

    // 4. Draw Inner Hexagon
    canvas.drawPath(Path()..addPolygon(innerPoints, true), paint);

    // 5. Draw Facet lines (Inner to Outer connections)
    for (int i = 0; i < 6; i++) {
      // Connect inner corners to outer corners
      canvas.drawLine(innerPoints[i], outerPoints[i], paint);

      // Draw the triangular facet lines as seen in reference image
      // Connect inner corner to the next outer corner
      canvas.drawLine(innerPoints[i], outerPoints[(i + 1) % 6], paint);

      // Connect center to inner corners (Center Point facets)
      canvas.drawLine(center, innerPoints[i], paint);
    }
  }
}

// 12. BAGUETTE (Faceted Hexagon style based on your image)
class MinimalBaguettePainter extends MinimalShapePainter {
  MinimalBaguettePainter({super.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final center = Offset(size.width / 2, size.height / 2);
    final double radius = size.width * 0.45;

    // 1. Calculate the 6 vertices of the outer Hexagon
    List<Offset> outerPoints = [];
    for (int i = 0; i < 6; i++) {
      double angle = (i * 60 + 90) * math.pi / 180;
      outerPoints.add(
        Offset(
          center.dx + radius * math.cos(angle),
          center.dy + radius * math.sin(angle),
        ),
      );
    }

    // 2. Draw Outer Hexagon
    canvas.drawPath(Path()..addPolygon(outerPoints, true), paint);

    // 3. Define Midpoints for internal grid
    List<Offset> midPoints = outerPoints
        .map(
          (p) => Offset(
            center.dx + (p.dx - center.dx) * 0.5,
            center.dy + (p.dy - center.dy) * 0.5,
          ),
        )
        .toList();

    // 4. Draw internal facet structure
    // ✅ FIX: Use indices [i] to access specific points from the lists
    for (int i = 0; i < 6; i++) {
      // Connect opposite outer vertices through the center
      if (i < 3) {
        canvas.drawLine(outerPoints[i], outerPoints[i + 3], paint);
      }

      // Connect midpoints to neighboring outer points to create triangles
      canvas.drawLine(midPoints[i], outerPoints[(i + 1) % 6], paint);
      canvas.drawLine(midPoints[i], outerPoints[(i + 5) % 6], paint);

      // Connect midpoints to each other to form the inner hexagon
      canvas.drawLine(midPoints[i], midPoints[(i + 1) % 6], paint);
    }
  }
}

// 13. HALF MOON
class MinimalHalfMoonPainter extends CustomPainter {
  final Color color;

  MinimalHalfMoonPainter({this.color = Colors.black});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;

    final center = Offset(size.width / 2, size.height / 2);

    // 1. Dimensions
    final double w = size.width * 0.85;
    final double h = w * 0.45;
    final double topY = center.dy - h / 2;

    // 2. Outer Shape
    final Path path = Path();
    path.moveTo(center.dx - w / 2, topY);
    path.lineTo(center.dx + w / 2, topY);

    path.addArc(
      Rect.fromCenter(center: Offset(center.dx, topY), width: w, height: h * 2),
      0,
      math.pi,
    );

    canvas.drawPath(path, paint);

    // 3. Top Points
    final List<Offset> top = [
      Offset(center.dx - w / 2, topY), // 0
      Offset(center.dx - w * 0.25, topY), // 1
      Offset(center.dx, topY), // 2
      Offset(center.dx + w * 0.25, topY), // 3
      Offset(center.dx + w / 2, topY), // 4
    ];

    // 4. Inner Points
    final Offset vLeft = Offset(center.dx - w * 0.2, topY + h * 0.3);
    final Offset vRight = Offset(center.dx + w * 0.2, topY + h * 0.3);
    final Offset vBottom = Offset(center.dx, topY + h * 0.55);

    // Arc Points
    final Offset arcLeft = Offset(center.dx - w * 0.4, topY + h * 0.5);
    final Offset arcRight = Offset(center.dx + w * 0.4, topY + h * 0.5);
    final Offset arcBottomLeft = Offset(center.dx - w * 0.2, topY + h * 0.85);
    final Offset arcBottomRight = Offset(center.dx + w * 0.2, topY + h * 0.85);
    final Offset arcCenterPoint = Offset(center.dx, topY + h);

    // =========================
    // ✅ FIXED DRAWING SECTION
    // =========================

    // Central "V"
    canvas.drawLine(top[2], vLeft, paint);
    canvas.drawLine(top[2], vRight, paint);

    canvas.drawLine(vLeft, vBottom, paint);
    canvas.drawLine(vRight, vBottom, paint);
    canvas.drawLine(vLeft, vRight, paint);

    // Connect to top
    canvas.drawLine(vLeft, top[1], paint);
    canvas.drawLine(vRight, top[3], paint);
    canvas.drawLine(vBottom, top[2], paint);

    // Bottom facets
    canvas.drawLine(vLeft, arcLeft, paint);
    canvas.drawLine(vLeft, arcBottomLeft, paint);

    canvas.drawLine(vBottom, arcBottomLeft, paint);
    canvas.drawLine(vBottom, arcCenterPoint, paint);
    canvas.drawLine(vBottom, arcBottomRight, paint);

    canvas.drawLine(vRight, arcBottomRight, paint);
    canvas.drawLine(vRight, arcRight, paint);

    // Side triangles
    canvas.drawLine(top[0], arcLeft, paint);
    canvas.drawLine(top[4], arcRight, paint);

    // Extra structure (for better match)
    canvas.drawLine(top[1], arcBottomLeft, paint);
    canvas.drawLine(top[3], arcBottomRight, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// 14. TRAPEZOID
class MinimalTrapezoidPainter extends MinimalShapePainter {
  MinimalTrapezoidPainter({super.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;

    final center = Offset(size.width / 2, size.height / 2);

    // 1. Base dimensions for the outermost trapezoid
    final double topW = size.width * 0.85;
    final double bottomW = size.width * 0.55;
    final double h = size.height * 0.5;
    // final double topY = center.dy - h / 2;
    // final double bottomY = center.dy + h / 2;

    // 2. Define 4 layers of "steps" (from image_3f0200.png)
    List<double> scales = [1.0, 0.75, 0.50, 0.25];
    List<List<Offset>> layers = [];

    for (var s in scales) {
      double curTopW = topW * s;
      double curBottomW = bottomW * s;
      double curH = h * s;

      // Calculate vertical center for each step to keep them nested
      double curTopY = center.dy - curH / 2;
      double curBottomY = center.dy + curH / 2;

      List<Offset> points = [
        Offset(center.dx - curTopW / 2, curTopY), // Top Left
        Offset(center.dx + curTopW / 2, curTopY), // Top Right
        Offset(center.dx + curBottomW / 2, curBottomY), // Bottom Right
        Offset(center.dx - curBottomW / 2, curBottomY), // Bottom Left
      ];

      layers.add(points);
      canvas.drawPath(Path()..addPolygon(points, true), paint);
    }

    // 3. Draw the structural corner lines (connecting the steps)
    // This connects the 4 corners of each layer to the next
    for (int i = 0; i < layers.length - 1; i++) {
      for (int j = 0; j < 4; j++) {
        canvas.drawLine(layers[i][j], layers[i + 1][j], paint);
      }
    }
  }
}

// 15. PENTAGONAL (Faceted/Step style)
class MinimalPentagonalPainter extends MinimalShapePainter {
  MinimalPentagonalPainter({super.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;

    final center = Offset(size.width / 2, size.height / 2);
    // The design is based on concentric pentagons
    final double maxRadius = size.width * 0.45;

    // We draw 4 nested layers (the steps from image_3f05d5.png)
    List<double> scales = [1.0, 0.75, 0.5, 0.25];
    List<List<Offset>> layers = [];

    for (var scale in scales) {
      double r = maxRadius * scale;
      List<Offset> points = [];
      for (int i = 0; i < 5; i++) {
        // Offset by -18 degrees to put a point exactly at the top center
        double angle = (i * 72 - 18) * math.pi / 180;
        points.add(
          Offset(
            center.dx + r * math.cos(angle),
            center.dy + r * math.sin(angle),
          ),
        );
      }
      layers.add(points);
      canvas.drawPath(Path()..addPolygon(points, true), paint);
    }

    // Converging Facets
    // Connect the corners of the innermost pentagon to the center point
    final innerLayer = layers.last;
    for (int j = 0; j < 5; j++) {
      canvas.drawLine(innerLayer[j], center, paint);
    }

    // Step connections (Corner structural lines)
    // Connect the corresponding corners of each layer to the next
    for (int i = 0; i < layers.length - 1; i++) {
      for (int j = 0; j < 5; j++) {
        canvas.drawLine(layers[i][j], layers[i + 1][j], paint);
      }
    }
  }
}

// 16. HEXAGONAL (Step/Nested style as seen in image_3f05eb.png)
class MinimalHexagonalPainter extends MinimalShapePainter {
  MinimalHexagonalPainter({super.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;

    final center = Offset(size.width / 2, size.height / 2);
    // Standard size for navigation bar/list row icons
    final double maxRadius = size.width * 0.45;

    // Define 4 nested layers (the steps)
    List<double> scales = [1.0, 0.76, 0.52, 0.28];
    List<List<Offset>> layers = [];

    // 1. Generate the layers and Draw Hexagons
    for (var scale in scales) {
      double r = maxRadius * scale;
      List<Offset> points = [];
      for (int i = 0; i < 6; i++) {
        // Standard hexagonal angles (60 degrees) starting from the right (0)
        double angle = (i * 60) * math.pi / 180;
        points.add(
          Offset(
            center.dx + r * math.cos(angle),
            center.dy + r * math.sin(angle),
          ),
        );
      }
      layers.add(points);
      // Draw the concentric ring path
      canvas.drawPath(Path()..addPolygon(points, true), paint);
    }

    // 2. Draw Converging Facets
    // Connect the 6 corners of the innermost hexagon to the center point
    final innerLayer = layers.last;
    for (int j = 0; j < 6; j++) {
      canvas.drawLine(innerLayer[j], center, paint);
    }

    // 3. Connect the steps (Corner structural lines)
    // Connect corresponding corners of each layer to the next
    // using direct indexing to ensure perfect alignment
    for (int i = 0; i < layers.length - 1; i++) {
      for (int j = 0; j < 6; j++) {
        // Correct use of layers[i][j] to pick a specific Offset
        canvas.drawLine(layers[i][j], layers[i + 1][j], paint);
      }
    }
  }
}

// 17. TRIANGULAR
class MinimalTriangularPainter extends CustomPainter {
  final Color color;

  MinimalTriangularPainter({this.color = Colors.black});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;

    final center = Offset(size.width / 2, size.height / 2);

    // 🔶 1. Dimensions
    final double side = size.width * 0.9;
    final double h = (math.sqrt(3) / 2) * side;

    final double topY = center.dy - (h * 0.4);
    final double bottomY = center.dy + (h * 0.6);

    // 🔶 2. Girdle (Outer Triangle)
    final List<Offset> girdle = [
      Offset(center.dx - side / 2, topY), // 0
      Offset(center.dx + side / 2, topY), // 1
      Offset(center.dx, bottomY), // 2
    ];
    canvas.drawPath(Path()..addPolygon(girdle, true), paint);

    // 🔶 3. Table (Inner Triangle)
    final double tw = side * 0.45;
    final double th = h * 0.45;

    final double tableTopY = center.dy - (th * 0.2);
    final double tableBottomY = center.dy + (th * 0.6);

    final List<Offset> table = [
      Offset(center.dx - tw / 2, tableTopY), // 0
      Offset(center.dx + tw / 2, tableTopY), // 1
      Offset(center.dx, tableBottomY), // 2
    ];
    canvas.drawPath(Path()..addPolygon(table, true), paint);

    // =====================================================
    // ✅ A. Connect Table → Girdle (FIXED)
    // =====================================================
    canvas.drawLine(table[0], girdle[0], paint);
    canvas.drawLine(table[1], girdle[1], paint);
    canvas.drawLine(table[2], girdle[2], paint);

    // Cross connections (diamond look)
    canvas.drawLine(table[0], girdle[1], paint);
    canvas.drawLine(table[1], girdle[2], paint);
    canvas.drawLine(table[2], girdle[0], paint);

    // =====================================================
    // ✅ B. Mid Facet Points
    // =====================================================
    final Offset topMid = Offset(center.dx, topY);
    final Offset leftMid = Offset(center.dx - side * 0.25, center.dy + h * 0.1);
    final Offset rightMid = Offset(
      center.dx + side * 0.25,
      center.dy + h * 0.1,
    );

    // Connect table → mids
    canvas.drawLine(table[0], topMid, paint);
    canvas.drawLine(table[1], topMid, paint);

    canvas.drawLine(table[0], leftMid, paint);
    canvas.drawLine(table[2], leftMid, paint);

    canvas.drawLine(table[1], rightMid, paint);
    canvas.drawLine(table[2], rightMid, paint);

    // =====================================================
    // ✅ C. Center Connections
    // =====================================================
    canvas.drawLine(table[0], center, paint);
    canvas.drawLine(table[1], center, paint);
    canvas.drawLine(table[2], center, paint);

    // Optional extra facet lines (for realism)
    canvas.drawLine(leftMid, center, paint);
    canvas.drawLine(rightMid, center, paint);
    canvas.drawLine(topMid, center, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// 18. TRILLIANT
class MinimalTrilliantPainter extends CustomPainter {
  final Color color;

  MinimalTrilliantPainter({this.color = Colors.black});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;

    final center = Offset(size.width / 2, size.height / 2);

    // 🔷 OUTER TRIANGLE (GIRDLE)
    final double side = size.width * 0.95;
    final double h = (math.sqrt(3) / 2) * side;

    final double topY = center.dy - (h * 0.55);
    final double bottomY = center.dy + (h * 0.45);

    final List<Offset> g = [
      Offset(center.dx, topY), // g[0] top
      Offset(center.dx + side / 2, bottomY), // g[1] right
      Offset(center.dx - side / 2, bottomY), // g[2] left
    ];

    canvas.drawPath(Path()..addPolygon(g, true), paint);

    // 🔷 INNER TRIANGLE (TABLE)
    final double tw = side * 0.45;
    final double th = (math.sqrt(3) / 2) * tw;

    final double tTopY = center.dy - (th * 0.4);
    final double tBottomY = center.dy + (th * 0.3);

    final List<Offset> t = [
      Offset(center.dx, tTopY), // t[0]
      Offset(center.dx + tw / 2, tBottomY), // t[1]
      Offset(center.dx - tw / 2, tBottomY), // t[2]
    ];

    canvas.drawPath(Path()..addPolygon(t, true), paint);

    // 🔷 MID POINTS (FIXED)
    final Offset leftMid = Offset(
      (g[0].dx + g[2].dx) / 2,
      (g[0].dy + g[2].dy) / 2,
    );

    final Offset rightMid = Offset(
      (g[0].dx + g[1].dx) / 2,
      (g[0].dy + g[1].dy) / 2,
    );

    final Offset bottomMid = Offset(
      (g[1].dx + g[2].dx) / 2,
      (g[1].dy + g[2].dy) / 2,
    );

    // =============================
    // 🔥 INTERNAL FACETS (FIXED)
    // =============================

    // A. Table to Girdle corners
    canvas.drawLine(t[0], g[0], paint);
    canvas.drawLine(t[1], g[1], paint);
    canvas.drawLine(t[2], g[2], paint);

    // B. Cross connections (diamond look)
    canvas.drawLine(t[0], rightMid, paint);
    canvas.drawLine(t[0], leftMid, paint);

    canvas.drawLine(t[1], leftMid, paint);
    canvas.drawLine(t[1], bottomMid, paint);

    canvas.drawLine(t[2], rightMid, paint);
    canvas.drawLine(t[2], bottomMid, paint);

    // C. Bottom fan (important for your design)
    final Offset bottomQuarterLeft = Offset(center.dx - side * 0.2, bottomY);

    final Offset bottomQuarterRight = Offset(center.dx + side * 0.2, bottomY);

    canvas.drawLine(t[1], bottomQuarterRight, paint);
    canvas.drawLine(t[2], bottomQuarterLeft, paint);

    canvas.drawLine(bottomMid, t[1], paint);
    canvas.drawLine(bottomMid, t[2], paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// 19. SHIELD
class MinimalShieldPainter extends MinimalShapePainter {
  MinimalShieldPainter({super.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;

    final center = Offset(size.width / 2, size.height / 2);

    // 1. Dimensions for the outermost shield
    final double w = size.width * 0.8;
    final double h = size.height * 0.8;

    // We draw 4 nested layers (the steps)
    List<double> scales = [1.0, 0.82, 0.64, 0.46];
    List<List<Offset>> layers = [];

    for (var s in scales) {
      double curW = w * s;
      double curH = h * s;
      // Calculate top and bottom based on scaling to keep it centered
      double topY = center.dy - curH * 0.45;
      double midY = center.dy - curH * 0.1;
      double bottomY = center.dy + curH * 0.55;

      // 7-point shield silhouette
      List<Offset> points = [
        Offset(center.dx - curW * 0.25, topY), // Top Left
        Offset(center.dx + curW * 0.25, topY), // Top Right
        Offset(center.dx + curW * 0.5, midY), // Right Shoulder
        Offset(center.dx + curW * 0.35, bottomY - curH * 0.3), // Right Taper
        Offset(center.dx, bottomY), // Bottom Point
        Offset(center.dx - curW * 0.35, bottomY - curH * 0.3), // Left Taper
        Offset(center.dx - curW * 0.5, midY), // Left Shoulder
      ];

      layers.add(points);
      canvas.drawPath(Path()..addPolygon(points, true), paint);
    }

    // 2. Connect the steps (Corner structural lines)
    // Connects corresponding points of each layer to create the "hall of mirrors"
    for (int i = 0; i < layers.length - 1; i++) {
      for (int j = 0; j < 7; j++) {
        canvas.drawLine(layers[i][j], layers[i + 1][j], paint);
      }
    }

    // 3. Optional: Converging facets for the center table
    final innerLayer = layers.last;
    for (int j = 0; j < 7; j++) {
      canvas.drawLine(innerLayer[j], center, paint);
    }
  }
}

// 20. LOZENGE
class MinimalLozengePainter extends MinimalShapePainter {
  MinimalLozengePainter({super.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;

    final center = Offset(size.width / 2, size.height / 2);

    // 1. Dimensions for the outermost rhombus
    final double h = size.height * 0.95;
    final double w = h * 0.55; // Traditional lozenge ratio

    // Define 4 nested layers (the steps)
    List<double> scales = [1.0, 0.78, 0.56, 0.34];
    List<List<Offset>> layers = [];

    // 2. Generate the nested layers and Draw Rhombuses
    for (var s in scales) {
      double sw = w * s;
      double sh = h * s;

      // Top point, Right center, Bottom point, Left center
      List<Offset> points = [
        Offset(center.dx, center.dy - sh / 2), // Top
        Offset(center.dx + sw / 2, center.dy), // Right
        Offset(center.dx, center.dy + sh / 2), // Bottom
        Offset(center.dx - sw / 2, center.dy), // Left
      ];

      layers.add(points);
      // Draw the step ring path
      canvas.drawPath(Path()..addPolygon(points, true), paint);
    }

    // 3. Draw Converging Facets (X pattern from image)
    // Connect the corners of the innermost layer to the center point
    final innerLayer = layers.last;
    for (int j = 0; j < 4; j++) {
      canvas.drawLine(innerLayer[j], center, paint);
    }

    // 4. Connect the steps (Corner structural lines)
    // Connect corresponding corners of each layer to the next
    // using direct indexing to ensure perfect type matching
    for (int i = 0; i < layers.length - 1; i++) {
      for (int j = 0; j < 4; j++) {
        // Access specific offset from the lists (prevent List<Offset> error)
        canvas.drawLine(layers[i][j], layers[i + 1][j], paint);
      }
    }
  }
}

// 21. KITE (Step/Nested style based on image_491451.png)
class MinimalKitePainter extends MinimalShapePainter {
  MinimalKitePainter({super.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;

    final center = Offset(size.width / 2, size.height / 2);

    // 1. Dimensions
    final double w = size.width * 0.7;
    final double h = size.height * 0.9;

    // 2. Define 4 nested layers (the steps)
    List<double> scales = [1.0, 0.75, 0.50, 0.25];
    List<List<Offset>> layers = [];

    for (var s in scales) {
      double curW = w * s;
      double curH = h * s;

      // We position the "shoulders" (widest part) at 35% from the top
      double topY = center.dy - (curH * 0.35);
      double shoulderY = center.dy - (curH * 0.05);
      double bottomY = center.dy + (curH * 0.65);

      List<Offset> points = [
        Offset(center.dx, topY), // Top Point
        Offset(center.dx + curW / 2, shoulderY), // Right Shoulder
        Offset(center.dx, bottomY), // Bottom Point
        Offset(center.dx - curW / 2, shoulderY), // Left Shoulder
      ];

      layers.add(points);
      canvas.drawPath(Path()..addPolygon(points, true), paint);
    }

    // 3. Connect the steps (Corner structural lines)
    // This creates the faceted depth look from your image
    for (int i = 0; i < layers.length - 1; i++) {
      for (int j = 0; j < 4; j++) {
        // Access specific Offset from the nested list
        canvas.drawLine(layers[i][j], layers[i + 1][j], paint);
      }
    }

    // 4. Converging center facets (Inner Table lines)
    final innerLayer = layers.last;
    for (int j = 0; j < 4; j++) {
      canvas.drawLine(innerLayer[j], center, paint);
    }
  }
}

// 22. PORTUGUESE
class MinimalPortuguesePainter extends MinimalShapePainter {
  MinimalPortuguesePainter({super.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;

    final center = Offset(size.width / 2, size.height / 2);
    final double radius = size.width * 0.45;

    // The Portuguese cut typically has 16-fold symmetry
    const int segments = 16;

    // 1. Define Radial Rings (Radii for the facet intersections)
    final double rTable = radius * 0.22; // Small center star
    final double rInner = radius * 0.50; // First rhomboid row
    final double rMiddle = radius * 0.78; // Second rhomboid row
    final double rGirdle = radius; // Outer circle

    // 2. Generate Points for each ring
    List<Offset> tablePoints = [];
    List<Offset> innerPoints = [];
    List<Offset> middlePoints = [];
    List<Offset> girdlePoints = [];

    for (int i = 0; i < segments; i++) {
      double angle = (i * 360 / segments) * math.pi / 180;
      double offsetAngle = ((i + 0.5) * 360 / segments) * math.pi / 180;

      tablePoints.add(
        Offset(
          center.dx + rTable * math.cos(angle),
          center.dy + rTable * math.sin(angle),
        ),
      );
      innerPoints.add(
        Offset(
          center.dx + rInner * math.cos(offsetAngle),
          center.dy + rInner * math.sin(offsetAngle),
        ),
      );
      middlePoints.add(
        Offset(
          center.dx + rMiddle * math.cos(angle),
          center.dy + rMiddle * math.sin(angle),
        ),
      );
      girdlePoints.add(
        Offset(
          center.dx + rGirdle * math.cos(offsetAngle),
          center.dy + rGirdle * math.sin(offsetAngle),
        ),
      );
    }

    // 3. Draw the Facets (Rhomboidal Grid)
    for (int i = 0; i < segments; i++) {
      final next = (i + 1) % segments;

      // A. Center Star Facets
      canvas.drawLine(tablePoints[i], tablePoints[next], paint);
      canvas.drawLine(tablePoints[i], innerPoints[i], paint);
      canvas.drawLine(tablePoints[next], innerPoints[i], paint);

      // B. Inner Rhomboid Row
      canvas.drawLine(innerPoints[i], middlePoints[i], paint);
      canvas.drawLine(innerPoints[i], middlePoints[next], paint);

      // C. Middle Rhomboid Row
      canvas.drawLine(middlePoints[next], girdlePoints[i], paint);
      canvas.drawLine(middlePoints[next], girdlePoints[next], paint);

      // D. Outer Girdle Facets
      canvas.drawLine(girdlePoints[i], girdlePoints[next], paint);

      // E. Connecting cross-lines for the "Portuguese" star look
      canvas.drawLine(innerPoints[i], middlePoints[i], paint);
      canvas.drawLine(middlePoints[i], girdlePoints[i], paint);
      canvas.drawLine(
        middlePoints[i],
        girdlePoints[(i + segments - 1) % segments],
        paint,
      );
    }

    // Draw the outermost girdle circle for a clean finish
    canvas.drawCircle(center, radius, paint);
  }
}
