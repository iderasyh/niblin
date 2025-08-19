import 'package:flutter/foundation.dart';

import '../../recipes/domain/measurement_unit.dart';

class UserSettings {
  final String appLangauge;
  final MeasurementUnit measurementUnit;
  final Map<String, bool>? notifications;

  const UserSettings({
    required this.appLangauge,
    required this.measurementUnit,
    this.notifications,
  });

  const factory UserSettings.initial() = UserSettings._initial;

  const UserSettings._initial()
    : this(appLangauge: 'en', measurementUnit: MeasurementUnit.metric);

  UserSettings copyWith({
    String? appLangauge,
    MeasurementUnit? measurementUnit,
    Map<String, bool>? notifications,
  }) {
    return UserSettings(
      appLangauge: appLangauge ?? this.appLangauge,
      measurementUnit: measurementUnit ?? this.measurementUnit,
      notifications: notifications ?? this.notifications,
    );
  }

  factory UserSettings.fromMap(Map<String, dynamic> json) {
    return UserSettings(
      appLangauge: json['appLangauge'],
      measurementUnit: MeasurementUnit.values.firstWhere(
        (element) => element.name == json['measurementUnit'],
      ),
      notifications: json['notifications'] == null
          ? null
          : Map<String, bool>.from(json['notifications']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'appLangauge': appLangauge,
      'measurementUnit': measurementUnit.name,
      'notifications': notifications,
    };
  }

  @override
  String toString() =>
      '''UserSettings(appLangauge: $appLangauge, measurementUnit: $measurementUnit, notifications: $notifications)''';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserSettings &&
        other.appLangauge == appLangauge &&
        other.measurementUnit == measurementUnit &&
        mapEquals(other.notifications, notifications);
  }

  @override
  int get hashCode =>
      appLangauge.hashCode ^ measurementUnit.hashCode ^ notifications.hashCode;
}
