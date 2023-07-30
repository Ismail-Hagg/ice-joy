import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icejoy/pages/login_page/auth_controller.dart';
import 'package:icejoy/utils/enums.dart';
import 'package:icejoy/widgets/custom_text.dart';

import '../../utils/constants.dart';
import '../../widgets/login_container.dart';
import '../../widgets/login_textfield.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackgroundColor,
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          AuthController controller = Get.find<AuthController>();
          bool isIos = Get.find<AuthController>().isIos;
          double width = constraints.maxWidth;
          double height = constraints.maxHeight;

          return SizedBox(
            height: height,
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Column(
                children: [
                  Container(
                    alignment: FractionalOffset.bottomCenter,
                    height: height * 0.3,
                    width: width,
                    child: Image.asset(
                      'assets/images/main_logo.png',
                      scale: 1.5,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.7,
                    child: Column(
                      children: [
                        SizedBox(
                          height: height * 0.1,
                        ),
                        LoginContainer(
                          width: width * 0.85,
                          backgroundColor: greayMain,
                          child: LoginTextField(
                            type: TextInputType.emailAddress,
                            action: TextInputAction.next,
                            suffex: Icon(
                              isIos
                                  ? CupertinoIcons.mail
                                  : Icons.email_outlined,
                              color: purpleColor.withOpacity(0.8),
                            ),
                            controller: controller.emailController,
                            otp: false,
                            obscure: false,
                            hint: 'email'.tr,
                          ),
                        ),
                        GetBuilder<AuthController>(
                          init: controller,
                          builder: (builder) => LoginContainer(
                            width: width * 0.85,
                            backgroundColor: greayMain,
                            child: LoginTextField(
                              type: TextInputType.text,
                              action: TextInputAction.done,
                              suffex: isIos
                                  ? CupertinoButton(
                                      child: Icon(
                                          builder.isPasswordAbscured
                                              ? CupertinoIcons.eye_slash
                                              : CupertinoIcons.eye,
                                          color: purpleColor.withOpacity(0.8)),
                                      onPressed: () => builder.passAbscure(),
                                    )
                                  : IconButton(
                                      splashRadius: 15,
                                      onPressed: () => builder.passAbscure(),
                                      icon: Icon(
                                          builder.isPasswordAbscured
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility_outlined,
                                          color: blackColor)),
                              controller: controller.passWordController,
                              otp: false,
                              obscure: builder.isPasswordAbscured,
                              hint: 'password'.tr,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 24, horizontal: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: purpleColor.withOpacity(0.5),
                                  thickness: 2,
                                  height: 9,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0),
                                child: CustomText(
                                  text: 'or'.tr,
                                  color: purpleColor.withOpacity(0.5),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: purpleColor.withOpacity(0.5),
                                  thickness: 2,
                                  height: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: GestureDetector(
                                onTap: () =>
                                    controller.googleSignIn(context: context),
                                child: LoginContainer(
                                  shadow: true,
                                  border: true,
                                  width: width * 0.14,
                                  height: width * 0.14,
                                  backgroundColor: greayMain,
                                  child: Padding(
                                    padding: const EdgeInsets.all(14.0),
                                    child: Image.asset(
                                        'assets/images/google_logo.png'),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: GestureDetector(
                                onTap: () => controller.goToEmail(
                                    method: LoginMethod.phone),
                                child: LoginContainer(
                                  shadow: true,
                                  border: true,
                                  width: width * 0.14,
                                  height: width * 0.14,
                                  backgroundColor: greayMain,
                                  child: Padding(
                                    padding: const EdgeInsets.all(14.0),
                                    child: Icon(
                                      Icons.phone,
                                      color: purpleColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        SafeArea(
                          child: Column(
                            children: [
                              Container(
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
                                    builder: (build) => isIos
                                        ? CupertinoButton(
                                            color: purpleColor,
                                            borderRadius:
                                                BorderRadius.circular(10.0),
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
                                                controller.emailLogin(
                                                    context: context,
                                                    email: controller
                                                        .emailController.text
                                                        .trim(),
                                                    password: controller
                                                        .passWordController.text
                                                        .trim()),
                                          )
                                        : ElevatedButton(
                                            style: ButtonStyle(
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                              ),
                                            ),
                                            onPressed: () =>
                                                controller.emailLogin(
                                                    context: context,
                                                    email: controller
                                                        .emailController.text
                                                        .trim(),
                                                    password: controller
                                                        .passWordController.text
                                                        .trim()),
                                            child: build.loading
                                                ? CircularProgressIndicator(
                                                    color: whiteColor,
                                                  )
                                                : CustomText(
                                                    text: 'login'.tr,
                                                    align: TextAlign.left,
                                                  ),
                                          ),
                                  )),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20.0),
                                    child: CustomText(
                                      text: 'no_account'.tr,
                                      align: TextAlign.left,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20.0),
                                    child: GestureDetector(
                                      onTap: () => controller.goToEmail(
                                          method: LoginMethod.email),
                                      child: CustomText(
                                        text: 'signup_now'.tr,
                                        align: TextAlign.left,
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
