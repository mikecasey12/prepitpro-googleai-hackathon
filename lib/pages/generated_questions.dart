import 'package:flutter/material.dart';
import 'package:prepitpro/components/action_button.dart';
import 'package:prepitpro/components/gap.dart';
import 'package:prepitpro/components/primary_button.dart';
import 'package:prepitpro/pages/generated_questions_practice.dart';
import 'package:prepitpro/utils/pip_ai.dart';

class GeneratedQuestionsPage extends StatefulWidget {
  const GeneratedQuestionsPage({super.key});
  static const routeName = "/generated-questions";

  @override
  State<GeneratedQuestionsPage> createState() => _GeneratedQuestionsPageState();
}

class _GeneratedQuestionsPageState extends State<GeneratedQuestionsPage> {
  late String questions;
  bool hasRan = false;
  List<Map<String, dynamic>> jsonArray = [];

  @override
  void didChangeDependencies() {
    if (!hasRan) {
      questions = ModalRoute.of(context)!.settings.arguments as String;
      PIPAI.formatQuestions(questions: questions, jsonArray: jsonArray);
      hasRan = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("Questions Generated"),
        leading: null,
        automaticallyImplyLeading: false,
        actions: [
          ActionButton(
            icon: Icons.close,
            size: 40,
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Gap()
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          Text(
            "Your Questions have been Generated Successfully. You can proceed to answering the questions",
            textAlign: TextAlign.center,
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color),
          ),
          const Gap(),
          Center(
            child: PrimaryButton(
              padding: 12,
              onTap: () {
                Navigator.pushNamed(
                    context, GeneratedQuestionsPracticePage.routeName,
                    arguments: jsonArray);
              },
              text: "Start Test",
              width: 120,
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
          )
        ],
      ),
    ));
  }
}
