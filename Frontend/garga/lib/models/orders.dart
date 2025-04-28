// To parse this JSON data, do
//
//     final orderResponse = orderResponseFromJson(jsonString);

import 'dart:convert';

OrderResponse orderResponseFromJson(String str) =>
    OrderResponse.fromJson(json.decode(str));

String orderResponseToJson(OrderResponse data) => json.encode(data.toJson());

class OrderResponse {
  final bool? success;
  final List<Order>? orders;
  final String? message;

  OrderResponse({
    this.success,
    this.orders,
    this.message,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) => OrderResponse(
        success: json["success"],
        orders: json["orders"] == null
            ? []
            : List<Order>.from(json["orders"]!.map((x) => Order.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "orders": orders == null
            ? []
            : List<dynamic>.from(orders!.map((x) => x.toJson())),
        "message": message,
      };
}

class Order {
  final String? email;
  final String? fullName;
  final String? orderId;
  final String? total;
  final String? status;
  final String? userId;
  final DateTime? orderDate;
  final String? paymentMode;
  final String? deliveryStatus;
  final List<OrderItem>? orderItems;

  Order({
    this.email,
    this.fullName,
    this.orderId,
    this.total,
    this.status,
    this.userId,
    this.orderDate,
    this.paymentMode,
    this.deliveryStatus,
    this.orderItems,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        email: json["email"],
        fullName: json["full_name"],
        orderId: json["order_id"],
        total: json["total"],
        status: json["status"],
        userId: json["user_id"],
        orderDate: json["order_date"] == null
            ? null
            : DateTime.parse(json["order_date"]),
        paymentMode: json["payment_mode"],
        deliveryStatus: json["delivery_status"],
        orderItems: json["order_items"] == null
            ? []
            : List<OrderItem>.from(
                json["order_items"]!.map((x) => OrderItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "full_name": fullName,
        "order_id": orderId,
        "total": total,
        "status": status,
        "user_id": userId,
        "order_date": orderDate?.toIso8601String(),
        "payment_mode": paymentMode,
        "delivery_status": deliveryStatus,
        "order_items": orderItems == null
            ? []
            : List<dynamic>.from(orderItems!.map((x) => x.toJson())),
      };
}

class OrderItem {
  final String? productTitle;
  final String? productId;
  final String? merchantId;
  final String? price;
  final String? quantity;
  final String? color;
  final String? size;
  final List<Image>? images;

  OrderItem({
    this.productTitle,
    this.productId,
    this.merchantId,
    this.price,
    this.quantity,
    this.color,
    this.size,
    this.images,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        productTitle: json["product_title"],
        productId: json["product_id"],
        merchantId: json["merchant_id"],
        price: json["price"],
        quantity: json["quantity"],
        color: json["color"],
        size: json["size"],
        images: json["images"] == null
            ? []
            : List<Image>.from(json["images"]!.map((x) => Image.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "product_title": productTitle,
        "product_id": productId,
        "merchant_id": merchantId,
        "price": price,
        "quantity": quantity,
        "color": color,
        "size": size,
        "images": images == null
            ? []
            : List<dynamic>.from(images!.map((x) => x.toJson())),
      };
}

class Image {
  final String? id;
  final String? imageUrl;
  final String? productId;

  Image({
    this.id,
    this.imageUrl,
    this.productId,
  });

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        id: json["id"],
        imageUrl: json["image_url"],
        productId: json["product_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image_url": imageUrl,
        "product_id": productId,
      };
}
