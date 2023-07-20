import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_page/home_page.dart';
import 'login_page/auth_controller.dart';
import 'login_page/login_page.dart';

class ControllPage extends StatelessWidget {
  const ControllPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isIos = Theme.of(context).platform == TargetPlatform.iOS;
    final AuthController controller = Get.put(AuthController(isIos: isIos));
    return GetBuilder<AuthController>(
      init: controller,
      builder: (controller) =>
          controller.user == null ? const LoginPage() : const HomePage(),
    );
  }
}
