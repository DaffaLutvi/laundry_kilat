import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Lapisan View/Theme: Tema terpusat Material 3 untuk aplikasi Laundry Kilat.
/// Mengonfigurasi palet warna toska/biru laut modern, aksen hangat ramah, latar belakang halus,
/// tipografi Poppins yang tajam dan nyaman dibaca, serta bentuk komponen modern bersudut lengkung halus.
class AppTheme {
  // Palet Warna Utama (Biru Laut / Toska Modern)
  static const Color primaryColor = Color(0xFF007A87);
  static const Color primaryDark = Color(0xFF00565F);
  static const Color primaryLight = Color(0xFFE6F7F9);
  static const Color primaryContainer = Color(0xFFD1F2F5);
  static const Color onPrimaryContainer = Color(0xFF00373D);

  // Palet Warna Aksen (Tombol & Label Penting)
  static const Color accentColor = Color(0xFFEA580C);
  static const Color accentLight = Color(0xFFFFEDD5);
  static const Color urgentRed = Color(0xFFDC2626);
  static const Color urgentRedBg = Color(0xFFFEE2E2);

  // Latar Belakang & Netral Modern
  static const Color scaffoldBackground = Color(0xFFF8FAFC);
  static const Color cardColor = Colors.white;
  static const Color surfaceMuted = Color(0xFFF1F5F9);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color outlineBorder = Color(0xFFE2E8F0);
  static const Color outlineBorderLight = Color(0xFFF1F5F9);

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

  // Gradien Modern
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF007A87), Color(0xFF0891B2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient ringkasanGradient = LinearGradient(
    colors: [Color(0xFF006874), Color(0xFF008D9D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFEA580C), Color(0xFFF97316)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Bayangan Halus Bertingkat (Modern Ambient Shadow)
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: const Color(0xFF0F172A).withAlpha(10),
      blurRadius: 10,
      offset: const Offset(0, 3),
    ),
    BoxShadow(
      color: const Color(0xFF0F172A).withAlpha(6),
      blurRadius: 3,
      offset: const Offset(0, 1),
    ),
  ];

  static List<BoxShadow> get elevatedShadow => [
    BoxShadow(
      color: const Color(0xFF007A87).withAlpha(25),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];

  static ThemeData get lightTheme {
    final poppins = GoogleFonts.poppins();
    final baseTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
        secondary: accentColor,
        secondaryContainer: accentLight,
        surface: cardColor,
        surfaceContainerLowest: cardColor,
        surfaceContainerLow: surfaceMuted,
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
            headlineMedium: poppins.copyWith(
              fontWeight: FontWeight.w700,
              color: textPrimary,
              fontSize: 24,
              letterSpacing: -0.5,
            ),
            titleLarge: poppins.copyWith(
              fontWeight: FontWeight.w700,
              color: textPrimary,
              fontSize: 20,
              letterSpacing: -0.3,
            ),
            titleMedium: poppins.copyWith(
              fontWeight: FontWeight.w600,
              color: textPrimary,
              fontSize: 16,
            ),
            bodyLarge: poppins.copyWith(
              color: textPrimary,
              fontSize: 15,
              height: 1.5,
            ),
            bodyMedium: poppins.copyWith(
              color: textPrimary,
              fontSize: 14,
              height: 1.45,
            ),
            bodySmall: poppins.copyWith(
              color: textSecondary,
              fontSize: 12,
              height: 1.4,
            ),
            labelLarge: poppins.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              letterSpacing: 0.1,
            ),
            labelMedium: poppins.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            labelSmall: poppins.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 11,
              color: textSecondary,
            ),
          ),
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBackground,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 19,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: -0.2,
        ),
        iconTheme: const IconThemeData(color: textPrimary),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: outlineBorder, width: 1),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            letterSpacing: 0.2,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: const BorderSide(color: outlineBorder, width: 1.2),
          textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        extendedTextStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: cardColor,
        selectedColor: primaryLight,
        side: const BorderSide(color: outlineBorder, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        labelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
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
          color: textTertiary,
          fontSize: 13,
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: cardColor,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: cardColor,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          side: WidgetStateProperty.all(
            const BorderSide(color: outlineBorder, width: 1),
          ),
          textStyle: WidgetStateProperty.resolveWith((states) {
            return GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: states.contains(WidgetState.selected)
                  ? FontWeight.w600
                  : FontWeight.w500,
            );
          }),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: cardColor,
        elevation: 0,
        height: 68,
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
