enum MeasurementUnit {
  metric,
  imperial,
}

extension MeasurementUnitExtension on MeasurementUnit {
  String get displayNameKey {
    switch (this) {
      case MeasurementUnit.metric:
        return 'measurement_unit_metric';
      case MeasurementUnit.imperial:
        return 'measurement_unit_imperial';
    }
  }
}