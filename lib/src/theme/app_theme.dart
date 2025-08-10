import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/constants/app_colors.dart';
import '../core/utils/responsive_utils.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        onPrimary: AppColors.textOnButton,
        primaryContainer: AppColors.primary.withValues(alpha: 0.15),
        onPrimaryContainer: AppColors.textPrimary,

        secondary: AppColors.secondary,
        onSecondary: AppColors.textPrimary,
        secondaryContainer: AppColors.secondary.withValues(alpha: 0.15),
        onSecondaryContainer: AppColors.textPrimary,

        tertiary: AppColors.tertiary,
        onTertiary: AppColors.textPrimary,
        tertiaryContainer: AppColors.tertiary.withValues(alpha: 0.15),
        onTertiaryContainer: AppColors.textPrimary,

        error: AppColors.error,
        onError: AppColors.textOnButton,
        errorContainer: AppColors.error.withValues(alpha: 0.15),
        onErrorContainer: AppColors.textPrimary,

        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,

        outline: AppColors.textSecondary,
        outlineVariant: AppColors.textSecondary.withValues(alpha: 0.5),

        surfaceTint: AppColors.primary,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 2,

        titleTextStyle: GoogleFonts.poppins(
          fontSize: ResponsiveUtils.fontSize20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),

        toolbarHeight: ResponsiveUtils.height56,

        iconTheme: IconThemeData(
          color: AppColors.textPrimary,
          size: ResponsiveUtils.iconSize24,
        ),

        actionsIconTheme: IconThemeData(
          color: AppColors.textPrimary,
          size: ResponsiveUtils.iconSize24,
        ),

        shape: Border(
          bottom: BorderSide(
            color: AppColors.textSecondary.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        shadowColor: AppColors.primary.withValues(alpha: 0.15),
        margin: EdgeInsets.all(ResponsiveUtils.spacing12),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveUtils.radius16),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.neutralLight, // Soft background for inputs
        contentPadding: EdgeInsets.symmetric(
          vertical: ResponsiveUtils.spacing14,
          horizontal: ResponsiveUtils.spacing16,
        ),
        isDense: true,

        hintStyle: GoogleFonts.poppins(
          color: AppColors.textSecondary,
          fontSize: ResponsiveUtils.fontSize14,
        ),
        labelStyle: GoogleFonts.poppins(
          color: AppColors.textPrimary,
          fontSize: ResponsiveUtils.fontSize16,
          fontWeight: FontWeight.w600,
        ),

        // Borders
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveUtils.radius12),
          borderSide: BorderSide(
            color: AppColors.textSecondary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveUtils.radius12),
          borderSide: BorderSide(
            color: AppColors.textSecondary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveUtils.radius12),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveUtils.radius12),
          borderSide: BorderSide(color: AppColors.error, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveUtils.radius12),
          borderSide: BorderSide(color: AppColors.error, width: 2),
        ),

        errorStyle: TextStyle(
          color: AppColors.error,
          fontSize: ResponsiveUtils.fontSize12,
        ),

        // Icon colors inside input (prefix/suffix)
        prefixIconColor: AppColors.textSecondary,
        suffixIconColor: AppColors.textSecondary,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColors.primary.withValues(alpha: 0.5);
            }
            if (states.contains(WidgetState.pressed)) {
              return AppColors.primary.withValues(alpha: 0.85);
            }
            return AppColors.primary;
          }),
          foregroundColor: WidgetStateProperty.all<Color>(
            AppColors.textOnButton,
          ),
          padding: WidgetStateProperty.all<EdgeInsets>(
            EdgeInsets.symmetric(
              vertical: ResponsiveUtils.spacing14,
              horizontal: ResponsiveUtils.spacing24,
            ),
          ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ResponsiveUtils.radius16),
            ),
          ),
          textStyle: WidgetStateProperty.all<TextStyle>(
            GoogleFonts.poppins(
              fontSize: ResponsiveUtils.fontSize16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          elevation: WidgetStateProperty.resolveWith<double>((states) {
            if (states.contains(WidgetState.pressed)) {
              return 2.0;
            }
            return 4.0;
          }),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColors.textSecondary.withValues(alpha: 0.5);
            }
            if (states.contains(WidgetState.pressed)) {
              return AppColors.primary.withValues(alpha: 0.8);
            }
            return AppColors.primary;
          }),
          padding: WidgetStateProperty.all<EdgeInsets>(
            EdgeInsets.symmetric(
              vertical: ResponsiveUtils.spacing10,
              horizontal: ResponsiveUtils.spacing16,
            ),
          ),
          textStyle: WidgetStateProperty.all<TextStyle>(
            GoogleFonts.poppins(
              fontSize: ResponsiveUtils.fontSize16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        selectedIconTheme: IconThemeData(
          color: AppColors.primary,
          size: ResponsiveUtils.iconSize28,
        ),
        unselectedIconTheme: IconThemeData(
          color: AppColors.textSecondary,
          size: ResponsiveUtils.iconSize24,
        ),
        selectedLabelStyle: GoogleFonts.poppins(
          color: AppColors.primary,
          fontSize: ResponsiveUtils.fontSize12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          color: AppColors.textSecondary,
          fontSize: ResponsiveUtils.fontSize12,
          fontWeight: FontWeight.w400,
        ),
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.poppins(
          fontSize: ResponsiveUtils.fontSize32,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),

        headlineMedium: GoogleFonts.poppins(
          fontSize: ResponsiveUtils.fontSize28,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),

        headlineSmall: GoogleFonts.poppins(
          fontSize: ResponsiveUtils.fontSize24,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),

        // Titles - for app bar titles, section titles, and list headers
        titleLarge: GoogleFonts.poppins(
          fontSize: ResponsiveUtils.fontSize20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),

        titleMedium: GoogleFonts.poppins(
          fontSize: ResponsiveUtils.fontSize18,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),

        titleSmall: GoogleFonts.poppins(
          fontSize: ResponsiveUtils.fontSize16,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),

        // Body text - for paragraphs and normal reading
        bodyLarge: GoogleFonts.merriweatherSans(
          fontSize: ResponsiveUtils.fontSize16,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: AppColors.textPrimary,
        ),

        bodyMedium: GoogleFonts.merriweatherSans(
          fontSize: ResponsiveUtils.fontSize14,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: AppColors.textSecondary,
        ),

        bodySmall: GoogleFonts.merriweatherSans(
          fontSize: ResponsiveUtils.fontSize12,
          fontWeight: FontWeight.w400,
          height: 1.4,
          color: AppColors.textSecondary,
        ),

        // Labels - for buttons, chips, small UI elements
        labelLarge: GoogleFonts.poppins(
          fontSize: ResponsiveUtils.fontSize14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: AppColors.textOnButton,
        ),

        labelMedium: GoogleFonts.poppins(
          fontSize: ResponsiveUtils.fontSize12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          color: AppColors.textSecondary,
        ),

        labelSmall: GoogleFonts.poppins(
          fontSize: ResponsiveUtils.fontSize10,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.4,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
