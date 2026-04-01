import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/constants/app_colors.dart';

class PriceStatsScreen extends StatelessWidget {
  final String productName;
  final double detectedPrice;

  const PriceStatsScreen({
    super.key,
    required this.productName,
    required this.detectedPrice,
  });

  // Mock 통계 데이터
  static const _avg = 38.2;
  static const _min = 20.0;
  static const _max = 65.0;
  static const _mode = 35.0;
  static const _stdDev = 9.5;

  // Mock 히스토그램 버킷
  static const _buckets = [
    (20.0, 25.0, 3),
    (25.0, 30.0, 8),
    (30.0, 35.0, 15),
    (35.0, 40.0, 22),
    (40.0, 45.0, 18),
    (45.0, 50.0, 10),
    (50.0, 55.0, 5),
    (55.0, 65.0, 2),
  ];

  @override
  Widget build(BuildContext context) {
    final displayName = productName.isNotEmpty ? productName : '인식된 상품';

    return Scaffold(
      appBar: AppBar(
        title: Text(displayName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/scan'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 통계 요약 카드
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: [
                  _StatsRow('평균가', _avg, isPrimary: true),
                  const Divider(height: 20),
                  Row(
                    children: [
                      Expanded(child: _StatsRow('최저가', _min)),
                      Expanded(child: _StatsRow('최고가', _max)),
                      Expanded(child: _StatsRow('최빈값', _mode)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 히스토그램
            const Text(
              '가격 분포',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              '이 지역에서 수집된 ${_buckets.fold(0, (s, b) => s + b.$3)}개 데이터',
              style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceLight),
            ),
            const SizedBox(height: 12),
            _Histogram(
              buckets: _buckets,
              avg: _avg,
            ),

            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/scan/input', extra: {
                'productName': displayName,
              }),
              child: const Text('상인이 제시한 가격 입력하기'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final String label;
  final double value;
  final bool isPrimary;

  const _StatsRow(this.label, this.value, {this.isPrimary = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceLight),
        ),
        const SizedBox(height: 4),
        Text(
          '${value.toStringAsFixed(0)} TL',
          style: TextStyle(
            fontSize: isPrimary ? 24 : 16,
            fontWeight: isPrimary ? FontWeight.bold : FontWeight.w600,
            color: isPrimary ? AppColors.primary : AppColors.onSurface,
          ),
        ),
      ],
    );
  }
}

class _Histogram extends StatelessWidget {
  final List<(double, double, int)> buckets;
  final double avg;

  const _Histogram({required this.buckets, required this.avg});

  @override
  Widget build(BuildContext context) {
    final maxCount = buckets.map((b) => b.$3).reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 160,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxCount.toDouble() * 1.2,
          barGroups: buckets.asMap().entries.map((e) {
            final i = e.key;
            final b = e.value;
            final isAvgBucket = avg >= b.$1 && avg < b.$2;
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: b.$3.toDouble(),
                  color: isAvgBucket ? AppColors.primary : AppColors.primary.withOpacity(0.4),
                  width: 22,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                ),
              ],
            );
          }).toList(),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (v, _) {
                  final i = v.toInt();
                  if (i < 0 || i >= buckets.length) return const SizedBox();
                  return Text(
                    buckets[i].$1.toInt().toString(),
                    style: const TextStyle(fontSize: 9, color: AppColors.onSurfaceLight),
                  );
                },
              ),
            ),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}
