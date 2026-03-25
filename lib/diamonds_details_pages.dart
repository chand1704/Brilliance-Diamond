import 'dart:html' as html;
import 'dart:ui_web' as ui;

import 'package:brilliance_diamond/utils/diamond_painter_utils.dart';
import 'package:brilliance_diamond/widgets/main_header.dart';
import 'package:brilliance_diamond/widgets/safe_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'DiamondDesign.dart';
import 'model/gmss_stone_model.dart';

class DiamondDetailScreen extends StatefulWidget {
  final GmssStone stone;
  final bool isFavorite;
  final Function(bool) onFavoriteToggle;
  const DiamondDetailScreen({
    super.key,
    required this.stone,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });
  @override
  State<DiamondDetailScreen> createState() => _DiamondDetailScreenState();
}

class _DiamondDetailScreenState extends State<DiamondDetailScreen> {
  static const String shapeBaseUrl =
      "https://demo.kodllin.com/apis/storage/app/shape_images/";

  final List<Map<String, dynamic>> shapeCategories = [
    {'id': 1, 'name': 'Round', 'icon': '${shapeBaseUrl}Round.svg'},
    {'id': 2, 'name': 'Princess', 'icon': '${shapeBaseUrl}Princess.svg'},
    {'id': 3, 'name': 'Emerald', 'icon': '${shapeBaseUrl}Emerald.svg'},
    {'id': 4, 'name': 'Cushion', 'icon': '${shapeBaseUrl}Cushion.svg'},
    {'id': 5, 'name': 'Radiant', 'icon': '${shapeBaseUrl}L%20Radiant.svg'},
    {'id': 6, 'name': 'Marquise', 'icon': '${shapeBaseUrl}Marquise.svg'},
    {'id': 7, 'name': 'Pear', 'icon': '${shapeBaseUrl}Pear.svg'},
    {'id': 8, 'name': 'Oval', 'icon': '${shapeBaseUrl}Oval.svg'},
    {'id': 9, 'name': 'Heart', 'icon': '${shapeBaseUrl}Heart.svg'},
    {'id': 27, 'name': 'Asscher', 'icon': '${shapeBaseUrl}1_sf_1734065506.svg'},
  ];
  double _getRotationAngle(String shape) {
    final s = shape.toUpperCase();
    if (s.contains('MARQUISE')) return 2.48;
    if (s.contains('RADIANT')) return 2.39;
    if (s.contains('CUSHION')) return 2.45;
    if (s.contains('EMERALD')) return 2.40;
    if (s.contains('PEAR')) return 11.80;
    if (s.contains('OVAL')) return 2.38;
    if (s.contains('HEART')) return 5.60;
    return 0.0;
  }

