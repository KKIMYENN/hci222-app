import '../models/region_stats.dart';

abstract class PriceRepository {
  Future<RegionStats> getStats({
    required String productId,
    required double lat,
    required double lon,
  });

  Future<void> submitPrice({
    required String productId,
    required double price,
    required String unit,
    required double lat,
    required double lon,
    required String userId,
  });
}

class PriceRepositoryImpl implements PriceRepository {
  // 단순 인메모리 캐시: 같은 productId는 앱 세션 내 1회만 API 호출
  static final Map<String, RegionStats> _cache = {};

  @override
  Future<RegionStats> getStats({
    required String productId,
    required double lat,
    required double lon,
  }) async {
    if (_cache.containsKey(productId)) {
      return _cache[productId]!;
    }

    // TODO: 백엔드 연동 시 아래 주석 해제
    // final res = await DioClient.instance.get(
    //   ApiEndpoints.priceStats,
    //   queryParameters: {'product_id': productId, 'lat': lat, 'lon': lon},
    // );
    // final stats = RegionStats.fromJson(res.data);
    // _cache[productId] = stats;
    // return stats;

    await Future.delayed(const Duration(milliseconds: 500));
    final stats = RegionStats.mock(productId);
    _cache[productId] = stats;
    return stats;
  }

  @override
  Future<void> submitPrice({
    required String productId,
    required double price,
    required String unit,
    required double lat,
    required double lon,
    required String userId,
  }) async {
    // TODO: 백엔드 연동 시 아래 주석 해제
    // await DioClient.instance.post(ApiEndpoints.submitPrice, data: {
    //   'product_id': productId,
    //   'price': price,
    //   'unit': unit,
    //   'lat': lat,
    //   'lon': lon,
    //   'user_id': userId,
    // });

    // 가격 제출 후 해당 상품 캐시 무효화 (다음 조회 시 최신 데이터 반영)
    _cache.remove(productId);
    await Future.delayed(const Duration(milliseconds: 300));
  }

  /// 테스트용 캐시 초기화
  static void clearCache() => _cache.clear();
}
