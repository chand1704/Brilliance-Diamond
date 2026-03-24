import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../diamond_shapes.dart';
import '../model/gmss_stone_model.dart';

class SafeImage extends StatefulWidget {
  final String url;
  final double size;
  final GmssStone stone;
  const SafeImage({
    super.key,
    required this.url,
    required this.size,
    required this.stone,
  });
  @override
  State<SafeImage> createState() => SafeImageState();
}

class SafeImageState extends State<SafeImage> {
  Uint8List? _bytes;
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _fetch();
  }

  @override
  void didUpdateWidget(SafeImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _fetch();
    }
  }

  Future<void> _fetch() async {
    if (widget.url.isEmpty || widget.url == "null") {
      if (mounted) setState(() => _isLoading = false);
      return;
    }
    try {
      final res = await http.get(Uri.parse(widget.url));
      if (res.statusCode == 200) {
        if (mounted) {
          setState(() {
            _bytes = res.bodyBytes;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint("SafeImage Error: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (_bytes != null) {
      return Image.memory(
        _bytes!,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.medium,
      );
    }
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            Colors.teal.withValues(alpha: 0.2),
          ),
        ),
      );
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: CustomPaint(
          size: Size(widget.size * 0.8, widget.size * 0.8),
          painter: _getShapePainter(widget.stone),
        ),
      ),
    );
  }

  CustomPainter _getShapePainter(GmssStone stone) {
    final String shape = stone.shapeStr.toUpperCase();
    if (shape.contains("ROUND")) return MinimalRoundPainter();
    if (shape.contains("PRINCESS")) return MinimalPrincessPainter();
    if (shape.contains("EMERALD")) return MinimalEmeraldPainter();
    if (shape.contains("CUSHION")) return MinimalCushionPainter();
    if (shape.contains("RADIANT")) return MinimalRadiantPainter();
    if (shape.contains("MARQUISE")) return MinimalMarquisePainter();
    if (shape.contains("PEAR")) return MinimalPearPainter();
    if (shape.contains("OVAL")) return MinimalOvalPainter();
    if (shape.contains("HEART")) return MinimalHeartPainter();
    if (shape.contains("ASSCHER")) return MinimalAsscherPainter();
    return MinimalRoundPainter(); // Default
  }
}
