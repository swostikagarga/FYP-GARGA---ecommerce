import 'package:dropdown_search/dropdown_search.dart';
import 'package:garga/constant.dart';
import 'package:garga/controllers/addProductController.dart';
import 'package:garga/controllers/getDataController.dart';
import 'package:flutter/material.dart';
import 'package:garga/models/products.dart';
import 'package:get/get.dart';

class AddProductPage extends StatefulWidget {
  final Product? product;
  const AddProductPage({super.key, this.product});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  var controller = Get.put(AddProductController());
  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      controller.productNameController.text =
          widget.product?.productTitle ?? "";
      controller.descriptionController.text = widget.product?.description ?? "";
      controller.productPriceController.text =
          widget.product?.price.toString() ?? "";
      controller.selectedCategory = widget.product?.categoryId;
      controller.stockController.text = widget.product?.stock.toString() ?? "";
      controller.selectedColors =
          getDecodedList<dynamic>(widget.product?.colors)
              .map((e) => ColorType.fromJson(e))
              .toList();
      controller.selectedSizes = getDecodedList<dynamic>(widget.product?.sizes)
          .map((e) => SizeType.fromJson(e))
          .toList();
      controller.imageUrls = widget.product?.images ?? [];
      controller.update();
    }
  }

  @override
  Widget build(BuildContext context) {
    var dataController = Get.find<GetDataController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product"),
      ),
      body: SingleChildScrollView(
        child: GetBuilder<AddProductController>(builder: (_) {
          return Form(
            key: controller.formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: controller.productNameController,
                    decoration: const InputDecoration(
                      labelText: "Product Name",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter your product name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    maxLines: 5,
                    minLines: 3,
                    maxLength: 2000,
                    controller: controller.descriptionController,
                    decoration: const InputDecoration(
                      labelText: "Product Description",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter your product description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: controller.productPriceController,
                    decoration: const InputDecoration(
                      labelText: "Product Price",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter your product price';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: controller.stockController,
                    decoration: const InputDecoration(
                      labelText: "Stock",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter your product stock';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                      onChanged: (value) =>
                          {controller.selectedCategory = value},
                      decoration: const InputDecoration(
                        labelText: "Category",
                        border: OutlineInputBorder(),
                      ),
                      value: controller.selectedCategory,
                      validator: (value) {
                        if (value == null) {
                          return "Please select category";
                        }
                        return null;
                      },
                      menuMaxHeight: 500,
                      items: dataController.categoriesResponse?.categories
                          ?.map((element) => DropdownMenuItem(
                              value: element.categoryId ?? "",
                              child: Text(element.categoryTitle ?? "")))
                          .toList()),
                  const SizedBox(height: 20),
                  // MultiDropdown<Color>(
                  //   controller: controller.selectedColorsController,
                  //   dropdownDecoration: DropdownDecoration(
                  //     borderRadius: BorderRadius.circular(8),
                  //     maxHeight: 250,
                  //   ),
                  //   fieldDecoration: FieldDecoration(
                  //       focusedBorder: OutlineInputBorder(
                  //         borderSide: BorderSide(
                  //           width: 2,
                  //           color: Theme.of(context).primaryColor,
                  //         ),
                  //       ),
                  //       labelText: 'Select Colors',
                  //       labelStyle: TextStyle(
                  //         color: Theme.of(context).primaryColor,
                  //         fontSize: 18,
                  //       ),
                  //       backgroundColor: Colors.white,
                  //       border: OutlineInputBorder(
                  //         borderSide: BorderSide(
                  //           color: Theme.of(context).primaryColor,
                  //           width: 2,
                  //         ),
                  //       ),
                  //       suffixIcon: const Padding(
                  //         padding: EdgeInsets.only(right: 10),
                  //         child: Icon(
                  //           Icons.arrow_drop_down,
                  //           color: Colors.black,
                  //         ),
                  //       ),
                  //       padding: const EdgeInsets.symmetric(
                  //         horizontal: 10,
                  //         vertical: 18,
                  //       )),
                  //   validator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return "Please select colors";
                  //     }
                  //     return null;
                  //   },
                  //   chipDecoration: ChipDecoration(
                  //     labelStyle: const TextStyle(
                  //       color: Colors.black,
                  //     ),
                  //     backgroundColor: Colors.grey[300],
                  //     padding: const EdgeInsets.symmetric(
                  //       horizontal: 6,
                  //       vertical: 2,
                  //     ),
                  //     spacing: 5,
                  //     runSpacing: 5,
                  //   ),
                  //   itemBuilder: (item, index, onTap) {
                  //     return InkWell(
                  //       onTap: onTap,
                  //       child: Container(
                  //         padding: const EdgeInsets.symmetric(
                  //           vertical: 8,
                  //           horizontal: 16,
                  //         ),
                  //         margin: const EdgeInsets.symmetric(
                  //           vertical: 4,
                  //           horizontal: 8,
                  //         ),
                  //         decoration: BoxDecoration(
                  //           color: controller
                  //                   .selectedColorsController.selectedItems
                  //                   .map((e) => e.value)
                  //                   .contains(item.value)
                  //               ? Colors.grey[300]
                  //               : Colors.transparent,
                  //           borderRadius: BorderRadius.circular(8),
                  //         ),
                  //         child: Row(
                  //           children: [
                  //             Container(
                  //               height: 20,
                  //               width: 20,
                  //               decoration: BoxDecoration(
                  //                 color: item.value,
                  //                 borderRadius: BorderRadius.circular(4),
                  //               ),
                  //             ),
                  //             const SizedBox(width: 8),
                  //             Text(item.label),
                  //           ],
                  //         ),
                  //       ),
                  //     );
                  //   },
                  //   items: availableColors
                  //       .map((e) => DropdownItem<Color>(
                  //             value: e.value,
                  //             label: e.label,
                  //           ))
                  //       .toList(),
                  // ),
                  DropdownSearch<ColorType>.multiSelection(
                    items: (f, cs) => availableColors,
                    compareFn: (item1, item2) {
                      return colorToHex(item1.value) == colorToHex(item2.value);
                    },
                    itemAsString: (item) => item.label,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please select colors";
                      }
                      return null;
                    },
                    onChanged: (colors) {
                      controller.selectedColors = colors;
                    },
                    selectedItems: controller.selectedColors,
                    popupProps: PopupPropsMultiSelection.dialog(
                      dialogProps: const DialogProps(
                        contentPadding: EdgeInsets.zero,
                        insetPadding: EdgeInsets.symmetric(horizontal: 5),
                      ),
                      itemBuilder: (context, item, isDisabled, isSelected) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          margin: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.grey[300]
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            children: [
                              Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                  color: item.value,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(item.label),
                            ],
                          ),
                        );
                      },
                    ),
                    decoratorProps: const DropDownDecoratorProps(
                      decoration: InputDecoration(
                        label: Text(
                          'Select Colors',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        contentPadding: EdgeInsets.all(20),
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  DropdownSearch<SizeType>.multiSelection(
                    items: (f, cs) => availableSizes,
                    compareFn: (item1, item2) => item1.value == item2.value,
                    itemAsString: (item) => item.label,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please select sizes";
                      }
                      return null;
                    },
                    onChanged: (sizes) {
                      controller.selectedSizes = sizes;
                    },
                    selectedItems: controller.selectedSizes,
                    popupProps: PopupPropsMultiSelection.modalBottomSheet(
                      modalBottomSheetProps: const ModalBottomSheetProps(
                        useSafeArea: true,
                        backgroundColor: Colors.white,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                      ),
                      itemBuilder: (context, item, isDisabled, isSelected) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          margin: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.grey[300]
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            children: [
                              const SizedBox(width: 8),
                              Text(item.label),
                            ],
                          ),
                        );
                      },
                    ),
                    decoratorProps: const DropDownDecoratorProps(
                      decoration: InputDecoration(
                        label: Text(
                          'Select Sizes',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        contentPadding: EdgeInsets.all(20),
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: controller.pickImage,
                    child: const Text('Upload Image'),
                  ),
                  const SizedBox(height: 20),
                  if (controller.imagePreviews.isNotEmpty ||
                      controller.imageUrls.isNotEmpty)
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.imagePreviews.length +
                            controller.imageUrls.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: controller.imagePreviews.isNotEmpty &&
                                        index < controller.imagePreviews.length
                                    ? Image.memory(
                                        controller.imagePreviews[index],
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        getImageUrl(
                                          controller.imageUrls[index -
                                              controller.imagePreviews.length],
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              //clear
                              Positioned(
                                right: 0,
                                top: 0,
                                child: IconButton(
                                  icon: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      border: Border.fromBorderSide(
                                          BorderSide(color: Colors.red)),
                                    ),
                                    child: const Icon(Icons.clear,
                                        color: Colors.red),
                                  ),
                                  onPressed: () {
                                    if (index < controller.imageUrls.length) {
                                      controller.imageUrls.removeAt(index);
                                    } else {
                                      controller.imagePreviews.removeAt(
                                          index - controller.imageUrls.length);
                                      controller.images.removeAt(
                                          index - controller.imageUrls.length);
                                    }
                                    controller.update();
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  if (controller.imagePreviews.isEmpty &&
                      controller.imageUrls.isEmpty)
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text("No image selected"),
                      ),
                    ),
                  const SizedBox(height: 20),
                  if (controller.imageError != null)
                    Text(controller.imageError!,
                        style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (widget.product != null) {
                        controller.addOrUpdateProduct(
                          isUpdate: true,
                          productId: widget.product?.productId,
                          imageUrls: widget.product?.images,
                        );
                      } else {
                        controller.addOrUpdateProduct();
                      }
                    },
                    // style: ElevatedButton.styleFrom(
                    //   backgroundColor: Colors.red,
                    // ),
                    child: Text(
                        '${widget.product != null ? "Update" : "Add"} Product'),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
