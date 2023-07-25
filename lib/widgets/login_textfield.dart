import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icejoy/utils/constants.dart';

class LoginTextField extends StatelessWidget {
  final bool otp;
  final String? hint;
  final TextEditingController controller;
  final bool obscure;
  final Widget? suffex;
  final TextInputType type;
  final TextInputAction? action;
  const LoginTextField(
      {super.key,
      required this.otp,
      this.hint,
      required this.controller,
      required this.obscure,
      this.suffex,
      required this.type,
      this.action});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (val) {
        if (otp && val.length == 1) {
          FocusScope.of(context).nextFocus();
        }
      },
      textAlign: otp ? TextAlign.center : TextAlign.left,
      style: const TextStyle(fontSize: 15),
      keyboardType: type,
      textInputAction: action,
      obscureText: obscure,
      controller: controller,
      cursorHeight: 0,
      cursorWidth: 0,
      decoration: InputDecoration(
        isDense: true,
        suffixIcon: suffex,
        hintText: hint ?? '',
        hintStyle: const TextStyle(
          fontSize: 15,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: purpleColor, width: 1.5),
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
      inputFormatters: otp
          ? [
              LengthLimitingTextInputFormatter(1),
              FilteringTextInputFormatter.digitsOnly
            ]
          : [],
    );
  }
}
