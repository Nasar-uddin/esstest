import 'package:essapp/widgets/custom_inputs/custom_audio_input.dart';
import 'package:essapp/widgets/custom_inputs/custom_image_picker_field.dart';
import 'package:essapp/widgets/custom_inputs/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  static const routeName = "/feedback";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Feedback"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            CustomTextField(
              label: "Feedback",
              isMultiline: true,
              maxLines: 4,
              onChanged: (String value){

              },
            ),
            const SizedBox(height: 16.0),
            CustomImagePickerField(
              onLoadComplete: (XFile? imageFile){
                debugPrint(imageFile!.path);
              },
            ),
            const SizedBox(height: 12.0),
            CustomAudionInput(
              onRecordComplete: (String? path){
                debugPrint(path);
              },
            ),
            const SizedBox(height: 12.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: const Text("Submit"),
                onPressed: (){
                  
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}