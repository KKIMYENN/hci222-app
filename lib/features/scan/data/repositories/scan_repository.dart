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
    // ──────────────────────────────────────────────────────────────
    // [YOLO 백엔드 연동 가이드] — 다른 개발자가 작업 예정
    //
    // 백엔드(Python/FastAPI)에서 YOLOv8 모델을 실행하고,
    // 감지된 객체 클래스(class_name)와 OCR로 추출된 가격을 반환한다.
    //
    // 1. pubspec.yaml에 dio 패키지 의존성 활성화:
    //    lib/core/network/dio_client.dart  →  DioClient.instance 참조
    //    lib/core/constants/api_endpoints.dart  →  ApiEndpoints.detectObject 참조
    //
    // 2. 백엔드 엔드포인트: POST /scan/detect-object
    //    Request (multipart/form-data):
    //      - image: File (JPEG/PNG)
    //      - lat: double  (현재 위도)
    //      - lon: double  (현재 경도)
    //    Response (JSON):
    //      {
    //        "product_id": "p001",
    //        "name_kr": "포도 (Grapes)",
    //        "name_ar": "عنب",
    //        "confidence": 0.92,
    //        "detected_price": 65.0   // OCR로 가격표 인식된 경우 (없으면 null)
    //      }
    //
    // 3. 연동 코드 (dio, MultipartFile import 추가 필요):
    //    final formData = FormData.fromMap({
    //      'image': await MultipartFile.fromFile(image.path),
    //      'lat': lat,
    //      'lon': lon,
    //    });
    //    final res = await DioClient.instance.post(ApiEndpoints.detectObject, data: formData);
    //    return DetectionResult.fromJson(res.data as Map<String, dynamic>);
    //
    // 4. ar_flutter_plugin (제안서 명시) 사용 시:
    //    AR 오버레이로 바운딩 박스 위에 가격을 실시간 표시 가능.
    //    해당 기능은 별도 AR 화면에서 구현 권장.
    // ──────────────────────────────────────────────────────────────

    // [DEMO] Mock: 2초 딜레이 후 포도 결과 반환
    await Future.delayed(const Duration(seconds: 2));
    return DetectionResult.mock();
  }
}
