import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:injectable/injectable.dart';

@lazySingleton
class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  FirebaseAnalyticsObserver getAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  Future<void> setUserProperties({
    required String userId,
    String? userRole,
  }) async {
    await _analytics.setUserId(id: userId);
    await _analytics.setUserProperty(name: userId, value: userRole);
  }

  // Future<void> logPostCreated({bool hasImage}) async {
  //   await _analytics.logEvent(
  //     name: 'Announcemt_Created',
  //     parameters: {'has_image': hasImage},
  //   );
  // }

  Future<void> logLogIn(
    String newAtsign,
  ) async {
    await _analytics.logLogin(
      loginMethod: newAtsign,
    );
  }

  Future<void> logError({
    required String name,
  }) async {
    await _analytics.logEvent(
      name: name,
      parameters: {
        'content_type': 'saving_data_error',
        'item_id': 'dess_error',
      },
    );
  }

  Future<void> logScreen({required String screenName}) async {
    await _analytics.setCurrentScreen(screenName: screenName);
  }

  Future<void> logScreenView({
    required String screenName,
    String screenClassOverride = 'Flutter',
  }) async {
    await _analytics.setCurrentScreen(
      screenName: screenName,
      screenClassOverride: screenClassOverride,
    );
  }

  Future<void> logEvent({
    required String name,
    String? itemId,
    String? contentType,
  }) async {
    await _analytics.logEvent(
      name: name,
      parameters: {
        'content_type': contentType,
        'item_id': itemId,
      },
    );
  }

  Future<void> logswipe({required SwipType type}) async {
    await _analytics.logEvent(name: 'swipes', parameters: {'swiptype': type});
  }
}

enum SwipType { top, down }
