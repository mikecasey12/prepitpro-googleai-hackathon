import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prepitpro/components/action_button.dart';
import 'package:prepitpro/components/custom_grid.dart';
import 'package:prepitpro/components/gap.dart';
import 'package:prepitpro/components/primary_button.dart';
import 'package:prepitpro/db/local_db.dart';
import 'package:prepitpro/db/recents.dart';
import 'package:prepitpro/db/schema/subjects.dart';
// import 'package:prepitpro/models/subject.dart';
import 'package:prepitpro/models/user.dart';
import 'package:prepitpro/pages/notifications.dart';
import 'package:prepitpro/pages/search.dart';
import 'package:prepitpro/pages/test.dart';
import 'package:prepitpro/pages/test_selection.dart';
import 'package:prepitpro/theme/theme.dart';
import 'package:prepitpro/utils/auth.dart';
import 'package:prepitpro/utils/favorites.dart';
import 'package:prepitpro/utils/notifications.dart';
import 'package:prepitpro/utils/subjects.dart';
import 'package:provider/provider.dart';
import 'package:typeset/typeset.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key, this.switchCurrentPageFn});
  final Function(int)? switchCurrentPageFn;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  User? _user;
  Future? _futureData;
  String? notificationText;
  final isar = LocalDbController.instance;
  @override
  void initState() {
    Future.microtask(() async {
      await NotificationsManager.initializeNotification(
          onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse);
      await NotificationsManager.isAndroidPermissionGranted();
      await NotificationsManager.requestPermissions();
      await NotificationsManager.periodicNotification(
          title: "Practice today", body: "Open app to begin today's practice");
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _initialize();
    super.didChangeDependencies();
  }

  void _initialize() async {
    _user = context.watch<CurrentUser>().user;
    _futureData = context
        .read<ClassSubjects>()
        .retrieveSubjectList(_user?.userClass ?? 0);
  }

  void _onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
      setState(() {
        notificationText = payload;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final recentSubject = context.watch<Recents>().recents;
    // final recentSubject = isar.collection<Recent>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("PrepIt Pro"),
        leading: null,
        automaticallyImplyLeading: false,
        actions: [
          ActionButton(
            icon: Icons.notifications_outlined,
            size: 40,
            onTap: () async {
              Navigator.pushNamed(context, NotificationsPage.routeName);
              // await NotificationsManager.triggerNotification(body: "Hi Marve");
            },
          ),
          const Gap(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: CustomScrollView(slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
                (context, index) => dashSect(context, _user!, recentSubject,
                    onSwitch: widget.switchCurrentPageFn,
                    notificationText: notificationText)[index],
                childCount: dashSect(context, _user!, recentSubject).length),
          ),
          if (_user!.id != null)
            FutureBuilder(
              future: _futureData,
              builder: (context, snapshot) {
                //Show a loading indicator when retrieving list
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SliverAnimatedList(
                    itemBuilder: (context, index, animation) {
                      return const Center(child: CircularProgressIndicator());
                    },
                    initialItemCount: 1,
                  );
                }

                final subject = context.read<ClassSubjects>().subject;

                //Returns a message if list is empty
                if (subject.isEmpty) {
                  return SliverAnimatedList(
                    itemBuilder: (context, index, animation) {
                      return Center(
                          child: Text("Class have no subject",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color,
                              )));
                    },
                    initialItemCount: 1,
                  );
                }
                return SliverGrid.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 140,
                      mainAxisSpacing: 8,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 8),
                  itemBuilder: (context, index) {
                    if (index <= 3) {
                      return InkWell(
                        onTap: () {
                          context
                              .read<FavoritesManager>()
                              .isFavorite(subject[index].id!);
                          Navigator.pushNamed(
                              context, TestSelectionPage.routeName,
                              arguments: subject[index].id);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Color(subject[index].color!).withOpacity(1),
                          ),
                          child: Column(children: [
                            Text(
                              subject[index].name!,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Expanded(
                              flex: 3,
                              child: Image.network(
                                subject[index].coverImage!,
                                fit: BoxFit.cover,
                                height: 100,
                              ),
                            )
                          ]),
                        ),
                      );
                    }
                    return null;
                  },
                  itemCount: subject.length,
                );
              },
            ),
        ]),
      ),
    );
  }
}

List<Widget> dashSect(
    BuildContext context, User user, List<Subject> recentSubjects,
    {Function(int)? onSwitch, String? notificationText}) {
  final size = MediaQuery.of(context).size;
  final isDark = ThemeController.themeMode.value == ThemeMode.dark;
  final textColor = Theme.of(context).textTheme.bodyLarge!.color;
  return [
    TypeSet(
        "Hello, *${user.fname ?? "There. "}* ${notificationText != null ? "You tapped on the notification: $notificationText" : ''}",
        style: TextStyle(color: textColor)),
    const Gap(),
    Text("What Subject do you want to improve on today?",
        style: GoogleFonts.anta(
            textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                height: 1,
                color: textColor))),
    const Gap(
      height: 16,
    ),
    TextField(
      readOnly: true,
      autofocus: false,
      onTap: () {
        Navigator.pushNamed(context, SearchPage.routeName);
      },
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 16, right: 16),
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
    const Gap(height: 16),
    Container(
      width: size.width,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
          boxShadow: [
            if (!isDark)
              BoxShadow(
                blurRadius: 15,
                color: Colors.grey.shade300,
                offset: const Offset(0, 8),
                spreadRadius: 0,
              )
          ],
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).colorScheme.secondary),
      child: Row(
        children: [
          SizedBox(
              width: size.width * 0.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: size.width * 0.6,
                    child: const Text(
                      "Take a Test today, develop your skill and IQ",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                  ),
                  const Gap(height: 24),
                  PrimaryButton(
                    text: "Go",
                    padding: 10,
                    width: size.width * 0.25,
                    backgroundColor: isDark
                        ? Theme.of(context).colorScheme.tertiary
                        : Colors.white,
                    textStyle: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall?.color),
                    onTap: () =>
                        Navigator.pushNamed(context, TestPage.routeName),
                  )
                ],
              )),
          Image.asset(
            "assets/images/write-pen.png",
            fit: BoxFit.cover,
            height: 150,
          )
        ],
      ),
    ),
    if (recentSubjects.isNotEmpty)
      Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 8),
        child: Row(
          children: [
            const Icon(
              Icons.history,
              size: 16,
            ),
            const Gap(width: 2),
            Text(
              "Recents",
              style: TextStyle(color: textColor),
            ),
          ],
        ),
      ),
    if (recentSubjects.isNotEmpty)
      SizedBox(
          height: size.height * 0.2,
          child: CustomSubjectGrid(subject: recentSubjects)),
    const Gap(),
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
              onSwitch!(1);
            },
            style: const ButtonStyle(
                padding: MaterialStatePropertyAll(EdgeInsets.zero)),
            child: const Text(
              "View all",
              style: TextStyle(fontSize: 12),
            ))
      ],
    ),
  ];
}
