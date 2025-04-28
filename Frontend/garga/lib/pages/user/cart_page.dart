import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:garga/components/button.dart';
import 'package:garga/components/cart_card.dart';
import 'package:garga/controllers/getDataController.dart';
import 'package:garga/utils/theme.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Cart")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: GetBuilder<GetDataController>(
          builder: (controller) {
            final total = controller.getTotal();

            if (controller.cart.isEmpty) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: const Center(
                  child: Text(
                    "Your cart is empty,\nadd some items!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🛒 CART LIST
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.cart.length,
                  itemBuilder: (context, index) => CartCard(
                    product: controller.cart[index].product,
                    isFavourite: false,
                    color: controller.cart[index].color,
                    size: controller.cart[index].size,
                  ),
                ),
                const SizedBox(height: 24),

                // 🎟️ PROMO CODE SECTION
                const Text(
                  'Have a promo code?',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller.promoCodeController,
                        decoration: InputDecoration(
                          hintText: 'Enter promo code',
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: controller.applyPromoCode,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("Apply"),
                    ),
                  ],
                ),
                if (controller.discountPercentage != 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      "Discount applied: ${controller.discountPercentage}%",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.green,
                      ),
                    ),
                  ),

                const SizedBox(height: 24),

                // 💰 ORDER SUMMARY
                const Text('Order Summary',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                _buildSummaryRow(
                    label: 'Subtotal',
                    value: "Rs. ${controller.getSubTotal()}"),

                if (controller.discountPercentage != 0 &&
                    controller.discountPercentage > 0)
                  _buildSummaryRow(
                      label: 'Discount',
                      value: "- Rs. ${controller.getDiscount()}",
                      valueColor: Colors.green),
                _buildSummaryRow(
                    label: 'Delivery Charge',
                    value: "Rs. ${controller.deliveryCharge}"),

                const Divider(height: 32),

                const Text(
                  'Total Payable',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  "Rs. $total",
                  style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                ),

                const SizedBox(height: 20),
                Button(
                  label: "Order Now",
                  onPressed: controller.createOrder,
                ),
                const SizedBox(height: 40),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSummaryRow({
    required String label,
    required String value,
    Color valueColor = Colors.black,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 14, color: Colors.black87)),
          Text(value,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: valueColor)),
        ],
      ),
    );
  }
}
