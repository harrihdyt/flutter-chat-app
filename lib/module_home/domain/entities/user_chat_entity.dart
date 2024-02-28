class UserChatEntity {
  String? connection;
  String? chatId;
  String? lastTime;
  int? totalUnread;

  UserChatEntity({
    this.chatId,
    this.connection,
    this.lastTime,
    this.totalUnread,
  });
}
