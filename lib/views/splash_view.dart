import 'package:fave_films_2/data/service_locator.dart';
import 'package:fave_films_2/data/services/auth_service.dart';
import 'package:fave_films_2/res/images/app_images.dart';
import 'package:fave_films_2/res/routes/route_name.dart';
import 'package:fave_films_2/res/urls/app_url.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    // Simulate checking user authentication status
    Future.delayed(const Duration(seconds: 2), () {
      checkUserLoggedIn();
    });
  }

  void checkUserLoggedIn() {
    final authService = ServiceLocator.instance<AuthService>();
    bool isLoggedIn = authService.isUserLoggedIn();

    if (isLoggedIn) {
      Get.offAndToNamed(RouteName.homeView);
    } else {
      Get.offAndToNamed(RouteName.loginView);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppUrl.assetImagesUrl + AppImages.appLogo),
            SizedBox(
              height: 48.h,
            ),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
