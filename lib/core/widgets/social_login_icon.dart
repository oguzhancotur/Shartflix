import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shartflix_app/core/theme/app_theme.dart';

class SocialLoginIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const SocialLoginIcon({super.key, required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final double size = screenWidth * 0.15;
    final double iconSize = screenWidth * 0.055;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.grey900,
          borderRadius: BorderRadius.circular(size * 0.3),
          border: Border.all(color: AppColors.white, width: 0.25),
        ),
        child: Center(
          child: FaIcon(icon, color: AppColors.white, size: iconSize),
        ),
      ),
    );
  }
}
