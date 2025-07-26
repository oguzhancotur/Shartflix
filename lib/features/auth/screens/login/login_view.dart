import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:shartflix_app/features/auth/bloc/auth_bloc.dart';
import 'package:shartflix_app/l10n/app_localizations.dart';
import 'package:shartflix_app/core/widgets/custom_text_field.dart';
import 'package:shartflix_app/core/widgets/social_login_icon.dart';
import 'package:shartflix_app/core/theme/app_theme.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              Navigator.pushReplacementNamed(context, '/home');
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Login Failed: ${state.error}')),
              );
            }
          },
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthLoading) {
                return Center(
                  child: Lottie.asset(
                    'assets/lottie/loading_animation.json',
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                );
              }

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.25),

                    Text(
                      loc.loginWelcome,
                      style: AppTextStyles.headline1.copyWith(
                        fontSize: screenWidth * 0.05,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),

                    Text(
                      loc.slogan,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyText1.copyWith(
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.w400, // Regular
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.05),

                    CustomTextField(
                      controller: _emailController,
                      hintText: loc.emailHint,
                      iconPath: 'assets/images/message.png',
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    CustomTextField(
                      controller: _passwordController,
                      hintText: loc.passwordHint,
                      iconPath: 'assets/images/unlock.png',
                      isPassword: true,
                    ),
                    SizedBox(height: screenHeight * 0.015),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        child: Text(
                          loc.forgotPassword,
                          style: AppTextStyles.linkText.copyWith(
                            fontSize: screenWidth * 0.032,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    SizedBox(
                      width: double.infinity,
                      height: screenHeight * 0.065,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryRed,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        onPressed: () {
                          context.read<AuthBloc>().add(
                            LoginRequested(
                              email: _emailController.text,
                              password: _passwordController.text,
                            ),
                          );
                        },
                        child: Text(
                          loc.loginButton,
                          style: AppTextStyles.buttonText.copyWith(
                            fontSize: screenWidth * 0.04,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.035),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SocialLoginIcon(icon: FontAwesomeIcons.google),
                        SizedBox(width: screenWidth * 0.02),
                        SocialLoginIcon(icon: FontAwesomeIcons.apple),
                        SizedBox(width: screenWidth * 0.02),
                        SocialLoginIcon(icon: FontAwesomeIcons.facebookF),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.035),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          loc.dontHaveAccount,
                          style: AppTextStyles.semiTransparentText.copyWith(
                            fontSize: screenWidth * 0.033,
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, '/register'),
                          child: Text(
                            loc.registerButton,
                            style: AppTextStyles.linkText.copyWith(
                              fontSize: screenWidth * 0.033,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.04),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
