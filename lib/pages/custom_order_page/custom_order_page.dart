import 'package:essapp/bloc/bloc_provider.dart';
import 'package:essapp/bloc/custom_order_bloc.dart';
import 'package:essapp/models/custom_order_response.dart';
import 'package:essapp/pages/custom_order_page/invoice_page.dart';
import 'package:essapp/widgets/custom_inputs/dynamic_form_builder.dart';
import 'package:flutter/material.dart';

class CustomOrderPage extends StatefulWidget {
  const CustomOrderPage({super.key});

  static const routeName = "/custom_order";

  @override
  State<CustomOrderPage> createState() => _CustomOrderPageState();
}

class _CustomOrderPageState extends State<CustomOrderPage> {
  
  late CustomOrderBloc customOrderBloc;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    customOrderBloc = BlocProvider.of<CustomOrderBloc>(context);
    customOrderBloc.loadJsonData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Custom Order page"),
      ),
      body: Container(
        padding: const EdgeInsets.all(12.0),
        child: StreamBuilder(
          stream: customOrderBloc.customOrderResponseStreamController.stream,
          builder: (BuildContext context, AsyncSnapshot<CustomOrderResponse?> snapshot){
            if(snapshot.hasData){
              // print(snapshot.data?.sections?.first.toJson());
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snapshot.data?.formName ?? "",
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    Form(
                      key: formKey,
                      child: ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: snapshot.data?.sections?.map((section){
                          int? sectionIndex = snapshot.data?.sections?.indexOf(section);
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                section.name ?? "",
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 12.0),
                              DynamicFormBuilder(fields: section.fields ?? [], sectionIndex: sectionIndex ?? 0),
                            ],
                          );
                        }).toList() ?? [],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            child: const Text("Submit"),
                            onPressed: (){
                              if(formKey.currentState?.validate() ?? false){
                                // print(customOrderBloc.formData);
                                Navigator.pushReplacementNamed(context, InvoicePage.routeName);
                              }
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            }else if(snapshot.hasError){
              return const Center(
                child: Text("Error getting the data")
              );
            }else{
              return const Center(
                child: CircularProgressIndicator(strokeWidth: 3),
              );
            }
          },
        )
      ),
    );
  }
}