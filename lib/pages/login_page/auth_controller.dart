import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final bool isIos;
  AuthController({required this.isIos});
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Rxn<User> _user = Rxn<User>();
  User? get user => _user.value;

  final TextEditingController _emailController = TextEditingController();
  TextEditingController get emailController => _emailController;

  bool _isPasswordAbscured = true;
  bool get isPasswordAbscured => _isPasswordAbscured;

  @override
  void onInit() {
    super.onInit();
    _user.bindStream(_auth.authStateChanges());
  }

  // controll the password textfield abscured or not
  void passAbscure() {
    _isPasswordAbscured = !_isPasswordAbscured;
    update();
  }
}
