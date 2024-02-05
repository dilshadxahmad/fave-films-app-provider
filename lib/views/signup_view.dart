import 'package:fave_films_2/data/service_locator.dart';
import 'package:fave_films_2/data/services/input_validation_service.dart';
import 'package:fave_films_2/res/colors/app_colors.dart';
import 'package:fave_films_2/res/images/app_images.dart';
import 'package:fave_films_2/res/routes/route_name.dart';
import 'package:fave_films_2/res/urls/app_url.dart';
import 'package:fave_films_2/res/widgets/custom_text_field.dart';
import 'package:fave_films_2/utils/helper_functions.dart';
import 'package:fave_films_2/view_models/auth_view_model.dart';
import 'package:fave_films_2/view_models/signup_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _inputValidationService =
      ServiceLocator.instance<InputValidationService>();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final userAuth = Provider.of<AuthViewModel>(context);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0.h),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(
                height: 64.h,
              ),
              Image.asset(AppUrl.assetImagesUrl + AppImages.appLogo,
                  height: 64.h),
              SizedBox(
                height: 48.h,
              ),
              Text(
                'Welcome, Signup.',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              SizedBox(height: 24.0.h),
              CustomTextField(
                customValidator: _inputValidationService.getEmailValidator(),
                controller: _emailController,
                labelText: 'Email',
              ),
              SizedBox(height: 24.0.h),
              CustomTextField(
                inputLength: 8,
                customValidator: _inputValidationService.getRequiredValidator(),
                controller: _passController,
                labelText: 'Password',
                obscureText: true,
              ),
              SizedBox(height: 24.0.h),
              ElevatedButton(
                onPressed: (_formKey.currentState?.validate() ?? false)
                    ? () async {
                        Provider.of<SignupViewModel>(context, listen: false)
                            .updateIsLoading();
                        userAuth
                            .signUp(_emailController.text, _passController.text)
                            .then((value) {
                          HelperFunctions.showToast('Success, Login now!');
                          if (context.mounted) {
                            Provider.of<SignupViewModel>(context, listen: false)
                                .updateIsLoading();
                          }

                          Get.offAndToNamed(RouteName.loginView);
                        }).onError((error, stackTrace) {
                          HelperFunctions.showToast(error.toString());
                        });
                      }
                    : null,
                child: Provider.of<SignupViewModel>(context).isLoading
                    ? const CircularProgressIndicator(
                        color: AppColors.black,
                      )
                    : const Text('Sign Up'),
              ),
              SizedBox(height: 24.0.h),
              TextButton(
                onPressed: () {
                  Get.offAndToNamed(RouteName.loginView);
                },
                child: Text(
                  'Already have an account? Login',
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodySmall?.color),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
