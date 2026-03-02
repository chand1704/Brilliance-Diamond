import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:ui_web' as ui;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart'; // Add this line

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
  final List<Map<String, dynamic>> shapeCategories = [
    {'id': 1, 'name': 'Round', 'icon': 'images/Round.png'},
    {'id': 2, 'name': 'Princess', 'icon': 'images/Princess.png'},
    {'id': 3, 'name': 'Emerald', 'icon': 'images/Emerald.png'},
    {'id': 4, 'name': 'Cushion', 'icon': 'images/Cushion.png'},
    {'id': 5, 'name': 'Radiant', 'icon': 'images/Radiant.png'},
    {'id': 6, 'name': 'Marquise', 'icon': 'images/Marquise.png'},
    {'id': 7, 'name': 'Pear', 'icon': 'images/Pear.png'},
    {'id': 8, 'name': 'Oval', 'icon': 'images/Oval.png'},
    {'id': 9, 'name': 'Heart', 'icon': 'images/Heart.png'},
    {'id': 27, 'name': 'Asscher', 'icon': 'images/Asscher.png'},
  ];
  String _getStaticShapeUrl(String shape) {
    final s = shape.toLowerCase().trim();
    if (s.contains('round'))
      return "https://www.brilliance.com/front/img/src/assets/images/diamond4c/diamond-Round..png";
    if (s.contains('cushion'))
      return "https://www.brilliance.com/front/img/src/assets/images/diamond4c/diamond-Cushion..png";
    if (s.contains('princess'))
      return "https://www.brilliance.com/front/img/src/assets/images/diamond4c/diamond-Princess..png";
    if (s.contains('emerald'))
      return "https://www.brilliance.com/front/img/src/assets/images/diamond4c/diamond-Emerald..png";
    if (s.contains('radiant'))
      return "https://www.brilliance.com/front/img/src/assets/images/diamond4c/diamond-Radiant..png";
    if (s.contains('marquise'))
      return "https://www.brilliance.com/front/img/src/assets/images/diamond4c/diamond-Marquise..png";
    if (s.contains('pear'))
      return "https://www.brilliance.com/front/img/src/assets/images/diamond4c/diamond-Pear..png";
    if (s.contains('oval'))
      return "https://www.brilliance.com/front/img/src/assets/images/diamond4c/diamond-Oval..png";
    if (s.contains('heart'))
      return "https://www.brilliance.com/front/img/src/assets/images/diamond4c/diamond-Heart..png";
    if (s.contains('asscher'))
      return "https://www.brilliance.com/front/img/src/assets/images/diamond4c/diamond-Asscher..png";

    return "https://www.brilliance.com/front/img/src/assets/images/diamond4c/diamond-Round..png";
  }

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

      // On Web, launchUrl is more reliable than canLaunchUrl
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint("Error launching URL: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open certificate link")),
      );
    }
  }

  late bool _isFav;
  final ValueNotifier<double> _caratNotifier = ValueNotifier<double>(0.50);
  @override
  void initState() {
    super.initState();
    _isFav = widget.isFavorite;
    // Set initial slider position to the actual stone weight
    // _currentCaratValue = widget.stone.weight;
    _caratNotifier.value = widget.stone.weight;

    double initialWeight = widget.stone.weight;
    _caratNotifier.value = initialWeight.clamp(0.1, 5.0);
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

      body: Column(
        children: [
          if (!isMobile) _buildMainHeader(const Color(0xFF005AAB)),
          Expanded(
            child: isMobile
                ? SingleChildScrollView(child: _buildMobileLayout())
                : _buildDesktopLayout(),
          ),
        ],
      ),
    );
  }

  // Placeholder Hover Nav Link
  // Widget _hoverNavLink(String label, dynamic controller, Widget menu) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 15),
  //     child: Text(
  //       label,
  //       style: const TextStyle(
  //         fontSize: 14,
  //         fontWeight: FontWeight.w500,
  //         color: Colors.black87,
  //       ),
  //     ),
  //   );
  // }
  Widget _hoverNavLink(String label, dynamic controller, Widget menu) {
    return MouseRegion(
      onEnter: (_) => _showMegaMenu(context, menu), // Trigger menu on hover
      // onExit: (_) => _hideMegaMenu(), // Hide when cursor leaves
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  OverlayEntry? _overlayEntry;

  void _showMegaMenu(BuildContext context, Widget menu) {
    _hideMegaMenu(); // Clear existing menu

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 61, // Position right below your _buildMainHeader
        left: 0,
        right: 0,
        child: MouseRegion(
          // onEnter: (_) {}, // Keep open while mouse is on the menu
          onExit: (_) => _hideMegaMenu(),
          // child: Material(
          //   elevation: 8,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            // padding: const EdgeInsets.all(40),
            child: menu, // This is your _buildMegaMenu(themeColor)
          ),
          // ),
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideMegaMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  // Add these dummy controllers if they aren't defined
  final _diamondHoverController = null;
  final _engagementHoverController = null;
  final _weddingHoverController = null;
  final _jewelryHoverController = null;
  final _aboutHoverController = null;

  // Placeholder Menu builders
  Widget _buildMegaMenu(Color themeColor) {
    return Material(
      elevation: 20,
      shadowColor: Colors.black26,
      child: Container(
        color: Colors.white,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 40),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. SHOP BY SHAPE GRID
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "SHOP BY SHAPE",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Wrap(
                    spacing: 20,
                    runSpacing: 30,
                    children: shapeCategories
                        .map((shape) => _buildShapeIconItem(shape))
                        .toList(),
                  ),
                ],
              ),
            ),

            // 2. NATURAL DIAMONDS COLUMN
            Expanded(
              flex: 2,
              child: _menuColumn("NATURAL DIAMONDS", [
                "All Natural Diamonds",
                "Fancy Color Diamonds",
                "GIA Certified",
              ]),
            ),

            // 3. LAB GROWN COLUMN
            Expanded(
              flex: 2,
              child: _menuColumn("LAB GROWN", [
                "All Lab Diamonds",
                "Sustainable Choice",
                "IGI Certified",
              ]),
            ),

            // 4. NEW ARRIVALS PROMO CARD
            _buildPromoCard(
              "images/diamonds.png",
              "NEW ARRIVALS",
              "Exquisite Lab Brilliance",
            ),
          ],
        ),
      ),
    );
  }

  // FIX: Defines the vertical text columns for the menu
  Widget _menuColumn(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 13,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 20),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              item,
              style: const TextStyle(color: Colors.black87, fontSize: 13),
            ),
          ),
        ),
      ],
    );
  }

  // FIX: Defines the dark-themed promo card on the right
  Widget _buildPromoCard(String assetPath, String title, String subtitle) {
    return Container(
      width: 240,
      height: 320,
      margin: const EdgeInsets.only(left: 30),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              assetPath,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(
                color: const Color(0xFF001F3F),
              ), // Dark blue fallback
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                  colors: [
                    Colors.black.withValues(alpha: 0.9),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // FIX: Helper for individual shape icons in the grid
  Widget _buildShapeIconItem(Map<String, dynamic> shape) {
    return InkWell(
      onTap: () {
        _hideMegaMenu();
      },
      borderRadius: BorderRadius.circular(8),
      hoverColor: Colors.teal.withOpacity(0.05),
      child: Container(
        width: 90,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            Image.asset(
              "assets/${shape['icon']}",
              height: 38,
              color: const Color(0xFF008080), // Use your Teal theme color
              errorBuilder: (c, e, s) =>
                  const Icon(Icons.diamond_outlined, color: Colors.teal),
            ),
            const SizedBox(height: 12),
            Text(
              shape['name'].toString().toUpperCase(),
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEngagementMenu(Color themeColor) {
    return Material(
      elevation: 0,
      shadowColor: Colors.white,
      child: Container(
        color: Colors.white,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 40),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. SHOP BY STYLE
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "SHOP BY STYLE",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _engagementStyleItem("Solitaire"),
                  _engagementStyleItem("Side Stone"),
                  _engagementStyleItem("Halo"),
                  _engagementStyleItem("Three Stones"),
                  _engagementStyleItem("Vintage"),
                ],
              ),
            ),

            // 2. CREATE YOUR OWN RING
            Expanded(
              flex: 2,
              child: _menuColumn("CREATE YOUR OWN RING", [
                "Start with a Setting",
                "Start with a Diamond",
                "3D Ring Creator",
              ]),
            ),

            // 3. SHOP BY METAL & TIPS
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _menuColumn("SHOP BY METAL", [
                    "White Gold",
                    "Yellow Gold",
                    "Rose Gold",
                    "Platinum",
                  ]),
                  const SizedBox(height: 30),
                  _menuColumn("ENGAGEMENT RING TIPS", [
                    "Ring Guide",
                    "Find Your Ring Size",
                  ]),
                ],
              ),
            ),

            // 4. FEATURED 3D CREATOR CARD
            _buildPromoCard(
              "images/engagement.png", // Path to your ring image
              "CREATE YOUR OWN RING",
              "Explore Our 3D Creator",
            ),
          ],
        ),
      ),
    );
  }

  Widget _engagementStyleItem(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Icon(Icons.diamond_outlined, size: 18, color: Colors.black54),
          const SizedBox(width: 15),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeddingMenu(Color themeColor) {
    return Material(
      elevation: 20,
      shadowColor: Colors.black26,
      child: Container(
        color: Colors.white,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 40),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. WOMEN'S RINGS COLUMN
            Expanded(
              flex: 2,
              child: _menuColumn("Women's Rings", [
                "Diamond Wedding Bands",
                "Diamond Eternity Bands",
                "Gemstone Wedding Bands",
                "Bestsellers",
              ]),
            ),

            // 2. MEN'S RINGS COLUMN
            Expanded(
              flex: 2,
              child: _menuColumn("Men's Rings", [
                "Men's Wedding Bands",
                "Men's Diamond Rings",
                "Top 10 Men's Rings",
                "Timeless Inspired Rings",
                "Bold & Unique Rings",
              ]),
            ),

            // 3. WEDDING RING TIPS COLUMN
            Expanded(
              flex: 2,
              child: _menuColumn("Weddings Ring Tips", [
                "Ring Size Chart",
                "Metal Education",
                "Women's Ring Guide",
                "Men's Ring Guide",
              ]),
            ),

            // 4. FEATURED WEDDING RINGS PROMO CARD
            _buildPromoCard(
              "images/wedding.png", // Ensure this path is in your assets
              "Wedding Rings",
              "Explore Our Best Sellers",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJewelryMenu(Color themeColor) {
    return Material(
      elevation: 20,
      shadowColor: Colors.black26,
      child: Container(
        color: Colors.white,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 40),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. BRACELETS & RINGS COLUMN
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _menuColumn("Bracelets", [
                    "Lab Diamond Bracelets",
                    "Diamond Bracelets",
                    "Gemstone Bracelets",
                  ]),
                  const SizedBox(height: 30),
                  _menuColumn("Rings", [
                    "Fashion Rings",
                    "Eternity Rings",
                    "Gemstone Rings",
                  ]),
                ],
              ),
            ),

            // 2. GIFTS & COLLECTIONS COLUMN
            Expanded(
              flex: 2,
              child: _menuColumn("Gifts & Collections", [
                "Gifts For Her",
                "Tennis Bracelets",
                "Hoop Earrings",
              ]),
            ),

            // 3. FEATURED COLUMN
            Expanded(
              flex: 2,
              child: _menuColumn("Featured", [
                "Custom Designed Jewelry",
                "Jewelry Guids",
                "Best Seller Bracelets",
              ]),
            ),

            // 4. VAULT SALE PROMO CARD
            _buildPromoCard(
              "images/jwelry.png", // Ensure this path is in your assets
              "Shop Vault Sale",
              "Get 50% Off with code VAULT",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutMenu(Color themeColor) {
    return Material(
      elevation: 20,
      shadowColor: Colors.black26,
      child: Container(
        color: Colors.white,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 40),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. BRILLIANCE COMPANY COLUMN
            Expanded(
              flex: 2,
              child: _menuColumn("BRILLIANCE", [
                "About",
                "Contact Us",
                "Diamond Experts",
                "Brilliance Reviews",
                "Flexible Financing",
              ]),
            ),

            // 2. CUSTOMER CARE COLUMN
            Expanded(
              flex: 2,
              child: _menuColumn("CUSTOMER CARE", [
                "30 Day Return",
                "Low Price Returns",
                "Lifetime Warranty",
                "FAQs",
                "Resize Your Ring",
                "care & Maintenance",
              ]),
            ),

            // 3. EDUCATION & ARTICLES COLUMN
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _menuColumn("Education", [
                    "Diamond Education",
                    "Jewelry Education",
                    "Engagement Ring Guide",
                  ]),
                  const SizedBox(height: 30),
                  _menuColumn("Articles", [
                    "Jewelry Cleaning Guide",
                    "Diamond Fluorescence Explained",
                    "What Is Rhodium Plating?",
                  ]),
                ],
              ),
            ),

            // 4. HANDMADE PROMO CARD
            _buildPromoCard(
              "images/about.png", // Path to your about promo image
              "Handmade with Love",
              "Learn About Our Process",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainHeader(Color themeColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          // LOGO
          // const Text(
          //   "BRILLIANCE",
          //   style: TextStyle(
          //     fontSize: 24,
          //     fontWeight: FontWeight.w300,
          //     letterSpacing: 6,
          //     color: Color(0xFF005AAB), // Brilliance Blue
          //   ),
          // ),
          const Spacer(),
          // NAVIGATION LINKS
          Row(
            children: [
              _hoverNavLink(
                "Diamonds",
                _diamondHoverController,
                _buildMegaMenu(themeColor),
              ),
              _hoverNavLink(
                "Engagement",
                _engagementHoverController,
                _buildEngagementMenu(themeColor),
              ),
              _hoverNavLink(
                "Wedding",
                _weddingHoverController,
                _buildWeddingMenu(themeColor),
              ),
              _hoverNavLink(
                "Jewelry",
                _jewelryHoverController,
                _buildJewelryMenu(themeColor),
              ),
              _hoverNavLink(
                "About",
                _aboutHoverController,
                _buildAboutMenu(themeColor),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.search, size: 20),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border, size: 20),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, size: 20),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined, size: 20),
            onPressed: () {},
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
          // Left Section: Main Image, Hand Comparison, and Video Link
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
                  // Technical diagrams (Table, Depth, Width)
                  _buildProportionDiagrams(widget.stone),
                  const SizedBox(height: 20),
                  // Video player section
                  _buildEmbeddedVideoPlayer(),
                  // Bottom padding to ensure the last diagram scrolls fully into view
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),

          const SizedBox(width: 30),

          // Right Section: Product Details and Pricing
          Expanded(
            flex: 3,
            child: Container(
              // This side has NO ScrollView, so it stays fixed
              child: _buildProductInfoPanel(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProportionDiagrams(GmssStone stone) {
    // bool isRound = stone.shapeStr.toUpperCase().contains('ROUND');
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
    const String videoUrl =
        "https://www.brilliance.com/sites/default/files/vue/products/diamonds_1.mp4";

    // Unique ID for the platform view
    // final String viewId = 'embedded-diamond-video';
    final String viewId = 'embedded-diamond-video-${widget.stone.id}';

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(viewId, (int viewId) {
      final video = html.VideoElement()
        ..src = videoUrl
        ..controls = false
        ..autoplay = true
        ..loop = true
        ..muted = true
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.objectFit = 'contain'
        ..style.border = 'none';

      return video;
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          height: 500, // Adjust the height as needed
          // decoration: const BoxDecoration(color: Colors.black),
          child: HtmlElementView(viewType: viewId),
        ),
      ],
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
          Center(child: SafeImage(url: widget.stone.image_link, size: 450)),
          Positioned(
            bottom: 20,
            left: 20,
            child: Row(
              children: [
                // Only show the InkWell if certi_file is not null
                if (widget.stone.certi_file != null &&
                    widget.stone.certi_file!.isNotEmpty)
                  InkWell(
                    onTap: () => _launchCertificate(widget.stone.certi_file),
                    borderRadius: BorderRadius.circular(20),
                    child: _buildBadge(
                      // Icons.verified_user_outlined,
                      imageUrl:
                          "https://www.brilliance.com/images.brilliance.com/images/product/diamonds/IGI_logo.jpg",
                      "IGI Certified",
                    ),
                  ),
                // _buildBadge(Icons.verified_user_outlined, "IGI Certified"),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () => _showVideoPopup(widget.stone.video_link),
                  borderRadius: BorderRadius.circular(20),
                  child: _buildBadge(
                    icon: Icons.play_circle_outline,
                    "360 Video",
                  ),
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
        "https://www.brilliance.com/front/img/src/assets/images/diamond4c/hand..png";

    // Scale logic: 1.0 scale factor is for 0.50ct baseline
    // const double baseStoneSize = 80.0;
    // const String staticDiamondUrl =
    //     "https://www.brilliance.com/front/img/src/assets/images/diamond4c/diamond-Round..png";

    // final String shapeImageUrl = _getStaticShapeUrl(widget.stone.shapeStr);

    return ValueListenableBuilder<double>(
      valueListenable: _caratNotifier,
      builder: (context, caratValue, child) {
        double scaleFactor = (caratValue <= 1.50)
            ? (caratValue / 0.50).clamp(0.6, 1.2)
            : (1.2 + (caratValue - 1.50) * 0.2).clamp(1.2, 2.5);
        return Container(
          height: 500, // Height adjusted to accommodate the slider panel
          width: double.infinity,
          decoration: const BoxDecoration(color: Color(0xFFF9F9F9)),
          child: Stack(
            children: [
              // 1. Hand Image
              Positioned.fill(child: SafeImage(url: handImageUrl, size: 400)),

              // 2. Dynamic Diamond - Grows/Shrinks based on slider
              Positioned(
                top: 120,
                left: 216,
                child: Transform.rotate(
                  angle: _getRotationAngle(widget.stone.shapeStr),
                  // widget.stone.shapeStr.toUpperCase().contains('MARQUISE')
                  // ? 2.35
                  // : 0.0,
                  child: Transform.scale(
                    scale: scaleFactor,
                    alignment: Alignment.center,
                    child: SafeImage(
                      url: _getStaticShapeUrl(widget.stone.shapeStr),
                      size: 45,
                    ),
                  ),
                ),
              ),
              // 3. Slider UI Panel
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
                        "Your diamond: ${caratValue.toStringAsFixed(2)} ct.", // ✅ Use caratValue from the builder
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
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon(icon, size: 14),
          if (imageUrl != null)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: SafeImage(
                url: imageUrl,
                size: 18,
              ), // Using your SafeImage for the logo
            )
          else if (icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Icon(icon, size: 14),
            ),
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
      return ColorFiltered(
        // This filter targets the lighter background pixels to blend them away
        colorFilter: ColorFilter.mode(
          Colors.white.withValues(alpha: 0.9),
          BlendMode.modulate,
        ),
        child: Image.memory(
          _bytes!,
          width: widget.size,
          height: widget.size,
          fit: BoxFit.contain,
          // We remove the ShaderMask for a cleaner look
        ),
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
