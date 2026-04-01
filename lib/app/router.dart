import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/widgets/bottom_nav_bar.dart';
import '../features/onboarding/presentation/screens/splash_screen.dart';
import '../features/onboarding/presentation/screens/permission_screen.dart';
import '../features/onboarding/presentation/screens/intro_screen.dart';
import '../features/scan/presentation/screens/scan_screen.dart';
import '../features/scan/presentation/screens/price_stats_screen.dart';
import '../features/scan/presentation/screens/price_input_screen.dart';
import '../features/scan/presentation/screens/price_analysis_screen.dart';
import '../features/scan/presentation/screens/final_price_screen.dart';
import '../features/market_map/presentation/screens/market_map_screen.dart';
import '../features/language/presentation/screens/phrase_screen.dart';
import '../features/community/presentation/screens/community_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
    GoRoute(path: '/permission', builder: (_, __) => const PermissionScreen()),
    GoRoute(path: '/intro', builder: (_, __) => const IntroScreen()),

    ShellRoute(
      builder: (context, state, child) => _MainShell(child: child),
      routes: [
        GoRoute(
          path: '/scan',
          builder: (_, __) => const ScanScreen(),
          routes: [
            GoRoute(
              path: 'stats',
              builder: (_, state) {
                final extra = state.extra as Map<String, dynamic>? ?? {};
                return PriceStatsScreen(
                  productName: extra['productName'] as String? ?? '',
                  detectedPrice: extra['detectedPrice'] as double? ?? 0,
                );
              },
            ),
            GoRoute(
              path: 'input',
              builder: (_, state) {
                final extra = state.extra as Map<String, dynamic>? ?? {};
                return PriceInputScreen(
                  productName: extra['productName'] as String? ?? '',
                );
              },
            ),
            GoRoute(
              path: 'analysis',
              builder: (_, state) {
                final extra = state.extra as Map<String, dynamic>? ?? {};
                return PriceAnalysisScreen(
                  productName: extra['productName'] as String? ?? '',
                  inputPrice: extra['inputPrice'] as double? ?? 0,
                );
              },
            ),
            GoRoute(
              path: 'final',
              builder: (_, state) {
                final extra = state.extra as Map<String, dynamic>? ?? {};
                return FinalPriceScreen(
                  productName: extra['productName'] as String? ?? '',
                  finalPrice: extra['finalPrice'] as double? ?? 0,
                );
              },
            ),
          ],
        ),
        GoRoute(path: '/map', builder: (_, __) => const MarketMapScreen()),
        GoRoute(path: '/language', builder: (_, __) => const PhraseScreen()),
        GoRoute(path: '/community', builder: (_, __) => const CommunityScreen()),
      ],
    ),
  ],
);

class _MainShell extends StatelessWidget {
  final Widget child;
  const _MainShell({required this.child});

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/map')) return 1;
    if (location.startsWith('/language')) return 2;
    if (location.startsWith('/community')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: AppBottomNavBar(currentIndex: _currentIndex(context)),
    );
  }
}
