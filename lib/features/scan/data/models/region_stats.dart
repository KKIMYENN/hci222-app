class PriceBucket {
  final double start;
  final double end;
  final int count;

  const PriceBucket({
    required this.start,
    required this.end,
    required this.count,
  });

  factory PriceBucket.fromJson(Map<String, dynamic> json) => PriceBucket(
        start: (json['bucket_start'] as num).toDouble(),
        end: (json['bucket_end'] as num).toDouble(),
        count: json['count'] as int,
      );
}

class RegionStats {
  final String productId;
  final double avgPrice;
  final double modePrice;
  final double maxPrice;
  final double minPrice;
  final double stdDev;
  final List<PriceBucket> distribution;

  const RegionStats({
    required this.productId,
    required this.avgPrice,
    required this.modePrice,
    required this.maxPrice,
    required this.minPrice,
    required this.stdDev,
    required this.distribution,
  });

  factory RegionStats.fromJson(Map<String, dynamic> json) => RegionStats(
        productId: json['product_id'] as String,
        avgPrice: (json['avg_price'] as num).toDouble(),
        modePrice: (json['mode_price'] as num).toDouble(),
        maxPrice: (json['max_price'] as num).toDouble(),
        minPrice: (json['min_price'] as num).toDouble(),
        stdDev: (json['std_dev'] as num).toDouble(),
        distribution: (json['distribution'] as List)
            .map((e) => PriceBucket.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  // Mock 데이터 (사과, 이스탄불 기준)
  static RegionStats mock(String productId) => RegionStats(
        productId: productId,
        avgPrice: 38.2,
        modePrice: 35.0,
        maxPrice: 65.0,
        minPrice: 20.0,
        stdDev: 9.5,
        distribution: const [
          PriceBucket(start: 20, end: 25, count: 3),
          PriceBucket(start: 25, end: 30, count: 8),
          PriceBucket(start: 30, end: 35, count: 15),
          PriceBucket(start: 35, end: 40, count: 22),
          PriceBucket(start: 40, end: 45, count: 18),
          PriceBucket(start: 45, end: 50, count: 10),
          PriceBucket(start: 50, end: 55, count: 5),
          PriceBucket(start: 55, end: 65, count: 2),
        ],
      );
}
