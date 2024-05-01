import 'package:flutter/material.dart';
import 'package:prepitpro/components/action_button.dart';
import 'package:prepitpro/components/gap.dart';
import 'package:prepitpro/components/primary_button.dart';
import 'package:prepitpro/db/local_db.dart';
import 'package:prepitpro/db/recents.dart';
import 'package:prepitpro/db/schema/subjects.dart' as local_db;
import 'package:prepitpro/helpers/messenger.dart';
import 'package:prepitpro/models/questions.dart';
import 'package:prepitpro/models/subject.dart';
import 'package:prepitpro/models/user.dart';
import 'package:prepitpro/pages/generated_questions.dart';
import 'package:prepitpro/pages/test_practice.dart';
import 'package:prepitpro/utils/auth.dart';
import 'package:prepitpro/utils/favorites.dart';
import 'package:prepitpro/utils/helpers.dart';
import 'package:prepitpro/utils/pip_ai.dart';
import 'package:prepitpro/utils/subjects.dart';
import 'package:provider/provider.dart';

class TestSelectionPage extends StatefulWidget {
  const TestSelectionPage({super.key});
  static const routeName = "/test-selection";

  @override
  State<TestSelectionPage> createState() => _TestSelectionPageState();
}

class _TestSelectionPageState extends State<TestSelectionPage> {
  final isar = LocalDbController.instance;
  late local_db.Subject subjectData;
  // late Subject subjectDat;
  late int subjectId;
  late User user;
  Difficulty _difficulty = Difficulty.easy;
  bool hasRan = false;
  Future<List<Questions>>? _dataState;

  final List<DropdownMenuEntry> _dropDownItems = const [
    DropdownMenuEntry(
      value: Difficulty.easy,
      label: "Easy",
    ),
    DropdownMenuEntry(
      value: Difficulty.medium,
      label: "Medium",
    ),
    DropdownMenuEntry(
      label: "Hard",
      value: Difficulty.hard,
    )
  ];

  final List _termButtonItems = [
    {"id": 1, "color": 0x00FFCBDC, "text": "1st Term"},
    {"id": 2, "color": 0x00F3FFEA, "text": "2nd Term"},
    {"id": 3, "color": 0x00FFC785, "text": "3rd Term"},
    {"id": 4, "color": 0x00BFB5FF, "text": "General"},
  ];

  void onChangeValue(val) {
    setState(() {
      _difficulty = val;
    });
  }

  @override
  void didChangeDependencies() {
    if (!hasRan) {
      _initialize();
      hasRan = true;
    }

    super.didChangeDependencies();
  }

  Future<void> _initialize() async {
    subjectId = ModalRoute.of(context)!.settings.arguments as int;
    final subjects = context.read<ClassSubjects>().subject;
    subjectData = subjects.firstWhere((element) => element.id == subjectId);
    _dataState = context
        .read<ClassSubjects>()
        .retrieveQuestionBySubject(context, subjectId);
    user = context.read<CurrentUser>().user;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isFav = context.watch<FavoritesManager>().isFavoriteSubject;
    final textColor = Theme.of(context).textTheme.bodySmall?.color;
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text("${subjectData.name} - Test"),
              leading: null,
              automaticallyImplyLeading: false,
              actions: [
                InkWell(
                  onTap: () async {
                    Messenger.showSnackBar(
                        isFav ? "Removed from favorites" : "Added to favorites",
                        context,
                        success: true);
                    if (isFav) {
                      await context.read<FavoritesManager>().removeFavorite(
                          user.id!, subjectData, user.userClass!);
                    } else {
                      await context
                          .read<FavoritesManager>()
                          .addFavorite(user.id!, subjectData, user.userClass!);
                    }
                  },
                  child: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    size: 32,
                    color: Colors.red,
                  ),
                ),
                const Gap(),
                ActionButton(
                  icon: Icons.close,
                  size: 40,
                  onTap: () => Navigator.pop(context),
                ),
                const Gap()
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Difficulty level: ",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: textColor),
                      ),
                      DropdownMenu(
                        initialSelection: _difficulty,
                        dropdownMenuEntries: _dropDownItems,
                        onSelected: onChangeValue,
                        enableSearch: false,
                        textStyle: const TextStyle(color: Colors.black87),
                        trailingIcon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black87,
                        ),
                        inputDecorationTheme: InputDecorationTheme(
                            filled: true,
                            fillColor: Colors.purple.shade100,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            constraints: const BoxConstraints(maxHeight: 45),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(999),
                                borderSide: BorderSide.none)),
                      ),
                    ],
                  ),
                  const Gap(),
                  Text(
                    "Select Term",
                    style: TextStyle(fontSize: 14, color: textColor),
                  ),
                  const Gap(),
                  FutureBuilder(
                    future: _dataState,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return Expanded(
                        child: GridView(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisExtent: 50,
                                    mainAxisSpacing: 8,
                                    childAspectRatio: 3 / 2,
                                    crossAxisSpacing: 8),
                            children: _termButtonItems
                                .map(
                                  (term) => PrimaryButton(
                                    text: term["text"],
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                    width: size.width * 0.4,
                                    backgroundColor:
                                        Color(term["color"]).withOpacity(1),
                                    onTap: () {
                                      context
                                          .read<Recents>()
                                          .addToRecentsDb(subjectData);
                                      Navigator.pushNamed(
                                          context, TestPracticePage.routeName,
                                          arguments: {
                                            "term": term["id"],
                                            "subjectName": subjectData.name,
                                            "subjectId": subjectData.id,
                                            "difficulty": _difficulty
                                          });
                                    },
                                  ),
                                )
                                .toList()),
                      );
                    },
                  ),
                  const Gap(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    child: PrimaryButton(
                      text: "Generate Questions",
                      padding: 16,
                      spacing: MainAxisAlignment.spaceBetween,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 16),
                      onTap: () async {
                        try {
                          final userClass = UtilsFunctions.getUserClassFromID(
                              user.userClass!);
                          Messenger.showLoader(
                              text: "Generating questions...", context);
                          final response = await PIPAI.generateSubjectQuestions(
                              subject: subjectData.name, userClass: userClass);
                          if (context.mounted) {
                            Navigator.pop(context);
                            Navigator.pushNamed(
                                context, GeneratedQuestionsPage.routeName,
                                arguments: response);
                          }
                        } catch (e) {
                          if (context.mounted) {
                            Navigator.pop(context);
                            Messenger.showSnackBar("$e", context);
                          }
                        }
                      },
                    ),
                  )
                ],
              ),
            )));
  }
}
