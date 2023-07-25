import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:icejoy/pages/login_page/info_page.dart';
import 'package:icejoy/pages/view_controller.dart';
import 'package:icejoy/services/firebase_services.dart';
import 'package:intl/intl.dart';
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
          await _auth.signInWithCredential(credential).then((user) {
            FirebaseServices()
                .getCurrentUser(userId: user.user!.uid)
                .then((value) async {
              if (value.data() != null) {
                // old user
                // get and save user data and route to home page
                _loading = false;
                update();
              } else {
                // new user
                // route to info page

                _userModel = UserModel(
                    userName: user.user!.displayName ?? '',
                    email: user.user!.email ?? '',
                    onlinePicPath: user.user!.photoURL ?? '',
                    localPicPath: '',
                    userId: user.user!.uid,
                    language: Get.deviceLocale.toString().substring(0, 2) ==
                            'en'
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
                    method: LoginMethod.google,
                    points: 0);
                await saveUserDataLocally(model: _userModel)
                    .then((value) async {
                  if (value) {
                    _loading = false;
                    _emailController.text = _userModel.email.toString();
                    _userNameController.text = _userModel.userName.toString();
                    Get.offAll(() => const ControllPage());
                  } else {
                    await showOkAlertDialog(
                      context: context,
                      title: 'error'.tr,
                      message: 'firelogin'.tr,
                    );
                    signOut();
                  }
                });

                _loading = false;
                update();
              }
            });
          });
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
  void delPic() {
    _userModel.onlinePicPath = '';
    _userModel.localPicPath = '';
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
        update();
      }
    }
  }

  // logout
  void signOut() async {
    await GoogleSignIn().signOut();
    await _auth.signOut();
    await DataPref().deleteUser();
    _emailController.clear();
    _passWordController.clear();
    _userNameController.clear;
    update();
  }
}
