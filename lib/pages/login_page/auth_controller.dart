import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:icejoy/pages/login_page/info_page.dart';
import 'package:icejoy/pages/login_page/otp_page.dart';
import 'package:icejoy/pages/view_controller.dart';
import 'package:icejoy/services/firebase_services.dart';
import 'package:intl/intl.dart';
import 'package:phone_number/phone_number.dart';
import '../../local_storage/local_data_pref.dart';
import '../../models/user_model.dart';
import '../../utils/enums.dart';
import '../../utils/functions.dart';

class AuthController extends GetxController {
  final bool isIos;
  UserModel _userModel;
  AuthController(this._userModel, {required this.isIos});
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Rxn<User> _user = Rxn<User>();
  User? get user => _user.value;

  final TextEditingController _userNameController = TextEditingController();
  TextEditingController get userNameController => _userNameController;

  final TextEditingController _emailController = TextEditingController();
  TextEditingController get emailController => _emailController;

  final TextEditingController _passWordController = TextEditingController();
  TextEditingController get passWordController => _passWordController;

  bool _isPasswordAbscured = true;
  bool get isPasswordAbscured => _isPasswordAbscured;

  bool _loading = false;
  bool get loading => _loading;

  UserModel get userModel => _userModel;

  @override
  void onInit() {
    super.onInit();
    _user.bindStream(_auth.authStateChanges());
    _userNameController.text = _userModel.userName ?? '';
    _emailController.text = _userModel.email ?? '';
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    _emailController.dispose();
    _userNameController.dispose();
    passWordController.dispose();
  }

  // controll the password textfield abscured or not
  void passAbscure() {
    _isPasswordAbscured = !_isPasswordAbscured;
    update();
  }

  // google sign in method
  void googleSignIn({required BuildContext context}) async {
    await GoogleSignIn().signIn().then((value) async {
      if (value != null) {
        _loading = true;
        update();
        try {
          final GoogleSignInAuthentication gAuth = await value.authentication;

          final credential = GoogleAuthProvider.credential(
              accessToken: gAuth.accessToken, idToken: gAuth.idToken);
          await _auth.signInWithCredential(credential).then((user) =>
              handleUser(
                  user: user, method: LoginMethod.google, context: context));
        } on FirebaseAuthException catch (e) {
          _loading = false;
          update();
          await showOkAlertDialog(
            context: context,
            title: 'error'.tr,
            message: getMessageFromErrorCode(errorMessage: e.code),
          );
        } catch (e) {
          _loading = false;
          update();
          await showOkAlertDialog(
            context: context,
            title: 'error'.tr,
            message: getMessageFromErrorCode(errorMessage: e.toString()),
          );
        }
      }
    });
  }

