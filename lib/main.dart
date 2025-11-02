import 'package:flutter/material.dart';
import 'package:softvence_project/constants/app_colors.dart';
import 'package:softvence_project/features/onboarding/screens/onboarding_screen.dart';
import 'package:google_fonts/google_fonts.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Onboarding App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.backgroundColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryColor,
          brightness: Brightness.dark,
          background: AppColors.backgroundColor,
        ),


        textTheme: GoogleFonts.oxygenTextTheme(
          Theme.of(context).textTheme.copyWith(
            headlineLarge: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            bodyMedium: const TextStyle(
              fontSize: 22,
              color: Colors.white70,
              height: 1.5,
            ),
          ),
        ),
      ),

      home: const OnboardingScreen(),
    );
  }
}
