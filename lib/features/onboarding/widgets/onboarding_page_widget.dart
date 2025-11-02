import 'package:flutter/material.dart';
import 'package:softvence_project/features/onboarding/models/onboarding_model.dart';

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingModel model;
  const OnboardingPageWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Padding(
      // 1. --- CHANGE ---
      // Added vertical padding (e.g., 24.0) to give it space.
      // Horizontal padding is 16.0 from your Figma reference.
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Column(
        // Text is aligned to the top of its available space.
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            model.title,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Gap from your Figma reference
          const SizedBox(height: 16),
          // Subtitle
          Text(
            model.subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}