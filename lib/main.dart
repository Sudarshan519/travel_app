import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:gogotravel/app/modules/home/models/providers/local_data_proivder.dart';

import 'app/routes/app_pages.dart';
 import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
 
/// TODO: Version control
void main() {
  runApp(
    GetMaterialApp(
      title: "GOGOTravel",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      initialBinding: AppBindings(),
      localizationsDelegates: const [
        AppLocalizations.delegate, // Add this line
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    ),
  );
}

class AppBindings implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => LocalDataProvider());
  }
}
