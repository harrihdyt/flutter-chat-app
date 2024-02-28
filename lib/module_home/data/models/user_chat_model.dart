import 'package:flutter_chat_app/module_home/domain/entities/user_chat_entity.dart';

class UserChatModel extends UserChatEntity {
  UserChatModel({
    super.chatId,
    super.connection,
    super.lastTime,
    super.totalUnread,
  });

  factory UserChatModel.fromJson(Map<String, dynamic> json) => UserChatModel(
        connection: json["connection"],
        chatId: json["chat_id"],
        lastTime: json["lastTime"],
        totalUnread: json["total_unread"],
      );

  Map<String, dynamic> toJson() => {
        "connection": connection,
        "chat_id": chatId,
        "lastTime": lastTime,
        "total_unread": totalUnread,
      };
}
