import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'diamonds_details_pages.dart';
import 'model/gmss_stone_model.dart';
import 'service/gmss_api_service.dart';

class GmssScreen extends StatefulWidget {
  const GmssScreen({super.key});
  @override
  State<GmssScreen> createState() => _GmssScreenState();
}

class _GmssScreenState extends State<GmssScreen> {
  bool isFancySearch = false;
  bool isFancyExpanded = false;
  String? selectedFancyColor;
  final List<Map<String, dynamic>> fancyColors = [
    {
      'name': 'Green',
      'url':
          'https://www.brilliance.com/sites/default/files/vue/fancy-search/RD_Green.png',
    },
    {
      'name': 'Orange',
      'url':
          'https://www.brilliance.com/sites/default/files/vue/fancy-search/RD_Orange.png',
    },
    {
      'name': 'Pink',
      'url':
          'https://www.brilliance.com/sites/default/files/vue/fancy-search/RD_Pink.png',
    },
    {
      'name': 'Purple',
      'url':
          'https://www.brilliance.com/sites/default/files/vue/fancy-search/RD_Purple.png',
    },
    {
      'name': 'Yellow',
      'url':
          'https://www.brilliance.com/sites/default/files/vue/fancy-search/RD_Yellow.png',
    },
    {
      'name': 'Blue',
      'url':
          'https://www.brilliance.com/sites/default/files/vue/fancy-search/RD_Blue.png',
    },
    {
      'name': 'Grey',
      'url':
          'https://www.brilliance.com/sites/default/files/vue/fancy-search/RD_Grey.png',
    },
    {
      'name': 'Brown',
      'url':
          'https://www.brilliance.com/sites/default/files/vue/fancy-search/RD_Brown.png',
    },
    {
      'name': 'White',
      'url':
          'https://www.brilliance.com/sites/default/files/vue/fancy-search/RD_NZ.png',
    },
  ];
  // --------------------------------------------------------------------------------
  final OverlayPortalController _diamondHoverController =
      OverlayPortalController();

  final OverlayPortalController _engagementHoverController =
      OverlayPortalController();

  final OverlayPortalController _weddingHoverController =
      OverlayPortalController();

  final OverlayPortalController _jewelryHoverController =
      OverlayPortalController();

  final OverlayPortalController _aboutHoverController =
      OverlayPortalController();
  // --------------------------------------------------------------------------------
  final ScrollController _scrollController = ScrollController();
  late Future<List<GmssStone>> _future;

  // --- STATE ---
  bool showOnlyWithImages = false;
  bool quickShipping = false;
  bool isGridView = true;
  final List<GmssStone> _savedStones = [];
  final List<GmssStone> _recentlyViewed = [];

  // --- FILTER STATE ---
  String selectedShape = 'Round';
  int selectedShapeId = 1;
  RangeValues _caratRange = const RangeValues(0.0, 15.00);
  RangeValues _priceRange = const RangeValues(0.0, 100000);
  int _currentTab = 0;
  // Add these to your State class
  bool showAdvancedFilters = false;
  // certification selection
  List<String> selectedCerts = [];
  List<String> certLabels = ["GIA", "IGI", "HRD"];
  RangeValues _certRange = const RangeValues(0, 2);
  // Symmetry selection
  final List<String> symLabels = ["FAIR", "GOOD", "VERY GOOD", "EXCELLENT"];
  RangeValues _symRange = const RangeValues(0, 3);
  //physical dimention
  RangeValues _depthRange = const RangeValues(0, 90);
  RangeValues _tableRange = const RangeValues(0, 90);
  final List<String> cutLabels = [
    "IDEAL",
    "EXCELLENT",
    "VERY GOOD",
    "GOOD",
    "FAIR",
  ];
  final List<String> polishLabels = ["EXCELLENT", "VERY GOOD", "GOOD", "FAIR"];
  final List<String> flLabels = ["NONE", "FAINT", "MEDIUM", "STRONG"];
  RangeValues _cutRange = const RangeValues(0, 4);
  RangeValues _polishRange = const RangeValues(0, 3);
  RangeValues _flRange = const RangeValues(0, 3);
  // The full list of shades in order
  final List<String> shadeLabels = [
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
    "L",
  ];
  RangeValues _colorRange = const RangeValues(0, 8); // Reset to full range D-L
  final List<String> clarityLabels = [
    "FL",
    "IF",
    "VVS1",
    "VVS2",
    "VS1",
    "VS2",
    "SI1",
    "SI2",
    "I1",
  ];
  RangeValues _clarityRange = const RangeValues(
    0,
    8,
  ); // Start with all selected
  int selectedOrigin = 1;
  final String baseAssetUrl = "https://dev2.kodllin.com/";
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
  @override
  void initState() {
    super.initState();
    _future = GmssApiService.fetchGmssData(shapeId: selectedShapeId);
  }

  void _toggleSave(GmssStone stone) {
    setState(() {
      if (_savedStones.any((s) => s.id == stone.id)) {
        _savedStones.removeWhere((s) => s.id == stone.id);
      } else {
        _savedStones.add(stone);
      }
    });
  }

