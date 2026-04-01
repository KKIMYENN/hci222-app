import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/price_classifier.dart';
import '../../../../core/widgets/price_badge.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  static final _mockFeed = [
    _MockFeed('사과 1kg', 45.0, 38.2, '그랜드 바자르 3구역', '2분 전'),
    _MockFeed('토마토 1kg', 28.0, 22.5, '이집션 바자르', '15분 전'),
    _MockFeed('오이 1kg', 15.0, 18.0, '아르나부트쾨이 시장', '32분 전'),
    _MockFeed('석류 1개', 60.0, 35.0, '그랜드 바자르 12구역', '1시간 전'),
    _MockFeed('레몬 5개', 20.0, 22.0, '이집션 바자르', '2시간 전'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('커뮤니티'),
        actions: [
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _mockFeed.length,
        itemBuilder: (_, i) => _FeedCard(feed: _mockFeed[i]),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('가격 공유', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

class _FeedCard extends StatelessWidget {
  final _MockFeed feed;
  const _FeedCard({required this.feed});

  @override
  Widget build(BuildContext context) {
    final status = PriceClassifier.classify(
      observed: feed.price,
      avg: feed.avgPrice,
      stdDev: feed.avgPrice * 0.25,
    );
    final pct = PriceClassifier.percentDiff(feed.price, feed.avgPrice);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        feed.productName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        feed.marketName,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.onSurfaceLight,
                        ),
                      ),
                    ],
                  ),
                ),
                PriceBadge(
                  status: status,
                  label: pct >= 0
                      ? '+${pct.toStringAsFixed(0)}%'
                      : '${pct.toStringAsFixed(0)}%',
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  '${feed.price.toStringAsFixed(0)} TL',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '(평균 ${feed.avgPrice.toStringAsFixed(0)} TL)',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.onSurfaceLight,
                  ),
                ),
                const Spacer(),
                Text(
                  feed.timeAgo,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.onSurfaceLight,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MockFeed {
  final String productName;
  final double price;
  final double avgPrice;
  final String marketName;
  final String timeAgo;
  _MockFeed(this.productName, this.price, this.avgPrice, this.marketName, this.timeAgo);
}
