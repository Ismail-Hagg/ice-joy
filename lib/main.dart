import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:icejoy/pages/login_page/auth_controller.dart';
import 'package:icejoy/pages/view_controller.dart';
import 'package:icejoy/utils/translation.dart';

import 'firebase_options.dart';
import 'local_storage/local_data_pref.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await DataPref().getUserData().then(
    (user) {
      Get.put(AuthController(user,
          isIos: defaultTargetPlatform == TargetPlatform.iOS));
    },
  );

  runApp(MyApp(
    language: language(),
  ));
}

Locale language() {
  return const Locale('en', 'US');
}

class MyApp extends StatelessWidget {
  final Locale language;

  const MyApp({super.key, required this.language});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'IceJoy',
      translations: Translation(),
      locale: const Locale('en', 'US'),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      home: const ControllPage(),
    );
  }
}
