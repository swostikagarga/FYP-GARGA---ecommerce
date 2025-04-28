import 'package:flutter/material.dart';
import 'package:garga/utils/theme.dart';

class Button extends StatelessWidget {
  final String label;
  final void Function() onPressed;
  const Button({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(primaryColor),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(vertical: 5),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      onPressed: onPressed,
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
