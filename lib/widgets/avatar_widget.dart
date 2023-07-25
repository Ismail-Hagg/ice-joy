import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icejoy/utils/enums.dart';

import '../utils/constants.dart';

class Avatar extends StatelessWidget {
  final double width;
  final double height;
  final bool isBorder;
  final Color? borderColor;
  final AvatarType type;
  final String? link;
  final BoxFit boxFit;
  final bool shadow;
  final bool? isIos;
  final IconData? iconAndroid;
  final IconData? iconIos;
  final Color? backgroundColor;
  final double? iconSize;
  final Color? iconColor;

  const Avatar(
      {super.key,
      required this.width,
      required this.height,
      required this.isBorder,
      this.borderColor,
      required this.type,
      this.link,
      required this.boxFit,
      required this.shadow,
      this.isIos,
      this.backgroundColor,
      this.iconSize,
      this.iconColor,
      this.iconAndroid,
      this.iconIos});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          color: type == AvatarType.none ? backgroundColor : null,
          shape: BoxShape.circle,
          border: isBorder
              ? Border.all(
                  color: borderColor as Color,
                )
              : null,
          image: type == AvatarType.none
              ? null
              : type == AvatarType.file
                  ? DecorationImage(
                      image: Image.file(File(link.toString())).image,
                      fit: boxFit)
                  : type == AvatarType.online
                      ? DecorationImage(
                          image: Image.network(link.toString()).image,
                          fit: boxFit)
                      : DecorationImage(
                          image: Image.asset(link.toString()).image,
                          fit: boxFit),
          boxShadow: shadow == true
              ? [
                  BoxShadow(
                    color: shadowColor,
                    spreadRadius: 3,
                    blurRadius: 8,
                    offset: const Offset(2, 2),
                  ),
                ]
              : null),
      child: type == AvatarType.none
          ? Center(
              child: Icon(
                isIos == true ? iconIos : iconAndroid,
                color: iconColor,
                size: iconSize,
              ),
            )
          : null,
    );
  }
}
