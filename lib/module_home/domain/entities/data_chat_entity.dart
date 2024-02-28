import 'package:flutter_chat_app/module_auth/domain/entities/chat_entity.dart';

class DataChatEntiity {
  List<String>? connection;
  List<ChatEntity>? chatEntity;

  DataChatEntiity({
    this.chatEntity,
    this.connection,
  });
}
