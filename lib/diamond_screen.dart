// import 'package:flutter/material.dart';
//
// import 'diamonds_details_pages.dart';
// import 'model/diamonds.dart';
//
// class DiamondApp extends StatefulWidget {
//   const DiamondApp({super.key});
//
//   @override
//   State<DiamondApp> createState() => _DiamondAppState();
// }
//
// class _DiamondAppState extends State<DiamondApp> {
//   final List<String> shapes = [
//     'Round',
//     'Cushion',
//     'Emerald',
//     'Pear',
//     'Asscher',
//     'Princess',
//     'Oval',
//     'Heart',
//     'Marquise',
//     'Radiant',
//   ];
//   String currentView = 'All';
//   String selectedShape = 'Emerald';
//   String selectedOrigin = 'Lab Grown';
//   RangeValues caratRange = const RangeValues(0.1, 12.0);
//   RangeValues priceRange = const RangeValues(450, 100000);
//
//   // bool _isHovered = false;
//   bool withImageOnly = true;
//   bool quickShippingOnly = false;
//   bool isGridView = true;
//   bool showAdvance = false;
//   // M is index 0, D is index 10
//   double colorStart = 3; // Starts at G
//   double colorEnd = 0; // Ends at D
//
//   final List<String> colorLabels = [
//     'M',
//     'L',
//     'K',
//     'J',
//     'I',
//     'H',
//     'G',
//     'F',
//     'E',
//     'D',
//   ]; // Length 10
//   RangeValues colorRange = const RangeValues(0, 9);
//   final List<String> clarityLabels = [
//     'I1',
//     'SI2',
//     'SI1',
//     'VS2',
//     'VS1',
//     'VVS2',
//     'VVS1',
//     'IF',
//     'FL',
//   ];
//   RangeValues clarityRange = const RangeValues(0, 8);
//   final List<String> cutLabels = [
//     'Fair',
//     'Good',
//     'Very Good',
//     'Ideal',
//     'Astor Ideal',
//   ];
//   RangeValues cutRange = const RangeValues(0, 4);
//   final List<String> fluorescenceLabels = [
//     'None',
//     'Faint',
//     'Medium',
//     'Strong',
//     'Very Strong',
//   ];
//   RangeValues fluorescenceRange = const RangeValues(0, 4);
//   void intiSape() {
//     super.initState();
//     // colorRange = RangeValues(0, colorLabels.length - 1.0);
//     // clarityRange = RangeValues(0, clarityLabels.length - 1.0);
//   }
//
//   // Add a reset function
//   void resetFilters() {
//     setState(() {
//       caratRange = const RangeValues(0.1, 12.0);
//       priceRange = const RangeValues(450, 100000);
//       withImageOnly = true;
//       quickShippingOnly = false;
//       showAdvance = false;
//       cutRange = const RangeValues(0, 4);
//       fluorescenceRange = const RangeValues(0, 4);
//       // Reset colors/clarity here too
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // 1. Logic for "All" tab (Apply all sidebar filters)
//     List<Diamond> filteredDiamonds = allDiamonds.where((d) {
//       final matchesBase =
//           d.shape == selectedShape &&
//           d.origin == selectedOrigin &&
//           d.carat >= caratRange.start &&
//           d.carat <= caratRange.end &&
//           d.price >= priceRange.start &&
//           d.price <= priceRange.end;
//
//       final matchesCheckboxes =
//           (!withImageOnly || d.hasImage) &&
//           (!quickShippingOnly || d.isQuickShipping);
//
//       return matchesBase && matchesCheckboxes;
//     }).toList();
//
//     // 2. Logic for "Recent" tab (Ignore sidebar filters)
//     List<Diamond> recentDiamonds = allDiamonds
//         .where((d) => d.isRecentlyViewed)
//         .toList();
//
//     // 3. Logic for "Compare" tab (Ignore sidebar filters)
//     List<Diamond> compareDiamonds = allDiamonds
//         .where((d) => d.isInCompareList)
//         .toList();
//
//     // 4. Determine which list to show in the Grid based on the Tab selected
//     List<Diamond> listToShow;
//     if (currentView == 'Recent') {
//       listToShow = recentDiamonds;
//     } else if (currentView == 'Compare') {
//       listToShow = compareDiamonds;
//     } else {
//       listToShow = filteredDiamonds;
//     }
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         // title: const Text('Diamond Store'),
//       ),
//       body: Center(
//         child: Container(
//           constraints: const BoxConstraints(maxWidth: 1550),
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 Text(
//                   currentView == 'All'
//                       ? "$selectedOrigin $selectedShape Diamonds"
//                       : currentView,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 32,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 _buildShapeSelector(),
//                 const Divider(height: 40),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 24.0),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Sidebar
//                       SizedBox(width: 260, child: _buildSidebar()),
//                       const SizedBox(width: 40),
//                       // Main Content
//                       Expanded(
//                         child: Column(
//                           children: [
//                             // PASSING STATIC COUNTS TO HEADER
//                             _buildGridHeader(
//                               filteredDiamonds.length,
//                               recentDiamonds.length,
//                               compareDiamonds.length,
//                             ),
//                             const SizedBox(height: 20),
//                             _buildProductGrid(listToShow),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildGridHeader(int total, int recent, int compare) {
//     return Row(
//       children: [
//         _headerTab("$total Diamonds", 'All'),
//         const SizedBox(width: 30),
//         _headerTab("$recent Recently Viewed", 'Recent'),
//         const SizedBox(width: 30),
//         _headerTab("$compare Compare", 'Compare'),
//         const Spacer(),
//         IconButton(
//           onPressed: () => setState(() => isGridView = true),
//           icon: Icon(
//             Icons.grid_view_rounded,
//             color: isGridView ? Colors.black : Colors.grey,
//           ),
//         ),
//         IconButton(
//           onPressed: () => setState(() => isGridView = false),
//           icon: Icon(
//             Icons.format_list_bulleted_rounded,
//             color: !isGridView ? Colors.black : Colors.grey,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _headerTab(String label, String viewValue) {
//     bool isSelected = currentView == viewValue;
//     return GestureDetector(
//       onTap: () => setState(() => currentView = viewValue),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 14, // Slightly smaller to fit numbers
//               color: isSelected ? Colors.black : Colors.black54,
//             ),
//           ),
//           if (isSelected) Container(height: 2, width: 25, color: Colors.teal),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildProductGrid(List<Diamond> items) {
//     if (items.isEmpty) {
//       return Center(
//         child: Padding(
//           padding: const EdgeInsets.only(top: 40),
//           child: Text("No diamonds in $currentView list."),
//         ),
//       );
//     }
//     return isGridView
//         ? GridView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 3,
//               childAspectRatio: 0.65,
//               crossAxisSpacing: 12,
//               mainAxisSpacing: 12,
//             ),
//             itemCount: items.length,
//             itemBuilder: (context, index) => _buildProductCard(items[index]),
//           )
//         : ListView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: items.length,
//             itemBuilder: (context, index) =>
//                 _buildProductListTile(items[index]),
//           );
//   }
//
//   Widget _buildProductCard(Diamond diamond) {
//     bool isHovered = false;
//
//     return StatefulBuilder(
//       builder: (context, setCardState) {
//         return MouseRegion(
//           onEnter: (_) {
//             WidgetsBinding.instance.addPostFrameCallback((_) {
//               if (context.mounted) {
//                 setCardState(() => isHovered = true);
//               }
//             });
//           },
//
//           onExit: (_) {
//             WidgetsBinding.instance.addPostFrameCallback((_) {
//               if (context.mounted) {
//                 setCardState(() => isHovered = false);
//               }
//             });
//           },
//           cursor: SystemMouseCursors.click,
//           child: GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => DiamondsDetailsPages(diamond: diamond),
//                 ),
//               );
//             },
//             // ),
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 200),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12), // Softer corners
//                 border: Border.all(
//                   color: isHovered
//                       ? Colors.teal.withValues(alpha: 0.3)
//                       : Colors.grey.shade200,
//                 ),
//                 boxShadow: [
//                   if (isHovered)
//                     BoxShadow(
//                       color: Colors.black.withValues(alpha: 0.05),
//                       blurRadius: 15,
//                       offset: const Offset(0, 8),
//                     ),
//                 ],
//               ),
//
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // --- IMAGE AREA ---
//                   Expanded(
//                     child: Stack(
//                       children: [
//                         GestureDetector(
//                           onTap: () => Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (c) =>
//                                   DiamondsDetailsPages(diamond: diamond),
//                             ),
//                           ),
//                           child: Container(
//                             margin: const EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                               color: const Color(
//                                 0xFFF9F9F9,
//                               ), // Lighter, cleaner grey
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Center(
//                               child: AnimatedScale(
//                                 scale: isHovered ? 1.1 : 1.0,
//                                 duration: const Duration(milliseconds: 400),
//                                 curve: Curves.easeOutQuart,
//                                 child: Hero(
//                                   tag: 'diamond_${diamond.id ?? diamond.name}',
//                                   // tag: 'diamond_${diamond.id}',
//                                   child: Image.asset(
//                                     diamond.imageUrl.isNotEmpty
//                                         ? diamond.imageUrl
//                                         : 'assets/placeholder.png',
//                                     fit: BoxFit.contain,
//                                     errorBuilder: (c, e, s) => const Icon(
//                                       Icons.diamond_outlined,
//                                       size: 40,
//                                       color: Colors.grey,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//
//                         // Favorite Button
//                         Positioned(
//                           top: 12,
//                           right: 12,
//                           child: IconButton(
//                             icon: Icon(
//                               diamond.isInCompareList
//                                   ? Icons.favorite
//                                   : Icons.favorite_border,
//                               color: diamond.isInCompareList
//                                   ? Colors.teal
//                                   : Colors.black26,
//                               size: 20,
//                             ),
//                             onPressed: () => setState(
//                               () => diamond.isInCompareList =
//                                   !diamond.isInCompareList,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   // --- TEXT AREA ---
//                   Padding(
//                     padding: const EdgeInsets.all(12),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           diamond.name.toUpperCase(),
//                           style: const TextStyle(
//                             fontWeight: FontWeight.w800,
//                             fontSize: 11,
//                             letterSpacing: 0.5,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         const Text(
//                           "E • VS2 • IGI Certified",
//                           style: TextStyle(color: Colors.black45, fontSize: 10),
//                         ),
//                         const SizedBox(height: 8),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               "\$${diamond.price.toStringAsFixed(0)}",
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16,
//                                 color: Colors.teal,
//                               ),
//                             ),
//                             if (diamond.isQuickShipping) _buildQuickShipBadge(),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildQuickShipBadge() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
//       decoration: BoxDecoration(
//         color: const Color(0xFF009688),
//         borderRadius: BorderRadius.circular(2),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: const [
//           Icon(Icons.local_shipping, color: Colors.white, size: 10),
//           SizedBox(width: 4),
//           Text(
//             "Quick\nShip",
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 7,
//               fontWeight: FontWeight.bold,
//               height: 1.1,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // --- Sidebar & Filter Widgets ---
//   Widget _buildSidebar() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Filters",
//           style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 20),
//         _buildOriginToggle(),
//         const SizedBox(height: 30),
//         _buildRangeFilter(
//           label: "Carat",
//           values: caratRange,
//           min: 0.1,
//           max: 12.0,
//           onChanged: (v) => setState(() => caratRange = v),
//         ),
//         const SizedBox(height: 30),
//         _buildRangeFilter(
//           label: "Price",
//           prefix: "\$",
//           values: priceRange,
//           min: 0,
//           max: 100000,
//           onChanged: (v) => setState(() => priceRange = v),
//         ),
//         const Divider(height: 40),
//         _buildCheckbox(
//           "With Image Only",
//           withImageOnly,
//           (v) => setState(() => withImageOnly = v!),
//         ),
//         _buildCheckbox(
//           "Quick Shipping",
//           quickShippingOnly,
//           (v) => setState(() => quickShippingOnly = v!),
//         ),
//
//         TextButton.icon(
//           onPressed: resetFilters,
//           icon: const Icon(Icons.refresh, size: 18, color: Colors.black54),
//           label: const Text(
//             "Resets Filters",
//             style: TextStyle(color: Colors.black),
//           ),
//         ),
//         const Divider(height: 40),
//         ExpansionTile(
//           title: const Text(
//             "Color",
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           trailing: const Icon(Icons.info_outline, size: 20),
//           shape: Border(),
//           children: [
//             _buildDiscreteRangeSlider(
//               currentRange: colorRange,
//               labels: colorLabels,
//               onChanged: (v) => setState(() => colorRange = v),
//             ),
//           ],
//         ),
//         const Divider(height: 40),
//         ExpansionTile(
//           title: const Text(
//             "Clarity",
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           trailing: const Icon(Icons.info_outline, size: 20),
//           shape: Border(),
//           children: [
//             _buildDiscreteRangeSlider(
//               currentRange: clarityRange,
//               labels: clarityLabels,
//               onChanged: (v) => setState(() => clarityRange = v),
//             ),
//           ],
//         ),
//         // const SizedBox(height: 20),
//         // TextButton.icon(
//         //   onPressed: () {},
//         //   icon: const Icon(Icons.add),
//         //   label: const Text("Advance Filters"),
//         // ),
//         const Divider(height: 40),
//         GestureDetector(
//           onTap: () => setState(() => showAdvance = !showAdvance),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 12.0),
//             child: Row(
//               children: [
//                 Icon(showAdvance ? Icons.remove : Icons.add, size: 20),
//                 const SizedBox(width: 10),
//                 Text(
//                   "Advanced Filters",
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.blueGrey.shade800,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         const SizedBox(height: 40),
//         if (showAdvance) ...[
//           _buildExpansionFilter(
//             "Cut",
//             cutLabels,
//             cutRange,
//             (v) => setState(() => cutRange = v),
//           ),
//           _buildExpansionFilter(
//             "Certification",
//             ["IGI", "GIA", "GCAL"],
//             const RangeValues(0, 2),
//             (v) {},
//           ),
//           _buildExpansionFilter(
//             "Polish",
//             ["Good", "VG", "EX"],
//             const RangeValues(0, 2),
//             (v) {},
//           ),
//           _buildExpansionFilter(
//             "Symmetry",
//             ["Good", "VG", "EX"],
//             const RangeValues(0, 2),
//             (v) {},
//           ),
//           _buildExpansionFilter(
//             "Fluorescence",
//             fluorescenceLabels,
//             fluorescenceRange,
//             (v) => setState(() => fluorescenceRange = v),
//           ),
//         ],
//       ],
//     );
//   }
//
//   Widget _buildOriginToggle() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.grey.shade100,
//         borderRadius: BorderRadius.circular(25),
//       ),
//       child: Row(
//         children: ['Lab Grown', 'Natural'].map((type) {
//           bool isSelected = selectedOrigin == type;
//           return Expanded(
//             child: GestureDetector(
//               onTap: () => setState(() => selectedOrigin = type),
//               child: Container(
//                 padding: const EdgeInsets.symmetric(vertical: 10),
//                 decoration: BoxDecoration(
//                   color: isSelected ? Colors.teal : Colors.transparent,
//                   borderRadius: BorderRadius.circular(25),
//                 ),
//                 child: Center(
//                   child: Text(
//                     type,
//                     style: TextStyle(
//                       color: isSelected ? Colors.white : Colors.black54,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
//
//   Widget _buildRangeFilter({
//     required String label,
//     String prefix = "",
//     required RangeValues values,
//     required double min,
//     required double max,
//     required Function(RangeValues) onChanged,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
//         RangeSlider(
//           values: values,
//           min: min,
//           max: max,
//           activeColor: Colors.teal,
//           onChanged: onChanged,
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             _rangeValueBox(
//               "$prefix${values.start.toStringAsFixed(label == "Carat" ? 2 : 0)}",
//             ),
//             _rangeValueBox("$prefix${values.end.toStringAsFixed(0)}.00+"),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _rangeValueBox(String text) => Container(
//     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//     decoration: BoxDecoration(
//       border: Border.all(color: Colors.grey.shade300),
//       borderRadius: BorderRadius.circular(4),
//     ),
//     child: Text(text, style: const TextStyle(fontSize: 12)),
//   );
//
//   Widget _buildCheckbox(String title, bool val, Function(bool?) onChanged) =>
//       Row(
//         children: [
//           Checkbox(value: val, onChanged: onChanged, activeColor: Colors.teal),
//           Text(title),
//         ],
//       );
//
//   Widget _buildShapeSelector() {
//     // itemCount:
//     (shapes ?? []).length; // Add the ?? [] fallback
//     return Container(
//       height: 100,
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         shrinkWrap: true,
//         itemCount: shapes.length,
//         separatorBuilder: (context, index) => const SizedBox(width: 25),
//         itemBuilder: (context, index) {
//           String shape = shapes[index];
//           bool isSelected = shape == selectedShape;
//           return GestureDetector(
//             onTap: () => setState(() => selectedShape = shape),
//             child: AnimatedOpacity(
//               duration: const Duration(milliseconds: 200),
//               opacity: isSelected ? 1.0 : 0.5,
//               child: Column(
//                 children: [
//                   Icon(
//                     Icons.diamond_outlined,
//                     color: isSelected ? Colors.teal : Colors.black,
//                     size: 28,
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     shape,
//                     style: TextStyle(
//                       fontSize: 12,
//                       fontWeight: isSelected
//                           ? FontWeight.bold
//                           : FontWeight.normal,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildProductListTile(Diamond diamond) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 15),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey.shade200),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 150,
//             // height: 100,
//             color: Colors.grey.shade50,
//             child: Image.asset(
//               diamond.imageUrl,
//               fit: BoxFit.contain,
//               errorBuilder: (c, e, s) =>
//                   const Icon(Icons.diamond, color: Colors.teal, size: 40),
//             ),
//           ),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   if (diamond.isQuickShipping) _buildBadge("Quick Shipping"),
//                   Text(
//                     diamond.name,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18,
//                     ),
//                   ),
//                   Text(
//                     "\$${diamond.price}",
//                     style: const TextStyle(
//                       color: Colors.teal,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 20,
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
//   Widget _buildBadge(String text) => Container(
//     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//     decoration: BoxDecoration(
//       color: Colors.teal.shade50,
//       borderRadius: BorderRadius.circular(4),
//     ),
//     child: Text(
//       text,
//       style: const TextStyle(
//         color: Colors.teal,
//         fontSize: 10,
//         fontWeight: FontWeight.bold,
//       ),
//     ),
//   );
//
//   Widget _buildDiscreteRangeSlider({
//     required RangeValues currentRange,
//     required List<String> labels,
//     required Function(RangeValues) onChanged,
//   }) {
//     // Determine the absolute maximum index allowed
//     double maxPossible = (labels.length - 1).toDouble();
//
//     // FORCE the values to be within 0 and maxPossible
//     RangeValues safeValues = RangeValues(
//       currentRange.start.clamp(0.0, maxPossible),
//       currentRange.end.clamp(0.0, maxPossible),
//     );
//
//     return Column(
//       children: [
//         RangeSlider(
//           values: safeValues, // Use the clamped values here
//           min: 0,
//           max: maxPossible,
//           divisions: labels.length - 1,
//           activeColor: Colors.teal,
//           onChanged: onChanged,
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: labels
//                 .map((l) => Text(l, style: const TextStyle(fontSize: 10)))
//                 .toList(),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildExpansionFilter(
//     String title,
//     List<String> labels,
//     RangeValues range,
//     Function(RangeValues) onChanged,
//   ) {
//     return Column(
//       children: [
//         ExpansionTile(
//           title: Text(
//             title,
//             style: const TextStyle(
//               // fontSize: 14, fontWeight: FontWeight.w500
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           trailing: const Icon(Icons.keyboard_arrow_down),
//           shape: const Border(), // Removes the default expansion border
//           children: [
//             _buildDiscreteRangeSlider(
//               currentRange: range,
//               labels: labels,
//               onChanged: onChanged,
//             ),
//           ],
//         ),
//         const Divider(height: 1),
//       ],
//     );
//   }
// }
