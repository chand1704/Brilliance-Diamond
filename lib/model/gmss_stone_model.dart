class GmssStone {
  final int id;
  final String stockNo;
  final String shapeStr;
  final String shapeIcon;
  final double weight;
  final String colorStr;
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

  factory GmssStone.fromJson(Map<String, dynamic> json) {
    double safeDouble(dynamic v) {
      if (v == null || v.toString() == 'null') return 0.0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }

    String rawImage = json['image_link']?.toString() ?? "";
    String fullImage = rawImage;

    if (rawImage.isNotEmpty && !rawImage.startsWith('http')) {
      fullImage = "https://dev2.kodllin.com/$rawImage";
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

    final cutItem = json['cut_item'] as Map<String, dynamic>?;

    return GmssStone(
      id: json['id'] is int ? json['id'] : 0,
      stockNo: json['stock_no']?.toString() ?? '',
      shapeStr: cleanShape,
      shapeIcon: shapeItem?['image_link']?.toString() ?? '',
      weight: safeDouble(json['weight']),
      colorStr: json['color_str']?.toString() ?? "",
      clarityStr: json['clarity_str']?.toString() ?? "",
      cut: json['cut']?.toString() ?? '',
      cut_code: cutItem?['cut_code']?.toString() ?? '',
      lab: json['lab_name']?.toString() ?? '',
      fl_intensity: json['fl_intensity']?.toString() ?? '',
      polish: json['polish']?.toString() ?? '',
      image_link: fullImage,
      // image_link: json['image_link']?.toString() ?? '',
      video_link: fullVideo,
      stoneName: json['stone_name']?.toString() ?? '',
      gridle_condition: json['gridle_condition']?.toString() ?? '',
      symmetry: json['symmetry_item']?['symmetry_code']?.toString() ?? "",
      culet_size: json['culet_size']?.toString() ?? '',
      certi_file: fullCert,
      length: safeDouble(json['length']),
      ratio: safeDouble(json['ratio']),
      depth: safeDouble(json['depth']),
      width: safeDouble(json['width']),
      table: safeDouble(json['table']),
      total_price: safeDouble(json['total_price']),
    );
  }
}
