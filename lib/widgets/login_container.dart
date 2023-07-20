import 'package:flutter/material.dart';
import 'package:icejoy/utils/constants.dart';

class LoginContainer extends StatelessWidget {
  final double width;
  final double? height;
  final Color backgroundColor;
  final Widget child;
  final bool? border;
  final bool? shadow;
  const LoginContainer({
    Key? key,
    required this.width,
    this.height,
    required this.backgroundColor,
    required this.child,
    this.border,
    this.shadow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
          border: border == true ? Border.all(color: greyAccent) : null,
          boxShadow: shadow == true
              ? [
                  BoxShadow(
                    color: shadowColor,
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(2, 2),
                  ),
                ]
              : null),
      child: child,
    );
  }
}
