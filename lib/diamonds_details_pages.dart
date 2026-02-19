import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:ui_web' as ui;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  late bool _isFav;
  // NEW: State variable to track slider value
  double _currentCaratValue = 0.50;

  @override
  void initState() {
    super.initState();
    _isFav = widget.isFavorite;
    // Set initial slider position to the actual stone weight
    _currentCaratValue = widget.stone.weight;
  }

  void _showVideoPopup(String videoUrl) {
    if (videoUrl.isEmpty || videoUrl == "null") {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("360 Video not available")));
      return;
    }

    final String viewId = 'diamond-video-${widget.stone.id}';

    // ignore: undefined_prefixed_name
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
                          "${widget.stone.gridle_condition}",
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isFav ? Icons.favorite : Icons.favorite_border,
              color: _isFav ? Colors.teal : Colors.black,
            ),
            onPressed: () {
              setState(() => _isFav = !_isFav);
              widget.onFavoriteToggle(_isFav);
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: (isMobile == true) ? _buildMobileLayout() : _buildDesktopLayout(),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 6,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                _buildMainImageCard(),
                const SizedBox(height: 20),
                _buildHandComparisonCard(),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Container(
            height: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: Colors.grey.shade100)),
            ),
            child: SingleChildScrollView(child: _buildProductInfoPanel()),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildMainImageCard(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildProductInfoPanel(),
                const SizedBox(height: 20),
                _buildHandComparisonCard(),
              ],
            ),
          ),
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
          Center(child: SafeImage(url: widget.stone.image_link, size: 450)),
          Positioned(
            bottom: 20,
            left: 20,
            child: Row(
              children: [
                _buildBadge(Icons.verified_user_outlined, "IGI Certified"),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () => _showVideoPopup(widget.stone.video_link),
                  borderRadius: BorderRadius.circular(20),
                  child: _buildBadge(Icons.play_circle_outline, "360 Video"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // UPDATED SECTION: Logic added to scale diamond with slider
  Widget _buildHandComparisonCard() {
    const String handImageUrl =
        "https://www.brilliance.com/images/hand-model-placeholder.jpg";

    // Scale logic: 1.0 scale factor is for 0.50ct baseline
    double scaleFactor = _currentCaratValue / 0.50;

    return Container(
      height: 450, // Height adjusted to accommodate the slider panel
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Stack(
        children: [
          // 1. Hand Image
          Positioned.fill(child: SafeImage(url: handImageUrl, size: 400)),

          // 2. Dynamic Diamond - Grows/Shrinks based on slider
          Center(
            child: Transform.scale(
              scale: scaleFactor,
              child: SafeImage(url: widget.stone.image_link, size: 40),
            ),
          ),

          // 3. Slider UI Panel
          Positioned(
            bottom: 25,
            left: 25,
            right: 25,
            child: Container(
              padding: const EdgeInsets.all(20),
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Your diamond: ${_currentCaratValue.toStringAsFixed(2)} ct.",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        "0.79 ct.",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 4,
                      activeTrackColor: const Color(0xFF005AAB),
                      inactiveTrackColor: Colors.blue.shade50,
                      thumbColor: Colors.white,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 10,
                        elevation: 3,
                      ),
                    ),
                    child: Slider(
                      value: _currentCaratValue,
                      min: 0.10,
                      max: 5.00,
                      onChanged: (val) =>
                          setState(() => _currentCaratValue = val),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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

  Widget _buildBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
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

class SafeImage extends StatefulWidget {
  final String url;
  final double size;
  const SafeImage({super.key, required this.url, required this.size});

  @override
  State<SafeImage> createState() => _SafeImageState();
}

class _SafeImageState extends State<SafeImage> {
  Uint8List? _bytes;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    if (widget.url.isEmpty || widget.url == "null") {
      if (mounted) setState(() => _isLoading = false);
      return;
    }
    try {
      final res = await http.get(
        Uri.parse("https://corsproxy.io/?${Uri.encodeComponent(widget.url)}"),
      );
      if (res.statusCode == 200 &&
          (res.headers['content-type'] ?? "").contains('image')) {
        if (mounted) {
          setState(() {
            _bytes = res.bodyBytes;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_bytes != null) {
      return Image.memory(
        _bytes!,
        width: widget.size,
        height: widget.size,
        fit: BoxFit.contain,
      );
    }
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.teal),
      );
    }
    return Icon(
      Icons.diamond_outlined,
      size: widget.size * 0.3,
      color: Colors.grey.shade300,
    );
  }
}

// import 'dart:html' as html;
// import 'dart:typed_data';
// import 'dart:ui_web' as ui;
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// import 'model/gmss_stone_model.dart';
//
// class DiamondDetailScreen extends StatefulWidget {
//   final GmssStone stone;
//   final bool isFavorite;
//   final Function(bool) onFavoriteToggle;
//
//   const DiamondDetailScreen({
//     super.key,
//     required this.stone,
//     required this.isFavorite,
//     required this.onFavoriteToggle,
//   });
//
//   @override
//   State<DiamondDetailScreen> createState() => _DiamondDetailScreenState();
// }
//
// class _DiamondDetailScreenState extends State<DiamondDetailScreen> {
//   late bool _isFav;
//
//   // CHANGE 1: Added state variable for the slider
//   double _currentCaratValue = 0.50;
//
//   @override
//   void initState() {
//     super.initState();
//     _isFav = widget.isFavorite;
//     // CHANGE 2: Default the slider to the actual stone's weight
//     _currentCaratValue = widget.stone.weight;
//   }
//
//   // --- UI SECTION: Hand comparison mockup with Slider ---
//   Widget _buildHandComparisonCard() {
//     const String handImageUrl =
//         "https://www.brilliance.com/images/hand-model-placeholder.jpg";
//
//     // CHANGE 3: Calculate dynamic scale.
//     // We assume 1.0 scale = 0.50ct based on your mockup
//     double scaleFactor = _currentCaratValue / 0.50;
//
//     return Container(
//       height: 450, // Slightly taller to fit the slider control
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: const Color(0xFFF9F9F9),
//         borderRadius: BorderRadius.circular(4),
//       ),
//       child: Stack(
//         children: [
//           // 1. Static Hand Background
//           Positioned.fill(child: SafeImage(url: handImageUrl, size: 400)),
//
//           // 2. DYNAMIC DIAMOND: Scales based on slider
//           Center(
//             child: Transform.scale(
//               scale: scaleFactor,
//               child: SafeImage(url: widget.stone.image_link, size: 40),
//             ),
//           ),
//
//           // 3. SLIDER OVERLAY UI
//           Positioned(
//             bottom: 25,
//             left: 25,
//             right: 25,
//             child: Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 15,
//                     offset: const Offset(0, 5),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Your diamond: ${_currentCaratValue.toStringAsFixed(2)} ct.",
//                         style: const TextStyle(
//                           fontWeight: FontWeight.w900,
//                           fontSize: 13,
//                         ),
//                       ),
//                       const Text(
//                         "5.00 ct.",
//                         style: TextStyle(color: Colors.grey, fontSize: 11),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   SliderTheme(
//                     data: SliderTheme.of(context).copyWith(
//                       trackHeight: 4,
//                       activeTrackColor: const Color(0xFF005AAB),
//                       inactiveTrackColor: Colors.blue.shade50,
//                       thumbColor: Colors.white,
//                       thumbShape: const RoundSliderThumbShape(
//                         enabledThumbRadius: 10,
//                         elevation: 4,
//                       ),
//                     ),
//                     child: Slider(
//                       value: _currentCaratValue,
//                       min: 0.10,
//                       max: 5.00,
//                       onChanged: (val) {
//                         setState(() {
//                           _currentCaratValue = val;
//                         });
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // --- PRESERVED ORIGINAL METHODS ---
//   void _showVideoPopup(String videoUrl) {
//     if (videoUrl.isEmpty || videoUrl == "null") {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("360 Video not available")));
//       return;
//     }
//     final String viewId = 'diamond-video-${widget.stone.id}';
//     // ignore: undefined_prefixed_name
//     ui.platformViewRegistry.registerViewFactory(
//       viewId,
//       (int viewId) => html.IFrameElement()
//         ..src = videoUrl
//         ..style.border = 'none'
//         ..width = '100%'
//         ..height = '100%'
//         ..allowFullscreen = true,
//     );
//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         backgroundColor: Colors.transparent,
//         insetPadding: const EdgeInsets.all(10),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Align(
//               alignment: Alignment.centerRight,
//               child: Padding(
//                 padding: const EdgeInsets.only(bottom: 10),
//                 child: CircleAvatar(
//                   backgroundColor: Colors.white,
//                   radius: 20,
//                   child: IconButton(
//                     icon: const Icon(Icons.close, color: Colors.black),
//                     onPressed: () => Navigator.of(context).pop(),
//                   ),
//                 ),
//               ),
//             ),
//             Container(
//               width: MediaQuery.of(context).size.width * 0.85,
//               height: MediaQuery.of(context).size.height * 0.75,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: HtmlElementView(viewType: viewId),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _showTechnicalDetailsPanel() {
//     showGeneralDialog(
//       context: context,
//       barrierDismissible: true,
//       barrierLabel: 'Dismiss',
//       transitionDuration: const Duration(milliseconds: 300),
//       pageBuilder: (context, animation1, animation2) {
//         return Align(
//           alignment: Alignment.centerRight,
//           child: Material(
//             elevation: 16,
//             child: Container(
//               constraints: BoxConstraints(
//                 minWidth: 350,
//                 maxWidth: MediaQuery.of(context).size.width * 0.35,
//               ),
//               height: double.infinity,
//               color: Colors.white,
//               padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Expanded(
//                         child: Text(
//                           "Lab Grown Diamond Specs",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w900,
//                           ),
//                         ),
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.close),
//                         onPressed: () => Navigator.pop(context),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 30),
//                   Expanded(
//                     child: ListView(
//                       children: [
//                         _buildTechRow("Stock Number :", widget.stone.stockNo),
//                         _buildTechRow("Shape :", widget.stone.shapeStr),
//                         _buildTechRow(
//                           "Carat Weight :",
//                           "${widget.stone.weight} ct.",
//                         ),
//                         _buildTechRow("Color :", widget.stone.colorStr),
//                         _buildTechRow("Clarity :", widget.stone.clarityStr),
//                         _buildTechRow("Cut :", widget.stone.cut_code),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//       transitionBuilder: (context, animation1, animation2, child) {
//         return SlideTransition(
//           position: Tween<Offset>(
//             begin: const Offset(1, 0),
//             end: Offset.zero,
//           ).animate(animation1),
//           child: child,
//         );
//       },
//     );
//   }
//
//   Widget _buildTechRow(String label, String value) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 18),
//       decoration: BoxDecoration(
//         border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: const TextStyle(
//               color: Colors.grey,
//               fontSize: 13,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           Text(
//             value.isEmpty ? "None" : value,
//             style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     bool isMobile = screenWidth < 900;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(
//               _isFav ? Icons.favorite : Icons.favorite_border,
//               color: _isFav ? Colors.teal : Colors.black,
//             ),
//             onPressed: () {
//               setState(() => _isFav = !_isFav);
//               widget.onFavoriteToggle(_isFav);
//             },
//           ),
//         ],
//       ),
//       body: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
//     );
//   }
//
//   Widget _buildDesktopLayout() {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Expanded(
//           flex: 6,
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(40),
//             child: Column(
//               children: [
//                 _buildMainImageCard(),
//                 const SizedBox(height: 20),
//                 _buildHandComparisonCard(),
//               ],
//             ),
//           ),
//         ),
//         Expanded(
//           flex: 4,
//           child: Container(
//             height: double.infinity,
//             padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
//             decoration: BoxDecoration(
//               border: Border(left: BorderSide(color: Colors.grey.shade100)),
//             ),
//             child: SingleChildScrollView(child: _buildProductInfoPanel()),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildMobileLayout() {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           _buildMainImageCard(),
//           Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               children: [
//                 _buildProductInfoPanel(),
//                 const SizedBox(height: 20),
//                 _buildHandComparisonCard(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMainImageCard() {
//     return Container(
//       height: 500,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: const Color(0xFFF9F9F9),
//         borderRadius: BorderRadius.circular(4),
//       ),
//       child: Stack(
//         children: [
//           Center(child: SafeImage(url: widget.stone.image_link, size: 450)),
//           Positioned(
//             bottom: 20,
//             left: 20,
//             child: Row(
//               children: [
//                 _buildBadge(Icons.verified_user_outlined, "IGI Certified"),
//                 const SizedBox(width: 10),
//                 InkWell(
//                   onTap: () => _showVideoPopup(widget.stone.video_link),
//                   borderRadius: BorderRadius.circular(20),
//                   child: _buildBadge(Icons.play_circle_outline, "360 Video"),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildProductInfoPanel() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "${widget.stone.weight} Carat ${widget.stone.shapeStr} Lab Grown Diamond",
//           style: const TextStyle(
//             fontSize: 28,
//             fontWeight: FontWeight.w800,
//             height: 1.2,
//           ),
//         ),
//         const SizedBox(height: 20),
//         Wrap(
//           spacing: 10,
//           runSpacing: 10,
//           crossAxisAlignment: WrapCrossAlignment.center,
//           children: [
//             _buildSpecChip("${widget.stone.weight} Carat"),
//             _buildSpecChip("${widget.stone.colorStr} Color"),
//             _buildSpecChip("${widget.stone.clarityStr} Clarity"),
//             _buildSpecChip("${widget.stone.cut_code} Cut"),
//             GestureDetector(
//               onTap: _showTechnicalDetailsPanel,
//               child: const Text(
//                 "More Details",
//                 style: TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.bold,
//                   decoration: TextDecoration.underline,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 30),
//         Text(
//           "\$${widget.stone.total_price.toStringAsFixed(2)}",
//           style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
//         ),
//         const SizedBox(height: 40),
//         SizedBox(
//           width: double.infinity,
//           height: 55,
//           child: ElevatedButton(
//             onPressed: () {},
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF005AAB),
//               shape: const RoundedRectangleBorder(),
//             ),
//             child: const Text(
//               "CHOOSE THIS DIAMOND",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(height: 12),
//         SizedBox(
//           width: double.infinity,
//           height: 55,
//           child: OutlinedButton(
//             onPressed: () {},
//             style: OutlinedButton.styleFrom(
//               side: const BorderSide(color: Color(0xFF005AAB)),
//               shape: const RoundedRectangleBorder(),
//             ),
//             child: const Text(
//               "ADD TO CART",
//               style: TextStyle(
//                 color: Color(0xFF005AAB),
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ),
//         const Divider(height: 60),
//         _buildTrustRow(),
//       ],
//     );
//   }
//
//   Widget _buildBadge(IconData icon, String label) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Row(
//         children: [
//           Icon(icon, size: 14),
//           const SizedBox(width: 6),
//           Text(
//             label,
//             style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSpecChip(String label) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       color: const Color(0xFFF5F5F5),
//       child: Text(
//         label,
//         style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
//       ),
//     );
//   }
//
//   Widget _buildTrustRow() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         _trustItem(Icons.verified_outlined, "Honest Pricing"),
//         _trustItem(Icons.security_outlined, "Lifetime Warranty"),
//         _trustItem(Icons.assignment_return_outlined, "30-Day Returns"),
//       ],
//     );
//   }
//
//   Widget _trustItem(IconData icon, String label) {
//     return Column(
//       children: [
//         Icon(icon, size: 20, color: Colors.grey),
//         const SizedBox(height: 5),
//         Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
//       ],
//     );
//   }
// }
//
// class SafeImage extends StatefulWidget {
//   final String url;
//   final double size;
//   const SafeImage({super.key, required this.url, required this.size});
//
//   @override
//   State<SafeImage> createState() => _SafeImageState();
// }
//
// class _SafeImageState extends State<SafeImage> {
//   Uint8List? _bytes;
//   bool _isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetch();
//   }
//
//   Future<void> _fetch() async {
//     if (widget.url.isEmpty || widget.url == "null") {
//       if (mounted) setState(() => _isLoading = false);
//       return;
//     }
//     try {
//       final res = await http.get(
//         Uri.parse("https://corsproxy.io/?${Uri.encodeComponent(widget.url)}"),
//       );
//       if (res.statusCode == 200 &&
//           (res.headers['content-type'] ?? "").contains('image')) {
//         if (mounted)
//           setState(() {
//             _bytes = res.bodyBytes;
//             _isLoading = false;
//           });
//       } else {
//         if (mounted) setState(() => _isLoading = false);
//       }
//     } catch (_) {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_bytes != null)
//       return Image.memory(
//         _bytes!,
//         width: widget.size,
//         height: widget.size,
//         fit: BoxFit.contain,
//       );
//     if (_isLoading)
//       return const Center(
//         child: CircularProgressIndicator(strokeWidth: 2, color: Colors.teal),
//       );
//     return Icon(
//       Icons.diamond_outlined,
//       size: widget.size * 0.3,
//       color: Colors.grey.shade300,
//     );
//   }
// }
