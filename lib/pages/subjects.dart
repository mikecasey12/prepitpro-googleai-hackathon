import 'package:flutter/material.dart';
import 'package:prepitpro/components/action_button.dart';
import 'package:prepitpro/components/gap.dart';
import 'package:prepitpro/pages/test_selection.dart';
import 'package:prepitpro/theme/theme.dart';
import 'package:prepitpro/utils/auth.dart';
import 'package:prepitpro/utils/favorites.dart';
import 'package:prepitpro/utils/subjects.dart';
import 'package:provider/provider.dart';

class SubjectsPage extends StatefulWidget {
  const SubjectsPage({super.key});
  static const routeName = "/all-subjects";

  @override
  State<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  bool isList = false;
  // List<local_db.Subject> subj = [];
  void modeSwitch() {
    setState(() {
      isList = !isList;
    });
  }

  // void retrieveSubjectList() async {
  //   // final response = DateTime.timestamp();
  //   for (final c in colors) {
  //     final response = Color(0).withOpacity(1).value;
  //     debugPrint(response.toString());
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<CurrentUser>().user;
    final subj = context.watch<ClassSubjects>().subject;
    final activeColor = Theme.of(context).colorScheme.secondary;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final isDark = ThemeController.isDark.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Subjects"),
        leading: null,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: CustomScrollView(
          slivers: [
            SliverList(
                delegate: SliverChildListDelegate.fixed([
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // MaterialButton(
                  //   onPressed: () {
                  //     retrieveSubjectList();
                  //   },
                  //   child: const Text("Retrieve"),
                  // ),
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
                  Row(
                    children: [
                      InkWell(
                        onTap: modeSwitch,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 4),
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomLeft: Radius.circular(8)),
                              color: isList ? activeColor : Colors.transparent),
                          child: Icon(
                            Icons.view_list_outlined,
                            size: 22,
                            color: isList
                                ? isDark
                                    ? Theme.of(context).colorScheme.background
                                    : Colors.black87
                                : Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: modeSwitch,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 4),
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  bottomRight: Radius.circular(8)),
                              color:
                                  !isList ? activeColor : Colors.transparent),
                          child: Icon(
                            Icons.grid_view_outlined,
                            size: 22,
                            color: !isList
                                ? isDark
                                    ? Theme.of(context).colorScheme.background
                                    : Colors.black87
                                : Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const Gap(height: 16)
            ])),

            //Returns a message if list is empty
            if (subj.isEmpty)
              SliverAnimatedList(
                itemBuilder: (context, index, animation) {
                  return const Center(child: Text("Class have no subject"));
                },
                initialItemCount: 1,
              ),
            if (user.id != null)
              SliverGrid.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isList ? 1 : 2,
                    mainAxisExtent: isList ? 64 : 140,
                    mainAxisSpacing: 12,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 12),
                itemBuilder: (context, index) {
                  final sub = subj[index];
                  if (sub.id == 32) {
                    return null;
                  }
                  return InkWell(
                    onTap: () {
                      context.read<FavoritesManager>().isFavorite(sub.id!);
                      Navigator.pushNamed(context, TestSelectionPage.routeName,
                          arguments: sub.id);
                    },
                    child: Container(
                      padding: isList
                          ? const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16)
                          : const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Color(sub.color!).withOpacity(1),
                      ),
                      child: isList
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                  Text(
                                    sub.name!,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const ActionButton(
                                    icon: Icons.arrow_right_alt_outlined,
                                    size: 30,
                                    backgroundColor: Colors.black87,
                                    iconColor: Colors.white,
                                  )
                                ])
                          : Column(children: [
                              Text(
                                sub.name!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),
                              Image.network(
                                sub.coverImage!,
                                fit: BoxFit.cover,
                                height: 100,
                              )
                            ]),
                    ),
                  );
                },
                itemCount: subj.length,
              ),
          ],
        ),
      ),
    );
  }
}
