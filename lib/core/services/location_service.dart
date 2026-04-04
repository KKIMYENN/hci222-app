import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

// 위치 기본값: 이집트 카이로 칸 엘-칼릴리 시장 인근
const _kDefaultLat = 30.0444;
const _kDefaultLon = 31.2357;

class LatLon {
  final double lat;
  final double lon;
  /// true이면 실제 GPS가 아닌 기본값(카이로)을 사용 중 — UI에서 안내 배너 표시에 활용
  final bool isFallback;

  const LatLon(this.lat, this.lon, {this.isFallback = false});

  static const defaultLocation = LatLon(_kDefaultLat, _kDefaultLon, isFallback: true);
}

class LocationService {
  static final LocationService _instance = LocationService._();
  factory LocationService() => _instance;
  LocationService._();

  LatLon? _cached;

  /// 현재 위치 반환. 실패 시 카이로 기본값(isFallback=true) 반환.
  /// [isFallback]이 true이면 UI에서 "현재 위치를 가져올 수 없어 카이로 기본 데이터를 표시합니다" 안내 가능.
  Future<LatLon> getCurrentLocation() async {
    if (_cached != null) return _cached!;

    // 웹: 브라우저 geolocation은 geolocator가 지원하지만,
    // HTTPS 환경 아닌 localhost에서는 비활성화될 수 있음
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('[LocationService] 위치 서비스 비활성화 → 카이로 기본값 사용');
        return LatLon.defaultLocation; // isFallback = true
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('[LocationService] 위치 권한 거부 → 카이로 기본값 사용');
          return LatLon.defaultLocation; // isFallback = true
        }
      }
      if (permission == LocationPermission.deniedForever) {
        debugPrint('[LocationService] 위치 권한 영구 거부 → 카이로 기본값 사용');
        return LatLon.defaultLocation; // isFallback = true
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low, // 배터리 절약
        timeLimit: const Duration(seconds: 5),
      );
      _cached = LatLon(pos.latitude, pos.longitude); // isFallback = false (실제 GPS)
      return _cached!;
    } catch (e) {
      debugPrint('[LocationService] 위치 획득 실패: $e → 카이로 기본값 사용');
      return LatLon.defaultLocation; // isFallback = true
    }
  }

  void clearCache() => _cached = null;
}
