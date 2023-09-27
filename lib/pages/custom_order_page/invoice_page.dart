import 'dart:io';

import 'package:essapp/bloc/bloc_provider.dart';
import 'package:essapp/bloc/custom_order_bloc.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class InvoicePage extends StatefulWidget {
  const InvoicePage({super.key});

  static const String routeName = "/invoice";

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {

  late CustomOrderBloc _customOrderBloc;

  final TextStyle labelTextStyle = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600
  );
  final TextStyle valueTextStyle = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400
  );

  @override
  void initState() {
    super.initState();
    _customOrderBloc = BlocProvider.of<CustomOrderBloc>(context);
  }
  
  Future<bool> willPopScope() async {
     bool? willPop = await showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text("Do you really want to lose the changes ??"),
        actions: [
          TextButton(
            child: const Text("No"),
            onPressed: (){
              Navigator.pop(ctx, false);
            }, 
          ),
          TextButton(
            child: const Text("Yes"),
            onPressed: (){
              Navigator.pop(ctx, true);
            }, 
          )
        ],
      )
    );
    return willPop ?? false;
  }

  @override
  Widget build(BuildContext context) {
    // print(_customOrderBloc.formData);
    return WillPopScope(
      onWillPop: willPopScope,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Invoice"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: _customOrderBloc.formData.entries.map((entity){
                    if(entity.value.type == "imageView"){
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                entity.value.label ?? "",
                                style: labelTextStyle,
                              ),
                            ),
                            entity.value.value.toString().contains("http")
                              ? Image.network(
                                entity.value.value,
                                height: 80,  
                              )
                              : Image.file(
                                File(entity.value.value),
                                height: 80,
                              )
                          ],
                        ),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              entity.value.label ?? "",
                              style: labelTextStyle,
                            )
                          ),
                          Text(
                            "${entity.value.value}",
                            style: valueTextStyle,
                          )
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12.0),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        child: const Text("Save"),
                        onPressed: () async {
                          await _customOrderBloc.saveInvoiceAsString();
                          Fluttertoast.showToast(msg: "Invoice is saved");
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        }, 
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}