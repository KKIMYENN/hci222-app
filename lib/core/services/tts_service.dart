import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static final TtsService _instance = TtsService._();
  factory TtsService() => _instance;
  TtsService._();

  final FlutterTts _tts = FlutterTts();
  bool _initialized = false;

  Future<void> _init() async {
    if (_initialized) return;
    await _tts.setLanguage('ar-SA');
    await _tts.setSpeechRate(0.7); // 아랍어는 조금 느리게
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
    _initialized = true;
  }

  /// 아랍어 텍스트 발음
  Future<void> speakArabic(String text) async {
    await _init();
    await _tts.stop();
    // ar-SA 지원 여부 확인 후 fallback
    try {
      await _tts.setLanguage('ar-SA');
      await _tts.speak(text);
    } catch (_) {
      // 언어팩 미설치 시 기본 언어로 fallback (무음 처리)
    }
  }

  Future<void> stop() async {
    await _tts.stop();
  }

  Future<void> dispose() async {
    await _tts.stop();
  }
}
