import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final TextInputType textInputType;
  final bool isPass;
  final String hintText;

  const TextFieldInput({super.key, required this.textEditingController, required this.textInputType, this.isPass = false, required this.hintText});

  @override
  Widget build(BuildContext context) {

    // Used for cursor position display
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context)
    );

    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hintText,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(12),
      ),
      keyboardType: textInputType,
      obscureText: isPass,
    );
  }
}