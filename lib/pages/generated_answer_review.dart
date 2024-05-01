import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prepitpro/components/action_button.dart';
import 'package:prepitpro/components/ai_explanation.dart';
import 'package:prepitpro/components/gap.dart';
import 'package:prepitpro/components/primary_button.dart';
import 'package:prepitpro/helpers/messenger.dart';

class GeneratedAnswerReviewPage extends StatefulWidget {
  const GeneratedAnswerReviewPage({super.key});
  static const routeName = "/generated-answer-review";

  @override
  State<GeneratedAnswerReviewPage> createState() =>
      _GeneratedAnswerReviewPageState();
}

class _GeneratedAnswerReviewPageState extends State<GeneratedAnswerReviewPage> {
  late int questionsTotal;
  late List<Map<String, dynamic>> userAnswers;
  late List<Map<String, dynamic>> questions;
  final PageController _pageController = PageController(keepPage: true);
  int currentIndex = 0;
  bool hasRan = false;

  @override
  void didChangeDependencies() {
    if (!hasRan) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, Object>;
      questionsTotal = args["questionsTotal"] as int;
      userAnswers = args["userAnswers"] as List<Map<String, dynamic>>;
      questions = args["questions"] as List<Map<String, dynamic>>;
      retrieveCorrectAnswers();
      checkAnswersAgainstUserAnswers();
      hasRan = true;
    }

