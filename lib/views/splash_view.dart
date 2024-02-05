import 'package:fave_films_2/data/service_locator.dart';
import 'package:fave_films_2/data/services/auth_service.dart';
import 'package:fave_films_2/res/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate checking user authentication status
    Future.delayed(Duration(seconds: 2), () {
      checkUserLoggedIn();
    });
  }

  void checkUserLoggedIn() {
    final authService = ServiceLocator.instance<AuthService>();
    bool isLoggedIn = authService.isUserLoggedIn();

    if (isLoggedIn) {
      Get.offAndToNamed(RouteName.homeScreen);
    } else {
      Get.offAndToNamed(RouteName.loginView);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
