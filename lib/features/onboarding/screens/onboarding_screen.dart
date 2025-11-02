import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:video_player/video_player.dart';
import 'package:softvence_project/constants/app_assets.dart';
import 'package:softvence_project/constants/app_colors.dart';
import 'package:softvence_project/features/onboarding/models/onboarding_model.dart';
import 'package:softvence_project/features/onboarding/widgets/onboarding_page_widget.dart';
import 'package:softvence_project/common_widgets/page_transition.dart';
import 'package:softvence_project/features/onboarding/screens/location_permission_screen.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<VideoPlayerController> _videoControllers = [];
  bool _allVideosInitialized = false;
  bool _hasError = false;

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
      'Travel made simple and exciting—discover places you’ll love and moments you’ll never forget.',
    ),
  ];

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _initializeAllVideos();
    _pageController.addListener(_onPageChanged);
  }


  Future<void> _initializeAllVideos() async {
    final startTime = DateTime.now();

    try {
      // Initialize all videos in parallel for maximum speed
      final initializationFutures = _onboardingPages.map((page) async {
        final controller = VideoPlayerController.asset(
          page.videoPath,
          videoPlayerOptions: VideoPlayerOptions(
            // Optimize for mobile playback
            mixWithOthers: false,
            allowBackgroundPlayback: false,
          ),
        );

        await controller.initialize();

        // Configure for optimal performance
        controller.setLooping(true);
        controller.setVolume(0.7); // Enable audio (0.0 = mute, 1.0 = full volume)

        return controller;
      }).toList();

      // Wait for all videos to be ready
      final controllers = await Future.wait(initializationFutures);

      if (mounted) {
        _videoControllers.addAll(controllers);
        setState(() {
          _allVideosInitialized = true;
        });

        // Start playing the first video
        _videoControllers[0].play();

        // Log initialization time for performance monitoring
        final duration = DateTime.now().difference(startTime);
        // debugPrint('✅ All videos initialized in ${duration.inMilliseconds}ms');
      }
    } catch (e) {
      // debugPrint('❌ Error initializing videos: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  void _onPageChanged() {
    final newPage = _pageController.page?.round() ?? 0;
    if (newPage != _currentPage && _allVideosInitialized) {
      // Pause old video
      _videoControllers[_currentPage].pause();

      setState(() {
        _currentPage = newPage;
      });

      // Play new video from start
      final newController = _videoControllers[_currentPage];
      newController.seekTo(Duration.zero);
      newController.play();
    }
  }

  @override
  void dispose() {
    // Restore system UI
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );

    _pageController.removeListener(_onPageChanged);
    _pageController.dispose();

    // Dispose all video controllers
    for (var controller in _videoControllers) {
      controller.pause();
      controller.dispose();
    }
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
    Navigator.of(context).pushReplacement(
      FadePageRoute(page: const LocationPermissionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    const figmaBorderRadius = 32.0;

    return Scaffold(
      body: Container(
        decoration: AppColors.gradientDecoration,
      child: Column(
        children: [
          // --- Video Player Section ---
          SizedBox(
            height: screenHeight * 0.55, // Responsive height
            child: Stack(
              children: [
                // Video Player or Loading/Error State
                if (_hasError)
                  _buildErrorState(figmaBorderRadius)
                else if (_allVideosInitialized)
                  _buildVideoPlayer(figmaBorderRadius)
                else
                  _buildLoadingState(figmaBorderRadius),

                // Gradient Overlay
                _buildGradientOverlay(figmaBorderRadius),

                // Skip Button
                _buildSkipButton(),
              ],
            ),
          ),

          // Page Content
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics: const BouncingScrollPhysics(), // Smooth scrolling
              itemCount: _onboardingPages.length,
              itemBuilder: (context, index) {
                return OnboardingPageWidget(model: _onboardingPages[index]);
              },
            ),
          ),

          // Bottom Navigation
          _buildBottomNavigation(),
        ],
      ),
    ),
    );
  }

  Widget _buildVideoPlayer(double borderRadius) {
    return Positioned.fill(
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(borderRadius),
        ),
        child: FittedBox(
          fit: BoxFit.cover,
          alignment: Alignment.center,
          child: SizedBox(
            width: _videoControllers[_currentPage].value.size.width,
            height: _videoControllers[_currentPage].value.size.height,
            child: VideoPlayer(_videoControllers[_currentPage]),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState(double borderRadius) {
    return Positioned.fill(
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(borderRadius),
        ),
        child: Container(
          color: Colors.black,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                color: AppColors.primaryColor,
                strokeWidth: 3,
              ),
              const SizedBox(height: 16),
              Text(
                'Loading videos...',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(double borderRadius) {
    return Positioned.fill(
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(borderRadius),
        ),
        child: Container(
          color: Colors.black,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: AppColors.primaryColor,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                'Unable to load videos',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  setState(() {
                    _hasError = false;
                  });
                  _initializeAllVideos();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGradientOverlay(double borderRadius) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(borderRadius),
          ),
          gradient: LinearGradient(
            colors: [
              Colors.black.withValues(alpha: 0.0),
              Colors.black.withValues(alpha: 0.3),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    );
  }

  Widget _buildSkipButton() {
    return SafeArea(
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextButton(
            onPressed: _goToNextScreen,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
            ),
            child: Text(
              'Skip',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.08, // 8% of screen width
      ).copyWith(
        bottom: (screenHeight * 0.05).clamp(24.0, 50.0), // Responsive bottom padding
      ),
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
              spacing: 12,
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
                elevation: 2,
              ),
              onPressed: _allVideosInitialized ? _onNextPressed : null,
              child: Text(
                _currentPage == _onboardingPages.length - 1
                    ? 'Get Started'
                    : 'Next',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}