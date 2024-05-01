import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prepitpro/components/action_button.dart';
import 'package:prepitpro/components/gap.dart';
import 'package:prepitpro/components/primary_button.dart';
import 'package:prepitpro/pages/generated_answer_review.dart';

class GeneratedQuestionsPracticePage extends StatefulWidget {
  const GeneratedQuestionsPracticePage({super.key});
  static const routeName = "/generated-questions-practice";

  @override
  State<GeneratedQuestionsPracticePage> createState() =>
      _GeneratedQuestionsPracticeStatePage();
}

class _GeneratedQuestionsPracticeStatePage
    extends State<GeneratedQuestionsPracticePage> {
  late List<Map<String, dynamic>> questions;
  final PageController _pageController = PageController(keepPage: true);
  int currentIndex = 0;
  bool _isShuffled = false;

  @override
  void didChangeDependencies() {
    if (!_isShuffled) {
      questions = ModalRoute.of(context)!.settings.arguments
          as List<Map<String, dynamic>>;
      questions.shuffle();
      _isShuffled = true;
    }
    super.didChangeDependencies();
  }

  void nextQuestion() {
    _pageController.nextPage(duration: Durations.short4, curve: Curves.linear);
  }

  void prevQuestion() {
    _pageController.previousPage(
        duration: Durations.short4, curve: Curves.linear);
  }

  final List<Map<String, dynamic>> answers = [];

  void addToAnswerList(String value, String questionId, String correctAnswer) {
    setState(() {
      final optionIndex =
          answers.indexWhere((element) => element["questionId"] == questionId);
      if (optionIndex != -1) {
        answers[optionIndex]["answer"] = value;
        return;
      }
      answers.add({
        "questionId": questionId,
        "answer": value,
        "correctAnswer": correctAnswer
      });
    });
  }

  String checkSelected(String questionId) {
    final optionIndex =
        answers.indexWhere((element) => element["questionId"] == questionId);
    if (optionIndex != -1) {
      return answers[optionIndex]["answer"] as String;
    }
    return "";
  }

  void onSubmit() async {
    final result = await showAdaptiveDialog(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          title: const Text("Submit"),
          content: Text(
            "You're about submitting your answers.",
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text("Submit")),
            TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text("Cancel")),
          ],
        );
      },
    );

    if (result && mounted) {
      Navigator.pushReplacementNamed(
          context, GeneratedAnswerReviewPage.routeName,
          arguments: {
            "userAnswers": answers,
            "questionsTotal": questions.length,
            "questions": questions
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final lastQuestion = currentIndex + 1 == questions.length;
    final backgroundColor = Theme.of(context).colorScheme.tertiary;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Generated Questions"),
          leading: null,
          automaticallyImplyLeading: false,
          actions: [
            ActionButton(
              icon: Icons.close,
              size: 48,
              onTap: () => Navigator.pop(context),
            ),
            const Gap()
          ],
        ),
        body: questions.isEmpty
            ? Center(
                child: Text(
                  "No questions generated, try again",
                  style:
                      TextStyle(fontWeight: FontWeight.w500, color: textColor),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      constraints: const BoxConstraints(minHeight: 60),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Theme.of(context).colorScheme.secondary),
                      child: Row(
                        children: [
                          const ActionButton(
                            icon: Icons.menu_book_outlined,
                            size: 28,
                            borderWidth: 0,
                            iconColor: Colors.black87,
                            backgroundColor: Colors.white,
                          ),
                          const Gap(),
                          AutoSizeText(
                            questions[0]["subject"] as String,
                            overflow: TextOverflow.ellipsis,
                            minFontSize: 10,
                            maxFontSize: 12,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          const Gap(),
                          Expanded(
                            child: LinearProgressIndicator(
                              value: ((currentIndex + 1) / questions.length),
                            ),
                          ),
                          const Gap(),
                          Text("${currentIndex + 1}/${questions.length}")
                        ],
                      ),
                    ),
                    const Gap(),
                    Expanded(
                      child: PageView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        onPageChanged: (value) {
                          setState(() {
                            currentIndex = value;
                          });
                        },
                        itemBuilder: (context, index) {
                          final questionId = questions[index]["id"].toString();
                          String selected = checkSelected(questionId);
                          final option = questions[index]["option_a"] as String;
                          final optionb =
                              questions[index]["option_b"] as String;
                          final optionc =
                              questions[index]["option_c"] as String;
                          final optiond =
                              questions[index]["option_d"] as String;
                          final correctAnswer =
                              questions[index]["answer"] as String;
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: backgroundColor),
                            child: ListView(
                              children: [
                                Text(
                                  "Question ${currentIndex + 1}:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: textColor),
                                ),
                                Text(
                                  "${questions[index]["question"]}",
                                  style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20,
                                          color: textColor)),
                                ),
                                const Gap(),
                                Text(
                                  "Options:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: textColor),
                                ),
                                ChoiceChip(
                                  clipBehavior: Clip.none,
                                  elevation: 0,
                                  padding: const EdgeInsets.all(16),
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide.none,
                                      borderRadius: BorderRadius.circular(99)),
                                  label: SizedBox(
                                    width: size.width,
                                    child: Text(
                                      "A. $option",
                                      overflow: TextOverflow.visible,
                                      softWrap: true,
                                      maxLines: 10,
                                    ),
                                  ),
                                  selected: selected == option,
                                  selectedColor: Colors.black87,
                                  checkmarkColor: Colors.amber,
                                  labelStyle: TextStyle(
                                      color: selected == option
                                          ? Colors.white
                                          : Colors.black87),
                                  onSelected: (_) {
                                    addToAnswerList(
                                        option, questionId, correctAnswer);
                                  },
                                ),
                                const Gap(),
                                ChoiceChip(
                                  clipBehavior: Clip.none,
                                  padding: const EdgeInsets.all(16),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide.none,
                                      borderRadius: BorderRadius.circular(99)),
                                  label: SizedBox(
                                    width: size.width,
                                    child: Text(
                                      "B. $optionb",
                                      overflow: TextOverflow.visible,
                                      softWrap: true,
                                      maxLines: 10,
                                    ),
                                  ),
                                  selected: selected == optionb,
                                  selectedColor: Colors.black87,
                                  checkmarkColor: Colors.amber,
                                  labelStyle: TextStyle(
                                      color: selected == optionb
                                          ? Colors.white
                                          : Colors.black87),
                                  onSelected: (_) {
                                    addToAnswerList(
                                        optionb, questionId, correctAnswer);
                                  },
                                ),
                                const Gap(),
                                ChoiceChip(
                                  clipBehavior: Clip.none,
                                  elevation: 0,
                                  padding: const EdgeInsets.all(16),
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide.none,
                                      borderRadius: BorderRadius.circular(99)),
                                  label: SizedBox(
                                    width: size.width,
                                    child: Text(
                                      "C. $optionc",
                                      overflow: TextOverflow.visible,
                                      softWrap: true,
                                      maxLines: 10,
                                    ),
                                  ),
                                  selected: selected == optionc,
                                  selectedColor: Colors.black87,
                                  checkmarkColor: Colors.amber,
                                  labelStyle: TextStyle(
                                      color: selected == optionc
                                          ? Colors.white
                                          : Colors.black87),
                                  onSelected: (_) {
                                    addToAnswerList(
                                        optionc, questionId, correctAnswer);
                                  },
                                ),
                                const Gap(),
                                ChoiceChip(
                                  clipBehavior: Clip.none,
                                  elevation: 0,
                                  padding: const EdgeInsets.all(16),
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide.none,
                                      borderRadius: BorderRadius.circular(99)),
                                  label: SizedBox(
                                    width: size.width,
                                    child: Text(
                                      "D. $optiond",
                                      overflow: TextOverflow.visible,
                                      softWrap: true,
                                      maxLines: 10,
                                    ),
                                  ),
                                  selected: selected == optiond,
                                  selectedColor: Colors.black87,
                                  checkmarkColor: Colors.amber,
                                  labelStyle: TextStyle(
                                      color: selected == optiond
                                          ? Colors.white
                                          : Colors.black87),
                                  onSelected: (_) {
                                    addToAnswerList(
                                        optiond, questionId, correctAnswer);
                                  },
                                ),
                                Container(
                                  width: size.width,
                                  margin: const EdgeInsets.only(top: 24),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        children: [
                                          PrimaryButton(
                                            padding: 12,
                                            text: "Back",
                                            reverse: true,
                                            icon: Icons.arrow_back_outlined,
                                            onTap: prevQuestion,
                                          ),
                                          const Gap(),
                                          PrimaryButton(
                                            padding: 12,
                                            text: lastQuestion
                                                ? "Submit"
                                                : "Next",
                                            icon: Icons.arrow_forward_outlined,
                                            onTap: lastQuestion
                                                ? onSubmit
                                                : nextQuestion,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        itemCount: questions.length,
                        controller: _pageController,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
