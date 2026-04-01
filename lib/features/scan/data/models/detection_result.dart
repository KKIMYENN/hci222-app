class DetectionResult {
  final String productId;
  final String productName;
  final String productNameAr;
  final double confidence;
  final double? detectedPrice;

  const DetectionResult({
    required this.productId,
    required this.productName,
    required this.productNameAr,
    required this.confidence,
    this.detectedPrice,
  });

  factory DetectionResult.fromJson(Map<String, dynamic> json) {
    return DetectionResult(
      productId: json['product_id'] as String,
      productName: json['name_kr'] as String,
      productNameAr: json['name_ar'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      detectedPrice: json['detected_price'] != null
          ? (json['detected_price'] as num).toDouble()
          : null,
    );
  }

  // Mock 결과
  static DetectionResult mock() => const DetectionResult(
        productId: 'p001',
        productName: '사과 (Apple)',
        productNameAr: 'تفاحة',
        confidence: 0.92,
        detectedPrice: 45.0,
      );
}
