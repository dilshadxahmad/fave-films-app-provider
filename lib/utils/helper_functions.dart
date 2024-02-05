import 'package:fave_films_2/res/colors/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class HelperFunctions {
  static String showYearsFromDate(String unformattedDate) {
    final dateTime = DateTime.parse(unformattedDate);
    return DateFormat('yyyy').format(dateTime);
  }

  static void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: AppColors.black,
      textColor: AppColors.white,
      fontSize: 14.0.sp,
    );
  }
}
