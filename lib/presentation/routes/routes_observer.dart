import 'package:decibel/infrastructure/core/analytics.dart';
import 'package:flutter/material.dart';

class GoRouterObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print('ROUTE didPush: $route');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print('ROUTE didPop: $route');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print('ROUTE didRemove: $route');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    print('ROUTE didReplace: $newRoute');
  }
}

class AlignFirebaseAnalyticsObserver extends RouteObserver<PageRoute<dynamic>> {
  final AnalyticsService analyticsService = AnalyticsService();

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute) {
      analyticsService.logScreenView(
        screenName: route.settings.name!,
        screenClassOverride: route.runtimeType.toString(),
      );
    }
  }
}
