import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';

class PriceInputScreen extends StatefulWidget {
  final String productName;
  final String productId;

  const PriceInputScreen({
    super.key,
    required this.productName,
    this.productId = 'p001',
  });

  @override
  State<PriceInputScreen> createState() => _PriceInputScreenState();
}

class _PriceInputScreenState extends State<PriceInputScreen> {
  final _controller = TextEditingController();
  String _selectedUnit = 'kg';
  bool get _hasInput => _controller.text.isNotEmpty;

  static const _units = ['kg', '개', '묶음', '1/2kg'];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _analyze() {
    final price = double.tryParse(_controller.text);
    if (price == null) return;
    context.go('/scan/analysis', extra: {
      'productName': widget.productName.isNotEmpty ? widget.productName : '상품',
      'productId': widget.productId,
      'inputPrice': price,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('가격 입력'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/scan'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.productName.isNotEmpty
                  ? widget.productName
                  : '상품 가격 입력',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '상인이 제시한 가격을 입력해주세요',
              style: TextStyle(color: AppColors.onSurfaceLight),
            ),
            const SizedBox(height: 32),

            // 가격 입력
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _hasInput ? AppColors.primary : Colors.grey.shade300,
                  width: _hasInput ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      ],
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '0',
                        hintStyle: TextStyle(
                          color: AppColors.onSurfaceLight,
                          fontSize: 32,
                        ),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const Text(
                    'TL',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: AppColors.onSurfaceLight,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 단위 선택
            const Text('단위', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _units.map((u) {
                final selected = _selectedUnit == u;
                return ChoiceChip(
                  label: Text(u),
                  selected: selected,
                  onSelected: (_) => setState(() => _selectedUnit = u),
                  selectedColor: AppColors.primary.withOpacity(0.15),
                  checkmarkColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: selected ? AppColors.primary : AppColors.onSurface,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                  ),
                );
              }).toList(),
            ),

            const Spacer(),
            ElevatedButton(
              onPressed: _hasInput ? _analyze : null,
              child: const Text('가격 분석하기'),
            ),
          ],
        ),
      ),
    );
  }
}
