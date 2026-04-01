import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';

class FinalPriceScreen extends StatefulWidget {
  final String productName;
  final double finalPrice;

  const FinalPriceScreen({
    super.key,
    required this.productName,
    required this.finalPrice,
  });

  @override
  State<FinalPriceScreen> createState() => _FinalPriceScreenState();
}

class _FinalPriceScreenState extends State<FinalPriceScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnim = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    // TODO: POST /prices/submit
    setState(() => _submitted = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('가격 정보를 공유해 주셔서 감사해요! 🙏'),
        backgroundColor: AppColors.primary,
      ),
    );
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) context.go('/scan');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('구매 완료'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/scan'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),

            // 완료 애니메이션
            ScaleTransition(
              scale: _scaleAnim,
              child: Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  color: AppColors.safe,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 60),
              ),
            ),

            const SizedBox(height: 32),
            Text(
              widget.productName,
              style: const TextStyle(
                fontSize: 18,
                color: AppColors.onSurfaceLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.finalPrice.toStringAsFixed(0)} TL',
              style: const TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '에 구매 완료!',
              style: TextStyle(fontSize: 20),
            ),

            const SizedBox(height: 40),

            // 데이터 공유 요청
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.2),
                ),
              ),
              child: Column(
                children: [
                  const Icon(Icons.people, color: AppColors.primary, size: 32),
                  const SizedBox(height: 12),
                  const Text(
                    '다른 여행자에게 도움을 주세요',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '구매한 가격을 공유하면\n다른 여행자들의 물가 데이터가 더 정확해져요',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.onSurfaceLight,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const Spacer(),

            ElevatedButton(
              onPressed: _submitted ? null : _submit,
              child: Text(_submitted ? '공유 완료!' : '가격 공유하기'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context.go('/scan'),
              child: const Text(
                '공유하지 않고 돌아가기',
                style: TextStyle(color: AppColors.onSurfaceLight),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
