import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';

class AppTheme {
  AppTheme._();

  static const Color _darkBg = Color(0xFF0F1115);
  static const Color _darkSurface = Color(0xFF171A21);
  static const Color _darkSurfaceSecondary = Color(0xFF20242E);
  static const Color _accent = Color(0xFFE11D48);
  static const Color _darkText = Color(0xFFFFFFFF);
  static const Color _darkMuted = Color(0xFFA1A1AA);

  static const Color _lightBg = Color(0xFFFFFFFF);
  static const Color _lightSurface = Color(0xFFF5F5F5);
  static const Color _lightText = Color(0xFF111827);
  static const Color _lightSecondary = Color(0xFF6B7280);

  static const _radiusSmall = 8.0;
  static const _radiusMedium = 12.0;
  static const _radiusLarge = 16.0;

  static ThemeData _baseTheme(Brightness brightness, ColorScheme dynamicColor) {
    final isDark = brightness == Brightness.dark;
    final colorScheme = dynamicColor.toScheme(brightness).harmonized();
    final primaryColor = _accent;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: isDark ? _accent : _accent,
        surfaceTint: isDark ? _darkSurface : _lightSurface,
        onPrimary: Colors.white,
        secondary: isDark ? _darkMuted : _lightSecondary,
        onSecondary: isDark ? _darkText : _lightText,
        tertiary: isDark ? _darkSurfaceSecondary : _lightSurface,
        onTertiary: isDark ? _darkText : _lightText,
        error: Colors.redAccent,
        onError: Colors.white,
        surface: isDark ? _darkSurface : _lightSurface,
        onSurface: isDark ? _darkText : _lightText,
        onSurfaceVariant: isDark ? _darkMuted : _lightSecondary,
        outline: isDark ? _darkSurfaceSecondary : const Color(0xFFE5E7EB),
        shadow: isDark ? Colors.black38 : Colors.black12,
        inverseSurface: isDark ? _lightSurface : _darkSurface,
        onInverseSurface: isDark ? _darkText : _lightText,
        inversePrimary: _accent,
        surfaceContainerHighest: isDark ? _darkSurfaceSecondary : const Color(0xFFE5E7EB),
        surfaceContainer: isDark ? _darkSurface : const Color(0xFFFAFAFA),
        surfaceContainerLow: isDark ? _darkBg : _lightBg,
        surfaceContainerHigh: isDark ? _darkSurfaceSecondary : const Color(0xFFF0F0F0),
        surfaceContainerLowest: isDark ? const Color(0xFF0A0C0E) : Colors.white,
        surfaceBright: isDark ? _darkSurface : _lightBg,
        surfaceDim: isDark ? _darkBg : const Color(0xFFE8E8E8),
      ),
      scaffoldBackgroundColor: isDark ? _darkBg : _lightBg,
      fontFamily: 'Inter',
      textTheme: _textTheme(isDark),
      primaryTextTheme: _textTheme(isDark),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: isDark ? _darkText : _lightText,
        titleTextStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: isDark ? _darkText : _lightText,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        color: isDark ? _darkSurface : _lightSurface,
        shadowColor: isDark ? Colors.black38 : Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.all(Radius.circular(_radiusMedium)),
        ),
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsetsDirectional.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? _darkSurfaceSecondary : const Color(0xFFF0F0F0),
        hintStyle: TextStyle(
          color: isDark ? _darkMuted : _lightSecondary,
          fontSize: 14,
        ),
        contentPadding: const EdgeInsetsDirectional.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadiusDirectional.all(Radius.circular(_radiusMedium)),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadiusDirectional.all(Radius.circular(_radiusMedium)),
          borderSide: BorderSide(
            color: isDark ? _darkSurfaceSecondary : const Color(0xFFE5E7EB),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadiusDirectional.all(Radius.circular(_radiusMedium)),
          borderSide: const BorderSide(color: _accent, width: 2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: _accent,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: 24,
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.all(Radius.circular(_radiusSmall)),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: isDark ? _darkText : _lightText,
          side: BorderSide(
            color: isDark ? _darkSurfaceSecondary : const Color(0xFFD1D5DB),
          ),
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: 24,
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.all(Radius.circular(_radiusSmall)),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _accent,
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: isDark ? _darkSurfaceSecondary : const Color(0xFFF0F0F0),
        selectedColor: _accent.withValues(alpha: 0.2),
        labelStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          color: isDark ? _darkText : _lightText,
        ),
        secondaryLabelStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          color: isDark ? _darkMuted : _lightSecondary,
        ),
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.all(Radius.circular(20)),
        ),
        side: BorderSide.none,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _accent,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.all(Radius.circular(_radiusMedium)),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark ? _darkSurface : _lightBg,
        selectedItemColor: _accent,
        unselectedItemColor: isDark ? _darkMuted : _lightSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 11,
        ),
        landscapeLayout: BottomNavigationBarLandscapeLayout.linear,
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: isDark ? _darkSurface : _lightBg,
        selectedIconTheme: const IconThemeData(color: _accent, size: 22),
        unselectedIconTheme: IconThemeData(
          color: isDark ? _darkMuted : _lightSecondary,
          size: 22,
        ),
        selectedLabelTextStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: _accent,
        ),
        unselectedLabelTextStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          color: isDark ? _darkMuted : _lightSecondary,
        ),
        indicatorColor: _accent.withValues(alpha: 0.15),
        labelType: NavigationRailLabelType.all,
        minExtendedWidth: 200,
        leadingPadding: const EdgeInsetsDirectional.only(top: 8),
        groupAlignment: 0,
      ),
      dividerTheme: DividerThemeData(
        color: isDark ? _darkSurfaceSecondary : const Color(0xFFE5E7EB),
        thickness: 0.5,
        space: 1,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: isDark ? _darkSurface : _lightBg,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.all(Radius.circular(_radiusSmall)),
        ),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: isDark ? _darkSurface : _lightBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.all(Radius.circular(_radiusLarge)),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: isDark ? _darkSurface : _lightBg,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.vertical(
            top: Radius.circular(_radiusLarge),
          ),
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: isDark ? _darkText : _lightText,
        unselectedLabelColor: isDark ? _darkMuted : _lightSecondary,
        indicatorColor: _accent,
        labelStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: _accent,
        thumbColor: _accent,
        overlayColor: _accent.withValues(alpha: 0.15),
        inactiveTrackColor: isDark ? _darkSurfaceSecondary : const Color(0xFFE5E7EB),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return _accent;
          return isDark ? _darkMuted : _lightSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return _accent.withValues(alpha: 0.3);
          return isDark ? _darkSurfaceSecondary : const Color(0xFFE5E7EB);
        }),
      ),
    );
  }

  static TextTheme _textTheme(bool isDark) {
    return TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'Inter',
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: isDark ? _darkText : _lightText,
        letterSpacing: -0.5,
      ),
      displayMedium: TextStyle(
        fontFamily: 'Inter',
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: isDark ? _darkText : _lightText,
        letterSpacing: -0.25,
      ),
      displaySmall: TextStyle(
        fontFamily: 'Inter',
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: isDark ? _darkText : _lightText,
      ),
      headlineLarge: TextStyle(
        fontFamily: 'Inter',
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: isDark ? _darkText : _lightText,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Inter',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: isDark ? _darkText : _lightText,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'Inter',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: isDark ? _darkText : _lightText,
      ),
      titleLarge: TextStyle(
        fontFamily: 'Inter',
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: isDark ? _darkText : _lightText,
      ),
      titleMedium: TextStyle(
        fontFamily: 'Inter',
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: isDark ? _darkText : _lightText,
      ),
      titleSmall: TextStyle(
        fontFamily: 'Inter',
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: isDark ? _darkText : _lightText,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: isDark ? _darkText : _lightText,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: isDark ? _darkText : _lightText,
        height: 1.5,
      ),
      bodySmall: TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: isDark ? _darkMuted : _lightSecondary,
        height: 1.4,
      ),
      labelLarge: TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: isDark ? _darkText : _lightText,
      ),
      labelMedium: TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: isDark ? _darkMuted : _lightSecondary,
      ),
      labelSmall: TextStyle(
        fontFamily: 'Inter',
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: isDark ? _darkMuted : _lightSecondary,
        letterSpacing: 0.5,
      ),
    );
  }

  static ThemeData lightFromDynamic(ColorScheme? dynamicScheme) {
    final scheme = dynamicScheme?.harmonized() ??
        ColorScheme.fromSeed(seedColor: _accent, brightness: Brightness.light);
    return _baseTheme(Brightness.light, scheme);
  }

  static ThemeData darkFromDynamic(ColorScheme? dynamicScheme) {
    final scheme = dynamicScheme?.harmonized() ??
        ColorScheme.fromSeed(seedColor: _accent, brightness: Brightness.dark);
    return _baseTheme(Brightness.dark, scheme);
  }
}
