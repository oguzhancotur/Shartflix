import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryRed = Color(0xFFE50914);
  static const Color darkBackground = Colors.black;
  static const Color lightGrey = Colors.white70;
  static const Color mediumGrey = Colors.grey;
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color pinkAccent = Colors.pinkAccent;
  static const Color red700 = Color(0xFFD32F2F);
  static const Color white12 = Colors.white12;
  static const Color white54 = Colors.white54;
  static const Color white24 = Colors.white24;
  static const Color white38 = Colors.white38;
  static const Color grey900 = Color(0xFF212121);
}

class AppTextStyles {
  static TextStyle headline1 = const TextStyle(
    color: AppColors.white,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static TextStyle bodyText1 = const TextStyle(
    color: AppColors.white,
    fontSize: 14,
  );

  static TextStyle buttonText = const TextStyle(
    color: AppColors.white,
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );

  static TextStyle linkText = const TextStyle(
    color: AppColors.white,
    fontSize: 13,
    decoration: TextDecoration.underline,
    decorationColor: AppColors.white,
    decorationThickness: 1.4,
  );

  static TextStyle hintText = TextStyle(
    color: AppColors.white.withAlpha((0.5 * 255).round()),
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static TextStyle movieTitle = const TextStyle(
    color: AppColors.white,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static TextStyle movieDescription = const TextStyle(
    color: AppColors.lightGrey,
    fontSize: 13,
    fontWeight: FontWeight.w400,
  );

  static TextStyle favoriteMovieTitle = const TextStyle(
    color: AppColors.white,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static TextStyle favoriteMovieDescription = const TextStyle(
    color: AppColors.mediumGrey,
    fontSize: 12,
  );

  static TextStyle profileDetailTitle = const TextStyle(
    color: AppColors.white,
    fontSize: 18,
  );

  static TextStyle profileDetailId = const TextStyle(
    color: AppColors.mediumGrey,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static TextStyle limitedOfferText = const TextStyle(
    color: AppColors.white,
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );

  static TextStyle addPhotoButtonText = const TextStyle(
    color: AppColors.white,
    fontSize: 13,
    fontWeight: FontWeight.bold,
  );

  static TextStyle favoriteMoviesHeader = const TextStyle(
    color: AppColors.white,
    fontSize: 13,
    fontWeight: FontWeight.bold,
  );

  static TextStyle dialogTitle = const TextStyle(
    color: AppColors.white,
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );

  static TextStyle dialogBody = const TextStyle(
    color: AppColors.lightGrey,
    fontSize: 14,
  );

  static TextStyle semiTransparentText = TextStyle(
    color: AppColors.white.withAlpha((0.5 * 255).round()),
    fontSize: 13,
  );

  static TextStyle bonusItemLabel = const TextStyle(
    color: AppColors.white,
    fontSize: 12,
  );

  static TextStyle packageAmount = const TextStyle(
    color: AppColors.white,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static TextStyle packagePrice = const TextStyle(
    color: AppColors.white,
    fontSize: 15,
    fontWeight: FontWeight.bold,
  );

  static TextStyle allCoinsButton = const TextStyle(
    color: AppColors.white,
    fontSize: 16,
  );

  static TextStyle limitedOfferDialogTitle = const TextStyle(
    fontFamily: 'Euclid Circular A',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  static TextStyle limitedOfferDialogSlogan = const TextStyle(
    fontFamily: 'Euclid Circular A',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.lightGrey,
  );

  static TextStyle limitedOfferDialogSelectPackage = const TextStyle(
    fontFamily: 'Euclid Circular A',
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.white,
  );

  static TextStyle limitedOfferDialogBonus = const TextStyle(
    fontFamily: 'Euclid Circular A',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.white,
  );

  static TextStyle limitedOfferDialogAmount = const TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 25,
    fontWeight: FontWeight.w900,
    color: AppColors.white,
  );
  static TextStyle newPrice = const TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 15,
    fontWeight: FontWeight.w900,
    color: AppColors.white,
  );
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryRed,
      scaffoldBackgroundColor: AppColors.darkBackground,
      fontFamily: 'Euclid Circular A',
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryRed,
        surface: AppColors.darkBackground,
        onSurface: AppColors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryRed,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.white),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: AppTextStyles.hintText,
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 20),
      ),
    );
  }
}
