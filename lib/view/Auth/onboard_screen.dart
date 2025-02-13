import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:towanto/utils/resources/fonts.dart';
import 'package:towanto/utils/routes/route_names.dart';
import '../../utils/common_widgets/PreferencesHelper.dart';
import '../../utils/common_widgets/Utils.dart';
import '../../utils/resources/colors.dart';

class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({Key? key}) : super(key: key);
  @override
  _OnBoardScreenState createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.7, curve: Curves.easeOutCubic),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.4, 0.8, curve: Curves.easeOut),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image with fade animation
          FadeTransition(
            opacity: _fadeAnimation,
            child: Image.asset(
              'assets/images/onboard_image.png',
              fit: BoxFit.cover,
            ),
          ),
          // Gradient overlay for better text readability
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.1),
                  Colors.black.withOpacity(0.5),
                ],
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  // Logo with scale animation
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Image.asset(
                      'assets/images/ic_launcher_foreground.png',
                      width: screenWidth * 0.3,
                      height: screenWidth * 0.3,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),                   // Text content with slide and fade animations
                  SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          Text(
                            'Welcome to Towanto',
                            style: TextStyle(
                              fontSize: screenWidth * 0.075,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily:MyFonts.font_regular,
                              height: 1.2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Text(
                            "Your Complete Business Solution",
                            style: TextStyle(
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.w500,
                              color: AppColors.calendartextcolor,
                              fontFamily:MyFonts.font_regular,

                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  // Get Started button with slide and fade animations
                  SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Utils.createButton(text: "Get Started", onClick: () async {

                        // Check for saved username in PreferencesHelper
                        final savedUsername = await PreferencesHelper.getString("login");

                        if (savedUsername == null || savedUsername.isEmpty) {
                          // No username found, navigate to login screen
                          Navigator.pushReplacementNamed(context, RoutesName.login);
                        } else {
                          // Username exists, navigate to signup or the next screen
                          Navigator.pushReplacementNamed(context, RoutesName.home);
                        }

                        // Navigator.pushReplacementNamed(context, RoutesName.login);

                      }),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}