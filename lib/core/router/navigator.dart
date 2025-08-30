import 'package:flutter/material.dart';
import 'package:twin_finder/core/router/router.dart';

class NavigatorPage extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final Widget child;

  const NavigatorPage({
    super.key,
    required this.navigatorKey,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: AppRouter.onGenerateRoute,
      onGenerateInitialRoutes: (_, __) => [
        MaterialPageRoute(builder: (_) => child),
      ],
    );
  }
}
