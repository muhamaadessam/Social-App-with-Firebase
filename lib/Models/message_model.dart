class MessageModel {
  String? senderId;
  String? receiverId;
  String? dateTime;
  String? message;

  MessageModel({
    this.senderId,
    this.receiverId,
    this.dateTime,
    this.message,

  });

  MessageModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    dateTime = json['dateTime'];
    receiverId = json['receiverId'];
    senderId = json['senderId'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['senderId'] = senderId;
    data['receiverId'] = receiverId;
    data['dateTime'] = dateTime;
    data['message'] = message;
    return data;
  }
}
