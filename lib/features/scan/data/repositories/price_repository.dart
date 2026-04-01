import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
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
  @override
  Future<RegionStats> getStats({
    required String productId,
    required double lat,
    required double lon,
  }) async {
    // TODO: 백엔드 연동 시 아래 주석 해제
    // final res = await DioClient.instance.get(
    //   ApiEndpoints.priceStats,
    //   queryParameters: {'product_id': productId, 'lat': lat, 'lon': lon},
    // );
    // return RegionStats.fromJson(res.data);

    await Future.delayed(const Duration(milliseconds: 500));
    return RegionStats.mock(productId);
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

    await Future.delayed(const Duration(milliseconds: 300));
  }
}
