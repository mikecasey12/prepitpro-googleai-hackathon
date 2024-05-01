import 'package:flutter/material.dart';
import "package:prepitpro/components/navigation_bar.dart";
import 'package:prepitpro/db/recents.dart';
import 'package:prepitpro/helpers/messenger.dart';
import 'package:prepitpro/pages/account.dart';
import 'package:prepitpro/pages/dashboard.dart';
import 'package:prepitpro/pages/subjects.dart';
import 'package:prepitpro/utils/auth.dart';
import 'package:prepitpro/utils/favorites.dart';
import 'package:prepitpro/utils/subjects.dart';
import 'package:provider/provider.dart';
import "package:prepitpro/utils/performance.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const routeName = "/";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;

  //Page Switcher Function
  void switchCurrentPageFn(index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  @override
  void initState() {
    Future.microtask(() async {
      await context.read<CurrentUser>().retrieveUser();
      if (mounted) {
        final user = context.read<CurrentUser>().user;
        await context
            .read<FavoritesManager>()
            .retrieveUserFavorites(user.id!, user.userClass!);
        if (mounted) {
          await context.read<Recents>().retrieveRecentsFromDb();
        }
        if (mounted) {
          await context
              .read<PerformanceManager>()
              .getUserPerformance(user.id!, user.userClass!);
          if (mounted) {
            await context.read<CurrentUser>().giveUserDailyPoint();
          }
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Default Pages Layout
    List<Widget> pages = [
      Dashboard(switchCurrentPageFn: switchCurrentPageFn),
      const SubjectsPage(),
      const AccountPage()
    ];
    return SafeArea(
      child: Scaffold(
        body: PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            if (didPop) {
              return;
            }
            Messenger.showAlertDialog(context);
          },
          child: RefreshIndicator(
              onRefresh: () async {
                final user = context.read<CurrentUser>().user;
                await context.read<CurrentUser>().retrieveUser();
                if (context.mounted) {
                  await context
                      .read<ClassSubjects>()
                      .retrieveSubjectList(user.userClass!);
                }
              },
              child: IndexedStack(index: currentPageIndex, children: pages)),
        ),
        bottomNavigationBar: MainNavigationBar(
          changeIndexFn: switchCurrentPageFn,
          currentPageIndex: currentPageIndex,
          context: context,
        ),
      ),
    );
  }
}
