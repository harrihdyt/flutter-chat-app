import 'package:flutter_chat_app/module_auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    super.createdAt,
    super.email,
    super.name,
    super.photoUrl,
    super.status,
    super.uid,
    super.keyName,
    super.chatEntity,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      photoUrl: json['photoUrl'],
      status: json['status'],
      createdAt: json['createdAt'],
      keyName: json['keyName'],
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'email': email,
        'photoUrl': photoUrl,
        'status': status,
        'createdAt': createdAt,
        'keyName': keyName,
      };
}
