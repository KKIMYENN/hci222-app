import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_colors.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final _picker = ImagePicker();
  bool _isProcessing = false;

  Future<void> _pickAndScan() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    _processImage(File(picked.path));
  }

  Future<void> _cameraAndScan() async {
    final picked = await _picker.pickImage(source: ImageSource.camera);
    if (picked == null) return;
    _processImage(File(picked.path));
  }

  void _processImage(File image) async {
    setState(() => _isProcessing = true);
    // TODO: ScanBloc → YOLO API 연동
    // 현재는 Mock으로 2초 후 결과 화면으로 이동
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isProcessing = false);
    context.go('/scan/stats', extra: {
      'productName': '사과 (Apple)',
      'detectedPrice': 45.0,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 카메라 뷰파인더 (Mock)
          Container(
            color: Colors.black87,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt,
                    size: 80,
                    color: Colors.white.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '상품을 화면 중앙에 맞춰주세요',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 스캔 오버레이 프레임
          Center(
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.scanLine, width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  _corner(Alignment.topLeft, true, true),
                  _corner(Alignment.topRight, true, false),
                  _corner(Alignment.bottomLeft, false, true),
                  _corner(Alignment.bottomRight, false, false),
                ],
              ),
            ),
          ),

          // 상단 AppBar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    const Text(
                      'Burası True Price',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.flash_off, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 처리 중 인디케이터
          if (_isProcessing)
            Container(
              color: AppColors.overlay,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: AppColors.scanLine),
                    SizedBox(height: 16),
                    Text(
                      'AI가 상품을 분석 중이에요...',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),

          // 하단 버튼
          if (!_isProcessing)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Column(
                    children: [
                      // 가격 직접 입력
                      TextButton(
                        onPressed: () => context.go('/scan/input',
                            extra: {'productName': ''}),
                        child: const Text(
                          '가격만 직접 입력하기',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // 갤러리 (시뮬레이터 fallback)
                          _ScanButton(
                            icon: Icons.photo_library,
                            label: '갤러리',
                            onTap: _pickAndScan,
                            small: true,
                          ),
                          // 메인 스캔 버튼
                          _ScanButton(
                            icon: Icons.camera_alt,
                            label: '스캔',
                            onTap: _cameraAndScan,
                            small: false,
                          ),
                          // 히스토리
                          _ScanButton(
                            icon: Icons.history,
                            label: '기록',
                            onTap: () {},
                            small: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _corner(Alignment align, bool top, bool left) {
    return Align(
      alignment: align,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          border: Border(
            top: top ? const BorderSide(color: AppColors.scanLine, width: 3) : BorderSide.none,
            bottom: !top ? const BorderSide(color: AppColors.scanLine, width: 3) : BorderSide.none,
            left: left ? const BorderSide(color: AppColors.scanLine, width: 3) : BorderSide.none,
            right: !left ? const BorderSide(color: AppColors.scanLine, width: 3) : BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class _ScanButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool small;

  const _ScanButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.small,
  });

  @override
  Widget build(BuildContext context) {
    final size = small ? 56.0 : 72.0;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: small
                  ? Colors.white.withOpacity(0.15)
                  : AppColors.scanLine,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white30, width: 1),
            ),
            child: Icon(icon, color: Colors.white, size: small ? 24 : 32),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
