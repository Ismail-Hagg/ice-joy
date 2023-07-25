import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../login_page/auth_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find<AuthController>();
    return Scaffold(
      body: Center(
        child: TextButton(
            onPressed: () => controller.signOut(),
            child: const Text('Sign out')),
      ),
    );
  }
}
