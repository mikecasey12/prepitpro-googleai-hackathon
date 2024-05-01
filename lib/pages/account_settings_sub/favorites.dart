import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:prepitpro/components/action_button.dart';
import 'package:prepitpro/components/gap.dart';
import 'package:prepitpro/pages/test_selection.dart';
import 'package:prepitpro/utils/favorites.dart';
import 'package:provider/provider.dart';

final _isList = ValueNotifier(false);

class FavoritesPage extends StatelessWidget {
  final String? title;
  const FavoritesPage({super.key, required this.title});
  static const routeName = "/favorites";

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesManager>().favorites;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("$title"),
        leading: null,
        automaticallyImplyLeading: false,
        actions: [
          ActionButton(
            icon: Icons.close,
            size: 40,
            onTap: () => Navigator.pop(context),
          ),
          const Gap(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ValueListenableBuilder(
          valueListenable: _isList,
          builder: (context, isList, child) => Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      _isList.value = !isList;
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 4),
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8)),
                          color: isList
                              ? Colors.amber.shade300
                              : Colors.transparent),
                      child: const Icon(
                        Icons.view_list_outlined,
                        size: 22,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _isList.value = !isList;
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 4),
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(8),
                              bottomRight: Radius.circular(8)),
                          color: !isList
                              ? Colors.amber.shade300
                              : Colors.transparent),
                      child: const Icon(
                        Icons.grid_view_outlined,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(),
              Expanded(
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isList ? 1 : 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1,
                        mainAxisExtent: isList ? 64 : null),
                    itemBuilder: (context, index) {
                      final sub = favorites[index];
                      return InkWell(
                        key: ValueKey(sub.subject_id),
                        onTap: () {
                          context
                              .read<FavoritesManager>()
                              .isFavorite(sub.subject_id!);
                          Navigator.pushNamed(
                              context, TestSelectionPage.routeName,
                              arguments: sub.subject_id);
                        },
                        child: Container(
                          padding: isList
                              ? const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16)
                              : const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(isList ? 16 : 8),
                              color: Color(sub.color!).withOpacity(1)),
                          child: isList
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                      Expanded(
                                        child: Text(
                                          sub.subject_name!,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      const ActionButton(
                                        icon: Icons.arrow_right_alt_outlined,
                                        size: 30,
                                        backgroundColor: Colors.black87,
                                        iconColor: Colors.white,
                                      )
                                    ])
                              : Column(
                                  children: [
                                    Expanded(
                                      child: AutoSizeText(
                                        sub.subject_name!,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16),
                                        minFontSize: 12,
                                      ),
                                    ),
                                    Image.network(
                                      sub.subject_image!,
                                      height: 64,
                                      fit: BoxFit.cover,
                                    )
                                  ],
                                ),
                        ),
                      );
                    },
                    itemCount: favorites.length),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
