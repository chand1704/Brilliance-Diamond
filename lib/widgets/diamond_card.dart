import 'package:brilliance_diamond/widgets/safe_image.dart';
import 'package:flutter/material.dart';

import '../model/gmss_stone_model.dart';

class DiamondCard extends StatefulWidget {
  final GmssStone stone;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;
  final VoidCallback onCardTap;
  final Color themeColor;
  const DiamondCard({
    super.key,
    required this.stone,
    required this.isFavorite,
    required this.onFavoriteTap,
    required this.onCardTap,
    required this.themeColor,
  });
  @override
  State<DiamondCard> createState() => DiamondCardState();
}

class DiamondCardState extends State<DiamondCard> {
  bool _isHovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onCardTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: (_isHovered || widget.isFavorite)
                  ? widget.themeColor
                  : Colors.transparent,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: _isHovered ? 0.08 : 0.03),
                blurRadius: _isHovered ? 20 : 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: AnimatedScale(
            scale: _isHovered ? 1.02 : 1.0,
            duration: const Duration(milliseconds: 10),
            curve: Curves.easeOut,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 12.0,
                            left: 12,
                            right: 12,
                          ),
                          child: SafeImage(
                            url: widget.stone.image_link,
                            size: 200,
                            stone: widget.stone,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          icon: Icon(
                            widget.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: widget.isFavorite
                                ? widget.themeColor
                                : Colors.grey.shade300,
                          ),
                          onPressed: widget.onFavoriteTap,
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${widget.stone.weight} CARAT ${widget.stone.shapeStr.toUpperCase()}",
                          // widget.stone.stoneName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${widget.stone.colorStr} • ${widget.stone.clarityStr} • ${widget.stone.lab}",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "\$${widget.stone.total_price.toStringAsFixed(0)}.00",
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
