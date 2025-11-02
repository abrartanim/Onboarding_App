import 'package:flutter/material.dart';
import 'package:softvence_project/common_widgets/page_transition.dart';
import 'package:softvence_project/constants/app_assets.dart';
import 'package:softvence_project/constants/app_colors.dart';
import 'package:softvence_project/features/home/screens/home_screen.dart';
import 'package:location/location.dart';

class LocationPermissionScreen extends StatefulWidget {
  const LocationPermissionScreen({super.key});

  @override
  State<LocationPermissionScreen> createState() =>
      _LocationPermissionScreenState();
}

class _LocationPermissionScreenState extends State<LocationPermissionScreen> {
  final Location _location = Location();
  bool _isLoading = false;

  Future<void> _requestLocationPermission() async {
    setState(() {
      _isLoading = true;
    });

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        setState(() {
          _isLoading = false;
        });
        return; // User did not enable service
      }
    }

    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        setState(() {
          _isLoading = false;
        });
        return; // User denied permission
      }
    }

    locationData = await _location.getLocation();

    if (!mounted) return;

    Navigator.of(context).push(
      SlidePageRoute(
        page: const HomeScreen(
          selectedLocation: "Your Current Location",
        ),
      ),
    );
  }

  void _goToHome() {
    Navigator.of(context).push(
      SlidePageRoute(
        page: const HomeScreen(selectedLocation: null),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppColors.gradientDecoration,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 70.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      'Welcome! Your Smart Travel Alarm',
                      textAlign: TextAlign.center,
                      style:
                      Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Stay on schedule and enjoy every moment of your journey.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Image.asset(
                      AppAssets.img1,
                      fit: BoxFit.contain, // Ensure the full image is shown
                    ),
                  ),
                ),
                Column(
                  children: [
                    _isLoading
                        ? const CircularProgressIndicator()
                        : SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.location_pin),
                        onPressed: _requestLocationPermission,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.white,
                          side:  BorderSide(
                            color: AppColors.white.withValues(alpha: 0.36),
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding:
                          const EdgeInsets.symmetric(vertical: 20),
                        ),
                        iconAlignment: IconAlignment.end,
                        label: const Text(
                          'Use Current Location',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _goToHome,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Home',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}