class GmssStone {
  final int id;
  final String stockNo;
  final String shapeStr;
  final String shapeIcon;
  final double weight;
  final String colorStr;
  final String fancy_color;
  final String clarityStr;
  final String cut;
  final String cut_code;
  final String lab;
  final String fl_intensity;
  final String polish;
  final String image_link;
  final String video_link;
  final String stoneName;
  final String gridle_condition;
  final String symmetry;
  final String culet_size;
  final String? certi_file;
  final double length;
  final double ratio;
  final double depth;
  final double width;
  final double table;
  final double total_price;

  GmssStone({
    required this.id,
    required this.stockNo,
    required this.shapeStr,
    required this.shapeIcon,
    required this.weight,
    required this.colorStr,
    required this.fancy_color,
    required this.clarityStr,
    required this.cut,
    required this.cut_code,
    required this.lab,
    required this.fl_intensity,
    required this.polish,
    required this.image_link,
    required this.video_link,
    required this.stoneName,
    required this.gridle_condition,
    required this.symmetry,
    required this.culet_size,
    this.certi_file,
    required this.length,
    required this.ratio,
    required this.depth,
    required this.width,
    required this.table,
    required this.total_price,
  });

  factory GmssStone.fromJson(Map<String, dynamic> json, {required bool isLab}) {
    double safeDouble(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }

    // return GmssStone(
    //   id: 0, // New API doesn't seem to have a unique numeric ID, using 0 or use stockNo.hashCode
    //   stockNo: json['stockNo']?.toString() ?? '',
    //   shapeStr: json['shape']?.toString() ?? 'ROUND',
    //   shapeIcon: '', // New API doesn't provide a shape icon URL
    //   weight: safeDouble(json['weight']),
    //   colorStr: json['color']?.toString() ?? "",
    //   fancy_color: json['fancyColor']?.toString() ?? "",
    //   clarityStr: json['clarity']?.toString() ?? "",
    //   cut: json['cut']?.toString() ?? '',
    //   cut_code: json['cut']?.toString() ?? '',
    //   lab: json['lab']?.toString() ?? '',
    //   fl_intensity: json['fluorescenceIntensity']?.toString() ?? '',
    //   polish: json['polish']?.toString() ?? '',
    //   image_link: json['imageLink']?.toString() ?? "",
    //   video_link: json['videoLink']?.toString() ?? "",
    //   stoneName: "LAB GROWN ${json['weight']} CT ${json['shape']}",
    //   gridle_condition: json['girdleCondition']?.toString() ?? '',
    //   symmetry: json['symmetry']?.toString() ?? "",
    //   culet_size: json['culetSize']?.toString() ?? '',
    //   length: safeDouble(json['measurements']?.toString().split('*').first),
    //   ratio: safeDouble(json['ratio']),
    //   depth: safeDouble(json['depth']),
    //   width: safeDouble(
    //     json['table'],
    //   ), // Using table as placeholder if width is missing
    //   table: safeDouble(json['table']),
    //   total_price: safeDouble(json['totalPrice']),
    // );
    return GmssStone(
      id: json['stockNo'].hashCode, // Use stockNo hash as unique ID
      stockNo: json['stockNo']?.toString() ?? '',
      shapeStr: json['shape']?.toString() ?? 'ROUND',
      shapeIcon: '',
      weight: safeDouble(json['weight']),
      colorStr: json['color']?.toString() ?? "",
      fancy_color: json['fancyColor']?.toString() ?? "",
      clarityStr: json['clarity']?.toString() ?? "",
      cut: json['cut']?.toString() ?? '',
      cut_code: json['cut']?.toString() ?? '',
      lab: json['lab'] ?? "GIA",
      fl_intensity: json['fluorescenceIntensity']?.toString() ?? '',
      polish: json['polish']?.toString() ?? '',
      image_link: json['imageLink']?.toString() ?? "",
      video_link: json['videoLink']?.toString() ?? "",
      certi_file: json['certiFile'] ?? json['certi_file'] ?? "",
      // Crucial for your UI filters:
      stoneName: isLab
          ? "LAB GROWN ${json['weight']} CT ${json['shape']}"
          : "NATURAL ${json['weight']} CT ${json['shape']}",
      gridle_condition: json['girdleCondition']?.toString() ?? '',
      symmetry: json['symmetry']?.toString() ?? "",
      culet_size: json['culetSize']?.toString() ?? '',
      length: safeDouble(json['measurements']?.toString().split('*').first),
      ratio: safeDouble(json['ratio']),
      depth: safeDouble(json['depth']),
      width: safeDouble(json['table']),
      table: safeDouble(json['table']),
      total_price: safeDouble(json['totalPrice']),
    );
  }
  // Inside your GmssStone class
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stockNo': stockNo,
      'shapeStr': shapeStr,
      'shapeIcon': shapeIcon,
      'weight': weight,
      'color': colorStr,
      'fancyColor': fancy_color,
      'clarity': clarityStr,
      'cut': cut,
      'cut_code': cut_code,
      'lab': lab,
      'fluorescenceIntensity': fl_intensity,
      'polish': polish,
      'imageLink': image_link,
      'videoLink': video_link,
      'certiFile': certi_file,
      'stoneName': stoneName,
      'girdleCondition': gridle_condition,
      'symmetry': symmetry,
      'culetSize': culet_size,
      'measurements':
          "$length*$width*$depth", // Reconstructed for fromJson split
      'ratio': ratio,
      'depth': depth,
      'table': table, // Maps to both width and table in your logic
      'totalPrice': total_price,
    };
  }

  // factory GmssStone.fromJson(Map<String, dynamic> json) {
  //   double safeDouble(dynamic v) {
  //     if (v == null || v.toString() == 'null') return 0.0;
  //     if (v is num) return v.toDouble();
  //     return double.tryParse(v.toString()) ?? 0.0;
  //   }
  //
  //   String rawImage = json['image_link']?.toString() ?? "";
  //   String fullImage = rawImage;
  //
  //   if (rawImage.isNotEmpty && !rawImage.startsWith('http')) {
  //     fullImage = "https://dev2.kodllin.com/$rawImage";
  //   }
  //
  //   String rawShape = json['shape_str']?.toString() ?? 'ROUND';
  //   String cleanShape = rawShape.split(' ')[0];
  //
  //   String rawVideo = json['video_link']?.toString() ?? "";
  //   String fullVideo = rawVideo.isEmpty
  //       ? ""
  //       : (rawVideo.startsWith('http')
  //             ? rawVideo
  //             : "https://dev2.kodllin.com/$rawVideo");
  //
  //   String? rawCert = json['certi_file']?.toString();
  //   String? fullCert;
  //   if (rawCert != null && rawCert.isNotEmpty && rawCert != "null") {
  //     fullCert = rawCert.startsWith('http')
  //         ? rawCert
  //         : "https://dev2.kodllin.com/$rawCert";
  //   }
  //
  //   final shapeItem = json['shape_item'] as Map<String, dynamic>?;
  //
  //   final cutItem = json['cut_item'] as Map<String, dynamic>?;
  //
  //   return GmssStone(
  //     id: json['id'] is int ? json['id'] : 0,
  //     stockNo: json['stock_no']?.toString() ?? '',
  //     shapeStr: cleanShape,
  //     shapeIcon: shapeItem?['image_link']?.toString() ?? '',
  //     weight: safeDouble(json['weight']),
  //     // colorStr: json['color_str_2']?.toString() ?? "",
  //     colorStr: (json['color_str_2']?.toString() ?? "").isEmpty
  //         ? (json['fancy_color']?.toString() ?? "")
  //         : json['color_str_2'].toString(),
  //     fancy_color: json['fancy_color']?.toString() ?? "",
  //     clarityStr: json['clarity_str']?.toString() ?? "",
  //     cut: json['cut']?.toString() ?? '',
  //     cut_code: cutItem?['cut_code']?.toString() ?? '',
  //     lab: json['lab_name']?.toString() ?? '',
  //     fl_intensity: json['fl_intensity']?.toString() ?? '',
  //     polish: json['polish']?.toString() ?? '',
  //     image_link: fullImage,
  //     video_link: fullVideo,
  //     stoneName: json['stone_name']?.toString() ?? '',
  //     gridle_condition: json['gridle_condition']?.toString() ?? '',
  //     symmetry: json['symmetry_item']?['symmetry_code']?.toString() ?? "",
  //     culet_size: json['culet_size']?.toString() ?? '',
  //     certi_file: fullCert,
  //     length: safeDouble(json['length']),
  //     ratio: safeDouble(json['ratio']),
  //     depth: safeDouble(json['depth']),
  //     width: safeDouble(json['width']),
  //     table: safeDouble(json['table']),
  //     total_price: safeDouble(json['total_price']),
  //   );
  // }
}
