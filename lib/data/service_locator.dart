import 'package:fave_films_2/data/services/auth_service.dart';
import 'package:fave_films_2/data/services/input_validation_service.dart';
import 'package:get_it/get_it.dart';

class ServiceLocator {
  static final GetIt instance = GetIt.instance;

  static void setup() {
    instance.registerLazySingleton<AuthService>(() => AuthService());
    instance.registerLazySingleton<InputValidationService>(
        () => InputValidationService());
  }
}
