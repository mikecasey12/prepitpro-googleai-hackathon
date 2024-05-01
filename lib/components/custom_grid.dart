import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:prepitpro/db/schema/subjects.dart' as local_db;
import 'package:prepitpro/pages/test_selection.dart';
import 'package:prepitpro/utils/favorites.dart';
import 'package:provider/provider.dart';

class CustomSubjectGrid extends StatelessWidget {
  final List<local_db.Subject> subject;
  final bool? isExternal;
  const CustomSubjectGrid(
      {super.key, required this.subject, this.isExternal = false});

  @override
  Widget build(BuildContext context) {
    final externalExams = subject
        .where((element) => element.id! == 32 || element.id! == 33)
        .toList();
    return GridView.builder(
        scrollDirection: Axis.horizontal,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            mainAxisExtent: 140,
            childAspectRatio: 3 / 2),
        itemBuilder: (context, index) {
          if (isExternal!) {
            final exExams = externalExams[index];
            return InkWell(
              onTap: () {
                context.read<FavoritesManager>().isFavorite(exExams.id!);
                Navigator.pushNamed(context, TestSelectionPage.routeName,
                    arguments: exExams.id);
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Color(exExams.color!).withOpacity(1)),
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: AutoSizeText(
                        exExams.name!,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
                        minFontSize: 12,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Image.network(
                        exExams.coverImage!,
                        height: 64,
                        fit: BoxFit.cover,
                      ),
                    )
                  ],
                ),
              ),
            );
          } else {
            final sub = subject[index];
            if (index > 4) {
              return null;
            }

            return InkWell(
              onTap: () {
                context.read<FavoritesManager>().isFavorite(sub.id!);
                Navigator.pushNamed(context, TestSelectionPage.routeName,
                    arguments: sub.id);
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Color(sub.color!).withOpacity(1)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: AutoSizeText(
                        sub.name!,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
                        minFontSize: 12,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Image.network(
                        sub.coverImage!,
                        height: 64,
                        fit: BoxFit.cover,
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        },
        itemCount: isExternal! ? externalExams.length : subject.length);
  }
}