  Future<void> _launchCertificate(String? url) async {
    if (url == null || url.isEmpty || url == "null ") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Certificate not available for this stone"),
        ),
      );
      return;
    }
    try {
      final Uri uri = Uri.parse(url);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint("Error launching URL: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open certificate link")),
      );
    }
  }

  final ValueNotifier<double> _caratNotifier = ValueNotifier<double>(0.50);
  @override
  void initState() {
    super.initState();
    _caratNotifier.value = widget.stone.weight;
    // double initialWeight = widget.stone.weight;
    // _caratNotifier.value = initialWeight.clamp(0.1, 5.0);
    // ✅ Register the factory ONCE here, not in the build method
    final String viewId = 'embedded-diamond-video-${widget.stone.id}';

    // Try using the direct URL or a proxy if it still fails
    const String videoUrl =
        "https://www.brilliance.com/sites/default/files/vue/products/diamonds_1.mp4";

    ui.platformViewRegistry.registerViewFactory(viewId, (int viewId) {
      final video = html.VideoElement()
        ..src = videoUrl
        ..autoplay = true
        ..loop = true
        ..muted = true
        ..controls = false
        ..setAttribute('playsinline', 'true')
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.objectFit = 'cover'
        ..style.border = 'none';
      video.crossOrigin = "anonymous";

      return video;
    });
  }

  void _showVideoPopup(String videoUrl) {
    if (videoUrl.isEmpty || videoUrl == "null") {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("360 Video not available")));
      return;
    }
    final String viewId = 'diamond-video-${widget.stone.id}';
    ui.platformViewRegistry.registerViewFactory(
      viewId,
      (int viewId) => html.IFrameElement()
        ..src = videoUrl
        ..style.border = 'none'
        ..width = '100%'
        ..height = '100%'
        ..allowFullscreen = true,
    );
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.85,
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: HtmlElementView(viewType: viewId),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTechnicalDetailsPanel() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation1, animation2) {
        return Align(
          alignment: Alignment.centerRight,
          child: Material(
            elevation: 16,
            child: Container(
              constraints: BoxConstraints(
                minWidth: 350,
                maxWidth: MediaQuery.of(context).size.width * 0.35,
              ),
              height: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          "Lab Grown Diamond: Specifications",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            height: 1.3,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: ListView(
                      children: [
                        _buildTechRow("Stock Number :", widget.stone.stockNo),
                        _buildTechRow("Shape :", widget.stone.shapeStr),
                        _buildTechRow(
                          "Carat Weight :",
                          "${widget.stone.weight} ct.",
                        ),
                        _buildTechRow("Color :", widget.stone.colorStr),
                        _buildTechRow("Clarity :", widget.stone.clarityStr),
                        _buildTechRow("Cut :", widget.stone.cut_code),
                        _buildTechRow("Measurements :", "4.78x3.45x2.42 mm"),
                        _buildTechRow(
                          "Length of Width :",
                          "${widget.stone.width}",
                        ),
                        _buildTechRow("Certification :", widget.stone.lab),
                        _buildTechRow("Depth% :", "${widget.stone.depth}%"),
                        _buildTechRow("Table% :", "${widget.stone.table}%"),
                        _buildTechRow("Polish :", widget.stone.polish),
                        _buildTechRow("Symmetry :", widget.stone.symmetry),
                        _buildTechRow(
                          "Gridle :",
                          widget.stone.gridle_condition,
                        ),
                        _buildTechRow("Culet :", widget.stone.culet_size),
                        _buildTechRow(
                          "Fluorescence :",
                          widget.stone.fl_intensity,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation1, animation2, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(animation1),
          child: child,
        );
      },
    );
  }

  Widget _buildTechRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value.isEmpty ? "None" : value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 900;
    const Color headerTheme = Color(0xFF005AAB);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          if (!isMobile)
            MainHeader(
              // ✅ Use the Widget class here
              themeColor: headerTheme,
              shapeCategories: shapeCategories,
              onNaturalDiamondsTap: () {
                // Navigate back to search or filter for Natural
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              onFancyDiamondsTap: () {
                // Navigate back to search or filter for Fancy
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              onShapeTap: (shapeName, shapeId) {
                // Navigate back to search and select this shape
                debugPrint("Selected Shape from Detail: $shapeName");
                Navigator.of(
                  context,
                ).pop({'selectedShape': shapeName, 'selectedShapeId': shapeId});
              },
            ),
          Expanded(
            child: isMobile
                ? SingleChildScrollView(child: _buildMobileLayout())
                : _buildDesktopLayout(),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 6,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildMainImageCard()),
                      const SizedBox(width: 15),
                      Expanded(child: _buildHandComparisonCard()),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildProportionDiagrams(widget.stone),
                  const SizedBox(height: 20),
                  _buildEmbeddedVideoPlayer(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          const SizedBox(width: 30),
          Expanded(flex: 3, child: Container(child: _buildProductInfoPanel())),
        ],
      ),
    );
  }

  Widget _buildProportionDiagrams(GmssStone stone) {
    String shape = stone.shapeStr.toUpperCase();
    bool isRound = shape.contains('ROUND');
    bool isPrincess = shape.contains('PRINCESS');
    bool isEmerald = shape.contains('EMERALD');
    bool isCushion = shape.contains('CUSHION');
    bool isRadiant = shape.contains('RADIANT');
    bool isMarquise = shape.contains('MARQUISE');
    bool isPear = shape.contains('PEAR');
    bool isOval = shape.contains('OVAL');
    bool isHeart = shape.contains('HEART');
    bool isBaguette = shape.contains('BAGUETTE');
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                height: 400,
                padding: const EdgeInsets.all(30),
                color: const Color(0xFFF9F9F9),
                child: isRound
                    ? CustomPaint(painter: RoundTopViewPainter(stone: stone))
                    : isPrincess
                    ? CustomPaint(painter: PrincessTopViewPainter(stone: stone))
                    : isEmerald
                    ? CustomPaint(painter: EmeraldTopViewPainter(stone: stone))
                    : isCushion
                    ? CustomPaint(painter: CushionTopViewPainter(stone: stone))
                    : isRadiant
                    ? CustomPaint(painter: RadiantTopViewPainter(stone: stone))
                    : isMarquise
                    ? CustomPaint(painter: MarquiseTopViewPainter(stone: stone))
                    : isPear
                    ? CustomPaint(painter: PearTopViewPainter(stone: stone))
                    : isOval
                    ? CustomPaint(painter: OvalTopViewPainter(stone: stone))
                    : isHeart
                    ? CustomPaint(painter: HeartTopViewPainter(stone: stone))
                    : isBaguette
                    ? CustomPaint(painter: BaguetteTopViewPainter(stone: stone))
                    : Center(
                        child: Text(
                          "${stone.shapeStr} diagram coming soon",
                          style: TextStyle(color: Colors.grey.shade400),
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Container(
                height: 400,
                padding: const EdgeInsets.all(30),
                color: const Color(0xFFF9F9F9),
                child: CustomPaint(
                  painter: DiamondProfilePainter(stone: stone),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmbeddedVideoPlayer() {
    final String viewId = 'embedded-diamond-video-${widget.stone.id}';
    return Container(
      width: double.infinity,
      height: 500,
      decoration: BoxDecoration(
        color: Colors
            .black, // Dark background looks better if video takes a second to load
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: HtmlElementView(viewType: viewId),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildMainImageCard(),
          const SizedBox(height: 20),
          _buildProductInfoPanel(),
          const SizedBox(height: 20),
          _buildHandComparisonCard(),
        ],
      ),
    );
  }

  Widget _buildMainImageCard() {
    return Container(
      height: 500,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Stack(
        children: [
          Center(
            child: SafeImage(
              url: widget.stone.image_link,
              size: 450,
              stone: widget.stone,
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Row(
              children: [
                if (widget.stone.certi_file != null &&
                    widget.stone.certi_file!.isNotEmpty &&
                    widget.stone.certi_file != "null")
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: InkWell(
                      onTap: () => _launchCertificate(widget.stone.certi_file),
                      borderRadius: BorderRadius.circular(20),
                      child: _buildBadge(
                        "${widget.stone.lab} Certificate",
                        imageUrl:
                            "https://www.brilliance.com/images.brilliance.com/images/product/diamonds/GIA_logo.jpg",
                        icon: Icons.verified_user_outlined,
                      ),
                    ),
                  ),
                InkWell(
                  onTap: () => _showVideoPopup(widget.stone.video_link),
                  borderRadius: BorderRadius.circular(20),
                  child: _buildBadge(
                    "360 Video",
                    icon: Icons.play_circle_outline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHandComparisonCard() {
    final String handImageUrl = "assets/images/img.png";
    return ValueListenableBuilder<double>(
      valueListenable: _caratNotifier,
      builder: (context, caratValue, child) {
        double scaleFactor = (caratValue <= 1.50)
            ? (caratValue / 0.50).clamp(0.6, 1.2)
            : (1.2 + (caratValue - 1.50) * 0.2).clamp(1.2, 2.5);
        return Container(
          height: 500,
          width: double.infinity,
          decoration: const BoxDecoration(color: Color(0xFFF9F9F9)),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  handImageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Text("Hand image not found in assets"),
                  ),
                ),
              ),
              Positioned(
                top: 120,
                left: 216,
                child: Transform.rotate(
                  angle: _getRotationAngle(widget.stone.shapeStr),
                  child: Transform.scale(
                    scale: scaleFactor,
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 45,
                      height: 45,
                      child: CustomPaint(
                        painter: DiamondPainterUtils.getPainterForShapeName(
                          widget.stone.shapeStr,
                          false,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 25,
                left: 25,
                right: 25,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Your diamond: ${caratValue.toStringAsFixed(2)} ct.",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 4,
                            activeTickMarkColor: const Color(0xFF005AAB),
                            inactiveTrackColor: Colors.blue.shade50,
                            thumbColor: Colors.white,
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 10,
                              elevation: 3,
                            ),
                          ),
                          child: Slider(
                            value: caratValue.clamp(0.1, 5.0),
                            min: 0.10,
                            max: 5.00,
                            onChanged: (val) {
                              _caratNotifier.value = val;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "5.00 ct.",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProductInfoPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${widget.stone.weight} Carat ${widget.stone.shapeStr} Lab Grown Diamond",
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _buildSpecChip("${widget.stone.weight} Carat"),
            _buildSpecChip("${widget.stone.colorStr} Color"),
            _buildSpecChip("${widget.stone.clarityStr} Clarity"),
            _buildSpecChip("${widget.stone.cut_code} Cut"),
            GestureDetector(
              onTap: _showTechnicalDetailsPanel,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "More Details",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward, size: 14),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        Text(
          "\$${widget.stone.total_price.toStringAsFixed(2)}",
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
        ),
        const Text(
          "Starting at \$30.08/mo. See options",
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF005AAB),
              shape: const RoundedRectangleBorder(),
            ),
            child: const Text(
              "CHOOSE THIS DIAMOND",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 55,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF005AAB)),
              shape: const RoundedRectangleBorder(),
            ),
            child: const Text(
              "ADD TO CART",
              style: TextStyle(
                color: Color(0xFF005AAB),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const Divider(height: 60),
        _buildTrustRow(),
      ],
    );
  }

  Widget _buildBadge(String label, {IconData? icon, String? imageUrl}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (imageUrl != null)
            Image.network(
              imageUrl,
              width: 18,
              height: 18,
              errorBuilder: (c, e, s) =>
                  const Icon(Icons.description, size: 14),
            )
          else if (icon != null)
            Icon(icon, size: 16, color: const Color(0xFF005AAB)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: const Color(0xFFF5F5F5),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildTrustRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _trustItem(Icons.verified_outlined, "Honest Pricing"),
        _trustItem(Icons.security_outlined, "Lifetime Warranty"),
        _trustItem(Icons.assignment_return_outlined, "30-Day Returns"),
      ],
    );
  }

  Widget _trustItem(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }
}
