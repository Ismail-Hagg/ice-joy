import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icejoy/pages/login_page/auth_controller.dart';
import 'package:icejoy/widgets/custom_text.dart';

import '../../utils/constants.dart';
import '../../widgets/login_container.dart';
import '../../widgets/login_textfield.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        resizeToAvoidBottomInset: false,
        body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          AuthController controller = Get.find<AuthController>();
          bool isIos = Get.find<AuthController>().isIos;
          double width = constraints.maxWidth;
          double height = constraints.maxHeight;

          return SizedBox(
            height: height,
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
                          type: TextInputType.number,
                          action: TextInputAction.next,
                          suffex: Icon(
                            isIos ? CupertinoIcons.mail : Icons.email_outlined,
                            color: blackColor,
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
                            suffex: isIos
                                ? CupertinoButton(
                                    child: Icon(
                                      builder.isPasswordAbscured
                                          ? CupertinoIcons.eye_slash
                                          : CupertinoIcons.eye,
                                      color: blackColor,
                                    ),
                                    onPressed: () => builder.passAbscure(),
                                  )
                                : IconButton(
                                    onPressed: () => builder.passAbscure(),
                                    icon: Icon(
                                        builder.isPasswordAbscured
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: blackColor)),
                            controller: controller.emailController,
                            otp: false,
                            obscure: builder.isPasswordAbscured,
                            hint: 'password'.tr,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: width * 0.075,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                // print('thing');
                              },
                              child: CustomText(
                                text: 'forgot'.tr,
                                align: TextAlign.left,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 24, horizontal: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: greayMain,
                                thickness: 2,
                                height: 9,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: CustomText(
                                text: 'or'.tr,
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: greayMain,
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
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: LoginContainer(
                              shadow: true,
                              border: true,
                              width: width * 0.14,
                              height: width * 0.14,
                              backgroundColor: greayMain,
                              child: const Padding(
                                padding: EdgeInsets.all(14.0),
                                child: Icon(
                                  Icons.smartphone,
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
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(
                                color: shadowColor,
                                spreadRadius: 0.5,
                                blurRadius: 7,
                                offset: const Offset(3, 9),
                              ),
                            ]),
                            width: width * 0.85,
                            child: isIos
                                ? CupertinoButton.filled(
                                    child: CustomText(
                                      text: 'login'.tr,
                                      align: TextAlign.left,
                                    ),
                                    onPressed: () {},
                                  )
                                : ElevatedButton(
                                    onPressed: () {},
                                    child: CustomText(
                                      text: 'login'.tr,
                                      align: TextAlign.left,
                                    ),
                                  ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: CustomText(
                                  text: 'no_account'.tr,
                                  align: TextAlign.left,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: CustomText(
                                  text: 'signup_now'.tr,
                                  align: TextAlign.left,
                                ),
                              ),
                            ],
                          )
                        ],
                      ))
                    ],
                  ),
                )
              ],
            ),
          );
        }));
  }
}
