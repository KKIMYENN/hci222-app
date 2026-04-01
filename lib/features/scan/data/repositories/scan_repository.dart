import 'dart:io';
import '../models/detection_result.dart';

abstract class ScanRepository {
  Future<DetectionResult> detectObject({
    required File image,
    required double lat,
    required double lon,
  });
}

class ScanRepositoryImpl implements ScanRepository {
  @override
  Future<DetectionResult> detectObject({
    required File image,
    required double lat,
    required double lon,
  }) async {
    // TODO: 백엔드 연동 시 아래 주석 해제
    // final formData = FormData.fromMap({
    //   'image': await MultipartFile.fromFile(image.path),
    //   'lat': lat,
    //   'lon': lon,
    // });
    // final res = await DioClient.instance.post(ApiEndpoints.detectObject, data: formData);
    // return DetectionResult.fromJson(res.data);

    // Mock: 2초 딜레이 후 결과 반환
    await Future.delayed(const Duration(seconds: 2));
    return DetectionResult.mock();
  }
}
