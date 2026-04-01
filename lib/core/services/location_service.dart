import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

// 위치 기본값: 이스탄불 그랜드 바자르
const _kDefaultLat = 41.0108;
const _kDefaultLon = 28.9683;

class LatLon {
  final double lat;
  final double lon;
  const LatLon(this.lat, this.lon);

  static const defaultLocation = LatLon(_kDefaultLat, _kDefaultLon);
}

class LocationService {
  static final LocationService _instance = LocationService._();
  factory LocationService() => _instance;
  LocationService._();

  LatLon? _cached;

  /// 현재 위치 반환. 실패 시 이스탄불 기본값 반환.
  Future<LatLon> getCurrentLocation() async {
    if (_cached != null) return _cached!;

    // 웹: 브라우저 geolocation은 geolocator가 지원하지만,
    // HTTPS 환경 아닌 localhost에서는 비활성화될 수 있음
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('[LocationService] 위치 서비스 비활성화 → 기본값 사용');
        return LatLon.defaultLocation;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('[LocationService] 위치 권한 거부 → 기본값 사용');
          return LatLon.defaultLocation;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        debugPrint('[LocationService] 위치 권한 영구 거부 → 기본값 사용');
        return LatLon.defaultLocation;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low, // 배터리 절약
        timeLimit: const Duration(seconds: 5),
      );
      _cached = LatLon(pos.latitude, pos.longitude);
      return _cached!;
    } catch (e) {
      debugPrint('[LocationService] 위치 획득 실패: $e → 기본값 사용');
      return LatLon.defaultLocation;
    }
  }

  void clearCache() => _cached = null;
}
