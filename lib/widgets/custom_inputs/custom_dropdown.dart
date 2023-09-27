import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  const CustomDropdown({
    super.key,
    required this.onChanged,
    required this.itemList,
    this.initialValue,
    this.label,
  });

  final void Function(Object?) onChanged;
  final String? label;
  final List itemList;
  final int? initialValue;

  String? getDefaultValue(){
    try{
      Map? value = itemList.firstWhere((element) => element['value'] == initialValue);
      if(value != null){
        onChanged(value['value']);
        return value['value'];
      }
      return null;
    }catch(error){
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label ?? ""),
        const SizedBox(height: 12.0),
        DropdownButtonHideUnderline(
          child: DropdownButtonFormField(
            value: initialValue,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
              border: OutlineInputBorder()
            ),
            items: itemList.map((item)=> DropdownMenuItem(
              value: item['value'],
              child: Text(item['name'] ?? ""),
            )).toList(), 
            onChanged: onChanged
          ),
        )
      ]
    );
  }
}