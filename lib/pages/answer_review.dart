import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prepitpro/components/action_button.dart';
import 'package:prepitpro/components/gap.dart';
import 'package:prepitpro/components/primary_button.dart';
import 'package:prepitpro/helpers/messenger.dart';
import 'package:prepitpro/models/questions.dart';
import 'package:prepitpro/utils/auth.dart';
import 'package:prepitpro/utils/performance.dart';
import 'package:provider/provider.dart';

class AnswerReviewPage extends StatefulWidget {
  const AnswerReviewPage({super.key});
  static const routeName = "/answer-review";

  @override
  State<AnswerReviewPage> createState() => _AnswerReviewPageState();
}

class _AnswerReviewPageState extends State<AnswerReviewPage> {
  late int questionsTotal;
  int? subjectId;
  late List<Map<String, Object>> userAnswers;
  late List<Questions> questions;
  final PageController _pageController = PageController(keepPage: true);
  int currentIndex = 0;
  bool hasRan = false;

  @override
  void didChangeDependencies() {
    if (!hasRan) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, Object>;
      questionsTotal = args["questionsTotal"] as int;
      userAnswers = args["userAnswers"] as List<Map<String, Object>>;
      questions = args["questions"] as List<Questions>;
      subjectId = args["subjectId"] as int;
      retrieveCorrectAnswers();
      checkAnswersAgainstUserAnswers();
      hasRan = true;
    }
    super.didChangeDependencies();
  }

  var correctOptions = [];
  var correctAnswers = [];
  var userAns = [];
  var passedQuestions = [];
  var failedQuestions = [];

  void retrieveCorrectAnswers() {
    for (var question in questions) {
      correctOptions.add(
          {"questionId": question.id.toString(), "answer": question.answer});
    }

    for (var question in questions) {
      for (var option in correctOptions) {
        if (question.id.toString() == option["questionId"]) {
          correctAnswers.add(question.id.toString() +
              getValueFromAnswer(option["answer"], question));
        }
      }
    }
    for (var ua in userAnswers) {
      userAns.add(ua["questionId"].toString() + ua["answer"].toString());
    }
  }

  String getValueFromAnswer(String answer, Questions question) {
    switch (answer) {
      case "option_a":
        return question.option_a!;
      case "option_b":
        return question.option_b!;
      case "option_c":
        return question.option_c!;
      default:
        return question.option_d!;
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

// check for correctAnswers
  bool isCorrect(String questionId, String answer) {
    final status = passedQuestions.contains(questionId + answer);
    return status;
  }

  // check for incorrectAnswers
  bool isInCorrect(String questionId, String answer) {
    final status = failedQuestions.contains(questionId + answer);
    return status;
  }

  void onContinueTest() async {
    Messenger.showLoader(context);
    await _submitUserPerformance();
    if (mounted) {
      Navigator.pop(context);
    }
  }

//Submit User Performance
  Future<void> _submitUserPerformance() async {
    try {
      final user = context.read<CurrentUser>().user;
      await context.read<PerformanceManager>().getUserPerformancePerSubject(
          user.id!,
          subjectId: subjectId,
          classId: user.userClass);
      if (mounted) {
        await context.read<PerformanceManager>().upsertUserPerformance(
            userId: user.id!,
            subjectId: subjectId!,
            classId: user.userClass!,
            totalQuestions: questionsTotal,
            passedQuestions: passedQuestions.length,
            failedQuestions: failedQuestions.length);
        if (mounted) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        Messenger.showSnackBar("An error occured.", context);
        Navigator.pop(context);
      }
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
        title: const Text("Answer's Review"),
        leading: null,
        automaticallyImplyLeading: false,
        actions: [
          ActionButton(
            icon: Icons.close,
            size: 40,
            onTap: () => Navigator.pop(context),
          ),
          const Gap(width: 16)
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
                  final questionId = questions[index].id.toString();
                  final option = questions[index].option_a;
                  final optionb = questions[index].option_b;
                  final optionc = questions[index].option_c;
                  final optiond = questions[index].option_d;
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
                          "${questions[index].question}",
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
                              ? isCorrect(questionId, option!)
                                  ? Colors.green
                                  : Colors.red
                              : isInCorrect(questionId, option!)
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
                              ? isCorrect(questionId, optionb!)
                                  ? Colors.green
                                  : Colors.red
                              : isInCorrect(questionId, optionb!)
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
                              ? isCorrect(questionId, optionc!)
                                  ? Colors.green
                                  : Colors.red
                              : isInCorrect(questionId, optionc!)
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
                              ? isCorrect(questionId, optiond!)
                                  ? Colors.green
                                  : Colors.red
                              : isInCorrect(questionId, optiond!)
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  PrimaryButton(
                                    mainPadding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 10),
                                    text: "Back",
                                    reverse: true,
                                    icon: Icons.arrow_back_outlined,
                                    onTap: prevQuestion,
                                  ),
                                  const Gap(),
                                  PrimaryButton(
                                    mainPadding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 10),
                                    text:
                                        lastQuestion ? "Continue Test" : "Next",
                                    icon: Icons.arrow_forward_outlined,
                                    onTap: lastQuestion
                                        ? onContinueTest
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
    ));
  }
}
