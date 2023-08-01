import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icejoy/controllers/auth_controller.dart';
import 'package:icejoy/utils/constants.dart';

// firebase error messages
String getMessageFromErrorCode({required String errorMessage}) {
  switch (errorMessage) {
    case "ERROR_EMAIL_ALREADY_IN_USE":
    case "account-exists-with-different-credential":
    case "email-already-in-use":
      return "firealready".tr;
    case "ERROR_WRONG_PASSWORD":
    case "wrong-password":
      return "firewrong".tr;
    case "ERROR_USER_NOT_FOUND":
    case "user-not-found":
      return "fireuser".tr;
    case "ERROR_USER_DISABLED":
    case "user-disabled":
      return "firedis".tr;
    case "ERROR_TOO_MANY_REQUESTS":
    case "ERROR_OPERATION_NOT_ALLOWED":
    case "operation-not-allowed":
      return "fireserver".tr;
    case "ERROR_INVALID_EMAIL":
    case "invalid-email":
      return "fireemail".tr;
    case 'invalid-verification-code':
      return 'fireverification'.tr;
    default:
      return "firelogin".tr;
  }
}

// date picker platform
void datePicker({
  required bool isIos,
  required BuildContext context,
  required double height,
  required double width,
}) async {
  if (isIos) {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: whiteColor,
            height: height,
            child: CupertinoDatePicker(
              initialDateTime: DateTime.now(),
              onDateTimeChanged: (dateTime) {
                Get.find<AuthController>().moedelBirth(time: dateTime);
              },
              mode: CupertinoDatePickerMode.date,
            ),
          );
        });
  } else {
    final DateTime? dateTime = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime(3000));
    if (dateTime != null) {
      Get.find<AuthController>().moedelBirth(time: dateTime);
    }
  }
}

// set initial language according to device
String languageDev() {
  return Get.deviceLocale.toString().substring(0, 2) == 'en'
      ? 'en_US'
      : Get.deviceLocale.toString().substring(0, 2) == 'ar'
          ? 'ar_SA'
          : 'ar_SA';
}
