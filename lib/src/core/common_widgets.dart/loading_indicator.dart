import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../utils/responsive_utils.dart';

/// A loading indicator that shows a platform-specific loading indicator
/// Uses CupertinoActivityIndicator on iOS and CircularProgressIndicator on Android
class LoadingIndicator extends StatelessWidget {
  final Color? color;
  const LoadingIndicator({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Platform.isIOS
          ? CupertinoActivityIndicator(color: color ?? AppColors.primary)
          : CircularProgressIndicator(
              strokeWidth: ResponsiveUtils.spacing2,
              color: color ?? AppColors.primary,
            ),
    );
  }
}
