import 'package:flutter/material.dart';
import 'package:garga/controllers/addProductController.dart';
import 'package:get/get.dart';

class ColorSizeSelector extends StatefulWidget {
  final List<ColorType> colors;
  final List<SizeType> sizes;
  final Function(ColorType, SizeType) onConfirm;

  const ColorSizeSelector({
    super.key,
    required this.colors,
    required this.sizes,
    required this.onConfirm,
  });

  @override
  ColorSizeSelectorState createState() => ColorSizeSelectorState();
}

class ColorSizeSelectorState extends State<ColorSizeSelector> {
  ColorType? selectedColor;
  SizeType? selectedSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButtonFormField<ColorType>(
          hint: const Text("Select Color"),
          value: selectedColor,
          onChanged: (value) {
            setState(() {
              selectedColor = value;
            });
          },
          items: widget.colors.map((color) {
            return DropdownMenuItem<ColorType>(
              value: color,
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    color: color.value,
                  ),
                  const SizedBox(width: 10),
                  Text(color.label),
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<SizeType>(
          hint: const Text("Select Size"),
          value: selectedSize,
          onChanged: (value) {
            setState(() {
              selectedSize = value;
            });
          },
          items: widget.sizes.map((size) {
            return DropdownMenuItem<SizeType>(
              value: size,
              child: Text(size.label),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
              ),
              onPressed: () {
                Get.back();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedColor != null && selectedSize != null) {
                  widget.onConfirm(selectedColor!, selectedSize!);
                } else {
                  Get.showSnackbar(const GetSnackBar(
                    message: "Please select both color and size",
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.red,
                  ));
                }
              },
              child: const Text("Confirm"),
            ),
          ],
        ),
      ],
    );
  }
}

class ColorAndSizeType {
  final ColorType color;
  final SizeType size;
  ColorAndSizeType({required this.color, required this.size});
}
