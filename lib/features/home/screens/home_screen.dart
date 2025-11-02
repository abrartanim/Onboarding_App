import 'package:flutter/material.dart';
import 'package:softvence_project/constants/app_colors.dart';

class HomeScreen extends StatelessWidget {
  final String? selectedLocation;

  const HomeScreen({super.key, this.selectedLocation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Alarms'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome Home!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            if (selectedLocation != null)
              Text(
                'Selected Location: $selectedLocation',
                style: Theme.of(context).textTheme.bodyLarge,
              )
            else
              Text(
                'No location selected.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement "Set Alarm" functionality
        },
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.alarm_add, color: AppColors.white),
      ),
    );
  }
}