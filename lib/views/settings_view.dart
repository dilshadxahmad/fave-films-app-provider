import 'package:fave_films_2/res/theme/theme_config.dart';
import 'package:fave_films_2/view_models/theme_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settings'.tr),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: Column(
          children: [
            ListTile(
              title: Text(
                'Theme',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              trailing: Switch(
                value: Provider.of<ThemeViewModel>(context).isDark,
                onChanged: (value) {
                  if (Provider.of<ThemeViewModel>(context, listen: false)
                      .isDark) {
                    Provider.of<ThemeViewModel>(context, listen: false)
                        .setTheme(ThemeConfig.lightTheme(), false);
                  } else {
                    Provider.of<ThemeViewModel>(context, listen: false)
                        .setTheme(ThemeConfig.darkTheme(), true);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
