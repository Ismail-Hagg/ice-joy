import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icejoy/controllers/auth_controller.dart';
import 'package:icejoy/widgets/custom_text.dart';
import 'package:icejoy/widgets/login_container.dart';
import 'package:icejoy/widgets/login_textfield.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../utils/constants.dart';
import '../../utils/enums.dart';
import '../../widgets/avatar_widget.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackgroundColor,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          AuthController controller = Get.find<AuthController>();
          bool isIos = Get.find<AuthController>().isIos;
          double width = constraints.maxWidth;
          double height = constraints.maxHeight;

          return SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Row(
                      children: [
                        controller.isIos
                            ? CupertinoButton(
                                child: Icon(CupertinoIcons.back,
                                    color: blackColor),
                                onPressed: () => controller.userModel.method ==
                                            LoginMethod.google ||
                                        controller.userModel.method ==
                                            LoginMethod.phone
                                    ? controller.signOut()
                                    : {
                                        controller.controllerClear(),
                                        Get.back()
                                      },
                              )
                            : IconButton(
                                splashRadius: 15,
                                onPressed: () => controller.userModel.method ==
                                            LoginMethod.google ||
                                        controller.userModel.method ==
                                            LoginMethod.phone
                                    ? controller.signOut()
                                    : {
                                        controller.controllerClear(),
                                        Get.back()
                                      },
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: blackColor,
                                ))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GetBuilder<AuthController>(
                          init: Get.find<AuthController>(),
                          builder: (rain) => Stack(
                            children: [
                              GestureDetector(
                                onTap: () => rain.selectPic(),
                                child: Avatar(
                                  iconAndroid: Icons.person_outlined,
                                  iconIos: CupertinoIcons.person,
                                  iconColor: blackColor,
                                  iconSize: 35,
                                  backgroundColor: greayMain,
                                  shadow: rain.userModel.onlinePicPath == '' &&
                                          rain.userModel.localPicPath == ''
                                      ? false
                                      : true,
                                  height: width * 0.3,
                                  width: width * 0.3,
                                  isBorder:
                                      rain.userModel.onlinePicPath == '' &&
                                              rain.userModel.localPicPath == ''
                                          ? true
                                          : false,
                                  borderColor: blackColor,
                                  type: rain.userModel.onlinePicPath == '' &&
                                          rain.userModel.localPicPath == ''
                                      ? AvatarType.none
                                      : rain.userModel.onlinePicPath != '' &&
                                              rain.userModel.localPicPath == ''
                                          ? AvatarType.online
                                          : AvatarType.file,
                                  boxFit: BoxFit.cover,
                                  isIos: controller.isIos,
                                  link: rain.userModel.onlinePicPath == '' &&
                                          rain.userModel.localPicPath == ''
                                      ? null
                                      : rain.userModel.onlinePicPath != '' &&
                                              rain.userModel.localPicPath == ''
                                          ? rain.userModel.onlinePicPath
                                              .toString()
                                          : rain.userModel.localPicPath
                                              .toString(),
                                ),
                              ),
                              if (rain.userModel.onlinePicPath != '' ||
                                  rain.userModel.localPicPath != '') ...[
                                Positioned(
                                  bottom: 2,
                                  right: 5,
                                  child: GestureDetector(
                                    onTap: () => rain.delPic(),
                                    child: Avatar(
                                      iconAndroid:
                                          Icons.delete_forever_outlined,
                                      iconIos: CupertinoIcons.delete,
                                      iconColor: blackColor,
                                      iconSize: 16,
                                      backgroundColor: appBackgroundColor,
                                      height: width * 0.06,
                                      width: width * 0.06,
                                      isBorder: true,
                                      type: AvatarType.none,
                                      boxFit: BoxFit.cover,
                                      shadow: false,
                                      borderColor: blackColor,
                                    ),
                                  ),
                                )
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0.0),
                      child: Column(
                        children: [
                          SizedBox(
                            width: width * 0.85,
                            child: CustomText(text: 'phone'.tr),
                          ),
                          LoginContainer(
                            border: true,
                            width: width * 0.85,
                            backgroundColor: greayMain,
                            child: controller.userModel.method ==
                                    LoginMethod.phone
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 18),
                                    child: CustomText(
                                        text: controller.userModel.phoneNumber
                                            .toString()),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0),
                                    child: InternationalPhoneNumberInput(
                                      keyboardAction: TextInputAction.next,
                                      keyboardType: TextInputType.number,
                                      hintText: '',
                                      initialValue: PhoneNumber(
                                          isoCode: 'SA',
                                          phoneNumber:
                                              controller.userModel.phoneNumber,
                                          dialCode: '+966'),
                                      inputBorder: InputBorder.none,
                                      cursorColor: Colors.transparent,
                                      autoValidateMode:
                                          AutovalidateMode.disabled,
                                      selectorConfig: const SelectorConfig(
                                          selectorType:
                                              PhoneInputSelectorType.DIALOG,
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
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Column(
                        children: [
                          SizedBox(
                              width: width * 0.85,
                              child: CustomText(text: 'username'.tr)),
                          LoginContainer(
                            width: width * 0.85,
                            backgroundColor: greayMain,
                            child: LoginTextField(
                              otp: false,
                              controller: controller.userNameController,
                              obscure: false,
                              type: TextInputType.text,
                              action: TextInputAction.next,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Column(
                        children: [
                          SizedBox(
                              width: width * 0.85,
                              child: Row(
                                children: [
                                  CustomText(text: 'email'.tr),
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                  if (controller.userModel.method !=
                                      LoginMethod.email) ...[
                                    CustomText(text: 'optional'.tr)
                                  ],
                                ],
                              )),
                          LoginContainer(
                            width: width * 0.85,
                            backgroundColor: greayMain,
                            child: LoginTextField(
                              otp: false,
                              controller: controller.emailController,
                              obscure: false,
                              type: TextInputType.emailAddress,
                              action: TextInputAction.next,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (controller.userModel.method == LoginMethod.email) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Column(
                          children: [
                            SizedBox(
                                width: width * 0.85,
                                child: Row(
                                  children: [
                                    CustomText(text: 'password'.tr),
                                    SizedBox(
                                      width: width * 0.02,
                                    ),
                                  ],
                                )),
                            LoginContainer(
                              width: width * 0.85,
                              backgroundColor: greayMain,
                              child: LoginTextField(
                                otp: false,
                                controller: controller.passWordController,
                                obscure: false,
                                type: TextInputType.emailAddress,
                                action: TextInputAction.done,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        children: [
                          SizedBox(
                              width: width * 0.85,
                              child: CustomText(text: 'birth'.tr)),
                          GestureDetector(
                            onTap: () => controller.setBirth(
                                width: width,
                                isIos: isIos,
                                context: context,
                                height: height,
                                color: Colors.transparent),
                            child: LoginContainer(
                              border: true,
                              width: width * 0.85,
                              backgroundColor: greayMain,
                              child: Row(
                                children: [
                                  isIos
                                      ? CupertinoButton(
                                          child: const Icon(
                                              CupertinoIcons.calendar),
                                          onPressed: () => controller.setBirth(
                                              width: width,
                                              isIos: isIos,
                                              context: context,
                                              height: height,
                                              color: Colors.transparent),
                                        )
                                      : IconButton(
                                          splashRadius: 15,
                                          onPressed: () => controller.setBirth(
                                              isIos: isIos,
                                              width: width,
                                              context: context,
                                              height: height * 0.1,
                                              color: whiteColor),
                                          icon:
                                              const Icon(Icons.calendar_month),
                                        ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: GetBuilder<AuthController>(
                                      init: Get.find<AuthController>(),
                                      builder: (build) => CustomText(
                                        text:
                                            build.userModel.birthday.toString(),
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        children: [
                          GetBuilder<AuthController>(
                            init: Get.find<AuthController>(),
                            builder: (build) => Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: width * 0.075, right: width * 0.1),
                                  child: CustomText(
                                    text: 'gender'.tr,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  child: GestureDetector(
                                    onTap: () =>
                                        build.setGender(gender: Gender.male),
                                    child: Chip(
                                      shadowColor: shadowColor,
                                      elevation:
                                          build.userModel.gender == Gender.male
                                              ? 5
                                              : 0,
                                      side: BorderSide(
                                          color: build.userModel.gender ==
                                                  Gender.male
                                              ? greyAccent
                                              : greyAccent.withOpacity(0.5)),
                                      padding: const EdgeInsets.all(12.0),
                                      label: CustomText(
                                        text: 'male'.tr,
                                        color: build.userModel.gender ==
                                                Gender.male
                                            ? blackColor
                                            : blackColor.withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6.0),
                                  child: GestureDetector(
                                    onTap: () =>
                                        build.setGender(gender: Gender.female),
                                    child: Chip(
                                      side: BorderSide(
                                          color: build.userModel.gender ==
                                                  Gender.female
                                              ? greyAccent
                                              : greyAccent.withOpacity(0.5)),
                                      elevation: build.userModel.gender ==
                                              Gender.female
                                          ? 5
                                          : 0,
                                      padding: const EdgeInsets.all(12.0),
                                      label: CustomText(
                                        text: 'female'.tr,
                                        color: build.userModel.gender ==
                                                Gender.female
                                            ? blackColor
                                            : blackColor.withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: controller.userModel.method ==
                                        LoginMethod.email
                                    ? width * 0.1
                                    : width * 0.2),
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
                                        onPressed: () => build.completeLogin(
                                            context: context),
                                      )
                                    : ElevatedButton(
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                          ),
                                        ),
                                        onPressed: () => build.completeLogin(
                                            context: context),
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
