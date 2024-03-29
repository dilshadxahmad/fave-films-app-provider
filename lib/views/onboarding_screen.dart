import 'package:fave_films_2/res/images/app_images.dart';
import 'package:fave_films_2/res/routes/route_name.dart';
import 'package:fave_films_2/res/urls/app_url.dart';
import 'package:fave_films_2/res/widgets/special_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        padding: EdgeInsets.all(16.w),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                AppUrl.assetImagesUrl + AppImages.onboardingScreenIllustration),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'your_rocketship_onboarding'.tr,
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.h),
            Text(
              'continue_and_explore_onboarding'.tr,
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            SpecialButton(
              onPressed: () {
                Get.offAndToNamed(RouteName.homeView);
              },
              child: const Icon(Icons.chevron_right_rounded),
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }
}
