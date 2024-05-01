import 'package:flutter/material.dart';
import 'package:prepitpro/components/action_button.dart';
import 'package:prepitpro/components/gap.dart';
import 'package:prepitpro/components/primary_button.dart';

class NotiSettings extends StatefulWidget {
  const NotiSettings({super.key});

  @override
  State<NotiSettings> createState() => _NotiSettingsState();
}

class _NotiSettingsState extends State<NotiSettings> {
  String _frequency = "Everyday";
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Dialog(
      child: Container(
        width: size.width * 0.40,
        constraints: BoxConstraints(
            minHeight: size.height * 0.30, maxHeight: size.height * 0.50),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 4, 4),
                child: Text(
                  "Notifications Settings",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).textTheme.bodyLarge?.color),
                ),
              ),
              const Divider(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: PrimaryButton(
                  leadingWidget: Row(
                    children: [
                      ActionButton(
                        icon: Icons.notifications,
                        size: 24,
                        iconSize: 12,
                        borderWidth: 0,
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                      ),
                      const Gap(width: 4),
                      const Text("Turn on")
                    ],
                  ),
                  text: "",
                  actionWidget: Switch.adaptive(
                      value: true,
                      onChanged: (v) {
                        setState(() {});
                      }),
                  mainPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  spacing: MainAxisAlignment.spaceBetween,
                  onTap: () {},
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: PrimaryButton(
                  leadingWidget: Row(
                    children: [
                      ActionButton(
                        icon: Icons.notifications,
                        size: 24,
                        iconSize: 12,
                        borderWidth: 0,
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                      ),
                      const Gap(width: 4),
                      const Text("Push notifications")
                    ],
                  ),
                  text: "",
                  actionWidget: Switch.adaptive(
                      value: true,
                      onChanged: (v) {
                        setState(() {});
                      }),
                  mainPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  spacing: MainAxisAlignment.spaceBetween,
                  onTap: () {},
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: PrimaryButton(
                  leadingWidget: Row(
                    children: [
                      ActionButton(
                        icon: Icons.notifications,
                        size: 24,
                        iconSize: 12,
                        borderWidth: 0,
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                      ),
                      const Gap(width: 4),
                      const Text("Frequency")
                    ],
                  ),
                  actionWidget: PopupMenuButton(
                    icon: Text(_frequency),
                    onSelected: (value) {
                      setState(() {
                        _frequency = value;
                      });
                    },
                    itemBuilder: (context) {
                      return const [
                        PopupMenuItem(
                          value: "Everyday",
                          child: Text("Everyday"),
                        ),
                        PopupMenuItem(
                          value: "Weekly",
                          child: Text("Weekly"),
                        ),
                      ];
                    },
                  ),
                  text: "",
                  mainPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  spacing: MainAxisAlignment.spaceBetween,
                  onTap: () {},
                ),
              ),
              Center(
                child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Close")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
