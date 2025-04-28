// To parse this JSON data, do
//
//     final promoCodes = promoCodesFromJson(jsonString);

import 'dart:convert';

PromoCodes promoCodesFromJson(String str) =>
    PromoCodes.fromJson(json.decode(str));

String promoCodesToJson(PromoCodes data) => json.encode(data.toJson());

class PromoCodes {
  final bool? success;
  final List<PromoCode>? promoCodes;
  final String? message;

  PromoCodes({
    this.success,
    this.promoCodes,
    this.message,
  });

  factory PromoCodes.fromJson(Map<String, dynamic> json) => PromoCodes(
        success: json["success"],
        promoCodes: json["promoCodes"] == null
            ? []
            : List<PromoCode>.from(
                json["promoCodes"]!.map((x) => PromoCode.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "promoCodes": promoCodes == null
            ? []
            : List<dynamic>.from(promoCodes!.map((x) => x.toJson())),
        "message": message,
      };
}

class PromoCode {
  final String? promoCodeId;
  final String? promoCode;
  final String? percentage;
  final bool? isActive;

  PromoCode({
    this.promoCodeId,
    this.promoCode,
    this.percentage,
    this.isActive,
  });

  factory PromoCode.fromJson(Map<String, dynamic> json) => PromoCode(
        promoCodeId: json["promo_code_id"],
        promoCode: json["promo_code"],
        percentage: json["percentage"],
        isActive: json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        "promo_code_id": promoCodeId,
        "promo_code": promoCode,
        "percentage": percentage,
        "is_active": isActive,
      };
}
