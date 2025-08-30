import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension NavigatorExtension on BuildContext {
  // Аналог pushNamed
  Future<T?> openPage<T>(String route, {Object? arguments}) {
    HapticFeedback.mediumImpact();
    return Navigator.pushNamed<T>(this, route, arguments: arguments);
  }

  // Дополнительно: методы для замены, закрытия и т.д.
  Future<T?> replacePage<T>(String route, {Object? arguments}) {
    return Navigator.pushReplacementNamed(this, route, arguments: arguments);
  }

  void closePage<T>([T? result]) {
    Navigator.pop(this, result);
  }

  Future<T?> animatedRoute<T>(String route, {Object? arguments}) {
    HapticFeedback.mediumImpact();
    return Navigator.of(this).pushAndRemoveUntil<T>(
      PageRouteBuilder(
        settings: RouteSettings(name: route, arguments: arguments),
        pageBuilder: (context, animation, secondaryAnimation) {
          final generatedRoute = Navigator.of(context).widget.onGenerateRoute!(
            RouteSettings(name: route, arguments: arguments),
          );
          if (generatedRoute is PageRoute) {
            return generatedRoute.buildPage(
              context,
              animation,
              secondaryAnimation,
            );
          } else {
            throw Exception('Route must be a PageRoute');
          }
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
      (route) => false,
    );
  }

  Future<T?> onlyAnimatedRoute<T>(String route, {Object? arguments}) {
    HapticFeedback.mediumImpact();
    return Navigator.of(this).push<T>(
      PageRouteBuilder(
        settings: RouteSettings(name: route, arguments: arguments),
        pageBuilder: (context, animation, secondaryAnimation) {
          final generatedRoute = Navigator.of(context).widget.onGenerateRoute!(
            RouteSettings(name: route, arguments: arguments),
          );
          if (generatedRoute is PageRoute) {
            return generatedRoute.buildPage(
              context,
              animation,
              secondaryAnimation,
            );
          } else {
            throw Exception('Route must be a PageRoute');
          }
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }
}
