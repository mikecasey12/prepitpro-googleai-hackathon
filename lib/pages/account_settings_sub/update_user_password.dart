// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:prepitpro/components/action_button.dart';
import 'package:prepitpro/components/gap.dart';
import 'package:prepitpro/components/input_field.dart';
import 'package:prepitpro/components/primary_button.dart';
import 'package:prepitpro/helpers/messenger.dart';
import 'package:prepitpro/utils/auth.dart';
import 'package:provider/provider.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});
  static const routeName = "/change-password";

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _passwordController = TextEditingController();
  final _rePasswordController = TextEditingController();
  bool showPassword = true;
  bool showRePassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _rePasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Change Password"),
          leading: null,
          automaticallyImplyLeading: false,
          actions: [
            ActionButton(
              icon: Icons.close,
              size: 40,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Gap()
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "You're about changing your password.",
                style: TextStyle(color: Colors.amber, fontSize: 14),
              ),
              const Gap(),
              InputField(
                label: "Password",
                isPassword: showPassword,
                filled: false,
                border: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1.0),
                    borderRadius: BorderRadius.circular(999)),
                textEditingController: _passwordController,
                suffixIcon: InkWell(
                    onTap: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    child: const Icon(Icons.remove_red_eye)),
              ),
              const Gap(),
              InputField(
                label: "Re-password",
                isPassword: showRePassword,
                filled: false,
                border: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1.0),
                    borderRadius: BorderRadius.circular(999)),
                textEditingController: _rePasswordController,
                suffixIcon: InkWell(
                    onTap: () {
                      setState(() {
                        showRePassword = !showRePassword;
                      });
                    },
                    child: const Icon(Icons.remove_red_eye)),
              ),
              const Gap(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: PrimaryButton(
                  text: "Change Password",
                  textStyle: const TextStyle(fontWeight: FontWeight.w500),
                  padding: 12,
                  backgroundColor: Colors.amber,
                  spacing: MainAxisAlignment.spaceBetween,
                  onTap: () async {
                    Messenger.showLoader(context);
                    if (_passwordController.text !=
                        _rePasswordController.text) {
                      Navigator.pop(context);
                      Messenger.showSnackBar("Passwords don't match", context);
                      return;
                    }
                    if (_rePasswordController.text.length < 8) {
                      Navigator.pop(context);
                      Messenger.showSnackBar("Password too short", context);
                      return;
                    }
                    try {
                      await context
                          .read<CurrentUser>()
                          .changeUserPassword(_rePasswordController.text);
                      if (mounted) {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      }
                    } catch (e) {
                      Navigator.pop(context);
                      Messenger.showSnackBar("$e", context);
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
