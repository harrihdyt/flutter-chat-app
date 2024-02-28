import 'package:flutter_chat_app/module_auth/domain/entities/chat_entity.dart';

class ChatModel extends ChatEntity {
  ChatModel({
    super.isRead,
    super.message,
    super.receiver,
    super.sender,
    super.time,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        sender: json["pengirim"],
        receiver: json["penerima"],
        message: json["pesan"],
        time: json["time"],
        isRead: json["isRead"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "pengirim": sender,
        "penerima": receiver,
        "pesan": message,
        "time": time,
        "isRead": isRead,
      };
}
