import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.label,
    this.onChanged,
    this.defaultValue,
    this.validator,
    this.obscureText = false,
    this.suffixIcon,
    this.isMultiline = false,
    this.maxLines = 1,
    this.formater,
    this.inputType,
    this.hintText,
    this.isReadyOnly
  });

  final String? label;
  final String? hintText;
  final String? defaultValue;
  final void Function(String value)? onChanged; 
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget? suffixIcon;
  final bool? isMultiline;
  final int? maxLines;
  final List<TextInputFormatter>? formater;
  final TextInputType? inputType;
  final bool? isReadyOnly;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: defaultValue,
      onChanged: onChanged,
      obscureText: obscureText,
      maxLines: isMultiline ?? false ? maxLines : 1,
      inputFormatters: formater,
      keyboardType: inputType,
      readOnly: isReadyOnly ?? false,
      decoration: InputDecoration(
        labelText: label,
        alignLabelWithHint: true,
        hintText: hintText,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColorDark)),
        suffixIcon: suffixIcon
      ),
      validator: validator,
    );
  }
}
