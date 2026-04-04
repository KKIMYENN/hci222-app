import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/constants/app_colors.dart';

class MarketMapScreen extends StatefulWidget {
  const MarketMapScreen({super.key});

  @override
  State<MarketMapScreen> createState() => _MarketMapScreenState();
}

class _MarketMapScreenState extends State<MarketMapScreen> {
  // Mock 시장 데이터 (카이로, 이집트)
  // TODO: 백엔드 연동 시 GET /markets/nearby?lat=&lon= 로 교체
  final _mockMarkets = [
    _MockMarket('칸 엘-칼릴리 (Khan el-Khalili)', 30.0478, 31.2625, '카이로 최대 전통시장·souq'),
    _MockMarket('알아타바 시장 (Ataba Market)', 30.0565, 31.2457, '과일·채소·향신료 전문'),
    _MockMarket('임바바 시장 (Imbaba Market)', 30.0720, 31.2130, '신선 과일·채소 특화'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('주변 시장'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: const LatLng(30.0478, 31.2625), // 카이로 칸 엘-칼릴리
              initialZoom: 13,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.trueprice.app',
              ),
              MarkerLayer(
                markers: _mockMarkets
                    .map(
                      (m) => Marker(
                        point: LatLng(m.lat, m.lon),
                        width: 40,
                        height: 40,
                        child: GestureDetector(
                          onTap: () => _showMarketSheet(context, m),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.storefront,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showMarketSheet(BuildContext context, _MockMarket market) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.storefront, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        market.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        market.desc,
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
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.directions),
              label: const Text('길찾기'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MockMarket {
  final String name;
  final double lat;
  final double lon;
  final String desc;
  _MockMarket(this.name, this.lat, this.lon, this.desc);
}
