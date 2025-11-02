import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF5A00F8);   // Purple button color
  static const Color white = Colors.white;
  static const Color grey = Colors.grey;

  // Gradient colors
  static const Color gradientTop = Color(0xFF082257);
  static const Color gradientBottom = Color(0xFF0B0024);

  // Reusable gradient
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [gradientTop, gradientBottom],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Reusable BoxDecoration for backgrounds
  static const BoxDecoration gradientDecoration = BoxDecoration(
    gradient: backgroundGradient,
  );
}