// ignore_for_file: constant_identifier_names, file_names


import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:towanto/utils/resources/colors.dart';

import '../../utils/common_widgets/PreferencesHelper.dart';
import '../../utils/routes/route_names.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(const Duration(seconds: 3), () async {
      if (mounted) {
        // Check for saved username in PreferencesHelper
        final savedUsername = await PreferencesHelper.getString("login");

        if (savedUsername == null || savedUsername.isEmpty) {
          // No username found, navigate to login screen
          Navigator.pushReplacementNamed(context, RoutesName.onBoardScreen);
        } else {
          // Username exists, navigate to signup or the next screen
          Navigator.pushReplacementNamed(context, RoutesName.home);

        }

      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body:    Center(
        child: SizedBox(
          height: 120,
          child: Image.asset(
            "assets/images/ic_launcher_foreground.png", // Add your T-shaped logo here
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

/*  _navigateHomepage() async{
    Directory appDocDir = await getApplicationDocumentsDirectory();
    appDocPath = appDocDir.path;

    Timer(const Duration(seconds: DEFAULT_SPLASH_DELAY_SECONDS), () {
      Navigator.pushReplacementNamed(context, Home);
    });
  }*/
}
