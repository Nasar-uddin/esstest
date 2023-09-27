import 'package:essapp/bloc/bloc_base.dart';
import 'package:flutter/material.dart';

class BlocProvider<T extends BlocBase> extends InheritedWidget {
  const BlocProvider({
    super.key,
    required super.child,
    required this.bloc,
  });

  final T bloc;

  static T of<T extends BlocBase>(BuildContext context) {
    BlocProvider<T>? provider = context.findAncestorWidgetOfExactType<BlocProvider<T>>();
    if(provider?.bloc == null){
      throw Exception("No bloc found");
    }
    return provider!.bloc;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}