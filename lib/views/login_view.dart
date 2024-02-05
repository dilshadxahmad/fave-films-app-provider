import 'package:fave_films_2/data/service_locator.dart';
import 'package:fave_films_2/data/services/input_validation_service.dart';
import 'package:fave_films_2/res/widgets/primary_button.dart';
import 'package:fave_films_2/res/images/app_images.dart';
import 'package:fave_films_2/res/routes/route_name.dart';
import 'package:fave_films_2/res/urls/app_url.dart';
import 'package:fave_films_2/res/widgets/custom_text_field.dart';
import 'package:fave_films_2/utils/helper_functions.dart';
import 'package:fave_films_2/view_models/auth_view_model.dart';
import 'package:fave_films_2/view_models/form_validation_view_model.dart';
import 'package:fave_films_2/view_models/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
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
                'Welcome, Login.',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              SizedBox(height: 24.0.h),
              CustomTextField(
                customValidator: _inputValidationService.getEmailValidator(),
                controller: _emailController,
                labelText: 'Email',
                onChanged: (value) {
                  Provider.of<FormValidationViewModel>(context, listen: false)
                      .updateFormValidity(
                          _formKey.currentState?.validate() ?? false);
                },
              ),
              SizedBox(height: 24.0.h),
              CustomTextField(
                inputLength: 8,
                customValidator: _inputValidationService.getRequiredValidator(),
                controller: _passController,
                labelText: 'Password',
                obscureText: true,
                onChanged: (value) {
                  Provider.of<FormValidationViewModel>(context, listen: false)
                      .updateFormValidity(
                          _formKey.currentState?.validate() ?? false);
                },
              ),
              SizedBox(height: 24.0.h),
              PrimaryButton(
                onPressed: Provider.of<FormValidationViewModel>(context)
                        .isFormValid
                    ? () async {
                        Provider.of<LoginViewModel>(context, listen: false)
                            .updateIsLoading();
                        await userAuth
                            .signIn(_emailController.text, _passController.text)
                            .then((value) {
                          Get.offAndToNamed(RouteName.onboardingView);
                        }).onError((error, stackTrace) {
                          HelperFunctions.showToast(error.toString());
                        });
                        if (context.mounted) {
                          Provider.of<LoginViewModel>(context, listen: false)
                              .updateIsLoading();
                        }
                      }
                    : null,
                // onPressed: (_formKey.currentState?.validate() ?? true)
                //     ? () async {
                //         Provider.of<LoginViewModel>(context, listen: false)
                //             .updateIsLoading();
                //         await userAuth
                //             .signIn(_emailController.text, _passController.text)
                //             .then((value) {
                //           Get.offAndToNamed(RouteName.onboardingView);
                //         }).onError((error, stackTrace) {
                //           HelperFunctions.showToast(error.toString());
                //         });
                //         if (context.mounted) {
                //           Provider.of<LoginViewModel>(context, listen: false)
                //               .updateIsLoading();
                //         }
                //       }
                //     : null,
                isLoading: Provider.of<LoginViewModel>(context).isLoading,
                child: const Text('Login'),
              ),
              SizedBox(height: 24.0.h),
              TextButton(
                onPressed: () {
                  Get.offAndToNamed(RouteName.signupView);
                },
                child: Text(
                  'Don\'t have an account? Sign up',
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
