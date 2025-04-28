import 'package:garga/constant.dart';
import 'package:garga/controllers/addProductController.dart';
import 'package:garga/controllers/getDataController.dart';
import 'package:garga/models/products.dart';
import 'package:flutter/material.dart';
import 'package:garga/pages/user/product_detail.dart';
import 'package:get/get.dart';
import 'package:garga/utils/theme.dart';

class CartCard extends StatefulWidget {
  final Product product;
  final bool isFavourite;
  final ColorType? color;
  final SizeType? size;
  const CartCard({
    super.key,
    required this.product,
    required this.isFavourite,
    this.color,
    this.size,
  });

  @override
  State<CartCard> createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<GetDataController>(builder: (controller) {
      var dataController = Get.find<GetDataController>();
      int quantity = dataController.cart
              .firstWhereOrNull((element) =>
                  element.product.productId == widget.product.productId)
              ?.quantity ??
          1;

      return GestureDetector(
        onTap: () {
          Get.to(() => ProductDetail(product: widget.product));
        },
        child: Stack(
          children: [
            Container(
              width: Get.width,
              // margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                color: const Color(0xffD9D9D9),
                boxShadow: const [],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image(
                            image: NetworkImage(
                                getImageUrl(widget.product.images![0])),
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        if (!widget.isFavourite)
                          const SizedBox(
                            height: 10,
                          ),
                        if (!widget.isFavourite)
                          Row(
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                color: widget.color?.value,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                widget.color?.label ?? "",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        if (!widget.isFavourite)
                          Text(
                            'Size: ${widget.size?.label ?? ""}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          widget.product.productTitle ?? "",
                          style: const TextStyle(
                            fontSize: 16,
                            color: textColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.product.categoryTitle ?? "",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Rs.${widget.product.price}",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        if (!widget.isFavourite)
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  controller.decreaseQuantity(widget.product);
                                },
                                icon: const Icon(Icons.remove),
                              ),
                              Text(
                                quantity.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  controller.increaseQuantity(widget.product);
                                },
                                icon: const Icon(Icons.add),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (!widget.isFavourite)
              Positioned(
                right: 10,
                top: 5,
                child: IconButton(
                  onPressed: () {
                    dataController.removeFromCart(widget.product);
                  },
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.grey,
                  ),
                ),
              ),
            if (widget.isFavourite)
              Positioned(
                right: 10,
                bottom: 5,
                child: IconButton(
                  onPressed: () {
                    dataController
                        .removeFavouriteProduct(widget.product.productId!);
                  },
                  icon: const Icon(
                    Icons.favorite,
                    color: primaryColor,
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}
