import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icejoy/pages/login_page/auth_controller.dart';
import 'package:icejoy/utils/constants.dart';
import 'package:icejoy/widgets/custom_text.dart';
import 'package:pinput/pinput.dart';

class OtpPage extends StatelessWidget {
  final String verificationId;
  const OtpPage({super.key, required this.verificationId});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find<AuthController>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double width = constraints.maxWidth;
          double height = constraints.maxHeight;
          final defaultPinTheme = PinTheme(
            width: width * 0.15,
            height: width * 0.15,
            textStyle: const TextStyle(
                fontSize: 20,
                color: Color.fromRGBO(30, 60, 87, 1),
                fontWeight: FontWeight.w600),
            decoration: BoxDecoration(
              color: greayMain,
              border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
              borderRadius: BorderRadius.circular(20),
            ),
          );

          final focusedPinTheme = defaultPinTheme.copyDecorationWith(
            border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
            borderRadius: BorderRadius.circular(8),
          );

          final submittedPinTheme = defaultPinTheme.copyWith(
            decoration: defaultPinTheme.decoration!.copyWith(
              color: const Color.fromRGBO(234, 239, 243, 1),
            ),
          );

          return SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    controller.isIos
                        ? CupertinoButton(
                            child: const Icon(CupertinoIcons.back),
                            onPressed: () => Get.back())
                        : IconButton(
                            onPressed: () => Get.back(),
                            splashRadius: 15,
                            icon: const Icon(Icons.arrow_back))
                  ],
                ),
                SizedBox(
                  height: height * 0.1,
                ),
                CustomText(
                  text: 'ver'.tr,
                  weight: FontWeight.w600,
                  color: blackColor,
                  size: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: CustomText(
                    text:
                        '${'codesend'.tr} ${controller.userModel.phoneNumber}',
                    //weight: FontWeight.w600,
                    color: blackColor.withOpacity(0.5),
                    size: 14,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 24.0, horizontal: 16),
                  child: SizedBox(
                    height: width * 0.3,
                    width: width,
                    child: Pinput(
                      autofocus: true,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: focusedPinTheme,
                      submittedPinTheme: submittedPinTheme,
                      length: 6,
                      onCompleted: (otp) => controller.verifyOtp(
                          otp: otp,
                          verificationId: verificationId,
                          context: context),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.07,
                ),
                GetBuilder<AuthController>(
                  init: Get.find<AuthController>(),
                  builder: (build) => build.loading
                      ? build.isIos
                          ? CupertinoActivityIndicator(
                              color: purpleAccent,
                              radius: 18,
                            )
                          : CircularProgressIndicator(color: purpleAccent)
                      : Container(),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
