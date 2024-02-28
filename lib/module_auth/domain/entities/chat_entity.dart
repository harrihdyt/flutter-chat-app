class ChatEntity {
  String? sender;
  String? receiver;
  String? message;
  String? time;
  bool? isRead;

  ChatEntity({
    this.isRead,
    this.message,
    this.receiver,
    this.sender,
    this.time,
  });

  toJson() {}
}
