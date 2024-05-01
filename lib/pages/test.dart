import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:prepitpro/components/action_button.dart';
import 'package:prepitpro/components/custom_grid.dart';
import 'package:prepitpro/components/gap.dart';
import 'package:prepitpro/components/primary_button.dart';
import 'package:prepitpro/db/schema/subjects.dart' as local_db;
import 'package:prepitpro/pages/customize_test.dart';
import 'package:prepitpro/pages/subjects.dart';
import 'package:prepitpro/pages/test_selection.dart';
import 'package:prepitpro/theme/theme.dart';
import 'package:prepitpro/utils/auth.dart';
import 'package:prepitpro/utils/favorites.dart';
import 'package:prepitpro/utils/subjects.dart';
import 'package:provider/provider.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});
  static const routeName = "/test";

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  late List<local_db.Subject> subjects;

  @override
  void initState() {
    _retrieveSubject();

    super.initState();
  }

  void _retrieveSubject() async {
    subjects = context.read<ClassSubjects>().subject;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final user = context.watch<CurrentUser>().user;
    final isDark = ThemeController.themeMode.value == ThemeMode.dark;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        surfaceTintColor: null,
        title: const Text("Test"),
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
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                  (context, index) => [
                        const Row(
                          children: [Text("PIP AI:")],
                        ),
                        const Gap(height: 8),
                        Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Theme.of(context).colorScheme.secondary),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: size.width * 0.6,
                                  child: const AutoSizeText(
                                    "Customize your test with AI",
                                    minFontSize: 12,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Expanded(
                                  child: PrimaryButton(
                                    text: "Go",
                                    textStyle: TextStyle(color: textColor),
                                    padding: 10,
                                    backgroundColor: isDark
                                        ? Theme.of(context).colorScheme.tertiary
                                        : null,
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, CustomizeTestPage.routeName);
                                    },
                                  ),
                                ),
                              ],
                            ))
                      ][index],
                  childCount: 3),
            ),
            if (user.userClass == 1 || user.userClass == 4)
              SliverList(
                delegate: SliverChildBuilderDelegate(
                    (context, index) => [
                          const Gap(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.category_outlined,
                                    size: 16,
                                  ),
                                  const Gap(width: 2),
                                  SizedBox(
                                    width: size.width * 0.7,
                                    child: Text(
                                      "External Exams Category",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: textColor),
                                    ),
                                  ),
                                ],
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, SubjectsPage.routeName);
                                  },
                                  style: const ButtonStyle(
                                      padding: MaterialStatePropertyAll(
                                          EdgeInsets.zero)),
                                  child: const Text(
                                    "View all",
                                    style: TextStyle(fontSize: 12),
                                  ))
                            ],
                          )
                        ][index],
                    childCount: 2),
              ),
            if (user.userClass == 1 || user.userClass == 4)
              SliverGrid.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    mainAxisExtent: 120),
                itemBuilder: (context, index) {
                  return CustomSubjectGrid(
                    subject: subjects,
                    isExternal: true,
                  );
                },
                itemCount: 1,
              ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                  (context, index) => [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.my_library_books_outlined,
                                  size: 16,
                                ),
                                const Gap(width: 2),
                                Text(
                                  "Subjects",
                                  style: TextStyle(color: textColor),
                                ),
                              ],
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, SubjectsPage.routeName);
                                },
                                style: const ButtonStyle(
                                    padding: MaterialStatePropertyAll(
                                        EdgeInsets.zero)),
                                child: const Text(
                                  "View all",
                                  style: TextStyle(fontSize: 12),
                                ))
                          ],
                        )
                      ][index],
                  childCount: 1),
            ),
            SliverGrid.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  mainAxisExtent: 140),
              itemBuilder: (context, index) {
                if (index > 5) {
                  return null;
                }
                return InkWell(
                  onTap: () {
                    context
                        .read<FavoritesManager>()
                        .isFavorite(subjects[index].id!);
                    Navigator.pushNamed(context, TestSelectionPage.routeName,
                        arguments: subjects[index].id);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Color(subjects[index].color!).withOpacity(1)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: AutoSizeText(
                            subjects[index].name!,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16),
                            minFontSize: 12,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Image.network(
                            subjects[index].coverImage!,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
              itemCount: subjects.length,
            ),
          ],
        ),
      ),
    ));
  }
}
//FFDF85


