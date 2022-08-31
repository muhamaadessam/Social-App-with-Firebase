class UserModel {
  String? uId;
  String? name;
  String? email;
  String? imageUrl;
  String? phone;
  String? bio;
  String? coverImageUrl;

  UserModel({
    this.uId,
    this.name,
    this.email,
    this.imageUrl,
    this.phone,
    this.bio,
    this.coverImageUrl,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    uId = json['userId'];
    name = json['name'];
    email = json['email'];
    imageUrl = json['imageUrl'];
    phone = json['phone'];
    bio = json['bio'];
    coverImageUrl = json['coverImageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uId'] = uId;
    data['name'] = name;
    data['email'] = email;
    data['imageUrl'] = imageUrl;
    data['phone'] = phone;
    data['bio'] = bio;
    data['coverImageUrl'] = coverImageUrl;
    return data;
  }
}
