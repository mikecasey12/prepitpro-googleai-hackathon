import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prepitpro/components/action_button.dart';
import 'package:prepitpro/components/gap.dart';
import 'package:prepitpro/components/input_field.dart';
import 'package:prepitpro/components/primary_button.dart';
import 'package:prepitpro/helpers/db_init.dart';
import 'package:prepitpro/helpers/messenger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});
  static const routeName = "/forgot-password";

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  void _passwordReset(String email) async {
    try {
      await DBInit.supabase.auth.resetPasswordForEmail(email,
          redirectTo: "com.supabase.staging://login-callback/");
      if (mounted) {
        Messenger.showSnackBar("Reset email sent. Check your inbox.", context);
      }
    } on AuthException catch (e) {
      if (mounted) {
        Messenger.showSnackBar(e.message, context);
      }
    } catch (e) {
      if (mounted) {
        Messenger.showSnackBar("$e", context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0x00F0AF99).withOpacity(1),
        leading: null,
        automaticallyImplyLeading: false,
        elevation: 0,
        bottomOpacity: 0,
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
      backgroundColor: const Color(0x00F0AF99).withOpacity(1),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 40, bottom: 40),
            child: Center(
              child: Text(
                "PrepIt Pro",
                style: GoogleFonts.anta(
                    textStyle: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w500)),
              ),
            ),
          ),
          Container(
            constraints: BoxConstraints(minHeight: (size.height - 64) * 0.8),
            padding:
                const EdgeInsets.only(left: 32, right: 32, top: 40, bottom: 20),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(120),
                ),
                color: const Color(0x00EBC1C3).withOpacity(1)),
            child: Column(
              children: [
                const Text(
                  "Reset Password",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                ),
                const Gap(height: 20),
                InputField(
                  label: "Email",
                  height: 60,
                  textEditingController: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const Gap(),
                PrimaryButton(
                  text: "Reset Password",
                  padding: 12,
                  height: 60,
                  hideTrailingButton: true,
                  spacing: MainAxisAlignment.center,
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  onTap: () {
                    final email = _emailController.text.trim();

                    final emailRegEx = RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      caseSensitive: false,
                      multiLine: false,
                    );
                    if (!emailRegEx.hasMatch(email)) {
                      Messenger.showSnackBar("Invalid email", context);
                      return;
                    }
                    _passwordReset(email);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
