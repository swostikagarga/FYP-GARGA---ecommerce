// To parse this JSON data, do
//
//     final allUsersResponse = allUsersResponseFromJson(jsonString);

import 'dart:convert';

AllUsersResponse allUsersResponseFromJson(String str) =>
    AllUsersResponse.fromJson(json.decode(str));

String allUsersResponseToJson(AllUsersResponse data) =>
    json.encode(data.toJson());

class AllUsersResponse {
  final bool? success;
  final List<User>? users;
  final String? message;

  AllUsersResponse({
    this.success,
    this.users,
    this.message,
  });

  factory AllUsersResponse.fromJson(Map<String, dynamic> json) =>
      AllUsersResponse(
        success: json["success"],
        users: json["users"] == null
            ? []
            : List<User>.from(json["users"]!.map((x) => User.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "users": users == null
            ? []
            : List<dynamic>.from(users!.map((x) => x.toJson())),
        "message": message,
      };
}

class User {
  final String? userId;
  final String? fullName;
  final String? gender;
  final String? email;
  final String? password;
  final String? role;
  final String? address;
  final String? phoneNumber;
  final String? profileImage;
  final String? documentUrl;
  final DateTime? createdAt;
  final String? isDeleted;

  User({
    this.userId,
    this.fullName,
    this.gender,
    this.email,
    this.password,
    this.role,
    this.address,
    this.phoneNumber,
    this.profileImage,
    this.documentUrl,
    this.createdAt,
    this.isDeleted,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["user_id"],
        fullName: json["full_name"],
        gender: json["gender"],
        email: json["email"],
        password: json["password"],
        role: json["role"],
        address: json["address"],
        phoneNumber: json["phone_number"],
        profileImage: json["profile_image"],
        documentUrl: json["document_url"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        isDeleted: json["is_deleted"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "full_name": fullName,
        "gender": gender,
        "email": email,
        "password": password,
        "role": role,
        "address": address,
        "phone_number": phoneNumber,
        "profile_image": profileImage,
        "document_url": documentUrl,
        "created_at": createdAt?.toIso8601String(),
        "is_deleted": isDeleted,
      };
}
