// To parse this JSON data, do
//
//     final productResponse = productResponseFromJson(jsonString);

import 'dart:convert';

ProductResponse productResponseFromJson(String str) =>
    ProductResponse.fromJson(json.decode(str));

String productResponseToJson(ProductResponse data) =>
    json.encode(data.toJson());

class ProductResponse {
  final bool? success;
  final List<Product>? products;
  final String? message;

  ProductResponse({
    this.success,
    this.products,
    this.message,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) =>
      ProductResponse(
        success: json["success"],
        products: json["products"] == null
            ? []
            : List<Product>.from(
                json["products"]!.map((x) => Product.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "products": products == null
            ? []
            : List<dynamic>.from(products!.map((x) => x.toJson())),
        "message": message,
      };
}

class Product {
  final String? productId;
  final String? productTitle;
  final String? description;
  final String? price;
  final String? categoryId;
  final String? merchantId;
  final String? colors;
  final String? sizes;
  final String? isDisabled;
  final String? stock;
  final dynamic profileImage;
  final String? categoryTitle;
  final String? merchantName;
  final List<String>? images;

  Product({
    this.productId,
    this.productTitle,
    this.description,
    this.price,
    this.categoryId,
    this.merchantId,
    this.colors,
    this.sizes,
    this.isDisabled,
    this.stock,
    this.profileImage,
    this.categoryTitle,
    this.merchantName,
    this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        productId: json["product_id"],
        productTitle: json["product_title"],
        description: json["description"],
        price: json["price"],
        categoryId: json["category_id"],
        merchantId: json["merchant_id"],
        colors: json["colors"],
        sizes: json["sizes"],
        isDisabled: json["is_disabled"],
        stock: json["stock"],
        profileImage: json["profile_image"],
        categoryTitle: json["category_title"],
        merchantName: json["merchant_name"],
        images: json["images"] == null
            ? []
            : List<String>.from(json["images"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "product_title": productTitle,
        "description": description,
        "price": price,
        "category_id": categoryId,
        "merchant_id": merchantId,
        "colors": colors,
        "sizes": sizes,
        "is_disabled": isDisabled,
        "stock": stock,
        "profile_image": profileImage,
        "category_title": categoryTitle,
        "merchant_name": merchantName,
        "images":
            images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
      };
}
