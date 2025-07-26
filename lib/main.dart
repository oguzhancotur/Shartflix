import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shartflix_app/features/auth/screens/login/login_screen.dart';
import 'package:shartflix_app/features/auth/screens/register/register_screen.dart';
import 'package:shartflix_app/features/auth/screens/upload_photo/upload_photo_screen.dart';
import 'package:shartflix_app/features/home/screens/home_screen.dart';
import 'package:shartflix_app/features/profile/screens/profile_screen.dart';
import 'package:shartflix_app/features/splash/screens/splash_screen.dart';
import 'package:shartflix_app/core/utils/my_http_overrides.dart';
import 'dart:io';
import 'package:shartflix_app/l10n/app_localizations.dart';
import 'package:shartflix_app/core/theme/app_theme.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shartflix',
      theme: AppTheme.darkTheme,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', ''), Locale('tr', '')],
      home: SplashScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/upload_photo': (context) => UploadPhotoScreen(),
        '/home': (context) => HomeScreen(),
        '/profile': (context) => ProfileScreen(onItemTapped: (index) {}),
      },
    );
  }
}
