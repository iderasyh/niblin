import 'package:flutter/material.dart';

class L10n {
  static final all = [
    const Locale('en'),
    const Locale('sq'),
  ];

  static String getFlag(String code) {
    switch (code) {
      case 'sq':
        return '🇦🇱';
      default:
        return '🇺🇸';
    }
  }

  static String getLanguageName(String code) {
    switch (code) {
      case 'sq':
        return 'Shqip';
      default:
        return 'English';
    }
  }
}

