import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static final TtsService _instance = TtsService._();
  factory TtsService() => _instance;
  TtsService._();

  final FlutterTts _tts = FlutterTts();
  bool _initialized = false;

  Future<void> _init() async {
    if (_initialized) return;
    // flutter_tts는 웹 미지원 — 초기화 건너뜀
    if (kIsWeb) {
      _initialized = true;
      return;
    }
    try {
      await _tts.setLanguage('ar-SA');
      await _tts.setSpeechRate(0.7);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
      _initialized = true;
    } catch (e) {
      debugPrint('[TtsService] 초기화 실패: $e');
      _initialized = true; // 실패해도 재시도 막기
    }
  }

  /// 아랍어 텍스트 발음. 웹/언어팩 미설치 시 false 반환.
  Future<bool> speakArabic(String text) async {
    if (kIsWeb) {
      debugPrint('[TtsService] 웹 환경: TTS 미지원');
      return false;
    }
    await _init();
    try {
      await _tts.stop();
      await _tts.setLanguage('ar-SA');
      await _tts.speak(text);
      return true;
    } catch (e) {
      debugPrint('[TtsService] 발음 실패: $e');
      return false;
    }
  }

  Future<void> stop() async {
    if (kIsWeb) return;
    try {
      await _tts.stop();
    } catch (e) {
      debugPrint('[TtsService] stop 실패: $e');
    }
  }
}
