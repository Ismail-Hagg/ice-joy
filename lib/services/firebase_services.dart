import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseServices {
  final CollectionReference _ref =
      FirebaseFirestore.instance.collection('Users');
  CollectionReference get ref => _ref;

  // get the current user's data
  Future<DocumentSnapshot> getCurrentUser({required String userId}) async {
    return await _ref.doc(userId).get();
  }
}
