import 'package:flutter/material.dart';
import 'package:garga/components/button.dart';
import 'package:garga/controllers/getDataController.dart';
import 'package:garga/models/promo_code.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class PromoCodesPage extends StatelessWidget {
  const PromoCodesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Promo Codes",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
      ),
      body: GetBuilder<GetDataController>(
        builder: (controller) {
          var promoCodes = controller.promoCodesResponse?.promoCodes ?? [];

          if (controller.promoCodesResponse == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (promoCodes.isEmpty) {
            return const Center(
              child: Text(
                "No promo codes available",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }
          return ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(
              height: 16,
            ),
            padding: const EdgeInsets.all(16),
            itemCount: promoCodes.length,
            itemBuilder: (context, index) {
              var promoCode = promoCodes[index];
              return ListTile(
                title: Text(promoCode.promoCode ?? ""),
                subtitle: Text("Discount: ${promoCode.percentage ?? ""}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            constraints: BoxConstraints(
                              minHeight:
                                  MediaQuery.of(context).size.height * 0.85,
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.9,
                            ),
                            isScrollControlled: true,
                            anchorPoint: const Offset(0, 0),
                            context: context,
                            builder: (context) {
                              return AddEditPromoCode(promoCode: promoCode);
                            },
                          );
                        },
                        icon: const Icon(Icons.edit)),
                    Icon(
                      promoCode.isActive == true
                          ? Icons.check_circle
                          : Icons.cancel,
                      color: promoCode.isActive == true
                          ? Colors.green
                          : Colors.red,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your action here
          showModalBottomSheet(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height * 0.85,
              maxHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            isScrollControlled: true,
            anchorPoint: const Offset(0, 0),
            context: context,
            builder: (context) {
              return const AddEditPromoCode();
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddEditPromoCode extends StatefulWidget {
  final PromoCode? promoCode;
  const AddEditPromoCode({super.key, this.promoCode});

  @override
  State<AddEditPromoCode> createState() => _AddEditPromoCodeState();
}

var promoCodeController = TextEditingController();
var percentageController = TextEditingController();
var isActive = false;
var key = GlobalKey<FormState>();

class _AddEditPromoCodeState extends State<AddEditPromoCode> {
  @override
  void initState() {
    super.initState();
    if (widget.promoCode != null) {
      promoCodeController.text = widget.promoCode!.promoCode ?? "";
      percentageController.text = widget.promoCode!.percentage ?? "";
      isActive = widget.promoCode!.isActive ?? false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // modal bottom sheet
    return GetBuilder<GetDataController>(
      builder: (controller) => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              widget.promoCode == null ? "Add Promo Code" : "Edit Promo Code",
            ),
            centerTitle: true,
          ),
          body: Form(
            key: key,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: promoCodeController,
                    maxLength: 50,
                    decoration: const InputDecoration(
                      labelText: "Promo Code",
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: percentageController,
                    keyboardType: TextInputType.number,
                    maxLength: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a discount percentage";
                      }
                      if (int.tryParse(value) == null) {
                        return "Please enter a valid number";
                      }
                      if (int.parse(value) < 0 || int.parse(value) > 100) {
                        return "Please enter a percentage between 0 and 100";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Discount Percentage",
                      hintText: "e.g. 10",
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Is Active",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )),
                      Switch.adaptive(
                        value: isActive,
                        onChanged: (value) {
                          setState(() {
                            isActive = value;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Button(
                    label: "Save",
                    onPressed: () {
                      if (key.currentState!.validate()) {
                        if (widget.promoCode == null) {
                          controller.addPromoCode(promoCodeController.text,
                              percentageController.text, isActive);
                        } else {
                          controller.updatePromoCode(
                            widget.promoCode!.promoCodeId ?? "",
                            promoCodeController.text,
                            percentageController.text,
                            isActive,
                          );
                        }
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
