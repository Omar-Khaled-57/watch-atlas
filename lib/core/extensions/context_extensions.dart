import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension ContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => mediaQuery.size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  bool get isDark => theme.brightness == Brightness.dark;
  bool get isDesktop => screenWidth >= 1024;
  bool get isTablet => screenWidth >= 768 && screenWidth < 1024;
  bool get isMobile => screenWidth < 768;

  void hideKeyboard() => SystemChannels.textInput.invokeMethod('TextInput.hide');

  ScaffoldMessengerState get showSnackBar => ScaffoldMessenger.of(this);
}
