import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_colors.dart';
import '../bloc/scan_bloc.dart';
import '../bloc/scan_event.dart';
import '../bloc/scan_state.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ScanBloc(),
      child: const _ScanView(),
    );
  }
}

class _ScanView extends StatefulWidget {
  const _ScanView();

  @override
  State<_ScanView> createState() => _ScanViewState();
}

class _ScanViewState extends State<_ScanView> {
  final _picker = ImagePicker();

  Future<void> _pickAndScan(ImageSource source) async {
    // 웹에서는 카메라 미지원 → 갤러리 fallback
    final effectiveSource =
        (kIsWeb && source == ImageSource.camera) ? ImageSource.gallery : source;

    if (kIsWeb && source == ImageSource.camera) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('웹에서는 갤러리에서 이미지를 선택해주세요'),
          duration: Duration(seconds: 2),
        ),
      );
    }

    final picked = await _picker.pickImage(source: effectiveSource);
    if (picked == null || !mounted) return;

    // 웹: XFile.path는 blob URL → File() 사용 불가, bytes로 처리
    if (kIsWeb) {
      // Web에서는 ScanBloc에 File 전달 대신 Mock 결과로 직행
      context.read<ScanBloc>().add(const ScanWebMockRequested());
    } else {
      context.read<ScanBloc>().add(ScanImageCaptured(File(picked.path)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ScanBloc, ScanState>(
      listener: (context, state) {
        if (state is ScanDetected) {
          context.read<ScanBloc>().add(const ScanReset());
          context.go('/scan/stats', extra: {
            'productName': state.result.productName,
            'productId': state.result.productId,
            'detectedPrice': state.result.detectedPrice,
          });
        } else if (state is ScanError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.warning,
              action: SnackBarAction(
                label: '다시 시도',
                textColor: Colors.white,
                onPressed: () => context.read<ScanBloc>().add(const ScanReset()),
              ),
            ),
          );
        }
      },
      child: BlocBuilder<ScanBloc, ScanState>(
        builder: (context, state) {
          final isProcessing = state is ScanProcessing;

          return Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              fit: StackFit.expand,
              children: [
                // 카메라 뷰파인더 (데모 모드 — 실제 카메라 미연동)
                // TODO: camera 패키지의 CameraPreview 위젯으로 교체 예정
                Container(
                  color: Colors.black87,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt,
                          size: 80,
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '상품을 화면 중앙에 맞춰주세요',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            '데모 모드 — 갤러리 이미지 선택 후 샘플 결과 반환',
                            style:
                                TextStyle(color: Colors.white, fontSize: 11),
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
                if (isProcessing)
                  Container(
                    color: AppColors.overlay,
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: AppColors.scanLine),
                          SizedBox(height: 16),
                          Text(
                            '[데모] 샘플 가격 데이터를 불러오는 중...',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),

                // 하단 버튼
                if (!isProcessing)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                        child: Column(
                          children: [
                            TextButton(
                              onPressed: () => context.go('/scan/input',
                                  extra: {'productName': '', 'productId': 'p001'}),
                              child: const Text(
                                '가격만 직접 입력하기',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _ScanButton(
                                  icon: Icons.photo_library,
                                  label: '갤러리',
                                  onTap: () => _pickAndScan(ImageSource.gallery),
                                  small: true,
                                ),
                                _ScanButton(
                                  icon: Icons.camera_alt,
                                  label: '스캔',
                                  onTap: () => _pickAndScan(ImageSource.camera),
                                  small: false,
                                ),
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
        },
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
              color: small ? Colors.white.withValues(alpha: 0.15) : AppColors.scanLine,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white30, width: 1),
            ),
            child: Icon(icon, color: Colors.white, size: small ? 24 : 32),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}
