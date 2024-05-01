import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prepitpro/components/gap.dart';
import 'package:prepitpro/components/input_field.dart';
import 'package:prepitpro/components/primary_button.dart';
import 'package:prepitpro/helpers/db_init.dart';
import 'package:prepitpro/helpers/messenger.dart';
import 'package:prepitpro/pages/auth/forgot_password.dart';
import 'package:prepitpro/pages/auth/signup.dart';
import 'package:prepitpro/pages/homepage.dart';
import 'package:prepitpro/theme/theme.dart';
import 'package:prepitpro/utils/auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});
  static const routeName = "/auth";

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late StreamSubscription<AuthState> logInStream;

  void signInWithEmail(String email, String password) async {
    try {
      Messenger.showLoader(context);
      final AuthResponse response = await DBInit.supabase.auth
          .signInWithPassword(password: password, email: email);
      if (mounted) {
        Navigator.pop(context);
        Messenger.showSnackBar("Signed in", context, success: true);
        Navigator.pushReplacementNamed(context, HomePage.routeName,
            arguments: response);
      }
    } on AuthException catch (e) {
      if (mounted) {
        Navigator.pop(context);
        Messenger.showSnackBar(e.message, context, isError: true);
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        Messenger.showSnackBar("An error occurred when sigining in.", context,
            isError: true);
      }
    }
  }

  @override
  void initState() {
    logInStream = DBInit.supabase.auth.onAuthStateChange.listen((event) {
      if (event.session != null) {
        Navigator.pushReplacementNamed(context, HomePage.routeName);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    logInStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = ThemeController.themeMode.value == ThemeMode.dark;
    final backgroundColor = Theme.of(context).colorScheme.background;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    return SafeArea(
        child: Scaffold(
      backgroundColor: isDark
          ? Colors.brown.shade900
          : const Color(0x00F0AF99).withOpacity(1),
      body: ListView(
        children: [
          Container(
            constraints: BoxConstraints(minHeight: size.height * 0.20),
            padding: const EdgeInsets.only(top: 40, bottom: 40),
            child: Center(
              child: Text(
                "PrepIt Pro",
                style: GoogleFonts.anta(
                    textStyle: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: textColor)),
              ),
            ),
          ),
          Container(
            constraints: BoxConstraints(minHeight: size.height * 0.75),
            padding: const EdgeInsets.only(left: 40, right: 40, top: 40),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(120),
                ),
                color: isDark
                    ? backgroundColor
                    : const Color(0x00EBC1C3).withOpacity(1)),
            child: Column(
              children: [
                Text(
                  "Sign In",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      color: textColor),
                ),
                const Gap(height: 40),
                InputField(
                  label: "Email",
                  keyboardType: TextInputType.emailAddress,
                  textEditingController: _emailController,
                  height: 64,
                ),
                const Gap(height: 8),
                InputField(
                  label: "Password",
                  isPassword: true,
                  textEditingController: _passwordController,
                ),
                const Gap(height: 24),
                PrimaryButton(
                    text: "Sign In",
                    padding: 12,
                    spacing: MainAxisAlignment.center,
                    height: 60,
                    onTap: () {
                      if (_emailController.text.trim() != "" &&
                          _passwordController.text.trim() != "") {
                        signInWithEmail(_emailController.text.trim(),
                            _passwordController.text.trim());
                      }
                    },
                    hideTrailingButton: true,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    )),
                const Gap(),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(
                          context, ForgotPasswordPage.routeName);
                    },
                    child: const Text("Forgot password?")),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(color: textColor),
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, SignupPage.routeName);
                        },
                        child: Text(
                          "Sign up",
                          style: TextStyle(
                              color: isDark
                                  ? Theme.of(context).colorScheme.secondary
                                  : Colors.blueGrey),
                        )),
                  ],
                ),
                const Gap(),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        width: size.width * 0.5,
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    width: 1.0, color: Colors.grey.shade600))),
                      ),
                    ),
                    const Gap(),
                    Text(
                      "Or sign in with",
                      style: TextStyle(color: textColor),
                    ),
                    const Gap(),
                    Expanded(
                      child: Container(
                        width: size.width * 0.5,
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    width: 1.0, color: Colors.grey.shade600))),
                      ),
                    ),
                  ],
                ),
                const Gap(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () async {
                        try {
                          await AuthManager.signInWithOAuth();
                          if (context.mounted) {
                            Messenger.showSnackBar("Signed in.", context);
                          }
                        } catch (e) {
                          if (context.mounted) {
                            Messenger.showSnackBar(
                                "An error occurred while signing in.", context);
                          }
                        }
                      },
                      child: Container(
                        height: 60,
                        width: size.width,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(
                              "https://img.icons8.com/fluency/48/google-logo.png",
                              height: 24,
                              fit: BoxFit.cover,
                            ),
                            const Gap(width: 4),
                            const Text("Sign in with Google")
                          ],
                        ),
                      ),
                    ),
                    const Gap(width: 20),
                    // InkWell(
                    //   onTap: () {},
                    //   child: Container(
                    //     height: 40,
                    //     width: 40,
                    //     padding: const EdgeInsets.all(8),
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(8),
                    //       color: Colors.white,
                    //     ),
                    //     child: Image.network(
                    //       "https://img.icons8.com/color/48/facebook-new.png",
                    //       height: 24,
                    //       fit: BoxFit.cover,
                    //     ),
                    //   ),
                    // ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
