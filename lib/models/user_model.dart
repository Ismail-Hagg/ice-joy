import '../utils/enums.dart';

class UserModel {
  String? userName;
  String? email;
  String? onlinePicPath;
  String? localPicPath;
  String? userId;
  String? language;
  bool? isError;
  String? errorMessage;
  String? messagingToken;
  LogState? state;
  LoginMethod? method;
  String? phoneNumber;
  Gender? gender;
  String? birthday;
  int? points;

  UserModel(
      {this.userName,
      this.email,
      this.onlinePicPath,
      this.localPicPath,
      this.userId,
      this.language,
      this.isError,
      this.messagingToken,
      this.state,
      this.gender,
      this.phoneNumber,
      this.birthday,
      this.errorMessage,
      this.method,
      this.points});

  toMap() {
    return <String, dynamic>{
      'userName': userName,
      'email': email,
      'onlinePicPath': onlinePicPath,
      'localPicPath': localPicPath,
      'userId': userId,
      'language': language,
      'isError': isError,
      'messagingToken': messagingToken,
      'errorMessage': errorMessage,
      'phoneNumber': phoneNumber,
      'state': state.toString(),
      'method': method.toString(),
      'gender': gender.toString(),
      'birthday': birthday,
      'points': points
    };
  }

  factory UserModel.fromMap(Map<dynamic, dynamic> map) {
    return UserModel(
        userName: map['userName'],
        email: map['email'],
        onlinePicPath: map['onlinePicPath'],
        localPicPath: map['localPicPath'],
        userId: map['userId'],
        language: map['language'],
        isError: map['isError'],
        messagingToken: map['messagingToken'],
        state: LogState.values.firstWhere((e) => e.toString() == map['state']),
        method:
            LoginMethod.values.firstWhere((e) => e.toString() == map['method']),
        gender: Gender.values.firstWhere((e) => e.toString() == map['gender']),
        birthday: map['birthday'],
        phoneNumber: map['phoneNumber'],
        points: map['points'],
        errorMessage: map['errorMessage']);
  }
}
