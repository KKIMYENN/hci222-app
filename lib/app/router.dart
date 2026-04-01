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

// extra Map에서 타입 안전하게 값을 꺼내는 헬퍼
extension _ExtraX on Map<String, dynamic> {
  String str(String key, [String fallback = '']) =>
      this[key] as String? ?? fallback;
  double dbl(String key, [double fallback = 0.0]) =>
      (this[key] as num?)?.toDouble() ?? fallback;
  double? dblOrNull(String key) => (this[key] as num?)?.toDouble();
}

Map<String, dynamic> _extra(GoRouterState s) =>
    s.extra as Map<String, dynamic>? ?? {};

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
              builder: (_, s) {
                final e = _extra(s);
                return PriceStatsScreen(
                  productName: e.str('productName'),
                  productId: e.str('productId', 'p001'),
                  detectedPrice: e.dblOrNull('detectedPrice'),
                );
              },
            ),
            GoRoute(
              path: 'input',
              builder: (_, s) {
                final e = _extra(s);
                return PriceInputScreen(
                  productName: e.str('productName'),
                  productId: e.str('productId', 'p001'),
                );
              },
            ),
            GoRoute(
              path: 'analysis',
              builder: (_, s) {
                final e = _extra(s);
                return PriceAnalysisScreen(
                  productName: e.str('productName'),
                  productId: e.str('productId', 'p001'),
                  inputPrice: e.dbl('inputPrice'),
                );
              },
            ),
            GoRoute(
              path: 'final',
              builder: (_, s) {
                final e = _extra(s);
                return FinalPriceScreen(
                  productName: e.str('productName'),
                  productId: e.str('productId', 'p001'),
                  finalPrice: e.dbl('finalPrice'),
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
      bottomNavigationBar:
          AppBottomNavBar(currentIndex: _currentIndex(context)),
    );
  }
}
