import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:prepitpro/components/action_button.dart';
import 'package:prepitpro/components/gap.dart';
import 'package:prepitpro/utils/notifications.dart';
import 'package:provider/provider.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});
  static const routeName = "/notifications";

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    FirebaseMessaging.onMessage.listen((message) {
      print("$message");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final notifications =
        context.watch<NotificationsManager>().notificationsHistory;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Notifications"),
          leading: null,
          automaticallyImplyLeading: false,
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
          padding: const EdgeInsets.all(8),
          child: notifications.isEmpty
              ? Text(
                  "You have no notifications",
                  style: TextStyle(color: textColor),
                )
              : ListView(
                  children: notifications
                      .map((noti) => ListTile(
                            leading: const Icon(Icons.notifications),
                            title: Text("${noti.title}"),
                            contentPadding:
                                const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          ))
                      .toList()),
        ),
      ),
    );
  }
}
