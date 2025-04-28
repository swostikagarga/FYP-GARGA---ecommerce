import 'package:garga/constant.dart';
import 'package:garga/controllers/addProductController.dart';
import 'package:garga/controllers/getDataController.dart';
import 'package:flutter/material.dart';
import 'package:garga/main.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders"),
      ),
      body: GetBuilder<GetDataController>(
        builder: (dataController) {
          if (dataController.orderResponse == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (dataController.orderResponse?.orders?.isEmpty ?? true) {
            return const Center(
              child: Text(
                "No Orders Found",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: dataController.orderResponse?.orders?.length ?? 0,
            itemBuilder: (context, index) {
              var order = dataController.orderResponse?.orders?[index];
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.only(
                  bottom: 15,
                ),
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                    offset: const Offset(2, 2),
                    color: Colors.black.withOpacity(
                      0.3,
                    ),
                    blurRadius: 5,
                    spreadRadius: 2,
                  )
                ]),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Order Id: ${order!.orderId}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${order.status?.toUpperCase()}",
                            style: TextStyle(
                              fontSize: 18,
                              color: order.status == "paid"
                                  ? Colors.green
                                  : Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Full Name: ${order.fullName}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Email: ${order.email}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            DateFormat().format(order.orderDate!),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Amount: Rs. ${order.total}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Payment Mode: ${order.paymentMode}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    "Delivery Status: ",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "${order.deliveryStatus?.toUpperCase()}",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: order.deliveryStatus == "pending"
                                          ? Colors.orange
                                          : order.deliveryStatus == "cancelled"
                                              ? Colors.red
                                              : order.deliveryStatus ==
                                                      "delivered"
                                                  ? Colors.green
                                                  : Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              if (prefs.getString("role") != "user")
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return UpdateOrderStatusDialog(
                                          orderId: order.orderId!,
                                          status: order.deliveryStatus!,
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.edit),
                                ),
                            ],
                          ),
                          const Text("Order Items: ",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              )),
                          ...order.orderItems!.map((orderItem) => Container(
                                margin: const EdgeInsets.only(
                                  top: 10,
                                ),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: const Offset(2, 2),
                                      color: Colors.black.withOpacity(
                                        0.2,
                                      ),
                                      blurRadius: 5,
                                      spreadRadius: 2,
                                    )
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Image(
                                      height: 100,
                                      width: 100,
                                      image: NetworkImage(
                                        getImageUrl(
                                            orderItem.images?.first.imageUrl ??
                                                ""),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 200,
                                          child: Text(
                                            "${orderItem.productTitle}",
                                            style: const TextStyle(
                                              fontSize: 18,
                                              overflow: TextOverflow.ellipsis,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "Quantity: ${orderItem.quantity}",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "Price: Rs.${orderItem.price}",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "Size: ${orderItem.size}",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              "Color: ",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            //getColorLabel
                                            Text(
                                              getColorLabel(
                                                orderItem.color ?? "#000000",
                                              ),
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: hexToColor(
                                                  orderItem.color ?? "#000000",
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Container(
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                color: hexToColor(
                                                  orderItem.color ?? "#000000",
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class UpdateOrderStatusDialog extends StatefulWidget {
  final String orderId;
  final String status;
  const UpdateOrderStatusDialog({
    super.key,
    required this.orderId,
    required this.status,
  });

  @override
  State<UpdateOrderStatusDialog> createState() =>
      _UpdateOrderStatusDialogState();
}

class _UpdateOrderStatusDialogState extends State<UpdateOrderStatusDialog> {
  List<String> statusList = ["pending", "shipped", "delivered", "cancelled"];

  String selectedStatus = "pending";

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.status;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GetDataController>(
      builder: (controller) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(0),
          contentPadding: const EdgeInsets.all(10),
          title: const Text(
            "Update Delivery Status",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                isExpanded: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                value: selectedStatus,
                items: statusList
                    .map(
                      (status) => DropdownMenuItem<String>(
                        value: status,
                        child: Text(
                          status.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedStatus = value!;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
              ),
              onPressed: () {
                controller.updateOrderStatus(selectedStatus, widget.orderId);
                Get.close(1);
              },
              child: const Text(
                "Update",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
