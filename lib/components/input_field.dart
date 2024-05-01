import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String? label;
  final double? height;
  final BoxShadow? boxShadow;
  final Color? fillColor;
  final bool filled;
  final bool autofocus;
  final TextEditingController? textEditingController;
  final TextInputType? keyboardType;
  final InputBorder? border;
  final double? borderRadius;
  final bool isPassword;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;

  const InputField(
      {super.key,
      required this.label,
      this.textEditingController,
      this.boxShadow,
      this.fillColor,
      this.filled = true,
      this.isPassword = false,
      this.autofocus = false,
      this.border,
      this.borderRadius,
      this.height,
      this.keyboardType,
      this.suffixIcon,
      this.prefixIcon,
      this.onChanged,
      this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 999)),
      child: TextField(
        autofocus: autofocus,
        obscureText: isPassword,
        decoration: InputDecoration(
          filled: filled,
          fillColor: fillColor ?? const Color(0x00EBC1C3).withOpacity(1),
          isDense: false,
          prefixIcon: prefixIcon,
          prefixIconColor: Colors.grey.shade300,
          contentPadding: const EdgeInsets.all(16),
          constraints: BoxConstraints(minHeight: height ?? 64),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black26),
          border: border ??
              OutlineInputBorder(
                borderSide: const BorderSide(width: 1),
                borderRadius: BorderRadius.circular(borderRadius ?? 999),
              ),
          suffixIcon: suffixIcon,
        ),
        keyboardType: keyboardType,
        controller: textEditingController,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
      ),
    );
  }
}
