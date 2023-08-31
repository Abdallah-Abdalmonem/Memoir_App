import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'constant/app_color.dart';
import 'constant/app_routes.dart';
import 'firebase_options.dart';
import 'helper/cache_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await CacheHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light));

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Memoir',
      theme: ThemeData(
        primarySwatch: AppColor.primaryColor,
      ),
      initialRoute: AppRoutes.signin,
      routes: routes,
    );
  }
}
