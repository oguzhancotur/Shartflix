import 'package:flutter/material.dart';
import 'package:shartflix_app/core/theme/app_theme.dart';
import 'package:shartflix_app/l10n/app_localizations.dart';

class CoinPackage extends StatelessWidget {
  final String bonus;
  final String original;
  final String finalAmount;
  final String price;
  final List<Color> gradientColors;
  final AppLocalizations loc;

  const CoinPackage({
    super.key,
    required this.bonus,
    required this.original,
    required this.finalAmount,
    required this.price,
    required this.gradientColors,
    required this.loc,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width * 0.28,
      height: size.height * 0.26 + 20,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Container(
              height: size.height * 0.26,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.4),
                  width: 0.4,
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          original,
                          style: AppTextStyles.limitedOfferDialogSelectPackage
                              .copyWith(decoration: TextDecoration.lineThrough),
                        ),
                        Text(
                          finalAmount,
                          style: AppTextStyles.limitedOfferDialogAmount,
                        ),
                        Text(
                          loc.coin,
                          style: AppTextStyles.limitedOfferDialogSelectPackage,
                        ),
                      ],
                    ),
                  ),

                  Text(price, style: AppTextStyles.newPrice),
                  Text(
                    loc.weeklyPer,
                    style: AppTextStyles.limitedOfferDialogBonus,
                  ),
                ],
              ),
            ),
          ),

          // Bonus etiketi
          Positioned(
            top: 8,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryRed, gradientColors.first],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.4),
                    width: 0.4,
                  ),
                ),
                child: Text(
                  bonus,
                  style: AppTextStyles.limitedOfferDialogBonus.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
