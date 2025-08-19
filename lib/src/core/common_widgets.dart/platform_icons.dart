import 'dart:io';
import 'package:flutter/material.dart';

class PlatformIcons {
  static IconData get forward {
    if (Platform.isIOS) {
      return Icons.arrow_forward_ios;
    }
    return Icons.arrow_forward;
  }
}
