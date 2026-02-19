class Diamond {
  final String id;
  final String name;
  final String shape;
  final String origin;
  final double carat;
  final double price;
  final String imageUrl;
  final bool hasImage;
  final bool isQuickShipping;
  final bool isRecentlyViewed;
  bool isInCompareList;
  final String color;
  final String clarity;

  Diamond({
    required this.id,
    required this.name,
    required this.shape,
    required this.origin,
    required this.carat,
    required this.price,
    required this.imageUrl,
    this.hasImage = true,
    this.isQuickShipping = false,
    this.isRecentlyViewed = false,
    this.isInCompareList = false,
    required this.color,
    required this.clarity,
  });

  factory Diamond.fromJson(Map<String, dynamic> json) {
    return Diamond(
      id: json['stock_id']?.toString() ?? '',
      name:
          json['name']?.toString() ?? '${json['carat']} Carat ${json['shape']}',
      shape: json['shape']?.toString() ?? 'N/A',
      origin: json['origin']?.toString() ?? 'Natural',
      carat: double.tryParse(json['carat']?.toString() ?? '0.0') ?? 0.0,
      price: double.tryParse(json['rate']?['max']?.toString() ?? '0.0') ?? 0.0,
      imageUrl: json['image_url']?.toString() ?? '',
      color: json['color']?.toString() ?? 'N/A',
      clarity: json['clarity']?.toString() ?? 'N/A',
    );
  }
}

// THIS LIST MUST BE OUTSIDE THE CLASS BRACES
final List<Diamond> allDiamonds = [
  Diamond(
    id: '1',
    name: '1.20 Carat Emerald Cut',
    shape: 'Emerald',
    origin: 'Lab Grown',
    carat: 1.2,
    price: 1200,
    color: 'G',
    clarity: 'VS1',
    hasImage: true,
    isQuickShipping: true,
    isRecentlyViewed: false,
    isInCompareList: false,
    imageUrl: 'assets/images/emerald.png',
  ),
  // Diamond(
  //   id: '2',
  //   name: '1.20 Carat Emerald Cut',
  //   shape: 'Emerald',
  //   origin: 'Lab Grown',
  //   carat: 1.2,
  //   price: 1200,
  //   color: 'G',
  //   clarity: 'VS1',
  //   hasImage: true,
  //   isQuickShipping: true,
  //   isRecentlyViewed: false,
  //   isInCompareList: false,
  //   imageUrl: 'assets/images/emerald.png',
  // ),
  Diamond(
    id: '2',
    name: '1.50 Carat Round Brilliant',
    shape: 'Round',
    origin: 'Natural',
    carat: 1.5,
    price: 5000,
    color: 'D',
    clarity: 'VVS1',
    hasImage: true,
    isQuickShipping: false,
    isRecentlyViewed: false,
    isInCompareList: false,
    imageUrl: 'assets/images/round.png',
  ),
  // Add more diamond objects here...
];
