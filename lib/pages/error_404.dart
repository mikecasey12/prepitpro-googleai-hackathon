import 'package:flutter/material.dart';

class Error404Page extends StatelessWidget {
  const Error404Page({super.key});
  static const routeName = "/error-404";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Couldn't find what you were looking for",
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text("Go Home"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
