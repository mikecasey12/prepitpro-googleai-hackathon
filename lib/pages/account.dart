import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:prepitpro/components/action_button.dart';
import 'package:prepitpro/components/gap.dart';
import 'package:prepitpro/components/primary_button.dart';
import 'package:prepitpro/db/static_data.dart';
import 'package:prepitpro/helpers/messenger.dart';
import 'package:prepitpro/pages/auth/auth.dart';
import 'package:prepitpro/pages/notifications.dart';
import 'package:prepitpro/pages/settings.dart';
import 'package:prepitpro/theme/theme.dart';
import 'package:prepitpro/utils/auth.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _settingsOptions = StaticData.settingsOptions;
  bool isDark = false;

  @override
  void initState() {
    Future.microtask(() async {
      await context.read<CurrentUser>().giveUserDailyPoint();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = context.watch<CurrentUser>().user;
    const userClassList = StaticData.userClass;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account"),
        actions: [
          ActionButton(
            icon: Icons.notifications_none_outlined,
            size: 40,
            onTap: () {
              Navigator.pushNamed(context, NotificationsPage.routeName);
            },
          ),
          const Gap(),
          ActionButton(
            icon: Icons.settings,
            size: 40,
            onTap: () => Navigator.pushNamed(context, SettingsPage.routeName),
          ),
          const Gap(width: 16),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
        children: [
          Row(
            children: [
              CircleAvatar(
                foregroundImage: NetworkImage(user.avatar != null
                    ? user.avatar!
                    : StaticData.defaultImage),
                radius: size.width * 0.2,
              ),
              const Gap(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: size.width * 0.5,
                    child: AutoSizeText(
                      user.fname != null
                          ? "${user.fname} ${user.lname}"
                          : "Profile Name",
                      style: Theme.of(context).textTheme.bodyLarge,
                      maxLines: 2,
                      minFontSize: 14,
                    ),
                  ),
                  Text(
                    user.username != null ? "@${user.username}" : "@username",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: Theme.of(context).textTheme.bodySmall?.color),
                  ),
                  const Gap(),
                  Text(
                    "Class:",
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 12,
                        color: Theme.of(context).textTheme.bodySmall?.color),
                  ),
                  Text(
                    user.userClass != null
                        ? "${user.userClass != null ? userClassList.firstWhere((userclass) => userclass["id"] == user.userClass)["text"] : "Class"}"
                        : "SS3",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Row(
                    children: [
                      Text("Share:",
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 12,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.color)),
                      InkWell(
                          onTap: () {
                            Share.shareUri(Uri.https("fixxsofts.com",
                                "/prepitpro", {"q": "download"}));
                          },
                          child: const Icon(Icons.share_outlined))
                    ],
                  ),
                ],
              )
            ],
          ),
          const Gap(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PrimaryButton(
                text: "",
                reverse: true,
                actionWidget: Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.amber.shade700,
                    ),
                    const Gap(width: 4),
                    Column(
                      children: [
                        Text(
                          "Points",
                          style: TextStyle(
                              fontSize: 8,
                              color: Colors.grey.shade100.withOpacity(0.4)),
                        ),
                        Text(
                          "${user.points ?? 0}",
                          style: const TextStyle(color: Colors.white),
                        )
                      ],
                    )
                  ],
                ),
                padding: 10,
                width: size.width * 0.35,
                backgroundColor: Colors.black87,
              ),
              PrimaryButton(
                text: user.subscribed! ? "Subscribed" : "Not Subscribed",
                actionWidget: Row(
                  children: [
                    user.subscribed!
                        ? const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          )
                        : Icon(
                            Icons.cancel_outlined,
                            color: Colors.red.shade400,
                          ),
                    const Gap(width: 4)
                  ],
                ),
                spacing: MainAxisAlignment.center,
                textStyle: const TextStyle(color: Colors.white),
                padding: 12,
                reverse: true,
                width: size.width * 0.5,
                backgroundColor: user.subscribed!
                    ? Colors.green.shade900
                    : Colors.grey.shade700,
              ),
            ],
          ),
          const Gap(),
          Container(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Theme.of(context).colorScheme.tertiary),
            child: Column(
              children: [
                PrimaryButton(
                  text: "Dark Mode",
                  mainPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                  spacing: MainAxisAlignment.spaceBetween,
                  actionWidget: Switch.adaptive(
                      value: ThemeController.themeMode.value == ThemeMode.dark,
                      onChanged: (v) {
                        setState(() {
                          ThemeController.switchDarkMode(value: v);
                        });
                      }),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(color: Colors.black45),
                ),
                ..._settingsOptions.map(
                  (e) => PrimaryButton(
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
                      Navigator.pushNamed(context, e["link"] as String,
                          arguments: e["name"]);
                    },
                  ),
                ),
                const Gap(height: 24),
                PrimaryButton(
                  onTap: () async {
                    Messenger.showLoader(context);
                    await context.read<CurrentUser>().signUserOut(context);
                    if (context.mounted) {
                      Navigator.pop(context);
                      Messenger.showSnackBar("Signed out", context);
                      Navigator.pushReplacementNamed(
                          context, AuthPage.routeName);
                    }
                  },
                  text: "",
                  padding: 12,
                  backgroundColor: Theme.of(context).colorScheme.error,
                  hideTrailingButton: false,
                  actionWidget: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Logout",
                        style: TextStyle(color: Colors.white),
                      ),
                      Gap(),
                      Icon(
                        Icons.logout,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
