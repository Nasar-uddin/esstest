import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CustomImagePickerField extends StatefulWidget {
  const CustomImagePickerField({super.key, this.label, this.defaultValue, this.onLoadComplete});

  final void Function(XFile? imageFile)? onLoadComplete;
  final String? label;
  final String? defaultValue;

  @override
  State<CustomImagePickerField> createState() => _CustomImagePickerFieldState();
}

class _CustomImagePickerFieldState extends State<CustomImagePickerField> {

  final ImagePicker _imagePicker = ImagePicker();

  XFile? imageFile;
  File? igFile;
  

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.label != null ? Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Text(widget.label ?? ""),
        ) : const SizedBox(),
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: const Color(0xFFE7EAEA),
            borderRadius: BorderRadius.circular(5.0)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              imageFile == null && widget.defaultValue == null ?
                const Text("No image selected")
                : ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: imageFile != null ? Image.file(
                    File(imageFile!.path),
                    height: 80,
                  ) : Image.network(
                    widget.defaultValue ?? "",
                    height: 80
                  ),
                ),
              TextButton(
                child: const Icon(
                  Icons.add_photo_alternate_outlined,
                  color: Colors.black,
                  size: 30,
                ),
                onPressed: () async{
                  try {
                    XFile? pickedFile =  await _imagePicker.pickImage(source: ImageSource.gallery);
                    if(pickedFile != null){
                      Uint8List? ul =  await pickedFile.readAsBytes();
                      igFile = File.fromRawPath(ul);
                      setState(() {
                        imageFile = pickedFile;
                      });
                      widget.onLoadComplete!(pickedFile);
                    }
                  } catch (error) {
                    //
                  }
                }, 
              )
            ],
          ),
        ),
      ],
    );
  }
}