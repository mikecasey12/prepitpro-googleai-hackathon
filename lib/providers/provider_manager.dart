import 'package:flutter/material.dart';
import 'package:prepitpro/db/recents.dart';
import 'package:prepitpro/utils/auth.dart';
import 'package:prepitpro/utils/favorites.dart';
import 'package:prepitpro/utils/notifications.dart';
import 'package:prepitpro/utils/performance.dart';
import 'package:prepitpro/utils/subjects.dart';
import 'package:provider/provider.dart';

class ProviderManager extends StatelessWidget {
  final Widget child;
  const ProviderManager({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (context) => CurrentUser(),
      ),
      ChangeNotifierProvider(
        create: (context) => ClassSubjects(),
      ),
      ChangeNotifierProvider(
        create: (context) => PerformanceManager(),
      ),
      ChangeNotifierProvider(
        create: (context) => Recents(),
      ),
      ChangeNotifierProvider(
        create: (context) => FavoritesManager(),
      ),
      ChangeNotifierProvider(
        create: (context) => NotificationsManager(),
      ),
    ], builder: (context, _) => child);
  }
}
