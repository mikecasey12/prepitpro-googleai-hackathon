import 'package:flutter/material.dart';
import 'package:prepitpro/components/gap.dart';
import 'package:prepitpro/utils/pip_ai.dart';
import 'package:typeset/typeset.dart';

class AIExplanation extends StatefulWidget {
  final String? question;
  final String? userSelected;
  final String? correctAnswer;
  const AIExplanation(
      {super.key,
      required this.question,
      required this.userSelected,
      required this.correctAnswer});

  @override
  State<AIExplanation> createState() => _AIExplanationState();
}

class _AIExplanationState extends State<AIExplanation> {
  Future<String?>? _futureData;

  @override
  void initState() {
    _futureData = PIPAI.explainAnswer(
        question: widget.question, answer: widget.correctAnswer);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textColor = Theme.of(context).textTheme.bodyLarge!.color;
    return Container(
        height: size.height * 0.8,
        padding: const EdgeInsets.all(16),
        child: FutureBuilder(
          future: _futureData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView(
              children: [
                const Text(
                  "Question:",
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.amber),
                ),
                Text(
                  "${widget.question}",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: textColor,
                      fontSize: 20),
                ),
                const Gap(),
                const Text(
                  "Answer:",
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.amber),
                ),
                Text(
                  "${widget.correctAnswer}",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: textColor,
                      fontSize: 20),
                ),
                const Gap(),
                const Text(
                  "PIP AI Explanation:",
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.amber),
                ),
                TypeSet(
                  "${snapshot.data}",
                  style: TextStyle(color: textColor),
                )
              ],
            );
          },
        ));
  }
}
