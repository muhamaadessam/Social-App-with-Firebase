class PostModel {
  String? uId;
  String? name;
  String? imageUrl;
  String? dateTime;
  String? updateDateTime;
  String? text;
  String? postImageUrl;

  PostModel(
      {this.uId,
        this.name,
        this.imageUrl,
        this.text,
        this.dateTime,
        this.updateDateTime,
        this.postImageUrl});

  PostModel.fromJson(Map<String, dynamic> json) {
    uId = json['userId'];
    name = json['name'];
    imageUrl = json['imageUrl'];
    text = json['text'];
    dateTime = json['dateTime'];
    updateDateTime = json['updateDateTime'];
    postImageUrl = json['postImageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uId'] = uId;
    data['name'] = name;
    data['imageUrl'] = imageUrl;
    data['text'] = text;
    data['dateTime'] = dateTime;
    data['updateDateTime'] = updateDateTime;
    data['postImageUrl'] = postImageUrl;
    return data;
  }
}