// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:essapp/bloc/bloc_base.dart';
import 'package:essapp/models/custom_order_response.dart';
import 'package:essapp/models/dynamic_form_field_value.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

const invoiceBoxName = "invoiceBox";

class CustomOrderBloc extends BlocBase{
  
  CustomOrderResponse? response;

  Map<String, DynamicFormFieldValue> formData = {};
  List<Map<String, dynamic>> csvData = [];
  
  StreamController<CustomOrderResponse?> customOrderResponseStreamController = StreamController<CustomOrderResponse?>.broadcast();
  StreamController<Map<String,DynamicFormFieldValue>> formDataStreamController = StreamController<Map<String,DynamicFormFieldValue>>.broadcast();

  Box? invoiceBox;

  loadJsonData() async {
    final String jsonData = await rootBundle.loadString("assets/response.json");
    response = CustomOrderResponse.fromJson(json.decode(jsonData));
    customOrderResponseStreamController.add(response);
    csvData = await loadDataFromCsv("assets/FruitPrices.csv");
    // queryFromMap(data: csvData, field: 'ProductCode', value: 1);
  }

  Future<Box> getOpenBox() async {
    if(invoiceBox == null){
      final documentsDirectory = await getApplicationDocumentsDirectory();
      Hive.init(documentsDirectory.path);
      invoiceBox ??= await Hive.openBox(invoiceBoxName);
    }
    return invoiceBox!;
  }

  mapValueToFields({required dynamic value, required Fields field, required int sectionIndex}){
    try {
      // find search list
      ValueMappingItem? item = response?.valueMapping?[sectionIndex].searchList?.firstWhere((el) => el.fieldKey == field.key);
      // get data from search list and value
      final queriedData = queryFromMap(data: csvData, field: item?.dataColumn ?? "", value: value);
      // set data to the form data
      if(queriedData != null){
        response?.valueMapping?[sectionIndex].displayList?.forEach((el) {
          // now you have the field key. get value from sections
          try {
            
            final sectionField = response?.sections?[sectionIndex].fields?.firstWhere((element) => el.fieldKey == element.key);

            formData[el.fieldKey?? ""] = DynamicFormFieldValue(
              value: queriedData[el.dataColumn],
              type: sectionField?.properties?['type'],
              label: sectionField?.properties?['label']
            );
          } catch (error) {
            print("No filed found for this key");
          }
        });
        formDataStreamController.add(formData);
      }
    } catch (error) {
      print(error);
    }
  }

  saveInvoiceAsString() async {
    // empty previous data
    formData = {};
    formDataStreamController.add(formData);
    if(formData.isNotEmpty){
      var box = await getOpenBox();
      // String ss = json.encode(formData);
      // print(ss);
      // return;
      await box.add(json.encode(formData));
    }
  }

  Future<List<Map<String, dynamic>>> loadDataFromCsv(String csvFilePath) async {
    final data = await rootBundle.loadString(csvFilePath);
    final List<List<dynamic>> listOfData = const CsvToListConverter().convert(data);
    // print(listOfData);
    List<Map<String, dynamic>> newData = [];
    // transform only if the array size is getter than 2
    if(listOfData.length > 2){
      List keys = listOfData.first;
      for(int start = 1;start < listOfData.length; start++){
        Map<String, dynamic> temp = {};
        for(int i = 0 ; i < keys.length ; i++){
          temp[keys[i]] = listOfData[start][i];
        }
        newData.add(temp);
      }
      // print(newData);
    }
    return newData;
  }
  
  Map<String, dynamic>? queryFromMap({required List<Map<String, dynamic>> data, required String field, dynamic value}){
    try {
      Map<String, dynamic>? foundData;
      foundData = data.firstWhere((element) => element[field] == value);
      return foundData;
    } catch (error) {
      return null;
    }
  }

  @override
  void dispose() {
    customOrderResponseStreamController.close();
    invoiceBox?.close();
    formDataStreamController.close();
  }

}