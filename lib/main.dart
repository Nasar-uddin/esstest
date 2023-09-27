import 'package:essapp/bloc/auth_bloc.dart';
import 'package:essapp/bloc/bloc_provider.dart';
import 'package:essapp/bloc/custom_order_bloc.dart';
import 'package:essapp/bloc/info_bloc.dart';
import 'package:essapp/pages/custom_order_page/custom_order_page.dart';
import 'package:essapp/pages/custom_order_page/invoice_page.dart';
import 'package:essapp/pages/feedback_page/feedback_page.dart';
import 'package:essapp/pages/home_page/home_page.dart';
import 'package:essapp/pages/login_page/login_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const BlocWraper();
  }
}

class BlocWraper extends StatefulWidget {
  const BlocWraper({super.key});

  @override
  State<BlocWraper> createState() => _BlocWraperState();
}

class _BlocWraperState extends State<BlocWraper> {
  final AuthBloc _authBloc = AuthBloc();
  final InfoBloc _infoBloc = InfoBloc();
  final CustomOrderBloc _customOrderBloc = CustomOrderBloc();

  @override
  void dispose() {
    _authBloc.dispose();
    _customOrderBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InfoBloc>(
      bloc: _infoBloc,
      child: BlocProvider<AuthBloc>(
        bloc: _authBloc,
        child: BlocProvider<CustomOrderBloc>(
          bloc: _customOrderBloc,
          child: MaterialApp(
            title: 'ESS demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.indigo,
            ),
            initialRoute: HomePage.routeName,
            // initialRoute: LoginPage.routeName,
            routes: {
              LoginPage.routeName: (context) => const LoginPage(),
              HomePage.routeName: (context) => const HomePage(),
              CustomOrderPage.routeName: (context) => const CustomOrderPage(),
              FeedbackPage.routeName:(context) => const FeedbackPage(),
              InvoicePage.routeName: (context) => const InvoicePage()
            },
          ),
        ),
      ),
    );
  }
}
