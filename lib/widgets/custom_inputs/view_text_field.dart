import 'package:flutter/material.dart';

class ViewTextField extends StatelessWidget {
  const ViewTextField({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 10.0),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(
              color: Colors.black26
            ),
          ),
          child: Row(
            children: [
              Text(value),
            ],
          ),
        )
      ],
    );
  }
}