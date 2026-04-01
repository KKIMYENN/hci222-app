class ApiEndpoints {
  static const String baseUrl = 'https://api.trueprice.app'; // TODO: 백엔드와 확정

  static const String detectObject = '/scan/detect-object';
  static const String extractPrice = '/scan/extract-price';
  static const String priceStats = '/prices/stats';
  static const String submitPrice = '/prices/submit';
  static const String marketsNearby = '/markets/nearby';
  static const String phrases = '/phrases';
  static const String communityFeed = '/community/feed';
}
