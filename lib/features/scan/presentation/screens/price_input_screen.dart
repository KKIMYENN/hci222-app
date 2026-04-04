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
  bool _useSlider = false;
  // 슬라이더 범위: EGP 기준 (이집트 카이로 전통시장)
  static const double _sliderMin = 0;
  static const double _sliderMax = 200;
  double _sliderValue = 50;

  bool get _hasInput => _useSlider ? true : _controller.text.isNotEmpty;

  static const _units = ['kg', '개', '묶음', '1/2kg'];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _analyze() {
    final price = _useSlider
        ? _sliderValue
        : double.tryParse(_controller.text);
    if (price == null) return;
    context.go('/scan/analysis', extra: {
      'productName': widget.productName.isNotEmpty ? widget.productName : '상품',
      'productId': widget.productId,
      'inputPrice': price,
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayPrice = _useSlider
        ? _sliderValue.toStringAsFixed(0)
        : (_controller.text.isNotEmpty ? _controller.text : '0');

    return Scaffold(
      appBar: AppBar(
        title: const Text('가격 입력'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/scan'),
        ),
        actions: [
          // 입력 방식 토글 (키보드 ↔ 슬라이더)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton.icon(
              onPressed: () => setState(() => _useSlider = !_useSlider),
              icon: Icon(
                _useSlider ? Icons.keyboard : Icons.tune,
                size: 18,
                color: AppColors.primary,
              ),
              label: Text(
                _useSlider ? '직접 입력' : '슬라이더',
                style: const TextStyle(color: AppColors.primary, fontSize: 13),
              ),
            ),
          ),
        ],
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

            // 가격 표시 (두 모드 공통)
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
                    child: _useSlider
                        // 슬라이더 모드: 읽기 전용 텍스트
                        ? Text(
                            displayPrice,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        // 키보드 모드: 텍스트 필드
                        : TextField(
                            controller: _controller,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9.]')),
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
                    'EGP',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: AppColors.onSurfaceLight,
                    ),
                  ),
                ],
              ),
            ),

            // 슬라이더 (슬라이더 모드일 때만 표시)
            if (_useSlider) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    _sliderMin.toInt().toString(),
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.onSurfaceLight),
                  ),
                  Expanded(
                    child: Slider(
                      value: _sliderValue,
                      min: _sliderMin,
                      max: _sliderMax,
                      divisions: 200,
                      activeColor: AppColors.primary,
                      label: '${_sliderValue.toStringAsFixed(0)} EGP',
                      onChanged: (v) => setState(() => _sliderValue = v),
                    ),
                  ),
                  Text(
                    _sliderMax.toInt().toString(),
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.onSurfaceLight),
                  ),
                ],
              ),
            ],

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
