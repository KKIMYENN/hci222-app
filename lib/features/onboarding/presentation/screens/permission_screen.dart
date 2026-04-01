import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';

class PermissionScreen extends StatelessWidget {
  const PermissionScreen({super.key});

  static const _permissions = [
    (Icons.camera_alt, '카메라', '상품 스캔 및 가격표 인식에 필요해요'),
    (Icons.location_on, '위치', '주변 시장 검색 및 지역 물가 비교에 필요해요'),
    (Icons.mic, '마이크', '아랍어 발음 가이드 재생에 필요해요'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                '앱 사용 권한',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '원활한 서비스 이용을 위해\n아래 권한이 필요해요',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.onSurfaceLight,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),
              ...(_permissions.map(
                (p) => _PermissionItem(
                  icon: p.$1,
                  title: p.$2,
                  desc: p.$3,
                ),
              )),
              const Spacer(),
              ElevatedButton(
                onPressed: () => context.go('/intro'),
                child: Text(kIsWeb ? '시작하기' : '권한 허용하고 시작하기'),
              ),
              if (!kIsWeb) ...[
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => context.go('/intro'),
                  child: const Text(
                    '나중에 설정하기',
                    style: TextStyle(color: AppColors.onSurfaceLight),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _PermissionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;

  const _PermissionItem({
    required this.icon,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.onSurfaceLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
