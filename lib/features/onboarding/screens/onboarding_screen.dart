import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:video_player/video_player.dart';
import 'package:softvence_project/constants/app_assets.dart';
import 'package:softvence_project/constants/app_colors.dart';
import 'package:softvence_project/features/onboarding/models/onboarding_model.dart';
import 'package:softvence_project/features/onboarding/widgets/onboarding_page_widget.dart';
import 'package:softvence_project/features/onboarding/screens/location_permission_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  final PageController _pageController = PageController();
  int _currentPage = 0;
  VideoPlayerController? _videoController;

  final List<OnboardingModel> _onboardingPages = [
    OnboardingModel(
      videoPath: AppAssets.video1,
      title: 'Discover the world, one journey at a time.',
      subtitle:
      'From hidden gems to iconic destinations, we make travel simple, inspiring, and unforgettable. Start your next adventure today.',
    ),
    OnboardingModel(
      videoPath: AppAssets.video2,
      title: 'Explore new horizons, one step at a time.',
      subtitle:
      'Every trip holds a story waiting to be lived. Let us guide you to experiences that inspire, connect, and last a lifetime.',
    ),
    OnboardingModel(
      videoPath: AppAssets.video3,
      title: 'See the beauty, one journey at a time.',
      subtitle:
      'Travel made simple and exciting—discover places you\'ll love and moments you\'ll never forget.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer(_onboardingPages[_currentPage].videoPath);
    _pageController.addListener(() {
      final newPage = _pageController.page?.round() ?? 0;
      if (newPage != _currentPage) {
        setState(() {
          _currentPage = newPage;
        });
        _initializeVideoPlayer(_onboardingPages[_currentPage].videoPath);
      }
    });
  }

  Future<void> _initializeVideoPlayer(String videoPath) async {
    if (_videoController != null) {
      await _videoController!.dispose();
    }
    _videoController = VideoPlayerController.asset(videoPath);
    if (!mounted) return;
    await _videoController!.initialize();
    if (mounted) {
      _videoController!.setLooping(true);
      _videoController!.setVolume(0.0);
      _videoController!.play();
      setState(() {});
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    if (_currentPage == _onboardingPages.length - 1) {
      _goToNextScreen();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToNextScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(

        builder: (context) => const LocationPermissionScreen(),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    const figmaVideoHeight = 429.0;
    const figmaBorderRadius = 32.0;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      body: Column(
        children: [
          // --- ITEM 1: Video Player Section (as a Stack) ---
          SizedBox(
            height: figmaVideoHeight,

            child: Stack(
              children: [
                if (_videoController != null &&
                    _videoController!.value.isInitialized)
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(figmaBorderRadius),
                      ),
                      child: FittedBox(
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: _videoController!.value.size.width,
                          height: _videoController!.value.size.height,
                          child: VideoPlayer(_videoController!),
                        ),
                      ),
                    ),
                  )
                else
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(figmaBorderRadius),
                      ),
                      child: Container(
                        color: Colors.black,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(),
                      ),
                    ),
                  ),
                // Gradient overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(figmaBorderRadius),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.0),
                          Colors.black.withOpacity(0.3),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                // Skip Button (now part of the video stack)
                SafeArea(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextButton(
                        onPressed: _goToNextScreen,
                        child: const Text(
                          'Skip',
                          style: TextStyle(color: AppColors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),


          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _onboardingPages.length,
              itemBuilder: (context, index) {
                return OnboardingPageWidget(model: _onboardingPages[index]);
              },
            ),
          ),


          Padding(
            padding: const EdgeInsets.only(left: 32, right: 32, bottom: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SmoothPageIndicator(
                  controller: _pageController,
                  count: _onboardingPages.length,
                  effect: const WormEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    activeDotColor: AppColors.primaryColor,
                    dotColor: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: _onNextPressed,
                    child: Text(
                      _currentPage == _onboardingPages.length - 1
                          ? 'Get Started'
                          : 'Next',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}