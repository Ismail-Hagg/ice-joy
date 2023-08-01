import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:icejoy/controllers/auth_controller.dart';
import 'package:icejoy/models/user_model.dart';

import '../services/firebase_services.dart';

class HomeController extends GetxController {
  final UserModel _usderModel = Get.find<AuthController>().userModel;
  UserModel get userModel => _usderModel;

  final bool _isIos = Get.find<AuthController>().isIos;
  bool get isIos => _isIos;

  final FirebaseMessaging fcm = FirebaseMessaging.instance;

  @override
  void onInit() {
    super.onInit();
    getToken();
  }

  // Future<void> handleBackground(RemoteMessage message) async {
  //   print('Title : ${message.notification?.title}');
  //   print('Body : ${message.notification?.body}');
  //   print('Title : ${message.notification?.title}');
  // }

  void getToken() async {
    await fcm.requestPermission().then((value) async {
      if (value.authorizationStatus == AuthorizationStatus.authorized) {
        await fcm.getToken().then(
          (value) {
            if (value != null && value != _usderModel.messagingToken) {
              _usderModel.messagingToken = value;
              Get.find<AuthController>()
                  .saveUserDataLocally(model: _usderModel)
                  .then((done) {
                if (done) {
                  FirebaseServices().userUpdate(
                      userId: _usderModel.userId.toString(),
                      map: {'messagingToken': _usderModel.messagingToken});
                }
              });
            }
          },
        );
        // if (_isIos) {
        //   await fcm
        //       .getToken()
        //       .then((value) => print('token is ===== >>> $value'));
        // } else {
        //   await fcm
        //       .getToken()
        //       .then((value) => print('token is ===== >>> $value'));
        // }
      }
    });
  }
}
