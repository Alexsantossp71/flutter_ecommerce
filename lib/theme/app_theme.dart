import 'package:flutter/material.dart';

/// Design system da Moda Praia Santos.
///
/// Paleta inspirada no litoral brasileiro:
/// - azul profundo (mar)      -> deep / primary
/// - água (turquesa)          -> secundária
/// - dourado (areia ao sol)   -> tertiary / CTA
/// - off-white quente         -> fundo
class AppTheme {
  static const Color deep = Color(0xFF0A3D5C);
  static const Color sea = Color(0xFF0E7490);
  static const Color aqua = Color(0xFF2CA6A4);
  static const Color sand = Color(0xFFF6F1E7);
  static const Color gold = Color(0xFFC9A24B);
  static const Color ink = Color(0xFF15202B);

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: sea,
      brightness: Brightness.light,
      primary: sea,
      secondary: aqua,
      tertiary: gold,
      surface: Colors.white,
      onSurface: ink,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: sand,
    );

    return base.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.6,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: sea,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white,
        selectedColor: sea,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
        side: BorderSide(color: Colors.black.withValues(alpha: 0.06)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        hintStyle: TextStyle(color: ink.withValues(alpha: 0.45)),
        prefixIconColor: ink.withValues(alpha: 0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: ink.withValues(alpha: 0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: sea, width: 1.6),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      ),
      textTheme: base.textTheme.apply(
        bodyColor: ink,
        displayColor: ink,
      ),
    );
  }

  /// Gradiente usado no AppBar e superfícies "mar".
  static const LinearGradient seaGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [deep, sea, aqua],
  );

  /// Gradiente dourado para CTAs de destaque.
  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFD9B45C), gold, Color(0xFFB98A35)],
  );
}
