// To parse this JSON data, do
//
//     final userResponse = userResponseFromJson(jsonString);

import 'dart:convert';

UserResponse userResponseFromJson(String str) =>
    UserResponse.fromJson(json.decode(str));

String userResponseToJson(UserResponse data) => json.encode(data.toJson());

class UserResponse {
  final bool? success;
  final User? user;
  final String? message;

  UserResponse({
    this.success,
    this.user,
    this.message,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
        success: json["success"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "user": user?.toJson(),
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
        "created_at": createdAt?.toIso8601String(),
        "is_deleted": isDeleted,
      };
}
