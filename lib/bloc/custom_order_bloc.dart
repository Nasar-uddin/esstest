import 'dart:async';
import 'dart:convert';

import 'package:essapp/bloc/bloc_base.dart';
import 'package:essapp/models/custom_order_response.dart';
import 'package:essapp/models/dynamic_form_field_value.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

const invoiceBoxName = "invoiceBox";

class CustomOrderBloc extends BlocBase{
  
  CustomOrderResponse? response;

  Map<String, DynamicFormFieldValue> formData = {};
  
  StreamController<CustomOrderResponse?> customOrderResponseStreamController = StreamController<CustomOrderResponse?>.broadcast();

  Box? invoiceBox;

  loadJsonData() async {
    final String jsonData = await rootBundle.loadString("assets/response.json");
    response = CustomOrderResponse.fromJson(json.decode(jsonData));
    customOrderResponseStreamController.add(response);
  }

  Future<Box> getOpenBox() async {
    if(invoiceBox == null){
      final documentsDirectory = await getApplicationDocumentsDirectory();
      Hive.init(documentsDirectory.path);
      invoiceBox ??= await Hive.openBox(invoiceBoxName);
    }
    return invoiceBox!;
  }

  saveImage(XFile? imageFile) async {

  }

  saveInvoiceAsString() async {
    if(formData.isNotEmpty){
      var box = await getOpenBox();
      // String ss = json.encode(formData);
      // print(ss);
      // return;
      await box.add(json.encode(formData));
    }
  }

  

  @override
  void dispose() {
    customOrderResponseStreamController.close();
    invoiceBox?.close();
  }

}