  //phone auth
  void phoneAuth(
      {required String phoneNumber,
      required BuildContext context,
      required LoginMethod method}) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (credential) async {
          if (method == LoginMethod.phone) {
            _loading = false;
            update();

            // await _auth.signInWithCredential(credential).then((value) {
            //   // move to info
            // });
          } else {
            _userModel.state = LogState.full;
            _loading = false;
            Get.offAll(() => const ControllPage());
          }
          print('================= verificationCompleted =============');
        },
        verificationFailed: (e) async {
          _loading = false;
          update();
          print('================= verificationFailed =============');
          print(e.code);
          await showOkAlertDialog(
              context: context,
              title: 'error'.tr,
              // message: getMessageFromErrorCode(
              //   errorMessage: e.toString(),
              // ),
              message: e.toString());
        },
        codeSent: (verificationId, resendToken) async {
          print('================= codeSent =============');
          _loading = false;
          update();
          Get.to(() => OtpPage(verificationId: verificationId));
        },
        codeAutoRetrievalTimeout: (verificationId) {
          print(verificationId);
          print('================= codeAutoRetrievalTimeout =============');
        },
      );
    } on FirebaseAuthException catch (e) {
      await showOkAlertDialog(
          context: context,
          title: 'error'.tr,
          // message: getMessageFromErrorCode(
          //   errorMessage: e.toString(),
          // ),
          message: e.code);
    } catch (e) {
      await showOkAlertDialog(
          context: context,
          title: 'error'.tr,
          // message: getMessageFromErrorCode(
          //   errorMessage: e.toString(),
          // ),
          message: e.toString());
    }
  }

  // verify otp
  void verifyOtp(
      {required String otp,
      required String verificationId,
      required BuildContext context}) async {
    _loading = true;
    update();
    try {
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otp);
      await _auth.signInWithCredential(creds).then((value) {
        _userModel.state = LogState.full;
        saveUserDataLocally(model: _userModel).then((value) async {
          if (value) {
            _loading = false;
            Get.offAll(() => const ControllPage());
          } else {
            await showOkAlertDialog(
                context: context,
                title: 'error'.tr,
                // message: getMessageFromErrorCode(
                //   errorMessage: e.toString(),
                // ),
                message: 'firelogin'.tr);
          }
        });
      });

      // await _auth.signInWithCredential(creds).then(
      //   (value) {
      //     _userModel.state = LogState.full;
      //     update();
      //   },
      // );
    } on FirebaseAuthException catch (e) {
      await showOkAlertDialog(
          context: context,
          title: 'error'.tr,
          // message: getMessageFromErrorCode(
          //   errorMessage: e.toString(),
          // ),
          message: e.code);
    } catch (e) {
      await showOkAlertDialog(
        context: context,
        title: 'error'.tr,
        // message: getMessageFromErrorCode(
        //   errorMessage: e.toString(),
        // ),
        message: e.toString(),
      );
    }
  }

  // handle user after login
  void handleUser(
      {required UserCredential user,
      required LoginMethod method,
      required BuildContext context}) {
    // check if user exists

    FirebaseServices()
        .getCurrentUser(userId: user.user!.uid)
        .then((value) async {
      if (value.data() != null) {
        // old user
      } else {
        // new user

        _userModel = UserModel(
            userName: user.user!.displayName ?? '',
            email: user.user!.email ?? '',
            onlinePicPath: user.user!.photoURL ?? '',
            localPicPath: '',
            userId: user.user!.uid,
            language: Get.deviceLocale.toString().substring(0, 2) == 'en'
                ? 'en_US'
                : Get.deviceLocale.toString().substring(0, 2) == 'ar'
                    ? 'ar_SA'
                    : 'ar_SA',
            isError: false,
            messagingToken: '',
            errorMessage: '',
            state: LogState.info,
            gender: Gender.undecided,
            phoneNumber: user.user!.phoneNumber ?? '',
            birthday: '',
            method: method,
            points: 0);
        await saveUserDataLocally(model: _userModel).then(
          (value) async {
            if (value) {
              _userNameController.text = _userModel.userName ?? '';
              _emailController.text = _userModel.email ?? '';
              _loading = false;
              Get.offAll(() => const ControllPage());
            } else {
              await showOkAlertDialog(
                context: context,
                title: 'error'.tr,
                message: 'firelogin'.tr,
              );
              _loading = false;
              signOut();
            }
          },
        );
      }
    });
  }

  // complete login process
  void completeLogin(
      {required LoginMethod method, required BuildContext context}) async {
    FocusScope.of(context).unfocus();
    //if(){}else{}
    switch (method) {
      case LoginMethod.google:
        if (_userModel.phoneNumber == '' ||
            _userNameController.text == '' ||
            _userModel.birthday == '' ||
            _userModel.gender == Gender.undecided) {
          // tell user to complete info
          await showOkAlertDialog(
            context: context,
            title: 'error'.tr,
            message: 'complete'.tr,
          );
        } else {
          _loading = true;
          update();

          // fill user model with new info and save it locally
          _userModel = UserModel(
              userName: _userNameController.text,
              email: _emailController.text,
              onlinePicPath: _userModel.onlinePicPath,
              localPicPath: _userModel.localPicPath,
              userId: _userModel.userId,
              language: _userModel.language,
              isError: false,
              messagingToken: _userModel.messagingToken,
              state: LogState.info,
              gender: _userModel.gender,
              phoneNumber: _userModel.phoneNumber,
              birthday: _userModel.birthday,
              errorMessage: '',
              method: method,
              points: 0);

          // take user to otp page
          phoneAuth(
              phoneNumber: _userModel.phoneNumber.toString(),
              context: context,
              method: method);
          // _loading = false;

          //Get.to(() => const OtpPage());
        }
        break;
      default:
    }
  }

  // click on create account
  void goToEmail() {
    _userModel = UserModel(
        isError: false,
        method: LoginMethod.email,
        birthday: '',
        onlinePicPath: '',
        localPicPath: '');
    Get.to(() => const InfoPage());
  }

  void alert(BuildContext context) async {
    await showOkAlertDialog(
        context: context,
        message: 'This is message.',
        useActionSheetForIOS: true);
  }

  // save user data locally
  Future<bool> saveUserDataLocally({required UserModel model}) async {
    return await DataPref().setUser(model);
  }

  void setBirth(
      {required bool isIos,
      required BuildContext context,
      required double height,
      required double width,
      required Color color}) {
    FocusScope.of(context).unfocus();
    datePicker(
      isIos: isIos,
      context: context,
      height: height * 0.4,
      width: width,
    );
  }

  // set birthdate in usermodel
  void moedelBirth({required DateTime time}) {
    _userModel.birthday = DateFormat('yyyy-MM-dd').format(time);
    update();
  }

  // set phone numbrt in usermodel
  void moedelPhone({required String phone}) {
    _userModel.phoneNumber =
        phone.trim() == '' || phone.trim() == '+966' ? '' : phone.trim();
  }

  // set gender in model
  void setGender({required Gender gender}) {
    _userModel.gender = gender;
    update();
  }

  void flipLang() {
    if (_userModel.language == 'ar') {
      Get.updateLocale(const Locale('en_US'));
      _userModel.language = 'en';
      update();
    } else {
      Get.updateLocale(const Locale('ar_SA'));
      _userModel.language = 'ar';
      update();
    }
  }

  // remove selected pic from info page
  void delPic() async {
    _userModel.onlinePicPath = '';
    _userModel.localPicPath = '';
    await saveUserDataLocally(model: _userModel);
    update();
  }

  //

  // select pic from device
  void selectPic() async {
    if (_userModel.localPicPath == '' && _userModel.onlinePicPath == '') {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          allowMultiple: false,
          type: FileType.custom,
          allowedExtensions: ['png', 'jpg', 'jpeg']);

      if (result != null) {
        _userModel.localPicPath = result.files.single.path.toString();
        await saveUserDataLocally(model: _userModel);
        update();
      }
    }
  }

  // clear text controllers
  void controllerClear() {
    _emailController.clear();
    _passWordController.clear();
    _userNameController.clear;
  }

  // logout
  void signOut() async {
    await GoogleSignIn().signOut();
    await _auth.signOut();
    await DataPref().deleteUser();
    controllerClear();
    update();
  }

  void thingy(String num) async {
    RegionInfo region = RegionInfo(name: 'SA', code: 'SA', prefix: 2);
    // PhoneNumber phoneNumber =
    //     await PhoneNumberUtil().parse(num, regionCode: region.code);
    // print('=====================');
    // print(phoneNumber);

    await PhoneNumberUtil()
        .validate(num, regionCode: region.code)
        .then((value) => print('Validity : $value'));
  }
}
