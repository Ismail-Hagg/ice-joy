import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icejoy/pages/login_page/info_page.dart';

import '../utils/enums.dart';
import 'home_page/home_page.dart';
import 'login_page/auth_controller.dart';
import 'login_page/login_page.dart';

class ControllPage extends StatelessWidget {
  const ControllPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      init: Get.find<AuthController>(),
      builder: (controll) => controll.user == null
          ? const LoginPage()
          : controll.userModel.state == LogState.info
              ? const InfoPage()
              : const HomePage(),
    );
  }
}
