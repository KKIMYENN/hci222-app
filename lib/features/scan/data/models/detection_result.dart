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

  // Mock 결과 (포도, 카이로 기준 EGP)
  // TODO: YOLO 백엔드 연동 시 DetectionResult.fromJson(res.data)으로 교체
  static DetectionResult mock() => const DetectionResult(
        productId: 'p001',
        productName: '포도 (Grapes)',
        productNameAr: 'عنب',
        confidence: 0.92,
        detectedPrice: 65.0,
      );
}
