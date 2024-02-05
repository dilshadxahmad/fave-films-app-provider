import 'package:fave_films_2/res/colors/app_colors.dart';
import 'package:fave_films_2/res/widgets/primary_button.dart';
import 'package:fave_films_2/res/images/app_images.dart';
import 'package:fave_films_2/res/routes/route_name.dart';
import 'package:fave_films_2/res/urls/app_url.dart';
import 'package:fave_films_2/utils/helper_functions.dart';
import 'package:fave_films_2/view_models/auth_view_model.dart';
import 'package:fave_films_2/view_models/drawer_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final userAuth = Provider.of<AuthViewModel>(context, listen: false);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          SizedBox(
            height: 150.h,
            child: DrawerHeader(
              padding: EdgeInsets.zero,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 64,
                    child: Image.asset(
                        AppUrl.assetImagesUrl + AppImages.profileAvatar),
                  ),
                  const SizedBox(height: 16),
                  (userAuth.getCurrentUser()?.displayName) == null
                      ? Text(
                          userAuth.getCurrentUser()?.email.toString() ?? '',
                          style: Theme.of(context).textTheme.displaySmall,
                        )
                      : Text(
                          userAuth.getCurrentUser()?.displayName.toString() ??
                              '',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),
          PrimaryButton(
            onPressed: () {
              Get.toNamed(RouteName.profileView);
            },
            backgroundColor: AppColors.lightGrey.withOpacity(0.5),
            child: Text(
              'Profile',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          SizedBox(height: 16.h),
          PrimaryButton(
            onPressed: () {
              Get.toNamed(RouteName.favMoviesView);
            },
            backgroundColor: AppColors.lightGrey.withOpacity(0.5),
            child: Text(
              'Favorites',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          SizedBox(height: 16.h),
          PrimaryButton(
            onPressed: () {
              Get.toNamed(RouteName.settingsView);
            },
            backgroundColor: AppColors.lightGrey.withOpacity(0.5),
            child: Text(
              'Settings',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          SizedBox(height: 16.h),
          PrimaryButton(
            onPressed: () async {
              Provider.of<DrawerViewModel>(context, listen: false)
                  .updateIsLoading();
              await userAuth.signOut().then((value) {
                if (context.mounted) {
                  Provider.of<DrawerViewModel>(context, listen: false)
                      .updateIsLoading();
                }
              }).onError((error, stackTrace) {
                HelperFunctions.showToast(error.toString());
              });
              Get.offAndToNamed(RouteName.loginView);
            },
            isLoading: Provider.of<DrawerViewModel>(context).isLoading,
            child: const Text('Logout'),
          ),
          SizedBox(height: 30.h),
          Text('app_version'.tr),
        ],
      ),
    );
  }
}
