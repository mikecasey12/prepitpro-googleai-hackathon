import 'package:flutter/material.dart';
import 'package:prepitpro/components/action_button.dart';
import 'package:prepitpro/components/gap.dart';
import 'package:prepitpro/db/schema/subjects.dart';
import 'package:prepitpro/pages/test_selection.dart';
import 'package:prepitpro/theme/theme.dart';
import 'package:prepitpro/utils/favorites.dart';
import 'package:prepitpro/utils/subjects.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  static const routeName = "/search";

  @override
  State<SearchPage> createState() => _SearchPageState();
}

// List itemsToSearch = [
//   {"id": 30, "subject_name": "History"},
//   {"id": 14, "subject_name": "Islamic Religious Studies (IRS)"},
//   {"id": 28, "subject_name": "Literature-in-English"},
//   {"id": 6, "subject_name": "Physics"},
//   {"id": 24, "subject_name": "Technical Drawing"},
//   {"id": 8, "subject_name": "Social Studies"},
//   {"id": 20, "subject_name": "French"},
//   {"id": 32, "subject_name": "JAMB"},
//   {"id": 33, "subject_name": "WAEC/SSCE"},
//   {"id": 34, "subject_name": "NECO"},
//   {"id": 35, "subject_name": "NECO/JSCE"},
//   {"id": 36, "subject_name": "GCE"},
//   {"id": 11, "subject_name": "Agricultural Science"},
//   {"id": 13, "subject_name": "Christian Religious Studies (CRS)"},
//   {"id": 5, "subject_name": "Chemistry"},
//   {"id": 26, "subject_name": "Commerce"},
//   {"id": 4, "subject_name": "Economics"},
//   {"id": 25, "subject_name": "Financial Accounting"},
//   {"id": 27, "subject_name": "Food and Nutrition"},
//   {"id": 23, "subject_name": "Further Mathematics"},
//   {"id": 29, "subject_name": "Geography"},
//   {"id": 31, "subject_name": "Government"},
//   {"id": 1, "subject_name": "English"},
//   {"id": 2, "subject_name": "Mathematics"},
//   {"id": 3, "subject_name": "Biology"},
//   {"id": 7, "subject_name": "Basic Science"},
//   {"id": 10, "subject_name": "Civic Education"},
//   {"id": 12, "subject_name": "Physical and Health Education"},
//   {"id": 22, "subject_name": "Computer Studies"},
//   {"id": 21, "subject_name": "Home Economics"},
//   {"id": 19, "subject_name": "Music"},
//   {"id": 17, "subject_name": "Yoruba"},
//   {"id": 16, "subject_name": "Igbo"},
//   {"id": 15, "subject_name": "Hausa"},
//   {"id": 18, "subject_name": "Fine Arts"},
//   {"id": 9, "subject_name": "Basic Technology"}
// ];

class _SearchPageState extends State<SearchPage> {
  List<Subject>? subjects;

  @override
  void initState() {
    _retrieveSubjects();
    super.initState();
  }

  _retrieveSubjects() {
    subjects = context.read<ClassSubjects>().subject;
  }

  List<Subject> searchItem(String value) {
    final searchItems = subjects!.where((subject) {
      if (subject.name!.toLowerCase().contains(value.toLowerCase())) {
        return true;
      }

      return false;
    }).toList();
    return searchItems;
  }

  List<Subject> items = [];
  @override
  Widget build(BuildContext context) {
    final isDark = ThemeController.isDark.value;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leading: null,
        automaticallyImplyLeading: false,
        title: const Text("Search Subjects"),
        actions: [
          ActionButton(
            icon: Icons.close_outlined,
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
            TextField(
              autofocus: true,
              onTap: () {},
              onChanged: (value) {
                setState(() {
                  if (value == "") {
                    items = [];
                    return;
                  }
                  items = searchItem(value);
                });
              },
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(16),
                  prefixIcon: const Icon(
                    Icons.search_outlined,
                  ),
                  prefixIconColor: Colors.grey.shade300,
                  label: Text(
                    "Search",
                    style: TextStyle(color: Colors.grey.shade300),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: const BorderSide(width: 1.5))),
            ),
            const Gap(),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisExtent: 64,
                    mainAxisSpacing: 12,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 12),
                itemBuilder: (context, index) {
                  final sub = items[index];

                  return InkWell(
                      onTap: () {
                        context.read<FavoritesManager>().isFavorite(sub.id!);
                        Navigator.pushNamed(
                            context, TestSelectionPage.routeName,
                            arguments: sub.id);
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: isDark
                                ? Theme.of(context).colorScheme.secondary
                                : const Color.fromARGB(0, 255, 223, 148)
                                    .withOpacity(1),
                          ),
                          child: Row(
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
                              ])));
                },
                itemCount: items.length,
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
