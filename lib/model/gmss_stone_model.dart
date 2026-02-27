class GmssStone {
  final int id;
  final String stockNo;
  final String shapeStr;
  final String shapeIcon;
  final double weight;
  final String colorStr;
  final String clarityStr;
  final String cut;
  final double length;
  final double ratio;

  final String cut_code;
  final String lab;
  final String fl_intensity;
  final String polish;
  final String image_link;
  final String video_link;
  final String stoneName;
  final String gridle_condition;
  final String symmetry;
  final double depth;
  final double width;
  final double table;
  final String culet_size;
  final double total_price;
  final String? certi_file;

  GmssStone({
    required this.id,
    required this.stockNo,
    required this.shapeStr,
    required this.shapeIcon,
    required this.weight,
    required this.colorStr,
    required this.clarityStr,
    required this.cut,
    required this.cut_code,
    required this.length,
    required this.ratio,
    // this.length = 0.0,
    // this.ratio = 0.0,
    required this.lab,
    required this.fl_intensity,
    required this.polish,
    required this.image_link,
    required this.video_link,
    required this.stoneName,
    required this.symmetry,
    required this.gridle_condition,
    required this.depth,
    required this.culet_size,
    required this.width,
    required this.table,
    required this.total_price,
    this.certi_file,
  });

  factory GmssStone.fromJson(Map<String, dynamic> json) {
    double safeDouble(dynamic v) {
      if (v == null || v.toString() == 'null') return 0.0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }

    String rawShape = json['shape_str']?.toString() ?? 'ROUND';
    String cleanShape = rawShape.split(' ')[0];
    String rawVideo = json['video_link']?.toString() ?? "";
    String fullVideo = rawVideo.isEmpty
        ? ""
        : (rawVideo.startsWith('http')
              ? rawVideo
              : "https://dev2.kodllin.com/$rawVideo");

    String? rawCert = json['certi_file']?.toString();
    String? fullCert;
    if (rawCert != null && rawCert.isNotEmpty && rawCert != "null") {
      fullCert = rawCert.startsWith('http')
          ? rawCert
          : "https://dev2.kodllin.com/$rawCert";
    }
    final shapeItem = json['shape_item'] as Map<String, dynamic>?;
    // final symmetryItem = json['symmetry_item'] as Map<String, dynamic>?;
    final cutItem = json['cut_item'] as Map<String, dynamic>?;

    return GmssStone(
      id: json['id'] is int ? json['id'] : 0,
      stockNo: json['stock_no']?.toString() ?? '',
      shapeStr: cleanShape,
      // shapeStr: json['shape_str']?.toString() ?? '',
      shapeIcon: shapeItem?['image_link']?.toString() ?? '',
      gridle_condition: json['gridle_condition']?.toString() ?? '',
      // video_link: json['video_link']?.toString() ?? "",
      video_link: fullVideo,
      colorStr: json['color_str']?.toString() ?? "",
      certi_file: fullCert,
      clarityStr: json['clarity_str']?.toString() ?? "",
      polish: json['polish']?.toString() ?? '',
      cut: json['cut']?.toString() ?? '',
      cut_code: cutItem?['cut_code']?.toString() ?? '',
      fl_intensity: json['fl_intensity']?.toString() ?? '',
      image_link: json['image_link']?.toString() ?? '',
      stoneName: json['stone_name']?.toString() ?? '',
      lab: json['lab_name']?.toString() ?? '',
      culet_size: json['culet_size']?.toString() ?? '',
      symmetry: json['symmetry_item']?['symmetry_code']?.toString() ?? "",
      depth: safeDouble(json['depth']),
      width: safeDouble(json['width']),
      table: safeDouble(json['table']),
      ratio: safeDouble(json['ratio']), // MAP THE RATIO HERE
      length: safeDouble(json['length']),
      weight: safeDouble(json['weight']),
      total_price: safeDouble(json['total_price']),
    );
  }
}
