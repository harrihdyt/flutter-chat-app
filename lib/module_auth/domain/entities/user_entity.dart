import 'package:flutter_chat_app/module_auth/domain/entities/chat_entity.dart';

class UserEntity {
  String? uid;
  String? name;
  String? email;
  String? photoUrl;
  String? status;
  String? createdAt;
  String? keyName;
  List<ChatEntity>? chatEntity;

  UserEntity({
    this.createdAt,
    this.email,
    this.name,
    this.photoUrl,
    this.status,
    this.uid,
    this.chatEntity,
    this.keyName,
  });
}
