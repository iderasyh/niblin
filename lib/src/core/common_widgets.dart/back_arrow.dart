import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/responsive_utils.dart';

class BackArrow extends StatelessWidget {
  /// Optional callback to override the default back behavior
  final VoidCallback? onPressed;

  /// Optional color for the icon
  final Color? color;

  /// Optional size for the icon
  final double? size;
  const BackArrow({super.key, this.onPressed, this.color, this.size});

  @override
  Widget build(BuildContext context) {
    // Use Platform.isIOS to determine the appropriate icon
    final bool isIOS = Platform.isIOS;
    final iconSize = size ?? ResponsiveUtils.iconSize20;

    if (isIOS) {
      return IconButton(
        icon: Icon(CupertinoIcons.back, color: color, size: iconSize),
        onPressed:
            onPressed ??
            () {
              HapticFeedback.mediumImpact();
              Navigator.of(context).maybePop();
            },
      );
    } else {
      return IconButton(
        icon: Icon(Icons.arrow_back, color: color, size: iconSize),
        onPressed:
            onPressed ??
            () {
              HapticFeedback.mediumImpact();
              Navigator.of(context).maybePop();
            },
      );
    }
  }
}
