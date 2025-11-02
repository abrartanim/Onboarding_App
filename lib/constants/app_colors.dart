import 'package:flutter/material.dart';

class AppColors {
  static const Color backgroundColor = Color(0xFF0A1540); // Dark blue background
  static const Color primaryColor = Color(0xFF5A00F8);   // Purple button color
  static const Color white = Colors.white;
  static const Color grey = Colors.grey;

}

const Color kGradientColorTop = Color(0xFF082257);
const Color kGradientColorBottom = Color(0xFF0B0024);

/// A reusable `LinearGradient` object.
const LinearGradient kAppGradient = LinearGradient(
  colors: [
    kGradientColorTop,
    kGradientColorBottom,
  ],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

/// A reusable `BoxDecoration` for backgrounds.
/// This is what you will use most often.
const BoxDecoration kAppGradientDecoration = BoxDecoration(
  gradient: kAppGradient,
);

// --- End of new constants ---