import 'package:fave_films_2/data/service_locator.dart';
import 'package:fave_films_2/res/l10n/app_translations.dart';
import 'package:fave_films_2/res/routes/app_route.dart';
import 'package:fave_films_2/res/routes/route_name.dart';
import 'package:fave_films_2/res/theme/theme_config.dart';
import 'package:fave_films_2/view_models/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  ServiceLocator.setup();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HomeViewModel>(
            create: (context) => HomeViewModel())
      ],
      child: ScreenUtilInit(
        builder: (context, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeConfig.darkTheme(),
            translations: AppTranslations(),
            locale: const Locale('en', 'US'),
            fallbackLocale: const Locale('en', 'US'),
            getPages: AppRoute.appRoutes(),
            initialRoute: RouteName.onboardingScreen,
          );
        },
      ),
    );
  }
}
