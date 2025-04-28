import 'package:garga/constant.dart';
import 'package:garga/controllers/getDataController.dart';
import 'package:garga/models/products.dart';
import 'package:flutter/material.dart';
import 'package:garga/pages/user/product_detail.dart';
import 'package:get/get.dart';
import 'package:garga/utils/theme.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final int? quantity;
  const ProductCard({super.key, required this.product, this.quantity});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GetDataController>(
      builder: (dataController) => GestureDetector(
        onTap: () {
          Get.to(() => ProductDetail(product: widget.product));
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
              boxShadow: const [], borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                    image: widget.product.profileImage == null
                        ? null
                        : DecorationImage(
                            image: NetworkImage(
                                getImageUrl(widget.product.profileImage)),
                            fit: BoxFit.cover,
                          ),
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 70,
                  child: Text(
                    widget.product.merchantName ?? "",
                    style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
              ]),
              const SizedBox(
                height: 10,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image(
                  image: NetworkImage(getImageUrl(widget.product.images![0])),
                  width: 130,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 130,
                      child: Text(
                        widget.product.productTitle ?? "",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      widget.product.categoryTitle ?? "",
                      style: const TextStyle(
                        fontSize: 14,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Row(
                        //   children: [
                        //     const Icon(
                        //       Icons.star,
                        //       color: Colors.orange,
                        //     ),
                        //     Text(
                        //       widget.product.rating ?? "1",
                        //       style: const TextStyle(
                        //         fontSize: 14,
                        //         color: Colors.black,
                        //         fontWeight: FontWeight.bold,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                dataController.addToCart(widget.product,
                                    availableColors:
                                        widget.product.colors ?? "[]",
                                    availableSizes:
                                        widget.product.sizes ?? "[]",
                                    quantity: quantity);
                              },
                              child: const Icon(
                                Icons.shopping_cart,
                                color: primaryColor,
                                size: 20,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                var isFav = dataController
                                    .isFavorite(widget.product.productId!);

                                if (isFav) {
                                  dataController.removeFavouriteProduct(
                                      widget.product.productId!);
                                } else {
                                  dataController.addFavouriteProduct(
                                      widget.product.productId!);
                                }
                              },
                              child: Icon(
                                dataController
                                        .isFavorite(widget.product.productId!)
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: primaryColor,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
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
                        Text(
                          "Rs.${double.parse(widget.product.price!) * 1.2}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
