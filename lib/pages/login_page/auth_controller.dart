import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:icejoy/pages/login_page/info_page.dart';
import 'package:icejoy/pages/login_page/otp_page.dart';
import 'package:icejoy/pages/login_page/pre_otp_page.dart';
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

  String _phoneCountry = '';
  String get phoneCountry => _phoneCountry;

  @override
  void onInit() {
    super.onInit();
    _user.bindStream(_auth.authStateChanges());
    _userNameController.text = _userModel.userName ?? '';
    _emailController.text = _userModel.email ?? '';
  }

  @override
  void onClose() {
    super.onClose();
    _emailController.dispose();
    _userNameController.dispose();
    _passWordController.dispose();
  }

  // controll the password textfield abscured or not
  void passAbscure() {
    _isPasswordAbscured = !_isPasswordAbscured;
    update();
  }

  // handle user after login
  Future<bool> isNewUser({
    required String user,
  }) async {
    // check if user exists

    var thing = await FirebaseServices().getCurrentUser(userId: user);
    if (thing.exists) {
      _userModel = UserModel.fromMap(thing.data() as Map<String, dynamic>);
      saveUserDataLocally(model: _userModel);
    }
    return !thing.exists;
  }

  // complete login process
  void completeLogin({required BuildContext context}) async {
    FocusScope.of(context).unfocus();
    _loading = true;
    update();

    switch (_userModel.method) {
      case LoginMethod.google:
        compGoogle(context: context);
        break;

      case LoginMethod.email:
        compEmail(context: context);
        break;

      default:
        compPhone(context: context);
    }
  }

  // click on create account
  void goToEmail({required LoginMethod method}) {
    _userModel = UserModel(
        userName: '',
        email: '',
        userId: '',
        language: languageDev(),
        isError: false,
        method: method,
        birthday: '',
        onlinePicPath: '',
        messagingToken: '',
        state: LogState.none,
        gender: Gender.undecided,
        phoneNumber: '',
        errorMessage: '',
        points: 0,
        localPicPath: '');
    Get.to(
        () => method == LoginMethod.email ? const InfoPage() : const PreOtp());
  }

  // set user birthdate
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
  void moedelPhone({required String phone, required String country}) {
    _userModel.phoneNumber =
        phone.trim() == '' || phone.trim() == '+966' ? '' : phone.trim();
    _phoneCountry = country;
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
    _userNameController.clear();

    _userModel = UserModel();
  }

  // logout
  void signOut() async {
    await GoogleSignIn().signOut();
    await _auth.signOut();
    await DataPref().deleteUser();
    controllerClear();
    update();
  }

  // login with only phone
  void phoneLogin({required BuildContext context}) async {
    FocusScope.of(context).unfocus();
    _loading = true;
    update();

    if (_userModel.phoneNumber == '') {
      _loading = false;
      update();
      await showOkAlertDialog(
        context: context,
        title: 'error'.tr,
        message: 'enterphone'.tr,
      );
    } else {
      await phoneValid(
              phone: _userModel.phoneNumber.toString(), country: _phoneCountry)
          .then((value) async {
        if (value) {
          phoneAuth(
              phoneNumber: _userModel.phoneNumber.toString(),
              context: context,
              method: _userModel.method as LoginMethod);
        } else {
          _loading = false;
          update();
          await showOkAlertDialog(
            context: context,
            title: 'error'.tr,
            message: 'badphone'.tr,
          );
        }
      });
    }
  }

  // check if phone number is valid
  Future<bool> phoneValid(
      {required String phone, required String country}) async {
    RegionInfo region = RegionInfo(name: country, code: country, prefix: 2);

    return await PhoneNumberUtil().validate(phone, regionCode: region.code);
  }

  // complete login google
  void compGoogle({required BuildContext context}) async {
    if (_userModel.phoneNumber == '' ||
        _userNameController.text.trim() == '' ||
        _userModel.birthday == '' ||
        _userModel.gender == Gender.undecided) {
      // tell user to complete info
      _loading = false;
      update();
      await showOkAlertDialog(
        context: context,
        title: 'error'.tr,
        message: 'complete'.tr,
      );
    } else {
      await phoneValid(
              phone: _userModel.phoneNumber.toString(), country: _phoneCountry)
          .then((value) async {
        if (!value) {
          _loading = false;
          update();
          await showOkAlertDialog(
            context: context,
            title: 'error'.tr,
            message: 'badphone'.tr,
          );
        } else {
          // fill user model with new info and save it locally
          _userModel.userName = _userNameController.text.trim();
          _userModel.email = _emailController.text.trim();
          _userModel.state = LogState.info;

          await saveUserDataLocally(model: _userModel).then((done) async {
            if (done) {
              phoneAuth(
                  phoneNumber: _userModel.phoneNumber.toString(),
                  context: context,
                  method: _userModel.method as LoginMethod);
            } else {
              _loading = false;
              update();
              await showOkAlertDialog(
                context: context,
                title: 'error'.tr,
                message: 'firelogin'.tr,
              );
            }
          });
        }
      });
    }
  }

  // conmplete login phone
  void compPhone({required BuildContext context}) async {
    if (_userNameController.text.trim() == '' ||
        _userModel.birthday == '' ||
        _userModel.gender == Gender.undecided) {
      // tell user to complete info
      _loading = false;
      update();
      await showOkAlertDialog(
        context: context,
        title: 'error'.tr,
        message: 'complete'.tr,
      );
    } else {
      // user data conpleted , save locally then send to database and upload picture if necessary
      _userModel.userName = _userNameController.text.trim();
      _userModel.state = LogState.full;
      await saveUserDataLocally(model: _userModel).then((done) async {
        if (done) {
          _loading = false;
          Get.offAll(() => const ControllPage());

          await uploadUser(model: _userModel).then((_) async {
            if (_userModel.localPicPath != '' &&
                _userModel.onlinePicPath == '') {
              await uploadeImage(
                      fileName: 'images/profile',
                      id: _userModel.userId.toString(),
                      file: _userModel.localPicPath.toString())
                  .then((value) {
                _userModel.onlinePicPath = value;
                saveUserDataLocally(model: _userModel).then((value) async {
                  if (value) {
                    await FirebaseServices().userUpdate(
                        userId: _userModel.userId.toString(),
                        map: {'onlinePicPath': _userModel.onlinePicPath});
                  }
                });
              }).onError((error, stackTrace) async {
                _userModel.state = LogState.info;
                await saveUserDataLocally(model: _userModel)
                    .then((value) => Get.offAll(() => const ControllPage()));
              });
            }
          });
        } else {
          _loading = false;
          update();
          await showOkAlertDialog(
            context: context,
            title: 'error'.tr,
            message: 'firelogin'.tr,
          );
        }
      });
    }
  }

  // complete login email
  void compEmail({required BuildContext context}) async {
    if (_userModel.phoneNumber == '' ||
        _userNameController.text.trim() == '' ||
        _userModel.birthday == '' ||
        _emailController.text.trim() == '' ||
        _passWordController.text.trim() == '' ||
        _userModel.gender == Gender.undecided) {
      // tell user to complete info
      _loading = false;
      update();
      await showOkAlertDialog(
        context: context,
        title: 'error'.tr,
        message: 'complete'.tr,
      );
    } else {
      // check if the phone number is valid
      await phoneValid(
              phone: _userModel.phoneNumber.toString(), country: _phoneCountry)
          .then((value) async {
        if (!value) {
          // tell user number is not valid
          _loading = false;
          update();
          await showOkAlertDialog(
            context: context,
            title: 'error'.tr,
            message: 'badphone'.tr,
          );
        } else {
          // continue login
          await emailSignup(
                  context: context,
                  email: _emailController.text.trim(),
                  password: _passWordController.text.trim())
              .then((res) async {
            if (res) {
              await saveUserDataLocally(model: _userModel).then((done) async {
                if (done) {
                  phoneAuth(
                      phoneNumber: _userModel.phoneNumber.toString(),
                      context: context,
                      method: _userModel.method as LoginMethod);
                } else {
                  _loading = false;
                  update();
                  await showOkAlertDialog(
                    context: context,
                    title: 'error'.tr,
                    message: 'firelogin'.tr,
                  );
                }
              });
            } else {
              _loading = false;
              update();
              await showOkAlertDialog(
                context: context,
                title: 'error'.tr,
                message: 'firelogin'.tr,
              );
            }
          });
        }
      });
    }
  }

  // save user data locally
  Future<bool> saveUserDataLocally({required UserModel model}) async {
    return await DataPref().setUser(model);
  }

  // google sign in method
  void googleSignIn({required BuildContext context}) async {
    await GoogleSignIn().signIn().then(
      (value) async {
        if (value != null) {
          _loading = true;
          update();
          try {
            final GoogleSignInAuthentication gAuth = await value.authentication;

            final credential = GoogleAuthProvider.credential(
                accessToken: gAuth.accessToken, idToken: gAuth.idToken);
            await _auth.signInWithCredential(credential).then(
              (user) async {
                await isNewUser(user: user.user!.uid).then(
                  (newUser) async {
                    if (newUser) {
                      // new user
                      _userModel = UserModel(
                          userName: user.user!.displayName ?? '',
                          email: user.user!.email ?? '',
                          onlinePicPath: user.user!.photoURL ?? '',
                          localPicPath: '',
                          userId: user.user!.uid,
                          language: languageDev(),
                          isError: false,
                          messagingToken: '',
                          errorMessage: '',
                          state: LogState.info,
                          gender: Gender.undecided,
                          phoneNumber: user.user!.phoneNumber ?? '',
                          birthday: '',
                          method: LoginMethod.google,
                          points: 0);
                      await saveUserDataLocally(model: _userModel).then(
                        (value) async {
                          if (value) {
                            _userNameController.text =
                                _userModel.userName.toString();
                            _emailController.text = _userModel.email.toString();
                            _loading = false;
                            Get.offAll(() => const ControllPage());
                          } else {
                            _loading = false;
                            update();
                            await showOkAlertDialog(
                              context: context,
                              title: 'error'.tr,
                              message: 'firelogin'.tr,
                            );
                            signOut();
                          }
                        },
                      );
                    } else {
                      // old user
                      _loading = false;
                      Get.offAll(() => const ControllPage());
                    }
                  },
                );
              },
            );
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
      },
    );
  }

  // login with email and password
  void emailLogin(
      {required String email,
      required String password,
      required BuildContext context}) async {
    _loading = true;
    update();

    if (email == '' || password == '') {
      _loading = false;
      update();
      await showOkAlertDialog(
        context: context,
        title: 'error'.tr,
        message: 'complete'.tr,
      );
    } else {
      try {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((user) async {
          FirebaseServices()
              .getCurrentUser(userId: user.user!.uid.toString())
              .then((value) {
            _userModel =
                UserModel.fromMap(value.data() as Map<String, dynamic>);
            saveUserDataLocally(model: _userModel).then((done) async {
              if (done) {
                _loading = false;
                Get.offAll(() => const ControllPage());
              } else {
                _loading = false;
                update();
                await showOkAlertDialog(
                  context: context,
                  title: 'error'.tr,
                  message: 'firelogin'.tr,
                );
              }
            });
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
  }

  // login with email and password
  Future<bool> emailSignup(
      {required BuildContext context,
      required String email,
      required String password}) async {
    late bool res;
    _loading = true;
    update();
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then(
        (user) async {
          _userModel.email = user.user!.email;
          _userModel.userName = _userNameController.text;
          _userModel.userId = user.user!.uid;
          res = true;
        },
      );
    } on FirebaseAuthException catch (e) {
      _loading = false;
      update();
      res = false;
      await showOkAlertDialog(
        context: context,
        title: 'error'.tr,
        message: getMessageFromErrorCode(errorMessage: e.code),
      );
    } catch (e) {
      _loading = false;
      update();
      res = false;
      await showOkAlertDialog(
        context: context,
        title: 'error'.tr,
        message: getMessageFromErrorCode(errorMessage: e.toString()),
      );
    }
    return res;
  }

  //login with phone number
  void phoneAuth(
      {required String phoneNumber,
      required BuildContext context,
      required LoginMethod method}) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (credential) async {
          _loading = true;
          update();

          await _auth.signInWithCredential(credential).then(
            (user) async {
              if (_userModel.method == LoginMethod.phone) {
                await isNewUser(user: user.user!.uid).then(
                  (value) {
                    if (value) {
                      _userModel.userId = user.user!.uid;
                      _userModel.state = LogState.info;
                      saveUserDataLocally(model: _userModel).then(
                        (value) async {
                          if (value) {
                            _loading = false;
                            Get.to(() => const ControllPage());
                          } else {
                            _loading = false;
                            update();
                            await showOkAlertDialog(
                              context: context,
                              title: 'error'.tr,
                              message: 'firelogin'.tr,
                            );
                            Get.back();
                          }
                        },
                      );
                    } else {
                      // user already exists
                      // user model is taken care of in the isNewUser method , just route
                      _loading = false;
                      Get.to(() => const ControllPage());
                    }
                  },
                );
              } else {
                _userModel.state = LogState.full;
                await saveUserDataLocally(model: _userModel)
                    .then((value) async {
                  if (value) {
                    _loading = false;
                    Get.offAll(() => const ControllPage());
                    await uploadUser(model: _userModel).then((_) async {
                      if (_userModel.localPicPath != '' &&
                          _userModel.onlinePicPath == '') {
                        await uploadeImage(
                                fileName: 'images/profile',
                                id: _userModel.userId.toString(),
                                file: _userModel.localPicPath.toString())
                            .then((value) {
                          _userModel.onlinePicPath = value;
                          saveUserDataLocally(model: _userModel)
                              .then((value) async {
                            if (value) {
                              await FirebaseServices().userUpdate(
                                  userId: _userModel.userId.toString(),
                                  map: {
                                    'onlinePicPath': _userModel.onlinePicPath
                                  });
                            }
                          });
                        }).onError((error, stackTrace) async {
                          _userModel.state = LogState.info;
                          await saveUserDataLocally(model: _userModel).then(
                              (value) =>
                                  Get.offAll(() => const ControllPage()));
                        });
                      }
                    });
                  } else {
                    _loading = false;
                    update();
                    await showOkAlertDialog(
                      context: context,
                      title: 'error'.tr,
                      message: 'firelogin'.tr,
                    );
                    Get.back();
                  }
                });
              }
            },
          );
        },
        verificationFailed: (e) async {
          _loading = false;
          update();
          await showOkAlertDialog(
              context: context, title: 'error'.tr, message: e.message);
        },
        codeSent: (verificationId, resendToken) async {
          _loading = false;
          update();
          Get.to(() => OtpPage(verificationId: verificationId));
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      await showOkAlertDialog(
        context: context,
        title: 'error'.tr,
        message: getMessageFromErrorCode(errorMessage: e.code),
      );
    } catch (e) {
      await showOkAlertDialog(
          context: context, title: 'error'.tr, message: e.toString());
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
      await _auth.signInWithCredential(creds).then(
        (user) async {
          // if coming from phone auth
          if (_userModel.method == LoginMethod.phone) {
            // check if new user
            // make stato info to route to the info page
            // save data locally
            await isNewUser(user: user.user!.uid).then(
              (value) {
                if (value) {
                  _userModel.userId = user.user!.uid;
                  _userModel.state = LogState.info;
                  saveUserDataLocally(model: _userModel).then(
                    (value) async {
                      if (value) {
                        _loading = false;
                        Get.offAll(() => const ControllPage());
                      } else {
                        _loading = false;
                        update();
                        await showOkAlertDialog(
                          context: context,
                          title: 'error'.tr,
                          message: 'firelogin'.tr,
                        );
                        Get.back();
                      }
                    },
                  );
                } else {
                  // user already exists
                  // user model is taken care of in the isNewUser method , just route
                  _loading = false;
                  Get.to(() => const ControllPage());
                }
              },
            );
          } else {
            // coming fron google login or email
            // state is full to route to home page
            // save data locally and route
            // send data to firestore then upload the image if necessary

            _userModel.state = LogState.full;
            await saveUserDataLocally(model: _userModel).then((value) async {
              if (value) {
                _loading = false;
                Get.offAll(() => const ControllPage());
                await uploadUser(model: _userModel).then((_) async {
                  if (_userModel.localPicPath != '' &&
                      _userModel.onlinePicPath == '') {
                    await uploadeImage(
                            fileName: 'images/profile',
                            id: _userModel.userId.toString(),
                            file: _userModel.localPicPath.toString())
                        .then((value) {
                      _userModel.onlinePicPath = value;
                      saveUserDataLocally(model: _userModel)
                          .then((value) async {
                        if (value) {
                          await FirebaseServices().userUpdate(
                              userId: _userModel.userId.toString(),
                              map: {'onlinePicPath': _userModel.onlinePicPath});
                        }
                      });
                    }).onError((error, stackTrace) async {
                      _userModel.state = LogState.info;
                      await saveUserDataLocally(model: _userModel).then(
                          (value) => Get.offAll(() => const ControllPage()));
                    });
                  }
                });
              } else {
                _loading = false;
                update();
                await showOkAlertDialog(
                  context: context,
                  title: 'error'.tr,
                  message: 'firelogin'.tr,
                );
                Get.back();
              }
            });
          }
        },
      );
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
        message: e.toString(),
      );
    }
  }

  // upload user data to firestore
  Future<void> uploadUser({required UserModel model}) async {
    await FirebaseServices().addUsers(model);
  }

  // uploading image to firebase storage
  Future<String> uploadeImage(
      {required String id,
      required String file,
      required String fileName}) async {
    UploadTask? uploadTask;
    final String path = '$id/$fileName';
    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(File(file));
    final snapshot = await uploadTask.whenComplete(() => {});
    return await snapshot.ref.getDownloadURL();
  }
}
