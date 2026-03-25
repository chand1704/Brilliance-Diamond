import 'package:brilliance_diamond/utils/diamond_painter_utils.dart';
import 'package:brilliance_diamond/widgets/diamond_card.dart';
import 'package:brilliance_diamond/widgets/main_header.dart';
import 'package:flutter/material.dart';

import 'diamonds_details_pages.dart';
import 'model/gmss_stone_model.dart';
import 'service/gmss_api_service.dart';

class GmssScreen extends StatefulWidget {
  const GmssScreen({super.key});
  @override
  State<GmssScreen> createState() => _GmssScreenState();
}

class _GmssScreenState extends State<GmssScreen> {
  final Map<int, List<GmssStone>> _cachedLabGrownMap = {};
  final Map<int, List<GmssStone>> _cachedNaturalMap = {};
  int? selectedFancyColorId;
  double selectedSaturation = 0;
  RangeValues _saturationRange = const RangeValues(0, 5);
  final List<String> saturationLabels = [
    "Light",
    "Fancy",
    "Intense",
    "Vivid",
    "Deep",
    "Dark",
  ];
  bool isFancySearch = false;
  bool isFancyExpanded = false;
  String? selectedFancyColor;
  final List<Map<String, dynamic>> fancyColors = [
    {
      'id': 7,
      'name': 'Green',
      'url':
          'https://www.brilliance.com/sites/default/files/vue/fancy-search/RD_Green.png',
    },
    {
      'id': 8,
      'name': 'Orange',
      'url':
          'https://www.brilliance.com/sites/default/files/vue/fancy-search/RD_Orange.png',
    },
    {
      'id': 9,
      'name': 'Pink',
      'url':
          'https://www.brilliance.com/sites/default/files/vue/fancy-search/RD_Pink.png',
    },
    {
      'id': 11,
      'name': 'Purple',
      'url':
          'https://www.brilliance.com/sites/default/files/vue/fancy-search/RD_Purple.png',
    },
    {
      'id': 14,
      'name': 'Yellow',
      'url':
          'https://www.brilliance.com/sites/default/files/vue/fancy-search/RD_Yellow.png',
    },
    {
      'id': 2,
      'name': 'Blue',
      'url':
          'https://www.brilliance.com/sites/default/files/vue/fancy-search/RD_Blue.png',
    },
    {
      'id': 6,
      'name': 'Grey',
      'url':
          'https://www.brilliance.com/sites/default/files/vue/fancy-search/RD_Grey.png',
    },
    {
      'id': 3,
      'name': 'Brown',
      'url':
          'https://www.brilliance.com/sites/default/files/vue/fancy-search/RD_Brown.png',
    },
    {
      'id': 10,
      'name': 'NZ',
      'url':
          'https://www.brilliance.com/sites/default/files/vue/fancy-search/RD_NZ.png',
    },
  ];
  final ScrollController _scrollController = ScrollController();
  late Future<List<GmssStone>> _future;
  bool showOnlyWithImages = false;
  bool quickShipping = false;
  bool isGridView = true;
  final List<GmssStone> _savedStones = [];
  final List<GmssStone> _recentlyViewed = [];
  String selectedShape = 'Round';
  int selectedShapeId = 1;
  RangeValues _caratRange = const RangeValues(0.0, 15.00);
  RangeValues _priceRange = const RangeValues(0.0, 100000);
  int _currentTab = 0;
  bool showAdvancedFilters = false;
  List<String> selectedCerts = [];
  List<String> certLabels = ["GIA", "IGI", "HRD"];
  RangeValues _certRange = const RangeValues(0, 2);
  final List<String> symLabels = ["FAIR", "GOOD", "VERY GOOD", "EXCELLENT"];
  RangeValues _symRange = const RangeValues(0, 3);
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
  RangeValues _colorRange = const RangeValues(0, 8);
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
  RangeValues _clarityRange = const RangeValues(0, 8);
  int selectedOrigin = 1;
  final String baseAssetUrl = "https://dev2.kodllin.com/";
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
    {'id': -1, 'name': 'Other', 'icon': '${shapeBaseUrl}white/Other.svg'},
  ];
  final List<Map<String, dynamic>> otherShapes = [
    {'id': 10, 'name': 'Rose', 'icon': '${shapeBaseUrl}Other.svg'},
    {'id': 11, 'name': 'Baguette', 'icon': '${shapeBaseUrl}Other.svg'},
    {'id': 23, 'name': 'SQ Radiant', 'icon': '${shapeBaseUrl}Sq%20Radiant.svg'},
    {
      'id': 38,
      'name': 'SQ Emerald',
      'icon': '${shapeBaseUrl}1_sf_1734065422.svg',
    },
    {
      'id': 43,
      'name': 'Half Moon',
      'icon': '${shapeBaseUrl}1_sf_1734074276.svg',
    },
    {
      'id': 44,
      'name': 'Trapezoid',
      'icon': '${shapeBaseUrl}1_sf_1734074928.svg',
    },
    {
      'id': 47,
      'name': 'Pentagonal',
      'icon': '${shapeBaseUrl}1_sf_1734074321.svg',
    },
    {
      'id': 48,
      'name': 'Hexagonal',
      'icon': '${shapeBaseUrl}1_sf_1734074309.svg',
    },
    {
      'id': 50,
      'name': 'Triangular',
      'icon': '${shapeBaseUrl}1_sf_1734074973.svg',
    },
    {
      'id': 51,
      'name': 'Trilliant',
      'icon': '${shapeBaseUrl}1_sf_1734074959.svg',
    },
    {'id': 53, 'name': 'Shield', 'icon': '${shapeBaseUrl}1_sf_1734075003.svg'},
    {'id': 54, 'name': 'Lozenge', 'icon': '${shapeBaseUrl}1_sf_1734075016.svg'},
    {'id': 55, 'name': 'Kite', 'icon': '${shapeBaseUrl}1_sf_1734075038.svg'},
    {
      'id': 77,
      'name': 'Portuguese',
      'icon': '${shapeBaseUrl}50_sf_1737092508.svg',
    },
  ];
  Future<List<GmssStone>> _getSmartData() async {
    int shapeId = selectedShapeId;
    Map<int, List<GmssStone>> targetCache = (selectedOrigin == 1)
        ? _cachedLabGrownMap
        : _cachedNaturalMap;
    if (targetCache.containsKey(shapeId)) {
      return targetCache[shapeId]!;
    }
    final data = (selectedOrigin == 1)
        ? await GmssApiService.fetchLabGrownData()
        : await GmssApiService.fetchNaturalData();

    targetCache[shapeId] = data;
    return data;
  }

  @override
  void initState() {
    super.initState();
    _future = _getSmartData();
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

  Future<void> _handleCardTap(GmssStone stone) async {
    setState(() {
      _recentlyViewed.removeWhere((s) => s.id == stone.id);
      _recentlyViewed.insert(0, stone);
    });
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DiamondDetailScreen(
          stone: stone,
          isFavorite: _savedStones.any((s) => s.id == stone.id),
          onFavoriteToggle: (isNowFavorite) {},
        ),
      ),
    );
    if (result != null && result is Map) {
      setState(() {
        selectedShape = result['selectedShape'];
        selectedShapeId = result['selectedShapeId'];
        _future = _getSmartData();
        _currentTab = 0;
      });
    }
  }

  List<GmssStone> _applyFiltering(List<GmssStone> allStones) {
    final List<GmssStone> filtered = allStones.where((stone) {
      bool matchesColor = false;
      if (isFancySearch) {
        if (selectedFancyColorId == null) {
          matchesColor = stone.colorStr.toLowerCase().contains("fancy");
        } else {
          String searchColor = selectedFancyColor?.toUpperCase() ?? "";
          matchesColor =
              (stone.id == selectedFancyColorId) ||
              stone.colorStr.toUpperCase().contains(searchColor) ||
              stone.fancy_color.toUpperCase().contains(searchColor);
        }
      } else {
        int colorIdx = shadeLabels.indexOf(stone.colorStr.trim().toUpperCase());
        matchesColor =
            (colorIdx >= _colorRange.start.toInt() &&
            colorIdx <= _colorRange.end.toInt());
      }
      // 2. Clarity Logic
      int stoneClarityIdx = clarityLabels.indexOf(
        stone.clarityStr.trim().toUpperCase(),
      );
      bool matchesClarity =
          (stoneClarityIdx >= _clarityRange.start.toInt() &&
          stoneClarityIdx <= _clarityRange.end.toInt());
      // 3. CUT LOGIC
      int stoneCutIdx = -1;
      const cutMapping = {
        'ID': 0, // IDEAL
        'EX': 1, // EXCELLENT
        'VG': 2, // VERY GOOD
        'GD': 3, // GOOD
        'FR': 4, // FAIR
      };
      String code = stone.cut_code.trim().toUpperCase();
      if (cutMapping.containsKey(code)) {
        stoneCutIdx = cutMapping[code]!;
      } else {
        stoneCutIdx = cutLabels.indexOf(stone.cut.trim().toUpperCase());
      }
      bool matchesCut =
          (stoneCutIdx >= _cutRange.start.toInt() &&
          stoneCutIdx <= _cutRange.end.toInt());
      if (stoneCutIdx == -1) matchesCut = true;
      // 4. POLISH LOGIC
      int stonePolishIdx = -1;
      const polishMapping = {
        'EX': 0, // EXCELLENT (Matches your first label)
        'VG': 1, // VERY GOOD
        'GD': 2, // GOOD
        'FR': 3, // FAIR
      };
      String polishCode = stone.polish.trim().toUpperCase();
      if (polishMapping.containsKey(polishCode)) {
        stonePolishIdx = polishMapping[polishCode]!;
      } else {
        stonePolishIdx = polishLabels.indexOf(polishCode);
      }
      bool matchesPolish =
          (stonePolishIdx >= _polishRange.start.toInt() &&
          stonePolishIdx <= _polishRange.end.toInt());
      if (stonePolishIdx == -1) matchesPolish = true;
      //  5. FLUORESCENCE LOGIC
      int stoneFlIdx = -1;
      const flMapping = {
        'NONE': 0,
        'NON': 0,
        'VERY SLIGHT': 0,
        'SLIGHT': 1,
        'FAINT': 1,
        'FNT': 1,
        'MEDIUM': 2,
        'MED': 2,
        'STRONG': 3,
        'STG': 3,
        'VERY STRONG': 3,
        'VST': 3,
      };
      String intensity = stone.fl_intensity.trim().toUpperCase();
      if (flMapping.containsKey(intensity)) {
        stoneFlIdx = flMapping[intensity]!;
      } else {
        stoneFlIdx = flLabels.indexOf(intensity);
      }
      bool matchesFl =
          (stoneFlIdx >= _flRange.start.toInt() &&
          stoneFlIdx <= _flRange.end.toInt());
      if (stoneFlIdx == -1) matchesFl = true;
      // 8. SYMMETRY LOGIC
      int stoneSymIdx = -1;
      const symMapping = {
        'EX': 3, // EXCELLENT
        'VG': 2, // VERY GOOD
        'GD': 1, // GOOD
        'FAIR': 0, // FAIR
        'PR': 0, // POOR (Mapping Poor to the start of the slider)
        'POOR': 0,
      };
      String symmetryCode = stone.symmetry.trim().toUpperCase();
      if (symMapping.containsKey(symmetryCode)) {
        stoneSymIdx = symMapping[symmetryCode]!;
      } else {
        stoneSymIdx = symLabels.indexOf(symmetryCode);
      }
      bool matchesSym =
          (stoneSymIdx >= _symRange.start.toInt() &&
          stoneSymIdx <= _symRange.end.toInt());
      if (stoneSymIdx == -1) matchesSym = true;
      // 9. DEPTH % LOGIC
      double stoneDepth = 0.0;
      if (stone.depth is String) {
        stoneDepth = double.tryParse(stone.depth as String) ?? 0.0;
      } else {
        stoneDepth = stone.depth.toDouble();
      }
      bool matchesDepth =
          (stoneDepth >= _depthRange.start && stoneDepth <= _depthRange.end);
      if (stoneDepth == 0) matchesDepth = true;
      // 10. TABLE % LOGIC
      double stoneTable = 0.0;
      if (stone.table is String) {
        stoneTable = double.tryParse(stone.table as String) ?? 0.0;
      } else {
        stoneTable = (stone.table as num).toDouble();
      }
      bool matchesTable =
          (stoneTable >= _tableRange.start && stoneTable <= _tableRange.end);
      if (stoneTable == 0) matchesTable = true;

      final bool matchesShape =
          (selectedShapeId == 0 ||
              selectedShape == "ALL" ||
              selectedShape == "Other")
          ? true
          : (stone.shapeStr).toLowerCase().contains(
              selectedShape.toLowerCase().trim(),
            );
      final bool matchesCarat =
          stone.weight >= _caratRange.start && stone.weight <= _caratRange.end;
      final bool matchesPrice =
          stone.total_price >= _priceRange.start &&
          stone.total_price <= _priceRange.end;
      final String stoneName = (stone.stoneName).toUpperCase();
      final bool matchesOrigin = (selectedOrigin == 1)
          ? (stoneName.contains("LAB") || stoneName.contains("LGD"))
          : (stoneName.contains("NATURAL") || stoneName.contains("NAT"));
      return matchesShape &&
          matchesCarat &&
          matchesPrice &&
          matchesColor &&
          matchesOrigin &&
          matchesClarity &&
          matchesCut &&
          matchesPolish &&
          matchesFl &&
          matchesSym &&
          matchesDepth &&
          matchesTable;
    }).toList();
    if (_currentTab == 1) return _recentlyViewed;
    if (_currentTab == 2) return _savedStones;
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final Color themeColor = (selectedOrigin == 1)
        ? Colors.teal
        : Colors.blue.shade700;
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 340,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(right: BorderSide(color: Colors.grey.shade100)),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 40),
              child: _buildSidebarFilters(themeColor),
            ),
          ),
          Expanded(
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: MainHeader(
                    themeColor: themeColor,
                    shapeCategories: shapeCategories,
                    onNaturalDiamondsTap: () {
                      setState(() {
                        isFancySearch = false;
                      });
                    },
                    onFancyDiamondsTap: () {
                      setState(() {
                        isFancySearch = true;
                        selectedFancyColor = null;
                        _currentTab = 0;
                      });
                    },
                    onShapeTap: (shapeName, shapeId) {
                      setState(() {
                        selectedShape = shapeName;
                        selectedShapeId = shapeId;
                        _future = _getSmartData();
                      });
                    },
                  ),
                ),
                SliverToBoxAdapter(child: _buildHeader()),
                SliverToBoxAdapter(child: _buildShapeSelector(shapeCategories)),
                FutureBuilder<List<GmssStone>>(
                  future: _future,
                  builder: (context, snapshot) {
                    final allStones = snapshot.data ?? [];
                    final filteredCount = _applyFiltering(allStones).length;
                    return SliverToBoxAdapter(
                      child: _buildUnifiedInventoryToolbar(
                        mainCount: filteredCount,
                        historyCount: _recentlyViewed.length,
                        compareCount: _savedStones.length,
                        themeColor: themeColor,
                      ),
                    );
                  },
                ),
                FutureBuilder<List<GmssStone>>(
                  future: _future,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.waiting) {
                      return const SliverFillRemaining(
                        child: Center(
                          child: CircularProgressIndicator(color: Colors.teal),
                        ),
                      );
                    }
                    final List<GmssStone> displayStones = _applyFiltering(
                      snapshot.data ?? [],
                    );
                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 20,
                      ),
                      sliver: displayStones.isEmpty
                          ? const SliverToBoxAdapter(
                              child: Center(child: Text("No data found")),
                            )
                          : isGridView
                          ? SliverGrid(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    childAspectRatio: 0.85,
                                    crossAxisSpacing: 15,
                                    mainAxisSpacing: 15,
                                  ),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) => DiamondCard(
                                  key: ValueKey(displayStones[index].id),
                                  stone: displayStones[index],
                                  isFavorite: _savedStones.any(
                                    (s) => s.id == displayStones[index].id,
                                  ),
                                  onFavoriteTap: () =>
                                      _toggleSave(displayStones[index]),
                                  onCardTap: () =>
                                      _handleCardTap(displayStones[index]),
                                  themeColor: themeColor,
                                ),
                                childCount: displayStones.length,
                              ),
                            )
                          : SliverMainAxisGroup(
                              slivers: [
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting)
                                  const SliverToBoxAdapter(
                                    child: LinearProgressIndicator(
                                      minHeight: 2,
                                      color: Colors.teal,
                                      backgroundColor: Colors.transparent,
                                    ),
                                  ),
                                SliverToBoxAdapter(child: _buildListHeader()),
                                SliverList(
                                  delegate: SliverChildBuilderDelegate((
                                    context,
                                    index,
                                  ) {
                                    final stone = displayStones[index];
                                    bool showCategoryHeader = false;
                                    if (index == 0) {
                                      showCategoryHeader = true;
                                    } else {
                                      if (stone.shapeStr !=
                                          displayStones[index - 1].shapeStr) {
                                        showCategoryHeader = true;
                                      }
                                    }
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildDiamondRow(stone, themeColor),
                                      ],
                                    );
                                  }, childCount: displayStones.length),
                                ),
                              ],
                            ),
                    );
                  },
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: const [
          Expanded(
            flex: 1,
            child: Text(
              "Compare",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "Shape",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "Carat",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "Cut",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "Color",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "Clarity",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "Report",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "Price",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "Actions",
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiamondRow(GmssStone stone, Color themeColor) {
    bool isFavorite = _savedStones.any((s) => s.id == stone.id);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () => _toggleSave(stone),
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? themeColor : Colors.grey.shade400,
                size: 20,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CustomPaint(
                    painter: DiamondPainterUtils.getPainterForShapeName(
                      stone.shapeStr,
                      false,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  stone.shapeStr.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xFF2D3142),
                  ),
                ),
              ],
            ),
          ),
          Expanded(flex: 1, child: Text(stone.weight.toStringAsFixed(2))),
          Expanded(
            flex: 1,
            child: Text(
              stone.cut.length >= 2
                  ? stone.cut.substring(0, 2).toUpperCase()
                  : (stone.cut.isEmpty ? "-" : stone.cut.toUpperCase()),
              style: const TextStyle(fontSize: 13),
            ),
          ),
          Expanded(flex: 1, child: Text(stone.colorStr)),
          Expanded(flex: 1, child: Text(stone.clarityStr)),
          Expanded(
            flex: 1,
            child: Text(
              stone.lab,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "\$${stone.total_price.toInt()}",
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () => _handleCardTap(stone),
              child: Text(
                "Details",
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: themeColor,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaturationSlider(Color themeColor) {
    final RangeValues currentRange =
        _saturationRange ?? const RangeValues(0, 5);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Saturation",
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 15,
            color: Color(0xFF2D3142),
          ),
        ),
        const SizedBox(height: 10),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 3,
            activeTrackColor: themeColor,
            thumbColor: themeColor,
            inactiveTrackColor: Colors.grey.shade200,
            rangeThumbShape: const RoundRangeSliderThumbShape(
              enabledThumbRadius: 10,
              elevation: 4,
            ),
            overlayColor: themeColor.withValues(alpha: 0.1),
            tickMarkShape: SliderTickMarkShape.noTickMark,
          ),
          child: RangeSlider(
            values: currentRange,
            min: 0,
            max: (saturationLabels.length - 1).toDouble(),
            divisions: saturationLabels.length - 1,
            onChanged: (RangeValues values) {
              setState(() {
                _saturationRange = values;
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(saturationLabels.length, (index) {
              bool isActive =
                  index >= currentRange.start.toInt() &&
                  index <= currentRange.end.toInt();
              return Text(
                saturationLabels[index],
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive ? Colors.black87 : Colors.grey.shade400,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildFancyColorFilter(Color themeColor) {
    String shapName = "RD";
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
            bool isSelected = selectedFancyColorId == item['id'];
            String colorFileName = item['name'] == "White"
                ? "NZ"
                : item['name'];
            String imageUrl =
                "https://www.brilliance.com/sites/default/files/vue/fancy-search/${shapName}_$colorFileName.png";
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (selectedFancyColorId == item['id']) {
                    selectedFancyColorId = null;
                    selectedFancyColor = null;
                  } else {
                    selectedFancyColorId = item['id'];
                    selectedFancyColor = item['name'];
                  }
                  _future = _getSmartData();
                });
              },
              child: Column(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: isSelected ? Colors.black : Colors.transparent,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Image.network(
                      "https://corsproxy.io/?${Uri.encodeComponent(imageUrl)}",
                      width: 42,
                      height: 42,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade100,
                          alignment: Alignment.center,
                          child: Text(
                            item['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(strokeWidth: 1),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['name'],
                    style: TextStyle(
                      fontSize: 11,
                      color: isSelected ? Colors.black : Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        TextButton(
          onPressed: () => setState(() => isFancyExpanded = !isFancyExpanded),
          child: Text(
            isFancyExpanded ? "Show less" : "Show more",
            style: const TextStyle(
              fontSize: 12,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSidebarFilters(Color themeColor) {
    return Padding(
      padding: const EdgeInsets.all(24),
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
            _buildFancyColorFilter(themeColor),
            const SizedBox(height: 30),
            _buildSaturationSlider(themeColor),
            const SizedBox(height: 30),
            const Divider(),
          ] else ...[
            _buildColorSlider(themeColor),
            const Divider(),
          ],
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
          const SizedBox(height: 40),
          _buildStaticFilters(themeColor),
          const Divider(),
          _buildClaritySlider(themeColor),
          const SizedBox(height: 20),
          _buildAdvancedFilters(themeColor),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildAdvancedFilters(Color themeColor) {
    return Column(
      children: [
        ListTile(
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
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3142),
          ),
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 3,
            activeTrackColor: themeColor,
            inactiveTrackColor: Colors.grey.shade200,
            thumbColor: Colors.white,
            overlayColor: themeColor.withValues(alpha: 0.1),
          ),
          child: RangeSlider(
            values: values,
            min: 0,
            max: (labels.length - 1).toDouble(),
            divisions: labels.length - 1,
            activeColor: themeColor,
            onChanged: onChanged,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: labels.asMap().entries.map((entry) {
              int idx = entry.key;
              String label = entry.value;
              bool isActive =
                  idx >= values.start.toInt() && idx <= values.end.toInt();
              return Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: isActive ? Colors.black87 : Colors.grey.shade400,
                ),
              );
            }).toList(),
          ),
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
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 3,
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
          padding: const EdgeInsets.only(),
          child: TextButton.icon(
            onPressed: () {
              setState(() {
                showOnlyWithImages = false;
                quickShipping = false;
                _caratRange = const RangeValues(0.0, 15.0);
                _priceRange = const RangeValues(0.0, 100000.0);
                selectedOrigin = 1;
                selectedFancyColor = null;
                _saturationRange = const RangeValues(0, 5);
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
        onTap: () {
          if (selectedOrigin != value) {
            setState(() {
              selectedOrigin = value;
              _future = _getSmartData();
            });
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 10),
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
          _buildValuePod("MIN", minVal, themeColor),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            width: 15,
            height: 2,
            color: Colors.grey.shade300,
          ),
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
                    trackHeight: 3,
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
                    children: List.generate(clarityLabels.length, (index) {
                      bool isActive =
                          index >= _clarityRange.start.toInt() &&
                          index <= _clarityRange.end.toInt();
                      return Text(
                        clarityLabels[index],
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: isActive ? Colors.black : Colors.grey.shade400,
                        ),
                      );
                    }),
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
        trackHeight: 3,
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

  Widget _buildShapeSelector(dynamic shapeCategories) {
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
          final painter = DiamondPainterUtils.getPainterForShapeName(
            s['name'],
            active,
          );
          return GestureDetector(
            onTap: () {
              if (s['name'] == 'Other') {
                _showOtherShapesPopup();
              } else {
                setState(() {
                  selectedShapeId = s['id'];
                  selectedShape = s['name'];
                  _future = _getSmartData();
                });
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 10),
              width: 90,
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: active ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: active ? Colors.teal : Colors.grey.shade200,
                  width: active ? 2 : 1,
                ),
                boxShadow: active
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30,
                    width: 30,
                    child: painter != null
                        ? CustomPaint(painter: painter)
                        : Icon(
                            Icons.diamond_outlined,
                            size: 24,
                            color: active ? Colors.teal : Colors.grey,
                          ),
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

  void _showOtherShapesPopup() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "OtherShapes",
      transitionDuration: const Duration(milliseconds: 10),
      pageBuilder: (context, anim1, anim2) => const SizedBox(),
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: anim1.value,
          child: Opacity(
            opacity: anim1.value,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              titlePadding: EdgeInsets.zero,
              title: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 24,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFFF8FAFB),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Browse More Shapes",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        letterSpacing: 0.5,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              content: Container(
                width: 500,
                padding: const EdgeInsets.only(top: 10),
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: otherShapes.length,
                  itemBuilder: (context, index) {
                    final shape = otherShapes[index];
                    return _buildShapeGridItem(shape);
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildShapeGridItem(Map<String, dynamic> shape) {
    bool isSelected = selectedShapeId == shape['id'];
    final painter = DiamondPainterUtils.getPainterForShapeName(
      shape['name'],
      isSelected,
    );
    return InkWell(
      onTap: () {
        setState(() {
          selectedShapeId = shape['id'];
          selectedShape = shape['name'];
          _future = _getSmartData();
        });
        Navigator.pop(context);
      },
      borderRadius: BorderRadius.circular(15),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 5),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.teal.withValues(alpha: 0.05)
              : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? Colors.teal : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 45,
              width: 45,
              child: painter != null
                  ? CustomPaint(painter: painter)
                  : Icon(
                      Icons.diamond_outlined,
                      size: 32,
                      color: isSelected ? Colors.teal : Colors.grey,
                    ),
            ),

            const SizedBox(height: 10),
            Text(
              shape['name'].toString().toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: isSelected ? Colors.teal : Colors.black54,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
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
}
