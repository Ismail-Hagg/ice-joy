import 'dart:convert';

import 'package:icejoy/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';

class DataPref {
  // save user data
  Future<bool> setUser(UserModel model) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.setString(userDataKey, json.encode(model.toMap()));
  }

  // retrieve user data
  Future<UserModel> getUserData() async {
    UserModel model = UserModel();
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      var value = pref.getString(userDataKey);
      model = UserModel.fromMap(json.decode(value.toString()));
      return model;
    } catch (e) {
      model.isError = true;
      model.errorMessage = e.toString();
      return model;
    }
  }

  // delete user data
  Future<void> deleteUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
  }
}
