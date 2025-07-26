import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:shartflix_app/features/auth/bloc/auth_bloc.dart';
import 'package:shartflix_app/l10n/app_localizations.dart';
import 'package:shartflix_app/core/widgets/custom_text_field.dart';
import 'package:shartflix_app/core/widgets/social_login_icon.dart';
import 'package:shartflix_app/core/theme/app_theme.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _emailController;
  late final TextEditingController _nameController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _nameController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              Navigator.pushReplacementNamed(context, '/upload_photo');
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Registration Failed: ${state.error}')),
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
                  children: [
                    SizedBox(height: screenHeight * 0.08),
                    Text(
                      loc.welcome,
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
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04),

                    CustomTextField(
                      controller: _nameController,
                      hintText: loc.nameHint,
                      iconPath: 'assets/images/adduser.png',
                    ),
                    SizedBox(height: screenHeight * 0.02),

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
                    SizedBox(height: screenHeight * 0.02),

                    CustomTextField(
                      controller: _confirmPasswordController,
                      hintText: loc.confirmPasswordHint,
                      iconPath: 'assets/images/unlock.png',
                      isPassword: true,
                    ),

                    SizedBox(height: screenHeight * 0.02),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.01,
                      ),
                      child: Text.rich(
                        TextSpan(
                          text: loc.termsAndConditionsPrefix,
                          style: AppTextStyles.semiTransparentText.copyWith(
                            fontSize: screenWidth * 0.032,
                          ),
                          children: [
                            TextSpan(
                              text: loc.termsAndConditionsUnderlined,
                              style: AppTextStyles.linkText.copyWith(
                                fontSize: screenWidth * 0.032,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: loc.termsAndConditionsSuffix,
                              style: AppTextStyles.semiTransparentText.copyWith(
                                fontSize: screenWidth * 0.032,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.045),

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
                          if (_passwordController.text ==
                              _confirmPasswordController.text) {
                            context.read<AuthBloc>().add(
                              RegisterRequested(
                                email: _emailController.text,
                                name: _nameController.text,
                                password: _passwordController.text,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(loc.passwordsDoNotMatch)),
                            );
                          }
                        },
                        child: Text(
                          loc.registerButton,
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
                        SizedBox(width: screenWidth * 0.04),
                        SocialLoginIcon(icon: FontAwesomeIcons.apple),
                        SizedBox(width: screenWidth * 0.04),
                        SocialLoginIcon(icon: FontAwesomeIcons.facebookF),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.035),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          loc.alreadyHaveAccount,
                          style: AppTextStyles.semiTransparentText.copyWith(
                            fontSize: screenWidth * 0.033,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/login'),
                          child: Text(
                            loc.loginButton,
                            style: AppTextStyles.linkText.copyWith(
                              fontSize: screenWidth * 0.033,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.05),
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
