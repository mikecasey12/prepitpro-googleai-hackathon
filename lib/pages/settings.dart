import 'package:flutter/material.dart';
import 'package:prepitpro/components/action_button.dart';
import 'package:prepitpro/components/gap.dart';
import 'package:prepitpro/components/primary_button.dart';
import 'package:prepitpro/pages/account_settings_sub/notification_settings.dart';
import 'package:prepitpro/pages/account_settings_sub/update_account.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  static const routeName = "/settings";

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const List<Map<String, Object>> _settingsOptions = [
    {
      "id": "1",
      "icon": Icons.person,
      "link": "profile",
      "name": "Update Profile",
    },
    {
      "id": "2",
      "icon": Icons.notifications,
      "link": "notifications",
      "name": "Notifications",
    },
    {
      "id": "3",
      "icon": Icons.privacy_tip,
      "link": "/privacy",
      "name": "Privacy",
    },
    {
      "id": "4",
      "icon": Icons.file_present,
      "link": "/terms-and-conditions",
      "name": "Terms & Condition",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
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
        body: ListView(
          padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Theme.of(context).colorScheme.tertiary),
              child: Column(
                children: [
                  ..._settingsOptions.map(
                    (e) {
                      final link = e["link"] as String;
                      return PrimaryButton(
                        key: ValueKey(e["id"]),
                        margin: const EdgeInsets.only(bottom: 8),
                        leadingWidget: Row(
                          children: [
                            ActionButton(
                              icon: e["icon"] as IconData,
                              size: 24,
                              iconSize: 12,
                              borderWidth: 0,
                              backgroundColor:
                                  Theme.of(context).colorScheme.tertiary,
                            ),
                            const Gap(width: 4),
                            Text("${e["name"]}")
                          ],
                        ),
                        text: "",
                        padding: 12,
                        spacing: MainAxisAlignment.spaceBetween,
                        onTap: () {
                          if (link == "profile") {
                            showModalBottomSheet(
                              showDragHandle: true,
                              enableDrag: true,
                              useSafeArea: true,
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                return const UpdateAccount();
                              },
                            );
                            return;
                          }
                          if (link == "notifications") {
                            showAdaptiveDialog(
                              barrierDismissible: false,
                              useRootNavigator: false,
                              context: context,
                              builder: (context) {
                                return const NotiSettings();
                              },
                            );
                            return;
                          }
                          Navigator.pushNamed(context, link);
                        },
                      );
                    },
                  ).toList(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
