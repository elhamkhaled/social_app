class SocialUserModel {
  String? uId;
  String? name;
  String? image;
  String? cover;
  String? email;
  String? phone;
  String? bio;
  bool? isEmailVerified;
  SocialUserModel({
    required this.uId,
    required this.name,
    required this.image,
    required this.cover,
    required this.email,
    required this.phone,
    required this.bio,
    this.isEmailVerified,
  });
  SocialUserModel.fromJson(Map<String, dynamic> json) {
    uId = json['uId'];
    name = json['name'];
    image = json['image'];
    cover = json['cover'];
    email = json['email'];
    phone = json['phone'];
    bio = json['bio'];
    isEmailVerified = json['isEmailVerified'];
  }
  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'name': name,
      'image': image,
      'cover': cover,
      'email': email,
      'phone': phone,
      'bio': bio,
      'isEmailVerified': isEmailVerified,
    };
  }
}
