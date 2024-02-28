import 'package:flutter_chat_app/module_auth/data/models/chat_model.dart';
import 'package:flutter_chat_app/module_home/domain/entities/data_chat_entity.dart';

class DataChatModel extends DataChatEntiity {
  DataChatModel({
    super.chatEntity,
    super.connection,
  });

  factory DataChatModel.fromJson(Map<String, dynamic> json) => DataChatModel(
        connection: List<String>.from(json["connections"].map((x) => x)),
        chatEntity: List<ChatModel>.from(
            json["chat"].map((x) => ChatModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "connections": List<dynamic>.from(connection!.map((x) => x)),
        "chat": List<dynamic>.from(chatEntity!.map((x) => x.toJson())),
      };
}
