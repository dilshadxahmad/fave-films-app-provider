import 'package:fave_films_2/res/routes/route_name.dart';
import 'package:fave_films_2/views/fav_movies_screen.dart';
import 'package:fave_films_2/views/home_view.dart';
import 'package:fave_films_2/views/login_view.dart';
import 'package:fave_films_2/views/onboarding_screen.dart';
import 'package:fave_films_2/views/signup_view.dart';
import 'package:fave_films_2/views/splash_view.dart';
import 'package:get/get.dart';

class AppRoute {
  static appRoutes() => [
        GetPage(
          name: RouteName.onboardingScreen,
          page: () => const OnboardingScreen(),
        ),
        GetPage(
          name: RouteName.homeScreen,
          page: () => const HomeView(),
        ),
        GetPage(
          name: RouteName.favMoviesScreen,
          page: () => const FavMoviesScreen(),
        ),
        GetPage(
          name: RouteName.splashView,
          page: () => const SplashView(),
        ),
        GetPage(
          name: RouteName.loginView,
          page: () => const LoginView(),
        ),
        GetPage(
          name: RouteName.signupView,
          page: () => const SignupView(),
        ),
      ];
}
