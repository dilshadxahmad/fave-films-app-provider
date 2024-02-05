import 'package:fave_films_2/res/images/app_images.dart';
import 'package:fave_films_2/res/urls/app_url.dart';
import 'package:fave_films_2/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final userAuth = Provider.of<AuthViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('profile'.tr),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 32.h),
              SizedBox(
                width: 64,
                child: Image.asset(
                    AppUrl.assetImagesUrl + AppImages.profileAvatar),
              ),
              SizedBox(height: 32.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Name:'),
                  SizedBox(width: 16.w),
                  Text(
                    userAuth.getCurrentUser()?.displayName.toString() ?? '',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Email:'),
                  SizedBox(width: 16.w),
                  Text(
                    userAuth.getCurrentUser()?.email.toString() ?? '',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
