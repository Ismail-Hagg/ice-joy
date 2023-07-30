import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

class FirebaseServices {
  final CollectionReference _ref =
      FirebaseFirestore.instance.collection('Users');
  CollectionReference get ref => _ref;

  // get the current user's data
  Future<DocumentSnapshot> getCurrentUser({required String userId}) async {
    return await _ref.doc(userId).get();
  }

  // add user data to firebase
  Future<void> addUsers(UserModel model) async {
    return await _ref.doc(model.userId).set(model.toMap());
  }

  // update user data
  Future<void> userUpdate(
      {required String userId, required Map<String, dynamic> map}) async {
    _ref.doc(userId).update(map);
  }
}
