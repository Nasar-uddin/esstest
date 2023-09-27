import 'package:essapp/pages/custom_order_page/custom_order_page.dart';
import 'package:essapp/pages/feedback_page/feedback_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const routeName = "/home";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleButton(
                label: "Custom order",
                bgColor: Theme.of(context).primaryColor,
                onPressed: (){
                  Navigator.pushNamed(context, CustomOrderPage.routeName);
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleButton(
                label: "Feedback",
                bgColor: Colors.greenAccent[700],
                onPressed: (){
                  Navigator.pushNamed(context, FeedbackPage.routeName);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CircleButton extends StatelessWidget {
  const CircleButton({
    super.key,
    this.onPressed,
    required this.label,
    this.bgColor
  });

  final String label;
  final void Function()? onPressed;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: bgColor
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white
          ),
        ),
      ),
    );
  }
}