  void _handleCardTap(GmssStone stone) {
    setState(() {
      _recentlyViewed.removeWhere((s) => s.id == stone.id);
      _recentlyViewed.insert(0, stone);
      // if (_recentlyViewed.length > 20) _recentlyViewed.removeLast();
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DiamondDetailScreen(
          stone: stone,
          isFavorite: _savedStones.any((s) => s.id == stone.id),
          onFavoriteToggle: (isNowFavorite) {
            setState(() {
              if (isNowFavorite) {
                if (!_savedStones.any((s) => s.id == stone.id)) {
                  _savedStones.add(stone);
                }
              } else {
                _savedStones.removeWhere((s) => s.id == stone.id);
              }
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      body: FutureBuilder<List<GmssStone>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.teal),
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final allStones = snapshot.data ?? [];
          final Color themeColor = (selectedOrigin == 1)
              ? Colors.teal
              : Colors.blue.shade700;
          List<GmssStone> applyFilters(List<GmssStone> list) {
            return list.where((stone) {
              final bool matchesShape =
                  (selectedShapeId == 0 ||
                      selectedShape == "ALL") // Assuming 0 is 'ALL'
                  ? true
                  : (stone.shapeStr).toLowerCase().trim() ==
                        selectedShape.toLowerCase().trim();

              final bool matchesCarat =
                  stone.weight >= _caratRange.start &&
                  stone.weight <= _caratRange.end;

              final bool matchesPrice =
                  stone.total_price >= _priceRange.start &&
                  stone.total_price <= _priceRange.end;

              bool matchesColor = false;

              if (selectedFancyColor != null) {
                // If a fancy color is picked, check if the stone color string contains it
                matchesColor = stone.colorStr.toLowerCase().contains(
                  selectedFancyColor!.toLowerCase(),
                );
              } else {
                // Default D-L Range Logic
                int colorIdx = shadeLabels.indexOf(
                  stone.colorStr.trim().toUpperCase(),
                );
                matchesColor =
                    (colorIdx == -1) ||
                    (colorIdx >= _colorRange.start.toInt() &&
                        colorIdx <= _colorRange.end.toInt());
              }
              // 2. Color & Clarity (FIX: Added ?? "" to prevent the indexOf crash)
              int colorIdx = shadeLabels.indexOf(
                (stone.colorStr).trim().toUpperCase(),
              );
              // bool matchesColor =
              //     (colorIdx == -1) ||
              //     (colorIdx >= _colorRange.start.toInt() &&
              //         colorIdx <= _colorRange.end.toInt());

              int clarityIdx = clarityLabels.indexOf(
                (stone.clarityStr).trim().toUpperCase(),
              );
              bool matchesClarity =
                  (clarityIdx == -1) ||
                  (clarityIdx >= _clarityRange.start.toInt() &&
                      clarityIdx <= _clarityRange.end.toInt());
              // 3. Advanced Filters (FIX: Robust null checks for Cut, Polish, Symmetry)
              int cutIdx = cutLabels.indexOf((stone.cut).trim().toUpperCase());
              bool matchesCut =
                  (cutIdx == -1) ||
                  (cutIdx >= _cutRange.start.toInt() &&
                      cutIdx <= _cutRange.end.toInt());
              int polishIdx = polishLabels.indexOf(
                (stone.polish).trim().toUpperCase(),
              );

              bool matchesPolish =
                  (polishIdx == -1) ||
                  (polishIdx >= _polishRange.start.toInt() &&
                      polishIdx <= _polishRange.end.toInt());
              int flIdx = flLabels.indexOf(
                (stone.fl_intensity).trim().toUpperCase(),
              );

              bool matchesFl =
                  (flIdx == -1) ||
                  (flIdx >= _flRange.start.toInt() &&
                      flIdx <= _flRange.end.toInt());
              int symIdx = symLabels.indexOf(
                (stone.symmetry).trim().toUpperCase(),
              );

              bool matchesSym =
                  (symIdx == -1) ||
                  (symIdx >= _symRange.start.toInt() &&
                      symIdx <= _symRange.end.toInt());

              // 4. Depth & Table
              bool matchesDepth =
                  stone.depth >= _depthRange.start &&
                  stone.depth <= _depthRange.end;

              bool matchesTable =
                  stone.table >= _tableRange.start &&
                  stone.table <= _tableRange.end;

              int certIdx = certLabels.indexOf(
                (stone.lab).trim().toUpperCase(),
              );

              bool matchesCert =
                  (certIdx == -1) ||
                  (certIdx >= _certRange.start.toInt() &&
                      certIdx <= _certRange.end.toInt());

              bool matchesImage = showOnlyWithImages
                  ? ((stone.image_link).isNotEmpty)
                  : true;

              // 6. Origin Filter
              final String stoneName = (stone.stoneName).toUpperCase();

              final bool matchesOrigin = (selectedOrigin == 1)
                  ? (stoneName.contains("LAB") || stoneName.contains("LGD"))
                  : (stoneName.contains("NATURAL") ||
                        stoneName.contains("NAT"));

              return matchesShape &&
                  matchesCarat &&
                  matchesPrice &&
                  matchesColor &&
                  matchesClarity &&
                  matchesCut &&
                  matchesPolish &&
                  matchesFl &&
                  matchesSym &&
                  matchesDepth &&
                  matchesTable &&
                  matchesCert &&
                  matchesImage &&
                  matchesOrigin;
            }).toList();
          }

          final filteredMain = applyFilters(allStones);
          final filteredHistory = applyFilters(_recentlyViewed);
          final filteredCompare = applyFilters(_savedStones);
          List<GmssStone> displayStones;
          if (_currentTab == 1) {
            displayStones = filteredHistory;
          } else if (_currentTab == 2) {
            displayStones =
                filteredCompare; // This list now includes your teal-hearted diamonds
          } else {
            displayStones = filteredMain;
          }

          return Scrollbar(
            controller: _scrollController,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(child: _buildMainHeader(themeColor)),
                SliverToBoxAdapter(child: _buildHeader()),
                SliverToBoxAdapter(child: _buildShapeSelector()),
                SliverToBoxAdapter(
                  child: _buildUnifiedInventoryToolbar(
                    mainCount: filteredMain.length,
                    historyCount: filteredHistory.length,
                    compareCount: filteredCompare.length,
                    themeColor: themeColor,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSidebarFilters(themeColor),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 20,
                          ),
                          child: displayStones.isEmpty
                              ? _buildEmptyState()
                              : isGridView
                              ? _buildGridView(displayStones, themeColor)
                              : _buildListView(displayStones, themeColor),
                        ),
                      ),
                    ],
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFancyColorFilter(Color themeColor) {
    String shapName = "RD"; // Default Round
    String currentShape = selectedShape.toUpperCase();

    if (currentShape == "PEAR") shapName = "PE";
    if (currentShape == "EMERALD") shapName = "EM";
    if (currentShape == "MARQUISE") shapName = "MQ";
    if (currentShape == "CUSHION") shapName = "CU";
    if (currentShape == "RADIANT") shapName = "RA";
    if (currentShape == "OVAL") shapName = "OV";
    if (currentShape == "HEART") shapName = "HT";
    if (currentShape == "PRINCESS") shapName = "PR";
    if (currentShape == "ASSCHER") shapName = "AS";

    if (fancyColors == null || fancyColors.isEmpty) {
      return const SizedBox.shrink();
    }

    final visibleColors = isFancyExpanded
        ? fancyColors
        : fancyColors.take(6).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader("Fancy Color"),
        const SizedBox(height: 15),
        Wrap(
          spacing: 15,
          runSpacing: 15,
          children: visibleColors.map((item) {
            bool isSelected = selectedFancyColor == item['name'];

            String colorFileName = item['name'];
            if (colorFileName == "White") {
              colorFileName = "NZ";
            }
            String imageUrl =
                "https://www.brilliance.com/sites/default/files/vue/fancy-search/${shapName}_$colorFileName.png";

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedFancyColor = isSelected ? null : item['name'];
                });
              },
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  // This creates the black square outline when selected
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        // "https://corsproxy.io/?${Uri.encodeComponent("https://www.brilliance.com/sites/default/files/vue/fancy-search/${shapName}_${item['name']}.png")}",
                        "https://corsproxy.io/?${Uri.encodeComponent(imageUrl)}",
                      ),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        // "Show more" / "Show less" toggle
        InkWell(
          onTap: () => setState(() => isFancyExpanded = !isFancyExpanded),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              isFancyExpanded ? "Show less" : "Show more",
              style: const TextStyle(
                color: Colors.blueAccent,
                fontSize: 14,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- CENTERED SIDEBAR FILTERS ---
  Widget _buildSidebarFilters(Color themeColor) {
    return Container(
      width: 370,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Filters",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 30),
          // 1. ORIGIN SECTION (Lab vs Natural)
          Text(
            "Diamond Origin",
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 15,
              color: Color(0xFF2D3142),
            ),
          ),
          const SizedBox(height: 15),
          _buildOriginSegmentedControl(),
          const SizedBox(height: 40),
          if (isFancySearch) ...[
            _buildFancyColorFilter(
              themeColor,
            ), // Only show if user clicked "Fancy Color"
            const Divider(),
          ] else ...[
            _buildColorSlider(
              themeColor,
            ), // Show standard slider for normal search
            const Divider(),
          ],

          // 2. CARAT SECTION
          _sectionHeader("Carat"),
          const SizedBox(height: 15),
          _buildCustomSlider(
            _caratRange,
            0,
            15,
            (v) => setState(() => _caratRange = v),
            themeColor,
          ),
          _buildValueDisplay(
            _caratRange.start.toStringAsFixed(2),
            "${_caratRange.end.toStringAsFixed(2)} ct",
            themeColor,
          ),
          const SizedBox(height: 40),
          // 3. PRICE SECTION
          _sectionHeader("Price Range"),
          const SizedBox(height: 15),
          _buildCustomSlider(
            _priceRange,
            0,
            100000,
            (v) => setState(() => _priceRange = v),
            themeColor,
          ),
          _buildValueDisplay(
            "\$${_priceRange.start.toInt()}",
            "\$${_priceRange.end.toInt()}",
            themeColor,
          ),
          // 4.with image only checkbox
          const SizedBox(height: 40),
          _buildStaticFilters(themeColor),
          // const Divider(),
          //5. color
          const SizedBox(height: 40),
          // _buildColorSlider(themeColor),
          const Divider(), // Add a divider
          const SizedBox(height: 20),
          _buildClaritySlider(themeColor),
          const SizedBox(height: 20),
          _buildAdvancedFilters(themeColor), // <--- Add this here
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildAdvancedFilters(Color themeColor) {
    return Column(
      children: [
        ListTile(
          // contentPadding: EdgeInsets.zero,
          title: const Text(
            "Advanced Filters",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          trailing: Icon(
            showAdvancedFilters ? Icons.remove : Icons.add,
            color: Colors.black,
          ),
          onTap: () =>
              setState(() => showAdvancedFilters = !showAdvancedFilters),
        ),
        if (showAdvancedFilters) ...[
          _buildRangeSliderGroup(
            "Cut",
            cutLabels,
            _cutRange,
            (v) => setState(() => _cutRange = v),
            themeColor,
          ),
          const SizedBox(height: 20),
          _buildRangeSliderGroup(
            "Polish",
            polishLabels,
            _polishRange,
            (v) => setState(() => _polishRange = v),
            themeColor,
          ),
          const SizedBox(height: 20),
          _buildRangeSliderGroup(
            "Fluorescence",
            flLabels,
            _flRange,
            (v) => setState(() => _flRange = v),
            themeColor,
          ),
          const SizedBox(height: 20),
          _buildRangeSliderGroup(
            "Certification",
            certLabels,
            _certRange,
            (v) => setState(() => _certRange = v),
            themeColor,
          ),
          const SizedBox(height: 20),
          _buildRangeSliderGroup(
            "Symmetry",
            symLabels,
            _symRange,
            (v) => setState(() => _symRange = v),
            themeColor,
          ),
          const SizedBox(height: 20),
          _sectionHeader("Depth"),
          _buildCustomSlider(
            _depthRange,
            0,
            90,
            (v) => setState(() => _depthRange = v),
            themeColor,
          ),
          _buildValueDisplay(
            "${_depthRange.start.toInt()}%",
            "${_depthRange.end.toInt()}%",
            themeColor,
          ),
          const SizedBox(height: 20),
          _sectionHeader("Table"),
          _buildCustomSlider(
            _tableRange,
            0,
            90,
            (v) => setState(() => _tableRange = v),
            themeColor,
          ),
          _buildValueDisplay(
            "${_tableRange.start.toInt()}%",
            "${_tableRange.end.toInt()}%",
            themeColor,
          ),
        ],
      ],
    );
  }

  // Helper to keep code clean
  Widget _buildRangeSliderGroup(
    String title,
    List<String> labels,
    RangeValues values,
    Function(RangeValues) onChanged,
    Color themeColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        RangeSlider(
          values: values,
          min: 0,
          max: (labels.length - 1).toDouble(),
          divisions: labels.length - 1,
          activeColor: themeColor,
          onChanged: onChanged,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: labels
              .map((l) => Text(l, style: const TextStyle(fontSize: 10)))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildColorSlider(Color themeColor) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        title: _sectionHeader("Color"),
        initiallyExpanded: true,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              children: [
                // Display the selected range text (e.g., "D - G")
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _rangeLabel(shadeLabels[_colorRange.start.toInt()]),
                    const Text(
                      "to",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    _rangeLabel(shadeLabels[_colorRange.end.toInt()]),
                  ],
                ),
                const SizedBox(height: 10),
                // The Actual Slider
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 2,
                    activeTrackColor: themeColor,
                    inactiveTrackColor: Colors.grey.shade200,
                    thumbColor: Colors.white,
                    rangeThumbShape: const RoundRangeSliderThumbShape(
                      enabledThumbRadius: 10,
                      elevation: 3,
                    ),
                    overlayColor: themeColor.withValues(alpha: 0.1),
                    tickMarkShape: const RoundSliderTickMarkShape(
                      tickMarkRadius: 2,
                    ),
                    activeTickMarkColor: themeColor,
                    inactiveTickMarkColor: Colors.grey.shade300,
                  ),
                  child: RangeSlider(
                    values: _colorRange,
                    activeColor: themeColor,
                    min: 0,
                    max: (shadeLabels.length - 1).toDouble(),
                    divisions: shadeLabels.length - 1,
                    onChanged: (RangeValues values) {
                      setState(() {
                        _colorRange = values;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: shadeLabels
                        .map(
                          (s) => Text(
                            s,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper for the D and G indicator boxes
  Widget _rangeLabel(String text) {
    final Color themeColor = (selectedOrigin == 1)
        ? Colors.teal
        : Colors.blueAccent;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: themeColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: themeColor.withValues(alpha: 0.2)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w900,
          color: themeColor,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildStaticFilters(Color themeColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => setState(() => showOnlyWithImages = !showOnlyWithImages),
          borderRadius: BorderRadius.circular(8),
          child: Row(
            children: [
              Checkbox(
                value: showOnlyWithImages,
                activeColor: themeColor,
                checkColor: Colors.white,
                onChanged: (v) => setState(() => showOnlyWithImages = v!),
              ),
              const Text(
                "With Image Only",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D3142),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 7),
        InkWell(
          onTap: () => setState(() => quickShipping = !quickShipping),
          borderRadius: BorderRadius.circular(8),
          child: Row(
            children: [
              Checkbox(
                value: quickShipping,
                activeColor: themeColor,
                checkColor: Colors.white,
                onChanged: (v) => setState(() => quickShipping = v!),
              ),
              const Text(
                "Quick Shipping",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D3142),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 7),
        Padding(
          padding: const EdgeInsets.only(), // Aligns with the checkbox edge
          child: TextButton.icon(
            onPressed: () {
              setState(() {
                showOnlyWithImages = false;
                quickShipping = false;
                // Resetting sliders and origin as well
                _caratRange = const RangeValues(0.0, 15.0);
                _priceRange = const RangeValues(0.0, 100000.0);
                selectedOrigin = 1;
                selectedFancyColor = null;
              });
            },
            icon: const Icon(
              Icons.restart_alt_rounded,
              size: 18,
              color: Colors.black,
            ),
            label: const Text(
              "Reset Filters",
              style: TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // PREMIUM SEGMENTED CONTROL
  Widget _buildOriginSegmentedControl() {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          _buildOriginOption("Lab Grown", 1),
          _buildOriginOption("Natural", 2),
        ],
      ),
    );
  }

  Widget _buildOriginOption(String label, int value) {
    bool isSelected = selectedOrigin == value;
    final Color activeBtnColor = (value == 1)
        ? Colors.teal
        : Colors.blue.shade700;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedOrigin = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: isSelected ? activeBtnColor : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: isSelected ? FontWeight.w900 : FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 15,
            color: Color(0xFF2D3142),
          ),
        ),

        Icon(Icons.info_outline_rounded, size: 16, color: Colors.grey.shade400),
      ],
    );
  }

  Widget _buildValueDisplay(String minVal, String maxVal, Color themeColor) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Minimum Value Pod
          _buildValuePod("MIN", minVal, themeColor),
          // Stylish Separator
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            width: 15,
            height: 2,
            color: Colors.grey.shade300,
          ),
          // Maximum Value Pod
          _buildValuePod("MAX", maxVal, themeColor),
        ],
      ),
    );
  }

  Widget _buildValuePod(String label, String value, Color themeColor) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade400,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            value,
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w900,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildClaritySlider(Color themeColor) {
    // Ensure indices are within bounds for the labels
    int startIdx = _clarityRange.start.toInt().clamp(
      0,
      clarityLabels.length - 1,
    );
    int endIdx = _clarityRange.end.toInt().clamp(0, clarityLabels.length - 1);
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        title: _sectionHeader("Clarity"),
        initiallyExpanded: true,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _rangeLabel(clarityLabels[startIdx]),
                    const Text(
                      "to",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    _rangeLabel(clarityLabels[endIdx]),
                  ],
                ),
                const SizedBox(height: 10),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 2,
                    activeTrackColor: themeColor,
                    inactiveTrackColor: Colors.grey.shade200,
                    thumbColor: Colors.white,
                    rangeThumbShape: const RoundRangeSliderThumbShape(
                      enabledThumbRadius: 10,
                    ),
                    overlayColor: themeColor.withValues(alpha: 0.1),
                  ),
                  child: RangeSlider(
                    values: _clarityRange,
                    activeColor: themeColor,
                    min: 0,
                    max: (clarityLabels.length - 1).toDouble(),
                    divisions: clarityLabels.length - 1,
                    onChanged: (RangeValues values) {
                      setState(() {
                        _clarityRange = values;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: clarityLabels
                        .map(
                          (s) => Text(
                            s,
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomSlider(
    RangeValues values,
    double min,
    double max,
    ValueChanged<RangeValues> onChanged,
    Color themeColor,
  ) {
    return SliderTheme(
      data: SliderThemeData(
        activeTrackColor: themeColor,
        inactiveTrackColor: Colors.grey.shade100,
        trackHeight: 6,
        thumbColor: Colors.white,
        rangeThumbShape: const RoundRangeSliderThumbShape(
          enabledThumbRadius: 11,
          elevation: 4,
        ),
        overlayColor: themeColor.withValues(alpha: 0.1),
      ),
      child: RangeSlider(
        values: values,
        min: min,
        max: max,
        activeColor: themeColor,
        onChanged: onChanged,
      ),
    );
  }

  // --- HEADER & TABS ---
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 60, bottom: 10),
      child: Column(
        children: [
          Text(
            "${selectedOrigin == 1 ? 'Lab Grown' : 'Natural'} $selectedShape Diamonds",
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w900,
              color: Color(0xFF2D3142),
            ),
          ),
          const Text(
            "HAND-SELECTED BRILLIANCE",
            style: TextStyle(
              letterSpacing: 2,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShapeSelector() {
    return Container(
      height: 110,
      margin: const EdgeInsets.symmetric(vertical: 10),
      alignment: Alignment.center,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: shapeCategories.length,
        itemBuilder: (context, index) {
          final s = shapeCategories[index];
          bool active = selectedShapeId == s['id'];

          return GestureDetector(
            onTap: () {
              setState(() {
                // FIX 2: Update both the ID and the String Name
                selectedShapeId = s['id'];
                selectedShape = s['name'];

                // FIX 3: Trigger the API call with the new ID
                _future = GmssApiService.fetchGmssData(
                  shapeId: selectedShapeId,
                );
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 90,
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: active ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: active ? Colors.teal : Colors.grey.shade200,
                  width: active ? 2 : 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    // s['icon']!,
                    "assets/${s['icon']}",
                    height: 30,
                    width: 30,
                    // color: active ? Colors.teal : Colors.grey,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.diamond_outlined),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    s['name']!.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: active ? Colors.black : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUnifiedInventoryToolbar({
    required int mainCount,
    required int historyCount,
    required int compareCount,
    required Color themeColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
      child: Row(
        children: [
          const SizedBox(width: 96),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _tabItem("Diamond", 0, mainCount, themeColor),
                const SizedBox(width: 30),
                _tabItem("Recently Viewed", 1, historyCount, themeColor),
                const SizedBox(width: 30),
                _tabItem("Compare", 2, compareCount, themeColor),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  Icons.grid_view_rounded,
                  color: isGridView ? Colors.black : Colors.grey,
                ),
                onPressed: () => setState(() => isGridView = true),
              ),
              IconButton(
                icon: Icon(
                  Icons.view_list_rounded,
                  color: !isGridView ? Colors.black : Colors.grey,
                ),
                onPressed: () => setState(() => isGridView = false),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tabItem(String label, int index, int count, Color themeColor) {
    bool active = _currentTab == index;
    return InkWell(
      onTap: () => setState(() => _currentTab = index),
      child: Column(
        children: [
          Text(
            "$label ($count)",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 14,
              color: active ? Colors.black : Colors.grey,
              letterSpacing: 1,
            ),
          ),
          if (active)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 3,
              width: 20,
              decoration: BoxDecoration(
                color: themeColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    );
  }

  // --- GRID & CARDS (With Safe Image Handling) ---
  Widget _buildGridView(List<GmssStone> stones, Color themeColor) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.60,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: stones.length,
      itemBuilder: (context, index) => _DiamondCard(
        stone: stones[index],
        isFavorite: _savedStones.any((s) => s.id == stones[index].id),
        onFavoriteTap: () => _toggleSave(stones[index]),
        onCardTap: () => _handleCardTap(stones[index]),
        themeColor: themeColor,
      ),
    );
  }

  Widget _buildListView(List<GmssStone> stones, Color themeColor) {
    return Column(
      children: [
        // 1. HEADER ROW (Stayed largely the same for structure)
        Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade200, width: 2),
            ),
          ),
          child: const Row(
            children: [
              SizedBox(
                width: 50,
              ), // Matches the width of the image + spacing below
              Expanded(
                flex: 2,
                child: Text(
                  "Shape",
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  "Carat",
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  "Color",
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  "Clarity",
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  "Price",
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  "Action",
                  textAlign: TextAlign.right,
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                ),
              ),
            ],
          ),
        ),

        // 2. DATA ROWS
        ...stones.map((stone) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
            ),
            child: ListTile(
              mouseCursor: SystemMouseCursors.click,
              onTap: () => _handleCardTap(stone),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 8,
              ),

              // FIXED: Wrapped leading in a SizedBox to prevent the layout crash
              leading: SizedBox(
                width: 40,
                height: 40,
                child: SafeImage(url: stone.image_link, size: 40),
              ),

              title: Row(
                children: [
                  // Matches Flex 2 in Header
                  Expanded(
                    flex: 2,
                    child: Text(
                      (stone.shapeStr).toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        // letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  // Matches Flex 1 in Header
                  Expanded(
                    flex: 1,
                    child: Text(
                      "${stone.weight.toStringAsFixed(2)} ct",
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  // Matches Flex 1 in Header
                  Expanded(
                    flex: 1,
                    child: Text(
                      stone.colorStr,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      stone.clarityStr,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  // Matches Flex 1 in Header
                  Expanded(
                    flex: 1,
                    child: Text(
                      "\$${stone.total_price.toInt()}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  // Matches Flex 1 in Header
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: themeColor.withValues(alpha: 0.3),
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "DETAILS",
                          style: TextStyle(
                            color: themeColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildEmptyState() => const Center(
    child: Text(
      "No diamonds found matching these filters.",
      style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
    ),
  );

  Widget _buildMainHeader(Color themeColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          const Text(
            "BRILLIANCE",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w300,
              letterSpacing: 4,
              color: Color(0xFF005AAB),
            ),
          ),
          const Spacer(),
          // These links now use MouseRegion + OverlayPortal to show details on hover
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
          // Action Icons
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

  Widget _buildEngagementMenu(Color themeColor) {
    return Material(
      elevation: 10,
      shadowColor: Colors.black26,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 30),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "SHOP BY STYLE",
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  _engagementStyleItem("Solitaire", ""),
                  _engagementStyleItem("Side Stone", ""),
                  _engagementStyleItem("Halo", ""),
                  _engagementStyleItem("Three Stones", ""),
                  _engagementStyleItem("Vintage", ""),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: _menuColumn("CREATE YOUR OWN RING", [
                "Start with a Setting",
                "Start with a Diamond",
                "3D Ring Creator",
              ]),
            ),
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
            Expanded(
              flex: 3,
              child: Container(
                height: 250,
                margin: const EdgeInsets.only(left: 20),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        "images/engagement.png",
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.blue.shade50,
                          child: const Icon(
                            Icons.diamond_outlined,
                            size: 30,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.6),
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
                            const Text(
                              "CREATE YOUR OWN RING",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "Explore Our 3D Creator",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
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
          ],
        ),
      ),
    );
  }

  Widget _engagementStyleItem(String label, String iconPath) {
    return Padding(
      padding: const EdgeInsetsGeometry.symmetric(vertical: 8.0),
      child: Row(
        children: [
          // Image.asset(
          //   iconPath,
          //   width: 30,
          //   height: 20,
          //   errorBuilder: (context, error, stackTrace) => const Icon(
          //     Icons.diamond_outlined,
          //     size: 18,
          //     color: Colors.grey,
          //   ),
          // ),
          const Icon(Icons.diamond_outlined, size: 20, color: Colors.black54),
          const SizedBox(width: 15),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _hoverNavLink(
    String label,
    OverlayPortalController controller,
    Widget menuContent,
  ) {
    return MouseRegion(
      onEnter: (_) => controller.show(),
      // We do NOT hide onExit here to allow the user to move the mouse into the menu
      child: OverlayPortal(
        controller: controller,
        overlayChildBuilder: (context) => Positioned(
          top: 80, // Positioned exactly below the header
          left: 0,
          right: 0,
          child: MouseRegion(
            onExit: (_) => controller
                .hide(), // Hide only when leaving the entire menu area
            child: menuContent,
          ),
        ),
        child: _navLink(label),
      ),
    );
  }

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
            // 1. SHOP BY SHAPE GRID (2 rows of icons)
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
                _menuItem(
                  "All Natural Diamonds",
                  onTap: () {
                    setState(() {
                      isFancySearch = false; // Show the D-L Slider
                    });
                    _diamondHoverController.hide();
                  },
                ),
                _menuItem(
                  "Fancy Color Diamonds",
                  onTap: () {
                    setState(() {
                      isFancySearch = true; // Show the Fancy Grid
                      selectedFancyColor = null;
                    });
                    _diamondHoverController.hide();
                  },
                ),
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
              "images/diamonds.png", // Ensure this path is correct in your assets
              "NEW ARRIVALS",
              "Exquisite Lab Brilliance",
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(String label, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      // child: Padding(
      //   padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      // ),
    );
  }

  Widget _buildShapeIconItem(Map<String, dynamic> shape) {
    return SizedBox(
      width: 80,
      child: Column(
        children: [
          // Using your existing asset logic
          Image.asset(
            "assets/${shape['icon']}",
            height: 35,
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
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconGrid(String title, List<Map<String, dynamic>> items) {
    return Expanded(
      flex: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 13,
              letterSpacing: 2.0,
              color: Colors.black87,
            ),
          ),
          // const SizedBox(height: 5),
          Wrap(
            // spacing: 0,
            // runSpacing: 25,
            children: items
                .map((item) => _enhancedShapeMenuItem(item, Colors.teal))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextColumn(String title, List<String> items) {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 13,
              // letterSpacing: 1.5,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 25),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                item,
                style: const TextStyle(color: Colors.black87, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _enhancedShapeMenuItem(Map<String, dynamic> shape, Color themeColor) {
    return InkWell(
      onTap: () {
        setState(() => selectedShape = shape['name']!);
        _diamondHoverController.hide();
      },
      // Adding a transparent hover color for better feedback
      hoverColor: themeColor.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 90,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            Image.asset(
              "assets/${shape['icon']}",
              height: 38,
              errorBuilder: (c, e, s) =>
                  const Icon(Icons.diamond_outlined, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Text(
              shape['name']!.toUpperCase(),
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

  Widget _buildPromoCard(String assetPath, String title, String subtitle) {
    return Container(
      height: 280, // Slightly taller for better aspect ratio
      margin: const EdgeInsets.only(left: 30),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
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
              errorBuilder: (c, e, s) =>
                  Container(color: Colors.blueGrey.shade50),
            ),
          ),
          // Premium subtle gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                  colors: [
                    Colors.black.withValues(alpha: 0.85),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 12,
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

  Widget _menuColumn(String title, List<dynamic> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
        ),
        const SizedBox(height: 20),
        ...items.map((item) {
          Widget content = item is String
              ? Text(
                  item,
                  style: const TextStyle(color: Colors.black87, fontSize: 14),
                )
              : item as Widget;
          return Padding(
            padding: const EdgeInsetsDirectional.only(bottom: 12),
            child: content,
          );
          // Padding(
          // padding: const EdgeInsetsDirectional.only(bottom: 12),
          // child: item,
          // Text(
          //   item,
          //   style: const TextStyle(color: Colors.black87, fontSize: 14),
          // ),
          // ),
        }),
      ],
    );
  }

  Widget _navLink(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildWeddingMenu(Color themeColor) {
    return Material(
      elevation: 10,
      shadowColor: Colors.black26,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 30),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: _menuColumn("Women's Rings", [
                "Diamond Wedding Bands",
                "Diamond Eternity Bands",
                "Gemstone Wedding Bands",
                "Bestsellers",
              ]),
            ),
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
            Expanded(
              flex: 2,
              child: _menuColumn("Weddings Ring Tips", [
                "Ring Size Chart",
                "Metal Education",
                "Women's Ring Guide",
                "Men's Ring Guide",
              ]),
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: const DecorationImage(
                        image: AssetImage("images/wedding.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Wedding Rings",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "Explore Our Best Sellers",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJewelryMenu(Color themeColor) {
    return Material(
      elevation: 10,
      shadowColor: Colors.black26,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 30),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _menuColumn("Gifts & Collections", [
                    "Gifts For Her",
                    "Tennis Bracelets",
                    "Hoop Earrings",
                  ]),
                  const SizedBox(height: 30),
                  _menuColumn("Featured", [
                    "Custom Designed Jewelry",
                    "Jewelry Guids",
                    "Best Seller Bracelets",
                  ]),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: const DecorationImage(
                        image: AssetImage("images/jwelry.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Shop Vault Sale",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "Get 50% Off with code VAULT",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutMenu(Color themeColor) {
    return Material(
      elevation: 25,
      shadowColor: Colors.black12,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 40),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextColumn("Brilliance", [
                "About",
                "Contact Us",
                "Diamond Experts",
                "Brilliance Reviews",
                "Flexible Financing",
              ]),
              _buildTextColumn("Customer Care", [
                "30 Day Return",
                "Low Price Returns",
                "Lifetime Warranty",
                "FAQs",
                "Resize Your Ring",
                "care & Maintenance",
              ]),
              Expanded(
                flex: 1,
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
              _buildPromoCard(
                "images/about.png",
                "Handmade with Love",
                "Learn About Our Process",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SafeImage extends StatefulWidget {
  final String url;
  final double size;
  const SafeImage({required this.url, required this.size});
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

  // If the URL changes (e.g., when scrolling), refetch the new image
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
      // Using corsproxy.io as used in your working details screen
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
    // Fallback for errors or empty URLs
    return Icon(
      Icons.diamond_outlined,
      size: widget.size,
      color: Colors.grey.shade600,
    );
  }
}

class _DiamondCard extends StatefulWidget {
  final GmssStone stone;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;
  final VoidCallback onCardTap;
  final Color themeColor;

  const _DiamondCard({
    required this.stone,
    required this.isFavorite,
    required this.onFavoriteTap,
    required this.onCardTap,
    required this.themeColor,
  });

  @override
  State<_DiamondCard> createState() => _DiamondCardState();
}

class _DiamondCardState extends State<_DiamondCard> {
  bool _isHoverd = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHoverd = true),
      onExit: (_) => setState(() => _isHoverd = false),

      child: GestureDetector(
        onTap: widget.onCardTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isHoverd
                  // Colors.grey.shade300 : Colors.grey.shade100,
                  ? widget.themeColor.withValues(alpha: 0.5)
                  : Colors.transparent,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                // color: Colors.black.withOpacity(0.03),
                color: Colors.black.withOpacity(_isHoverd ? 0.08 : 0.03),
                blurRadius: _isHoverd ? 20 : 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: AnimatedScale(
                          scale: _isHoverd ? 1.15 : 1.0,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOutCubic,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: SafeImage(
                              url: widget.stone.image_link,
                              size: 200,
                            ),
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
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${widget.stone.weight} CT ${widget.stone.shapeStr.toUpperCase()}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${widget.stone.colorStr.toUpperCase()} | ${widget.stone.clarityStr.toUpperCase()} | IGI Certified",
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "\$${widget.stone.total_price.toStringAsFixed(0)}",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
