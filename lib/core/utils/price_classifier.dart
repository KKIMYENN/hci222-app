enum PriceStatus { safe, negotiable, warning }

class PriceClassifier {
  /// z-score 기반 가격 분류
  /// z > 1.5  → warning (Red)
  /// z > 0.0  → negotiable (Yellow)
  /// z <= 0.0 → safe (Green)
  static PriceStatus classify({
    required double observed,
    required double avg,
    required double stdDev,
  }) {
    if (stdDev == 0) {
      return observed > avg ? PriceStatus.warning : PriceStatus.safe;
    }
    final z = (observed - avg) / stdDev;
    if (z > 1.5) return PriceStatus.warning;
    if (z > 0.0) return PriceStatus.negotiable;
    return PriceStatus.safe;
  }

  /// 평균 대비 차이(%) 계산
  static double percentDiff(double observed, double avg) {
    if (avg == 0) return 0;
    return (observed - avg) / avg * 100;
  }

  /// 상태별 안내 메시지
  static String statusMessage(PriceStatus status, double percent) {
    switch (status) {
      case PriceStatus.safe:
        return '적정 가격이에요 (평균보다 ${percent.abs().toStringAsFixed(0)}% 저렴)';
      case PriceStatus.negotiable:
        return '흥정 가능해요 (평균보다 ${percent.toStringAsFixed(0)}% 비쌈)';
      case PriceStatus.warning:
        return '바가지 주의! (평균보다 ${percent.toStringAsFixed(0)}% 비쌈)';
    }
  }
}
