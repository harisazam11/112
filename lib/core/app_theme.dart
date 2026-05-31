import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static TextTheme _buildTextTheme(bool dark) {
    final base = dark ? AppColors.textDark : AppColors.text;
    final muted = dark ? AppColors.textMutedDark : AppColors.textMuted;
    return GoogleFonts.interTextTheme(TextTheme(
      displayLarge:  TextStyle(fontSize: 28, fontWeight: FontWeight.w700, letterSpacing: -0.56, color: base, height: 1.15),
      displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: -0.48, color: base, height: 1.2),
      displaySmall:  TextStyle(fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: -0.2,  color: base, height: 1.25),
      headlineMedium:TextStyle(fontSize: 17, fontWeight: FontWeight.w600, letterSpacing: -0.17, color: base, height: 1.3),
      bodyLarge:     TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: base, height: 1.45),
      bodyMedium:    TextStyle(fontSize: 13.5, fontWeight: FontWeight.w400, color: base, height: 1.45),
      bodySmall:     TextStyle(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.12, color: muted, height: 1.35),
      labelSmall:    TextStyle(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.88, color: muted, height: 1.2),
    ));
  }

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.bg,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.found,
        surface: AppColors.surface,
        onSurface: AppColors.text,
        outline: AppColors.border,
      ),
      textTheme: _buildTextTheme(false),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.bg,
        foregroundColor: AppColors.text,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 17, fontWeight: FontWeight.w600,
          letterSpacing: -0.17, color: AppColors.text,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size.fromHeight(48),
          shape: const StadiumBorder(),
          textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderStrong),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderStrong),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        hintStyle: const TextStyle(color: AppColors.textFaint, fontSize: 15),
      ),
      dividerColor: AppColors.border,
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textFaint,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
      extensions: const [AppThemeExtension(isDark: false)],
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bgDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryDark,
        onPrimary: Colors.white,
        secondary: AppColors.foundDark,
        surface: AppColors.surfaceDark,
        onSurface: AppColors.textDark,
        outline: AppColors.borderDark,
      ),
      textTheme: _buildTextTheme(true),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.bgDark,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 17, fontWeight: FontWeight.w600,
          letterSpacing: -0.17, color: AppColors.textDark,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryDark,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size.fromHeight(48),
          shape: const StadiumBorder(),
          textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderStrongDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderStrongDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryDark, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        hintStyle: const TextStyle(color: AppColors.textFaintDark, fontSize: 15),
      ),
      dividerColor: AppColors.borderDark,
      cardTheme: CardThemeData(
        color: AppColors.surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderDark),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: AppColors.primaryDark,
        unselectedItemColor: AppColors.textFaintDark,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
      extensions: const [AppThemeExtension(isDark: true)],
    );
  }
}

class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final bool isDark;
  const AppThemeExtension({required this.isDark});

  Color get bgColor => isDark ? AppColors.bgDark : AppColors.bg;
  Color get surfaceColor => isDark ? AppColors.surfaceDark : AppColors.surface;
  Color get surface2Color => isDark ? AppColors.surface2Dark : AppColors.surface2;
  Color get surface3Color => isDark ? AppColors.surface3Dark : AppColors.surface3;
  Color get textColor => isDark ? AppColors.textDark : AppColors.text;
  Color get textMutedColor => isDark ? AppColors.textMutedDark : AppColors.textMuted;
  Color get textFaintColor => isDark ? AppColors.textFaintDark : AppColors.textFaint;
  Color get borderColor => isDark ? AppColors.borderDark : AppColors.border;
  Color get borderStrongColor => isDark ? AppColors.borderStrongDark : AppColors.borderStrong;

  Color get primaryColor => isDark ? AppColors.primaryDark : AppColors.primary;
  Color get primarySoftColor => isDark ? AppColors.primarySoftDark : AppColors.primarySoft;
  Color get primaryInkColor => isDark ? AppColors.primaryInkDark : AppColors.primaryInk;

  Color get lostColor => isDark ? AppColors.lostDark : AppColors.lost;
  Color get lostSoftColor => isDark ? AppColors.lostSoftDark : AppColors.lostSoft;
  Color get lostInkColor => isDark ? AppColors.lostInkDark : AppColors.lostInk;

  Color get foundColor => isDark ? AppColors.foundDark : AppColors.found;
  Color get foundSoftColor => isDark ? AppColors.foundSoftDark : AppColors.foundSoft;
  Color get foundInkColor => isDark ? AppColors.foundInkDark : AppColors.foundInk;

  Color get warnColor => isDark ? AppColors.warnDark : AppColors.warn;
  Color get infoColor => isDark ? AppColors.infoDark : AppColors.info;

  @override
  AppThemeExtension copyWith({bool? isDark}) =>
      AppThemeExtension(isDark: isDark ?? this.isDark);

  @override
  AppThemeExtension lerp(AppThemeExtension? other, double t) => this;
}

extension ThemeContextX on BuildContext {
  AppThemeExtension get ext =>
      Theme.of(this).extension<AppThemeExtension>() ??
      const AppThemeExtension(isDark: false);
  bool get isDark => ext.isDark;
}
