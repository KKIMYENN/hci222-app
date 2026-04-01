import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/user_id_service.dart';
import '../bloc/price_bloc.dart';
import '../bloc/price_event.dart';
import '../bloc/price_state.dart';

class FinalPriceScreen extends StatelessWidget {
  final String productName;
  final String productId;
  final double finalPrice;

  const FinalPriceScreen({
    super.key,
    required this.productName,
    required this.finalPrice,
    this.productId = 'p001',
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PriceBloc(),
      child: _FinalPriceView(
        productName: productName,
        productId: productId,
        finalPrice: finalPrice,
      ),
    );
  }
}

class _FinalPriceView extends StatefulWidget {
  final String productName;
  final String productId;
  final double finalPrice;

  const _FinalPriceView({
    required this.productName,
    required this.productId,
    required this.finalPrice,
  });

  @override
  State<_FinalPriceView> createState() => _FinalPriceViewState();
}

class _FinalPriceViewState extends State<_FinalPriceView>
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
    _scaleAnim =
        CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _submitted = true);
    final userId = await UserIdService.getOrCreate();
    if (!mounted) return;
    context.read<PriceBloc>().add(PriceSubmitted(
      productId: widget.productId,
      price: widget.finalPrice,
      unit: 'kg',
      userId: userId,
    ));
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
    return BlocListener<PriceBloc, PriceState>(
      listener: (context, state) {
        if (state is PriceError) {
          setState(() => _submitted = false); // 실패 시 재시도 허용
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.warning,
            ),
          );
        }
      },
      child: Scaffold(
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

              ScaleTransition(
                scale: _scaleAnim,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    color: AppColors.safe,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check,
                      color: Colors.white, size: 60),
                ),
              ),

              const SizedBox(height: 32),
              Text(
                widget.productName,
                style: const TextStyle(
                    fontSize: 18, color: AppColors.onSurfaceLight),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '${widget.finalPrice.toStringAsFixed(0)} TL',
                style: const TextStyle(
                    fontSize: 42, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('에 구매 완료!', style: TextStyle(fontSize: 20)),

              const SizedBox(height: 40),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.2)),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.people, color: AppColors.primary, size: 32),
                    SizedBox(height: 12),
                    Text(
                      '다른 여행자에게 도움을 주세요',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
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
      ),
    );
  }
}