    super.didChangeDependencies();
  }

  var correctOption = [];
  var correctAnswers = [];
  var userAns = [];
  var passedQuestions = [];
  var failedQuestions = [];

  void retrieveCorrectAnswers() {
    for (var question in questions) {
      correctOption.add({
        "questionId": question["id"].toString(),
        "answer": question["answer"]
      });
    }

    for (var question in questions) {
      for (var option in correctOption) {
        if (question["id"].toString() == option["questionId"]) {
          correctAnswers.add(question["id"].toString() +
              question[option["answer"]].toString());
        }
      }
    }
    for (var ua in userAnswers) {
      userAns.add(ua["questionId"].toString() + ua["answer"].toString());
    }
  }

  void checkAnswersAgainstUserAnswers() {
    for (var ua in correctAnswers) {
      if (userAns.contains(ua)) {
        passedQuestions.add(ua);
      } else {
        failedQuestions.add(ua);
      }
    }
  }

  void nextQuestion() {
    _pageController.nextPage(duration: Durations.short4, curve: Curves.linear);
  }

  void prevQuestion() {
    _pageController.previousPage(
        duration: Durations.short4, curve: Curves.linear);
  }

  String checkSelected(String questionId) {
    final optionIndex = userAnswers
        .indexWhere((element) => element["questionId"] == questionId);
    if (optionIndex != -1) {
      return userAnswers[optionIndex]["answer"] as String;
    }
    return "";
  }

  bool isCorrect(String questionId, String answer) {
    // correctAnswers
    final status = passedQuestions.contains(questionId + answer);
    return status;
  }

  bool isInCorrect(String questionId, String answer) {
    // correctAnswers
    final status = failedQuestions.contains(questionId + answer);
    return status;
  }

  void onContinueTest() {
    Navigator.pop(context);
  }

  void _showBottomDialog(
      String question, String userSelected, String correctAnswer) {
    final size = MediaQuery.of(context).size;
    showModalBottomSheet(
      enableDrag: true,
      showDragHandle: true,
      scrollControlDisabledMaxHeightRatio: size.height * 0.8,
      useSafeArea: true,
      context: context,
      builder: (context) {
        return AIExplanation(
            question: question,
            userSelected: userSelected,
            correctAnswer: correctAnswer);
      },
    );
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
        title: const Text("Answers Review"),
        leading: null,
        automaticallyImplyLeading: false,
        actions: [
          ActionButton(
            icon: Icons.close,
            size: 40,
            onTap: () => Navigator.pop(context),
          ),
          const Gap()
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.amber.shade100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      Text(
                        "$questionsTotal",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                      const Text(
                        "Total Questions",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "${passedQuestions.length}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const Text(
                        "Passed",
                        style: TextStyle(color: Colors.green),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "${failedQuestions.length}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const Text(
                        "Failed",
                        style: TextStyle(color: Colors.red),
                      )
                    ],
                  )
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
                  final option = questions[index]["option_a"] as String;
                  final optionb = questions[index]["option_b"] as String;
                  final optionc = questions[index]["option_c"] as String;
                  final optiond = questions[index]["option_d"] as String;
                  String selected = checkSelected(questionId);
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
                              fontWeight: FontWeight.w500, color: textColor),
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
                              fontWeight: FontWeight.w500, color: textColor),
                        ),
                        ChoiceChip(
                          elevation: 0,
                          padding: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                              side: BorderSide.none,
                              borderRadius: BorderRadius.circular(99)),
                          label: SizedBox(
                            width: size.width,
                            child: Text("A. $option"),
                          ),
                          backgroundColor: selected == option
                              ? isCorrect(questionId, option)
                                  ? Colors.green
                                  : Colors.red
                              : isInCorrect(questionId, option)
                                  ? Colors.green
                                  : null,
                          selected: selected == option,
                          selectedColor: isCorrect(questionId, option)
                              ? Colors.green
                              : Colors.red,
                          checkmarkColor: Colors.amber,
                          labelStyle: TextStyle(
                              color: selected == option
                                  ? Colors.white
                                  : Colors.black87),
                          onSelected: (_) {},
                        ),
                        const Gap(),
                        ChoiceChip(
                          elevation: 0,
                          padding: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                              side: BorderSide.none,
                              borderRadius: BorderRadius.circular(99)),
                          label: SizedBox(
                            width: size.width,
                            child: Text("B. $optionb"),
                          ),
                          backgroundColor: selected == optionb
                              ? isCorrect(questionId, optionb)
                                  ? Colors.green
                                  : Colors.red
                              : isInCorrect(questionId, optionb)
                                  ? Colors.green
                                  : null,
                          selected: selected == optionb,
                          selectedColor: isCorrect(questionId, optionb)
                              ? Colors.green
                              : Colors.red,
                          checkmarkColor: Colors.amber,
                          labelStyle: TextStyle(
                              color: selected == optionb
                                  ? Colors.white
                                  : Colors.black87),
                          onSelected: (_) {},
                        ),
                        const Gap(),
                        ChoiceChip(
                          elevation: 0,
                          padding: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                              side: BorderSide.none,
                              borderRadius: BorderRadius.circular(99)),
                          label: SizedBox(
                            width: size.width,
                            child: Text("C. $optionc"),
                          ),
                          backgroundColor: selected == optionc
                              ? isCorrect(questionId, optionc)
                                  ? Colors.green
                                  : Colors.red
                              : isInCorrect(questionId, optionc)
                                  ? Colors.green
                                  : null,
                          selected: selected == optionc,
                          selectedColor: isCorrect(questionId, optionc)
                              ? Colors.green
                              : Colors.red,
                          checkmarkColor: Colors.amber,
                          labelStyle: TextStyle(
                              color: selected == optionc
                                  ? Colors.white
                                  : Colors.black87),
                          onSelected: (_) {},
                        ),
                        const Gap(),
                        ChoiceChip(
                          elevation: 0,
                          padding: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                              side: BorderSide.none,
                              borderRadius: BorderRadius.circular(99)),
                          label: SizedBox(
                            width: size.width,
                            child: Text("D. $optiond"),
                          ),
                          backgroundColor: selected == optiond
                              ? isCorrect(questionId, optiond)
                                  ? Colors.green
                                  : Colors.red
                              : isInCorrect(questionId, optiond)
                                  ? Colors.green
                                  : null,
                          selected: selected == optiond,
                          selectedColor: isCorrect(questionId, optiond)
                              ? Colors.green
                              : Colors.red,
                          checkmarkColor: Colors.amber,
                          labelStyle: TextStyle(
                              color: selected == optiond
                                  ? Colors.white
                                  : Colors.black87),
                          onSelected: (_) {},
                        ),
                        Container(
                          width: size.width,
                          margin: const EdgeInsets.only(top: 24),
                          child: Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            runAlignment: WrapAlignment.center,
                            runSpacing: 16,
                            children: [
                              PrimaryButton(
                                text: "Explain Answer - AI",
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.w500),
                                backgroundColor: Colors.green,
                                padding: 12,
                                icon: Icons.arrow_forward_outlined,
                                onTap: () {
                                  if (questions[index]["question"] == "" ||
                                      questions[index]["question"] == null) {
                                    Messenger.showSnackBar(
                                        "Not a valid question.", context);
                                    return;
                                  }
                                  _showBottomDialog(
                                      questions[index]["question"],
                                      selected,
                                      questions[index]
                                          [questions[index]["answer"]]);
                                  // print(questions[index]["answer"]);
                                },
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  PrimaryButton(
                                    text: "Back",
                                    padding: 12,
                                    reverse: true,
                                    icon: Icons.arrow_back_outlined,
                                    onTap: prevQuestion,
                                  ),
                                  const Gap(),
                                  PrimaryButton(
                                    text:
                                        lastQuestion ? "Continue Test" : "Next",
                                    padding: 12,
                                    icon: Icons.arrow_forward_outlined,
                                    onTap: lastQuestion
                                        ? onContinueTest
                                        : nextQuestion,
                                  ),
                                ],
                              )
                            ].reversed.toList(),
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
    ));
  }
}
