import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prepitpro/components/action_button.dart';
import 'package:prepitpro/components/gap.dart';
import 'package:prepitpro/components/primary_button.dart';
import 'package:prepitpro/components/timer.dart';
import 'package:prepitpro/helpers/messenger.dart';
import 'package:prepitpro/models/questions.dart';
import 'package:prepitpro/models/subject.dart';
import 'package:prepitpro/pages/answer_review.dart';
import 'package:prepitpro/theme/theme.dart';
import 'package:prepitpro/utils/subjects.dart';
import 'package:provider/provider.dart';

class TestPracticePage extends StatefulWidget {
  const TestPracticePage({super.key});
  static const routeName = "/test-practice";

  @override
  State<TestPracticePage> createState() => _TestPracticeStatePage();
}

class _TestPracticeStatePage extends State<TestPracticePage> {
  late int _termId;
  late String _subjectName;
  late int _subjectId;
  late Difficulty _difficulty;
  late List<Questions> _questions;
  final PageController _pageController = PageController(keepPage: true);
  int currentIndex = 0;
  bool _isShuffled = false;

  @override
  void didChangeDependencies() {
    if (!_isShuffled) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      _termId = args["term"] as int;
      _subjectName = args["subjectName"];
      _subjectId = args["subjectId"];
      _difficulty = args["difficulty"];
      _retrieveQuestions();
      _isShuffled = true;
    }
    super.didChangeDependencies();
  }

  void _retrieveQuestions() {
    _questions = context.read<ClassSubjects>().questions.where((question) {
      return question.term == _termId;
    }).toList();

    if (_difficulty == Difficulty.easy) {
      if (_questions.length >= 20) {
        _questions = _questions.getRange(0, 20).toList();
      }
    } else if (_difficulty == Difficulty.medium) {
      if (_questions.length >= 40) {
        _questions = _questions.getRange(0, 40).toList();
      }
    }
    if (_subjectId != 1) {
      _questions.shuffle();
    }
  }

  void nextQuestion() {
    _pageController.nextPage(duration: Durations.short4, curve: Curves.linear);
  }

  void prevQuestion() {
    _pageController.previousPage(
        duration: Durations.short4, curve: Curves.linear);
  }

  final List<Map<String, Object>> answers = [];

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
      Navigator.pushReplacementNamed(context, AnswerReviewPage.routeName,
          arguments: {
            "userAnswers": answers,
            "questionsTotal": _questions.length,
            "questions": _questions,
            "subjectName": _subjectName,
            "subjectId": _subjectId
          });
    }
  }

  void timerSubmit() {
    Messenger.showSnackBar("Time's up.", context);
    Navigator.pushReplacementNamed(context, AnswerReviewPage.routeName,
        arguments: {
          "userAnswers": answers,
          "questionsTotal": _questions.length,
          "questions": _questions,
          "subjectName": _subjectName,
          "subjectId": _subjectId
        });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = ThemeController.isDark.value;
    final lastQuestion = currentIndex + 1 == _questions.length;
    final backgroundColor = Theme.of(context).colorScheme.tertiary;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("$_subjectName - $_termId Term"),
          leading: null,
          automaticallyImplyLeading: false,
          actions: [
            ActionButton(
              icon: Icons.close,
              size: 48,
              onTap: () => Navigator.pop(context),
            ),
            const Gap(width: 16)
          ],
        ),
        body: _questions.isEmpty
            ? Center(
                child: Text(
                  "No questions for this term",
                  style: TextStyle(color: textColor),
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
                          Text(
                            _subjectName,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          const Gap(),
                          Expanded(
                            child: LinearProgressIndicator(
                              value: ((currentIndex + 1) / _questions.length),
                            ),
                          ),
                          const Gap(),
                          Text("${currentIndex + 1}/${_questions.length}")
                        ],
                      ),
                    ),
                    if (_difficulty == Difficulty.hard)
                      Container(
                        width: size.width,
                        margin: const EdgeInsets.only(top: 16),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: isDark
                                ? backgroundColor
                                : Colors.black.withOpacity(0.8)),
                        child: Center(
                          child: Timer(
                            onSubmit: timerSubmit,
                          ),
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
                          final questionId = _questions[index].id.toString();
                          String selected = checkSelected(questionId);
                          final option = _questions[index].option_a;
                          final optionb = _questions[index].option_b;
                          final optionc = _questions[index].option_c;
                          final optiond = _questions[index].option_d;
                          final correctAnswer = _questions[index].answer;
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
                                  "${_questions[index].question}",
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
                                  elevation: 0,
                                  padding: const EdgeInsets.all(16),
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide.none,
                                      borderRadius: BorderRadius.circular(99)),
                                  label: SizedBox(
                                    width: size.width,
                                    child: Text("A. $option"),
                                  ),
                                  selected: selected == option,
                                  selectedColor: Colors.black87,
                                  checkmarkColor: Colors.amber,
                                  labelStyle: TextStyle(
                                      color: selected == option
                                          ? Colors.white
                                          : Colors.black),
                                  onSelected: (_) {
                                    addToAnswerList(
                                        option!, questionId, correctAnswer!);
                                  },
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
                                  selected: selected == optionb,
                                  selectedColor: Colors.black87,
                                  checkmarkColor: Colors.amber,
                                  labelStyle: TextStyle(
                                      color: selected == optionb
                                          ? Colors.white
                                          : Colors.black87),
                                  onSelected: (_) {
                                    addToAnswerList(
                                        optionb!, questionId, correctAnswer!);
                                  },
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
                                  selected: selected == optionc,
                                  selectedColor: Colors.black87,
                                  checkmarkColor: Colors.amber,
                                  labelStyle: TextStyle(
                                      color: selected == optionc
                                          ? Colors.white
                                          : Colors.black87),
                                  onSelected: (_) {
                                    addToAnswerList(
                                        optionc!, questionId, correctAnswer!);
                                  },
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
                                  selected: selected == optiond,
                                  selectedColor: Colors.black87,
                                  checkmarkColor: Colors.amber,
                                  labelStyle: TextStyle(
                                      color: selected == optiond
                                          ? Colors.white
                                          : Colors.black87),
                                  onSelected: (_) {
                                    addToAnswerList(
                                        optiond!, questionId, correctAnswer!);
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
                                            mainPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 10),
                                            text: "Back",
                                            reverse: true,
                                            icon: Icons.arrow_back_outlined,
                                            onTap: prevQuestion,
                                          ),
                                          const Gap(),
                                          PrimaryButton(
                                            mainPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 10),
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
                        itemCount: _questions.length,
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
