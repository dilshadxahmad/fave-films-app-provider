import 'package:fave_films_2/res/constants/app_constants.dart';

class InputValidationService {
  String? Function(String?)? getNameValidator() {
    final validName = RegExp(r'^[a-zA-Z ]+$');
    return (name) {
      String validationResults;
      if (name!.isNotEmpty) {
        if (validName.hasMatch(name)) {
          return null;
        }
        validationResults = AppConstants.onlyAlphabets;
        return validationResults;
      } else {
        validationResults = AppConstants.cantBeEmpty;
      }
      return validationResults;
    };
  }

  String? Function(String?)? getEmailValidator() {
    final validEmail = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return (email) {
      String validationResults;
      if (email!.isNotEmpty) {
        if (validEmail.hasMatch(email)) {
          return null;
        }
        validationResults = AppConstants.enterValidEmail;
        return validationResults;
      } else {
        validationResults = AppConstants.cantBeEmpty;
      }
      return validationResults;
    };
  }

  String? Function(String?)? getRequiredValidator() {
    return (text) {
      String validationResults;
      if (text!.isEmpty) {
        validationResults = AppConstants.cantBeEmpty;

        return validationResults;
      } else if (text.isNotEmpty && text.length < 8) {
        validationResults = AppConstants.passwordCantBeLess;

        return validationResults;
      }
      return null;
    };
  }
}
