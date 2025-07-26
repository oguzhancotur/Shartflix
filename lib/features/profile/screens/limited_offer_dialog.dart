import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shartflix_app/core/theme/app_theme.dart';
import 'package:shartflix_app/core/widgets/coin_package.dart';
import 'package:shartflix_app/l10n/app_localizations.dart';

class LimitedOfferModal extends StatelessWidget {
  const LimitedOfferModal({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
      child: FractionallySizedBox(
        heightFactor: 0.75,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(32),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
                child: Container(color: Colors.black.withOpacity(0.8)),
              ),
            ),
            Positioned(
              top: -100,
              left: 0,
              right: 0,
              child: Container(
                height: 300,
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    colors: [AppColors.primaryRed, Colors.transparent],
                    radius: 1,
                    center: Alignment(0.0, 0.0),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -100,
              left: 0,
              right: 0,
              child: Container(
                height: 400,
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    colors: [AppColors.primaryRed, Colors.transparent],
                    radius: 0.6,
                    center: Alignment(0.0, 0.8),
                  ),
                ),
              ),
            ),
            _ModalContent(loc: loc, size: size),
          ],
        ),
      ),
    );
  }
}

class _ModalContent extends StatelessWidget {
  final AppLocalizations loc;
  final Size size;

  const _ModalContent({required this.loc, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.05,
        vertical: size.height * 0.02,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              loc.limitedOffer,
              style: AppTextStyles.limitedOfferDialogTitle,
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: Text(
              loc.limitedOfferDialogSlogan,
              textAlign: TextAlign.center,
              style: AppTextStyles.limitedOfferDialogBonus,
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: size.width * 0.65,
                  height: size.height * 0.13,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [AppColors.red700, Colors.transparent],
                      radius: 0.9,
                      center: Alignment.center,
                    ),
                  ),
                ),
                Image.asset(
                  'assets/images/group.png',
                  width: size.width * 1.1,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              loc.selectCoinPackageToUnlock,
              style: AppTextStyles.limitedOfferDialogSelectPackage,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                CoinPackage(
                  bonus: "+10%",
                  original: "200",
                  finalAmount: "330",
                  price: "₺99,99",
                  gradientColors: const [
                    Color(0xFF6F060B),
                    AppColors.primaryRed,
                  ],
                  loc: loc,
                ),
                const SizedBox(width: 12),
                CoinPackage(
                  bonus: "+70%",
                  original: "2.000",
                  finalAmount: "3.375",
                  price: "₺799,99",
                  gradientColors: const [
                    Color(0xFF5949E6),
                    AppColors.primaryRed,
                  ],
                  loc: loc,
                ),
                const SizedBox(width: 12),
                CoinPackage(
                  bonus: "+35%",
                  original: "1.000",
                  finalAmount: "1.350",
                  price: "₺399,99",
                  gradientColors: const [
                    Color(0xFF6F060B),
                    AppColors.primaryRed,
                  ],
                  loc: loc,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                loc.allCoinsButton,
                style: AppTextStyles.allCoinsButton,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
