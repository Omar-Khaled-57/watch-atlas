import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Dark theme
  static const Color _darkBg = Color(0xFF0F1115);
  static const Color _darkSurface = Color(0xFF171A21);
  static const Color _darkSurfaceSecondary = Color(0xFF20242E);
  static const Color _darkText = Color(0xFFFFFFFF);
  static const Color _darkMuted = Color(0xFFA1A1AA);

  // Light theme – warm, eye-friendly palette
  static const Color _lightBg = Color(0xFFFDFBF7);
  static const Color _lightSurface = Color(0xFFF5F0EB);
  static const Color _lightText = Color(0xFF292524);
  static const Color _lightSecondary = Color(0xFF78716C);

  // Accent & states
  static const Color _accent = Color(0xFF00B8FF);
  static const Color _accentHover = Color(0xFF009FE0);
  static const Color _accentPressed = Color(0xFF0088C2);

  // Logo brand colors
  static const Color _logoCyan = Color(0xFF00D4FF);
  static const Color _logoPurple = Color(0xFF8B5CF6);

  // Semantic
  static const Color _success = Color(0xFF22C55E);
  static const Color _warning = Color(0xFFF59E0B);
  static const Color _error = Color(0xFFEF4444);

  static const _radiusSmall = 8.0;
  static const _radiusMedium = 12.0;
  static const _radiusLarge = 16.0;

  // Logo gradient – Cyan → Purple (135deg)
  static const LinearGradient logoGradient = LinearGradient(
    colors: [_logoCyan, _logoPurple],
    begin: Alignment(-0.5, -0.5),
    end: Alignment(0.5, 0.5),
    stops: [0.0, 1.0],
  );

  // Soft glow shadow for logo accent colors
  static List<BoxShadow> logoGlow(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: _logoPurple.withValues(alpha: isDark ? 0.35 : 0.12),
        blurRadius: 20,
        spreadRadius: isDark ? 2 : 0,
      ),
      BoxShadow(
        color: _logoCyan.withValues(alpha: isDark ? 0.15 : 0.05),
        blurRadius: 40,
        spreadRadius: -4,
      ),
    ];
  }

  static const ColorScheme _darkColorScheme = ColorScheme.dark(
    primary: _accent,
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFF004D6B),
    onPrimaryContainer: Color(0xFFB3E8FF),
    secondary: _logoPurple,
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFF3B1E6B),
    onSecondaryContainer: Color(0xFFEDDBFF),
    tertiary: _logoCyan,
    onTertiary: Color(0xFF003544),
    tertiaryContainer: Color(0xFF004E62),
    onTertiaryContainer: Color(0xFFA8ECFF),
    error: _error,
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    surface: _darkBg,
    onSurface: _darkText,
    surfaceContainerHighest: _darkSurfaceSecondary,
    onSurfaceVariant: _darkMuted,
    outline: Color(0xFF49454F),
    outlineVariant: Color(0xFF2A2A35),
    shadow: Color(0xFF000000),
    inverseSurface: Color(0xFFE6E1E5),
    onInverseSurface: Color(0xFF1C1B1F),
    inversePrimary: _accent,
    surfaceTint: _accent,
  );

  static const ColorScheme _lightColorScheme = ColorScheme.light(
    primary: _accent,
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFCAE9FF),
    onPrimaryContainer: Color(0xFF001E31),
    secondary: _logoPurple,
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFEDDBFF),
    onSecondaryContainer: Color(0xFF1E0040),
    tertiary: _logoCyan,
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFA8ECFF),
    onTertiaryContainer: Color(0xFF001F28),
    error: _error,
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),
    surface: _lightBg,
    onSurface: _lightText,
    surfaceContainerHighest: Color(0xFFEDE8E2),
    onSurfaceVariant: _lightSecondary,
    outline: Color(0xFF79747E),
    outlineVariant: Color(0xFFCAC4D0),
    shadow: Color(0xFF000000),
    inverseSurface: Color(0xFF1C1B1F),
    onInverseSurface: Color(0xFFE6E1E5),
    inversePrimary: _accent,
    surfaceTint: _accent,
  );

  static ThemeData _baseTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: isDark ? _darkColorScheme : _lightColorScheme,
      scaffoldBackgroundColor: isDark ? _darkBg : _lightBg,
      textTheme: _textTheme(isDark),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: isDark ? _darkText : _lightText,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: isDark ? _darkText : _lightText,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: isDark ? _darkSurface : _lightSurface,
        shadowColor: isDark ? Colors.black38 : Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(_radiusMedium)),
        ),
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero,
        surfaceTintColor: Colors.transparent,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: isDark
            ? _darkSurface.withValues(alpha: 0.85)
            : _lightSurface.withValues(alpha: 0.92),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(_radiusLarge)),
          side: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : Colors.black.withValues(alpha: 0.04),
          ),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: isDark
            ? _darkSurface.withValues(alpha: 0.92)
            : _lightBg.withValues(alpha: 0.95),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(_radiusLarge),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? _darkSurfaceSecondary : const Color(0xFFEDE8E2),
        hintStyle: TextStyle(
          color: isDark ? _darkMuted : _lightSecondary,
          fontSize: 14,
        ),
        contentPadding: const EdgeInsetsDirectional.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(_radiusMedium)),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(_radiusMedium)),
          borderSide: BorderSide(
            color: isDark ? _darkSurfaceSecondary : const Color(0xFFE5E7EB),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(_radiusMedium)),
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
            borderRadius: BorderRadius.all(Radius.circular(_radiusSmall)),
          ),
          textStyle: const TextStyle(
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
            borderRadius: BorderRadius.all(Radius.circular(_radiusSmall)),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _accent,
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: isDark ? _darkSurfaceSecondary : const Color(0xFFF0F0F0),
        selectedColor: _accent.withValues(alpha: 0.2),
        labelStyle: TextStyle(
          fontSize: 12,
          color: isDark ? _darkText : _lightText,
        ),
        secondaryLabelStyle: TextStyle(
          fontSize: 12,
          color: isDark ? _darkMuted : _lightSecondary,
        ),
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        side: BorderSide.none,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _accent,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(_radiusMedium)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isDark ? _darkSurface : _lightBg,
        indicatorColor: _accent.withValues(alpha: 0.15),
        height: 64,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        surfaceTintColor: Colors.transparent,
        shadowColor: isDark ? Colors.black38 : Colors.black12,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark ? _darkSurface : _lightBg,
        selectedItemColor: _accent,
        unselectedItemColor: isDark ? _darkMuted : _lightSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
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
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: _accent,
        ),
        unselectedLabelTextStyle: TextStyle(
          fontSize: 12,
          color: isDark ? _darkMuted : _lightSecondary,
        ),
        indicatorColor: _accent.withValues(alpha: 0.15),
        labelType: NavigationRailLabelType.all,
        minExtendedWidth: 200,
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
          borderRadius: BorderRadius.all(Radius.circular(_radiusSmall)),
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: isDark ? _darkText : _lightText,
        unselectedLabelColor: isDark ? _darkMuted : _lightSecondary,
        indicatorColor: _accent,
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
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
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: isDark ? _darkText : _lightText,
        letterSpacing: -0.5,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: isDark ? _darkText : _lightText,
        letterSpacing: -0.25,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: isDark ? _darkText : _lightText,
      ),
      headlineLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: isDark ? _darkText : _lightText,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: isDark ? _darkText : _lightText,
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: isDark ? _darkText : _lightText,
      ),
      titleLarge: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: isDark ? _darkText : _lightText,
      ),
      titleMedium: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: isDark ? _darkText : _lightText,
      ),
      titleSmall: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: isDark ? _darkText : _lightText,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: isDark ? _darkText : _lightText,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: isDark ? _darkText : _lightText,
        height: 1.5,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: isDark ? _darkMuted : _lightSecondary,
        height: 1.4,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: isDark ? _darkText : _lightText,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: isDark ? _darkMuted : _lightSecondary,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: isDark ? _darkMuted : _lightSecondary,
        letterSpacing: 0.5,
      ),
    );
  }

  static ThemeData light() {
    return _baseTheme(Brightness.light);
  }

  static ThemeData dark() {
    return _baseTheme(Brightness.dark);
  }
}
