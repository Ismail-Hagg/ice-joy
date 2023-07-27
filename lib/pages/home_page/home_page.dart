import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icejoy/widgets/custom_text.dart';

import '../login_page/auth_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find<AuthController>();
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextButton(
              onPressed: () => controller.signOut(),
              child: const Text('Sign out')),
          CustomText(text: controller.userModel.toMap().toString())
        ],
      ),
    );
  }
}
