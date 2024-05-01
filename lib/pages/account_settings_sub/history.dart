import 'package:flutter/material.dart';
import 'package:prepitpro/components/action_button.dart';
import 'package:prepitpro/components/gap.dart';

class HistoryPage extends StatelessWidget {
  final String? title;
  const HistoryPage({super.key, required this.title});
  static const routeName = "/history";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("$title"),
        leading: null,
        automaticallyImplyLeading: false,
        actions: [
          ActionButton(
            icon: Icons.close,
            size: 30,
            onTap: () => Navigator.pop(context),
          ),
          const Gap()
        ],
      ),
    ));
  }
}
