import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icejoy/pages/login_page/auth_controller.dart';
import 'package:icejoy/utils/constants.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../utils/enums.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/login_container.dart';

class PreOtp extends StatelessWidget {
  const PreOtp({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController controller = Get.find<AuthController>();
    return Scaffold(
      backgroundColor: appBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appBackgroundColor,
        leading: controller.isIos
            ? CupertinoButton(
                child: Icon(CupertinoIcons.back, color: blackColor),
                onPressed: () =>
                    controller.userModel.method == LoginMethod.google
                        ? controller.signOut()
                        : {controller.controllerClear(), Get.back()},
              )
            : IconButton(
                splashRadius: 15,
                onPressed: () =>
                    controller.userModel.method == LoginMethod.google
                        ? controller.signOut()
                        : {controller.controllerClear(), Get.back()},
                icon: Icon(
                  Icons.arrow_back,
                  color: blackColor,
                ),
              ),
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        double width = constraints.maxWidth;
        double height = constraints.maxHeight;
        return SizedBox(
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: height * 0.05,
              ),
              LoginContainer(
                width: width * 0.85,
                backgroundColor: greayMain,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: InternationalPhoneNumberInput(
                    autoFocus: true,
                    keyboardAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    hintText: 'enterphone'.tr,
                    initialValue: PhoneNumber(
                        isoCode: 'SA',
                        phoneNumber: controller.userModel.phoneNumber,
                        dialCode: '+966'),
                    inputBorder: InputBorder.none,
                    cursorColor: Colors.transparent,
                    autoValidateMode: AutovalidateMode.disabled,
                    selectorConfig: const SelectorConfig(
                        selectorType: PhoneInputSelectorType.DIALOG,
                        useEmoji: true,
                        leadingPadding: 18,
                        setSelectorButtonAsPrefixIcon: true),
                    onInputChanged: (val) {
                      controller.moedelPhone(
                          country: val.isoCode.toString(),
                          phone: val.phoneNumber.toString());
                    },
                  ),
                ),
              ),
              Expanded(child: Container()),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: SafeArea(
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: shadowColor,
                          spreadRadius: 0.5,
                          blurRadius: 7,
                          offset: const Offset(3, 9),
                        ),
                      ],
                    ),
                    width: width * 0.85,
                    height: width * 0.14,
                    child: GetBuilder<AuthController>(
                      init: Get.find<AuthController>(),
                      builder: (build) => build.isIos
                          ? CupertinoButton(
                              color: purpleColor,
                              borderRadius: BorderRadius.circular(10.0),
                              child: build.loading
                                  ? CupertinoActivityIndicator(
                                      color: whiteColor,
                                      radius: 12,
                                    )
                                  : CustomText(
                                      text: 'login'.tr,
                                      align: TextAlign.left,
                                    ),
                              onPressed: () =>
                                  build.phoneLogin(context: context),
                            )
                          : ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                              onPressed: () =>
                                  build.phoneLogin(context: context),
                              child: build.loading
                                  ? CircularProgressIndicator(
                                      color: whiteColor,
                                    )
                                  : CustomText(
                                      text: 'login'.tr,
                                      align: TextAlign.left,
                                    ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
