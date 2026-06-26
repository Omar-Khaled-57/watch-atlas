class Spacing {
  Spacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double section = 48;

  static const double cardRadiusSm = 8;
  static const double cardRadiusMd = 12;
  static const double cardRadiusLg = 16;

  static const double chipRadius = 20;
  static const double navBarHeight = 64;
  static const double minTouchTarget = 48;

  static const double posterWidth = 140;
  static const double posterHeight = 210;
  static const double posterWidthLg = 200;
  static const double posterHeightLg = 300;
  static const double carouselHeight = 460;
  static const double backdropHeight = 240;

  static double gridPadding(double screenWidth) =>
      screenWidth >= 768 ? 16 : lg;
  static double gridSpacing(double screenWidth) =>
      screenWidth >= 768 ? 12 : sm;

  static int gridColumns(double width) {
    if (width >= 1024) return 6;
    if (width >= 768) return 4;
    return 3;
  }

  static double cardWidth(double screenWidth, int columns, double spacing) {
    final padding = gridPadding(screenWidth);
    return (screenWidth - padding * 2 - (columns - 1) * spacing) / columns;
  }
}
