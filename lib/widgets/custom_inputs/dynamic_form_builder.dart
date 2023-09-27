import 'dart:convert';
import 'dart:io';

import 'package:essapp/bloc/bloc_provider.dart';
import 'package:essapp/bloc/custom_order_bloc.dart';
import 'package:essapp/models/custom_order_response.dart';
import 'package:essapp/models/dynamic_form_field_value.dart';
import 'package:essapp/widgets/custom_inputs/custom_dropdown.dart';
import 'package:essapp/widgets/custom_inputs/custom_image_picker_field.dart';
import 'package:essapp/widgets/custom_inputs/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DynamicFormBuilder extends StatelessWidget {
  const DynamicFormBuilder({super.key, required this.fields});

  final List<Fields> fields;


  @override
  Widget build(BuildContext context) {
    final CustomOrderBloc customOrderBloc = BlocProvider.of<CustomOrderBloc>(context);
    const double bottomSpace = 16.0;

    // debugPrint("re rendered.....................");
    // setting default value to form field data
    for (var field in fields) {
      if(field.properties?['defaultValue'] != null){
        customOrderBloc.formData[field.key ?? ""] = DynamicFormFieldValue(
          value: field.properties?['defaultValue'],
          type: field.properties?['type'],
          label: field.properties?['label']
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: fields.map((field){
        switch(field.properties?['type'] ?? ""){
          case "text":
            return Padding(
              padding: const EdgeInsets.only(bottom: bottomSpace),
              child: CustomTextField(
                label: field.properties?["label"] ?? "",
                hintText: field.properties?['hintText'],
                defaultValue: field.properties?['defaultValue'],
                onChanged: (String value){
                  customOrderBloc.formData[field.key ?? ""] = DynamicFormFieldValue(
                    value: value,
                    type: field.properties?['type'],
                    label: field.properties?['label']
                  );
                },
                validator: (String? value){
                  String? error;
                  if(field.properties?['minLength'] != null){
                    error = (value?.length ?? 0) >= field.properties?['minLength'] ? null : "Min length ${field.properties?['minLength']}";
                    if(error != null) return error;
                  }
                  if(field.properties?['maxLength'] != null){
                    error = (value?.length ?? 0) <= field.properties?['maxLength'] ? null : "Max length ${field.properties?['maxLength']}";
                  }
                  return error;
                },
              )
            );
          case "numberText":
            return Padding(
              padding: const EdgeInsets.only(bottom: bottomSpace),
              child: CustomTextField(
                label: field.properties?["label"] ?? "",
                hintText: field.properties?['hintText'],
                defaultValue: "${field.properties?['defaultValue']}",
                formater: [FilteringTextInputFormatter.digitsOnly],
                inputType: TextInputType.number,
                onChanged: (value){
                  customOrderBloc.formData[field.key ?? ""] = DynamicFormFieldValue(
                    value: value,
                    type: field.properties?['type'],
                    label: field.properties?['label']
                  );
                },
              ),
            );
          case "imageView": return Padding(
            padding: const EdgeInsets.only(bottom: bottomSpace),
            child: CustomImagePickerField(
              label: field.properties?['label'],
              defaultValue: field.properties?['defaultValue'],
              onLoadComplete: (XFile? imageFile) async {
                if(imageFile == null) return;
                final String duplicateFilePath = (await getApplicationDocumentsDirectory()).path;
                File imF = File(imageFile.path);
                final fileName = basename(imageFile.path);
                final File localImage = await imF.copy('$duplicateFilePath/$fileName');
                customOrderBloc.formData[field.key ?? ""] = DynamicFormFieldValue(
                    value: localImage.path,
                    type: field.properties?['type'],
                    label: field.properties?['label']
                  );
                // print(customOrderBloc.formData);
              }),
            );
          case "dropDownList":{
            return Padding(
              padding: const EdgeInsets.only(bottom: bottomSpace),
              child: CustomDropdown(
                label: field.properties?['label'],
                itemList: json.decode(field.properties?["listItems"]),
                initialValue: customOrderBloc.formData[field.key]?.value,
                onChanged: (value){
                  customOrderBloc.formData[field.key ?? ""] = DynamicFormFieldValue(
                    value: value,
                    type: field.properties?['type'],
                    label: field.properties?['label']
                  );
                },
              ),
            );
          } 
          case "viewText": {
            // customOrderBloc.formData[field.key ?? ""] = field.properties?['defaultValue'] ?? "";
            return Padding(
              padding: const EdgeInsets.only(bottom: bottomSpace),
              child: CustomTextField(
                // label: field.properties?['label'],
                isReadyOnly: true,
                defaultValue: field.properties?['label'],
              ),
            );
          }
          default:
            return Padding(
              padding: const EdgeInsets.only(bottom: bottomSpace),
              child: Text(field.properties?['label'] ?? ""),
            );
        }
      }).toList(),
    );
  }
}