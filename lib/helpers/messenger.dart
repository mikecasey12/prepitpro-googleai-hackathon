import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prepitpro/components/gap.dart';

abstract class Messenger {
  static void showSnackBar(
    String text,
    BuildContext context, {
    bool isError = false,
    Color? backgroundColor,
    Duration? duration,
    bool success = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: duration ?? Durations.extralong3 * 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
        content: Text(
          text,
          textAlign: TextAlign.center,
        ),
        backgroundColor: isError
            ? Theme.of(context).colorScheme.error.withOpacity(0.9)
            : success
                ? Colors.green.withOpacity(0.9)
                : backgroundColor,
      ),
    );
  }

  static void showLoader(BuildContext context, {String text = "Please wait"}) {
    showAdaptiveDialog(
      barrierDismissible: false,
      useSafeArea: true,
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          content: SizedBox(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color),
                ),
                const Gap(),
                const LinearProgressIndicator(),
              ],
            ),
          ),
        );
      },
    );
  }

  static void showAlertDialog(BuildContext context) {
    showAdaptiveDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Close App",
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color)),
          titleTextStyle: const TextStyle(fontSize: 20),
          content: Text("Do you want to exit",
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color)),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  SystemNavigator.pop();
                },
                child: const Text("Yes")),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("No"))
          ],
        );
      },
    );
  }
}
