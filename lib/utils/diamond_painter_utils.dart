import 'package:flutter/material.dart';

// If your painters are in diamond_shapes.dart, import it here:
import '../diamond_shapes.dart';

class DiamondPainterUtils {
  static CustomPainter? getPainterForShapeName(String name, bool isActive) {
    if (name.isEmpty) return null;

    final Color shapeColor = isActive ? Colors.teal : const Color(0xFF616161);
    final String upperName = name.toUpperCase();

    if (upperName.contains("ROUND"))
      return MinimalRoundPainter(color: shapeColor);
    if (upperName.contains("PRINCESS"))
      return MinimalPrincessPainter(color: shapeColor);
    if (upperName.contains("EMERALD"))
      return MinimalEmeraldPainter(color: shapeColor);
    if (upperName.contains("CUSHION"))
      return MinimalCushionPainter(color: shapeColor);
    if (upperName.contains("RADIANT"))
      return MinimalRadiantPainter(color: shapeColor);
    if (upperName.contains("MARQUISE"))
      return MinimalMarquisePainter(color: shapeColor);
    if (upperName.contains("PEAR"))
      return MinimalPearPainter(color: shapeColor);
    if (upperName.contains("OVAL"))
      return MinimalOvalPainter(color: shapeColor);
    if (upperName.contains("HEART"))
      return MinimalHeartPainter(color: shapeColor);
    if (upperName.contains("ASSCHER"))
      return MinimalAsscherPainter(color: shapeColor);
    if (upperName.contains("ROSE"))
      return MinimalRosePainter(color: shapeColor);
    if (upperName.contains("BAGUETTE"))
      return MinimalBaguettePainter(color: shapeColor);
    if (upperName.contains("HALF MOON"))
      return MinimalHalfMoonPainter(color: shapeColor);
    if (upperName.contains("TRAPEZOID"))
      return MinimalTrapezoidPainter(color: shapeColor);
    if (upperName.contains("PENTAGONAL"))
      return MinimalPentagonalPainter(color: shapeColor);
    if (upperName.contains("HEXAGON"))
      return MinimalHexagonalPainter(color: shapeColor);
    if (upperName.contains("TRIANGULAR"))
      return MinimalTriangularPainter(color: shapeColor);
    if (upperName.contains("TRILLIANT") || upperName.contains("TRILLION"))
      return MinimalTrilliantPainter(color: shapeColor);
    if (upperName.contains("SHIELD"))
      return MinimalShieldPainter(color: shapeColor);
    if (upperName.contains("LOZENGE"))
      return MinimalLozengePainter(color: shapeColor);
    if (upperName.contains("KITE"))
      return MinimalKitePainter(color: shapeColor);
    if (upperName.contains("PORTUGUESE"))
      return MinimalPortuguesePainter(color: shapeColor);

    return null;
  }
}
