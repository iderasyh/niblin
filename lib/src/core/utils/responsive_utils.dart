import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Responsive utilities for consistent sizing across the app
/// Uses flutter_screenutil for responsive scaling
class ResponsiveUtils {
  // Common responsive spacing values
  static double get spacing1 => 1.w;
  static double get spacing2 => 2.w;
  static double get spacing4 => 4.w;
  static double get spacing6 => 6.w;
  static double get spacing8 => 8.w;
  static double get spacing10 => 10.w;
  static double get spacing12 => 12.w;
  static double get spacing14 => 14.w;
  static double get spacing16 => 16.w;
  static double get spacing20 => 20.w;
  static double get spacing24 => 24.w;
  static double get spacing28 => 28.w;
  static double get spacing30 => 30.w;
  static double get spacing32 => 32.w;
  static double get spacing36 => 36.w;
  static double get spacing40 => 40.w;
  static double get spacing48 => 48.w;
  static double get spacing50 => 50.w;
  static double get spacing52 => 52.w;
  static double get spacing56 => 56.w;
  static double get spacing60 => 60.w;
  static double get spacing64 => 64.w;
  static double get spacing68 => 68.w;
  static double get spacing80 => 80.w;
  static double get spacing96 => 96.w;
  static double get spacing100 => 100.w;
  static double get spacing108 => 108.w;
  static double get spacing112 => 112.w;
  static double get spacing120 => 120.w;
  static double get spacing200 => 200.w;
  static double get spacing230 => 230.w;
  static double get spacing280 => 280.w;
  static double get spacing320 => 320.w;

  // Common responsive heights
  static double get height1 => 1.h;
  static double get height2 => 2.h;
  static double get height4 => 4.h;
  static double get height6 => 6.h;
  static double get height8 => 8.h;
  static double get height10 => 10.h;
  static double get height12 => 12.h;
  static double get height16 => 16.h;
  static double get height20 => 20.h;
  static double get height24 => 24.h;
  static double get height28 => 28.h;
  static double get height32 => 32.h;
  static double get height34 => 34.h;
  static double get height36 => 36.h;
  static double get height40 => 40.h;
  static double get height48 => 48.h;
  static double get height50 => 50.h;
  static double get height52 => 52.h;
  static double get height56 => 56.h;
  static double get height60 => 60.h;
  static double get height64 => 64.h;
  static double get height68 => 68.h;
  static double get height80 => 80.h;
  static double get height96 => 96.h;
  static double get height100 => 100.h;
  static double get height120 => 120.h;
  static double get height140 => 140.h;
  static double get height150 => 150.h;
  static double get height160 => 160.h;
  static double get height180 => 180.h;
  static double get height200 => 200.h;
  static double get height230 => 230.h;
  static double get height240 => 240.h;
  static double get height250 => 250.h;
  static double get height260 => 260.h;
  static double get height280 => 280.h;
  static double get height320 => 320.h;
  static double get height360 => 360.h;
  static double get height380 => 380.h;
  static double get height400 => 400.h;
  static double get height560 => 560.h;

  // Common responsive radius values
  static double get radius2 => 2.r;
  static double get radius3 => 3.r;
  static double get radius4 => 4.r;
  static double get radius6 => 6.r;
  static double get radius8 => 8.r;
  static double get radius10 => 10.r;
  static double get radius12 => 12.r;
  static double get radius14 => 14.r;
  static double get radius16 => 16.r;
  static double get radius20 => 20.r;
  static double get radius24 => 24.r;
  static double get radius32 => 32.r;

  // Common responsive font sizes
  static double get fontSize8 => 8.sp;
  static double get fontSize10 => 10.sp;
  static double get fontSize12 => 12.sp;
  static double get fontSize14 => 14.sp;
  static double get fontSize16 => 16.sp;
  static double get fontSize18 => 18.sp;
  static double get fontSize20 => 20.sp;
  static double get fontSize22 => 22.sp;
  static double get fontSize24 => 24.sp;
  static double get fontSize28 => 28.sp;
  static double get fontSize32 => 32.sp;
  static double get fontSize36 => 36.sp;
  static double get fontSize40 => 40.sp;
  static double get fontSize72 => 72.sp;

  // Screen dimensions
  static double get screenWidth => 1.sw;
  static double get screenHeight => 1.sh;
  static double get statusBarHeight => ScreenUtil().statusBarHeight;
  static double get bottomBarHeight => ScreenUtil().bottomBarHeight;

  // Responsive breakpoints for different screen sizes
  static bool get isSmallScreen => screenWidth < 360;
  static bool get isMediumScreen => screenWidth >= 360 && screenWidth < 768;
  static bool get isLargeScreen => screenWidth >= 768;

  static double get iconSize14 => 14.w;
  static double get iconSize16 => 16.w;
  static double get iconSize24 => 24.w;
  static double get iconSize32 => 32.w;
  static double get iconSize48 => 48.w;
  static double get iconSize64 => 64.w;
  static double get iconSize18 => 18.w;
  static double get iconSize20 => 20.w;
  static double get iconSize28 => 28.w;
}
