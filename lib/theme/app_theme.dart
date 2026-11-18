import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Lapisan View/Theme: Tema terpusat Material 3 untuk aplikasi Laundry Kilat.
/// Mengonfigurasi palet warna toska/biru laut, aksen label penting, latar belakang abu muda lembut,
/// serta tipografi Poppins dengan bentuk komponen standar (radius 16, bayangan tipis, padding kelipatan 8).
class AppTheme {
  // Palet Warna Utama (Biru Laut / Toska)
  static const Color primaryColor = Color(0xFF007A87);
  static const Color primaryDark = Color(0xFF00565F);
  static const Color primaryLight = Color(0xFFE0F4F6);
  static const Color primaryContainer = Color(0xFFCCEDF0);
  static const Color onPrimaryContainer = Color(0xFF00373D);

  // Palet Warna Aksen (Tombol & Label Penting)
  static const Color accentColor = Color(0xFFB93800);
  static const Color urgentRed = Color(0xFFDC2626);
  static const Color urgentRedBg = Color(0xFFFEE2E2);

  // Latar Belakang & Netral
  static const Color scaffoldBackground = Color(0xFFF8FAFC);
  static const Color cardColor = Colors.white;
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color outlineBorder = Color(0xFFE2E8F0);

  // Warna Jenis Layanan Jadwal (Antar, Jemput, Ambil di Toko)
  static const Color jemputColor = Color(0xFFD97706);
  static const Color jemputBg = Color(0xFFFEF3C7);
  static const Color antarColor = Color(0xFF0284C7);
  static const Color antarBg = Color(0xFFE0F2FE);
  static const Color ambilTokoColor = Color(0xFF0D9488);
  static const Color ambilTokoBg = Color(0xFFCCFBF1);

  // Warna Jenis Layanan Cucian (Cuci Kering, Cuci Setrika, Setrika Saja)
  static const Color cuciKeringColor = Color(0xFF0284C7);
  static const Color cuciKeringBg = Color(0xFFE0F2FE);
  static const Color cuciSetrikaColor = Color(0xFF7C3AED);
  static const Color cuciSetrikaBg = Color(0xFFEDE9FE);
  static const Color setrikaSajaColor = Color(0xFFD97706);
  static const Color setrikaSajaBg = Color(0xFFFEF3C7);

  // Warna Status Selesai
  static const Color successGreen = Color(0xFF059669);
  static const Color successGreenBg = Color(0xFFECFDF5);
  static const Color successGreenBorder = Color(0xFFA7F3D0);

  // Bayangan Halus untuk Kartu
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withAlpha(10),
      blurRadius: 10,
      offset: const Offset(0, 3),
    ),
  ];

  static ThemeData get lightTheme {
    final poppins = GoogleFonts.poppins();
    final baseTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: accentColor,
        surface: cardColor,
        surfaceContainerLowest: cardColor,
        surfaceContainerLow: const Color(0xFFF1F5F9),
        error: urgentRed,
        errorContainer: urgentRedBg,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: scaffoldBackground,
    );

    return baseTheme.copyWith(
      textTheme: baseTheme.textTheme
          .apply(fontFamily: poppins.fontFamily)
          .copyWith(
            titleLarge: poppins.copyWith(
              fontWeight: FontWeight.w700,
              color: textPrimary,
              fontSize: 20,
            ),
            titleMedium: poppins.copyWith(
              fontWeight: FontWeight.w600,
              color: textPrimary,
              fontSize: 16,
            ),
            bodyMedium: poppins.copyWith(color: textPrimary, fontSize: 14),
            bodySmall: poppins.copyWith(color: textSecondary, fontSize: 12),
            labelLarge: poppins.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBackground,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 19,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        shadowColor: Colors.black.withAlpha(20),
        color: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: outlineBorder, width: 1),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: const BorderSide(color: outlineBorder),
          textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: outlineBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: outlineBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: urgentRed),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: urgentRed, width: 1.8),
        ),
        labelStyle: GoogleFonts.poppins(color: textSecondary, fontSize: 13),
        hintStyle: GoogleFonts.poppins(
          color: textSecondary.withAlpha(160),
          fontSize: 13,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: cardColor,
        elevation: 4,
        indicatorColor: primaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: onPrimaryContainer,
            );
          }
          return GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: textSecondary,
          );
        }),
      ),
    );
  }
}
