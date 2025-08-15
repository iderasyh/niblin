import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analytics_service.g.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics;
  // final FacebookAppEventsService _facebookAppEventsService;

  AnalyticsService(this._analytics);

  /// A generic method to log events.
  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    await _analytics.logEvent(name: name, parameters: parameters);
    // await _facebookAppEventsService.logEvent(name, parameters: parameters);
  }
}

@Riverpod(keepAlive: true)
AnalyticsService analyticsService(Ref ref) {
  return AnalyticsService(
    FirebaseAnalytics.instance,
    // ref.read(facebookAppEventsServiceProvider),
  );
}
