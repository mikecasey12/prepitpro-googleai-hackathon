import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prepitpro/components/gap.dart';
import 'package:prepitpro/components/primary_button.dart';
import 'package:prepitpro/db/avatars.dart';
import 'package:prepitpro/db/static_data.dart';
import 'package:prepitpro/helpers/db_init.dart';
import 'package:prepitpro/helpers/function.dart';
import 'package:prepitpro/helpers/messenger.dart';
import 'package:prepitpro/pages/auth/auth.dart';
import 'package:prepitpro/pages/homepage.dart';
import 'package:prepitpro/theme/theme.dart';
import 'package:prepitpro/utils/auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  static const routeName = "/signup";

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  late StreamSubscription<AuthState> logInStream;
  final Map<String, dynamic> _formdata = {
    "fname": "",
    "lname": "",
    "email": "",
    "password": "",
    "re-password": "",
    "phonenum": "",
    "gender": "",
    "username": "",
    "userClass": "",
    "avatar": "",
  };
  bool _obscurePassword = true;
  bool _obscureRepassword = true;

  @override
  void initState() {
    logInStream = DBInit.supabase.auth.onAuthStateChange.listen((event) {
      if (event.session != null) {
        Navigator.pushReplacementNamed(context, HomePage.routeName);
      }
    });
    super.initState();
  }

  void _onSave() async {
    try {
      final isValid = _formKey.currentState?.validate();
      if (!isValid!) {
        Navigator.pop(context);
        return;
      }

      _formKey.currentState?.save();

      //Generating random usernames
      final username =
          FunctionHelper.usernameGen(_formdata["fname"], _formdata["lname"]);
      _formdata["username"] = username;

      //Store user avatar
      _formdata["avatar"] = _formdata["gender"].toLowerCase() == "f"
          ? fAvatars[Random().nextInt(2)]
          : mAvatars[Random().nextInt(2)];

      //User points default 10
      _formdata["points"] = 10;

      //Points date
      _formdata["datePointsGiven"] =
          DateTime.timestamp().add(const Duration(days: 1)).toIso8601String();

      //Set user auth status
      _formdata["accountCompleted"] = true;

      //Send userdata to database
      await DBInit.supabase.auth.signUp(
          password: _formdata["password"],
          email: _formdata["email"],
          data: _formdata);

      //Navigate to home screen on successful signup
      if (mounted) {
        Navigator.pop(context);
        Messenger.showSnackBar("Account created successfully", context,
            success: true);
        Navigator.of(context).pushReplacementNamed(HomePage.routeName);
      }
    } on AuthException catch (e) {
      if (mounted) {
        Navigator.pop(context);
        Messenger.showSnackBar(e.message, context);
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        Messenger.showSnackBar(e.toString(), context);
      }
    }
  }

  final _userClass = StaticData.userClass;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = ThemeController.isDark.value;
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
            constraints: BoxConstraints(minHeight: size.height * 0.8),
            padding:
                const EdgeInsets.only(left: 32, right: 32, top: 40, bottom: 20),
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
                  "Sign Up",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      color: textColor),
                ),
                const Gap(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        onSaved: (value) {
                          _formdata["fname"] = value!.trim();
                        },
                        validator: (value) {
                          if (value!.trim() == "") {
                            return "Enter first name";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(999),
                                borderSide: const BorderSide(width: 1)),
                            fillColor: const Color(0x00EBC1C3).withOpacity(1),
                            filled: true,
                            hintStyle: const TextStyle(color: Colors.black26),
                            contentPadding: const EdgeInsets.all(16),
                            hintText: "First Name"),
                      ),
                      const Gap(),
                      TextFormField(
                        onSaved: (value) {
                          _formdata["lname"] = value!.trim();
                        },
                        validator: (value) {
                          if (value!.trim() == "") {
                            return "Enter last name";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(width: 1),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            fillColor: const Color(0x00EBC1C3).withOpacity(1),
                            filled: true,
                            hintStyle: const TextStyle(color: Colors.black26),
                            contentPadding: const EdgeInsets.all(16),
                            hintText: "Last Name"),
                      ),
                      const Gap(),
                      TextFormField(
                        onSaved: (newValue) {
                          _formdata["email"] = newValue!.trim();
                        },
                        validator: (value) {
                          final emailRegEx = RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            caseSensitive: false,
                            multiLine: false,
                          );
                          if (!emailRegEx.hasMatch(value!)) {
                            return "email is not valid";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(width: 1),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            fillColor: const Color(0x00EBC1C3).withOpacity(1),
                            filled: true,
                            hintStyle: const TextStyle(color: Colors.black26),
                            contentPadding: const EdgeInsets.all(16),
                            hintText: "Email"),
                      ),
                      const Gap(),
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(width: 1),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            fillColor: const Color(0x00EBC1C3).withOpacity(1),
                            filled: true,
                            hintStyle: const TextStyle(color: Colors.black26),
                            contentPadding: const EdgeInsets.all(16),
                            hintText: "Gender"),
                        items: const [
                          DropdownMenuItem(
                            value: "M",
                            child: Text("Male"),
                          ),
                          DropdownMenuItem(
                            value: "F",
                            child: Text("Female"),
                          ),
                        ],
                        onSaved: (newValue) {
                          _formdata["gender"] = newValue!.trim();
                        },
                        onChanged: (value) {
                          _formdata["gender"] = value!;
                        },
                        validator: (value) {
                          return value == null ? "select a gender" : null;
                        },
                      ),
                      const Gap(),
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(width: 1),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            fillColor: const Color(0x00EBC1C3).withOpacity(1),
                            filled: true,
                            hintStyle: const TextStyle(color: Colors.black26),
                            contentPadding: const EdgeInsets.all(16),
                            hintText: "Class"),
                        items: [
                          ..._userClass.map(
                            (e) {
                              return DropdownMenuItem(
                                key: ValueKey(e["id"]),
                                value: e["id"],
                                child: Text("${e["text"]}"),
                              );
                            },
                          ),
                        ],
                        onSaved: (newValue) {
                          _formdata["userClass"] = newValue;
                        },
                        onChanged: (value) {
                          _formdata["userClass"] = value!;
                        },
                        validator: (value) {
                          return value == null ? "select a class" : null;
                        },
                      ),
                      const Gap(),
                      TextFormField(
                        onSaved: (newValue) {
                          _formdata["phonenum"] = newValue!.trim();
                        },
                        validator: (value) {
                          if (value?.trim() == "") {
                            return null;
                          }

                          if (value!.trim().length < 11) {
                            return "enter a valid phone number";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(width: 1),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            fillColor: const Color(0x00EBC1C3).withOpacity(1),
                            filled: true,
                            hintStyle: const TextStyle(color: Colors.black26),
                            contentPadding: const EdgeInsets.all(16),
                            hintText: "Phone Number(optional)"),
                      ),
                      const Gap(),
                      TextFormField(
                        onSaved: (newValue) {
                          _formdata["password"] = newValue!;
                        },
                        onChanged: (value) {
                          _formdata["password"] = value;
                        },
                        validator: (value) {
                          if (value == null) {
                            return "password cannot be empty";
                          } else if (value.length < 6) {
                            return "password must be at least 6 characters";
                          }
                          return null;
                        },
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                                icon: const Icon(Icons.remove_red_eye_rounded)),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(width: 1),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            fillColor: const Color(0x00EBC1C3).withOpacity(1),
                            filled: true,
                            hintStyle: const TextStyle(color: Colors.black26),
                            contentPadding: const EdgeInsets.all(16),
                            hintText: "Password"),
                      ),
                      const Gap(),
                      TextFormField(
                        onSaved: (newValue) {
                          _formdata["re-password"] = newValue!;
                        },
                        validator: (value) {
                          if (value == null) {
                            return "password cannot be empty";
                          } else if (value.length < 6) {
                            return "password must be at least 6 characters";
                          } else if (value != _formdata["password"]) {
                            return "passwords do not match";
                          }
                          return null;
                        },
                        obscureText: _obscureRepassword,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(width: 1),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          fillColor: const Color(0x00EBC1C3).withOpacity(1),
                          filled: true,
                          hintStyle: const TextStyle(color: Colors.black26),
                          contentPadding: const EdgeInsets.all(16),
                          hintText: "Re-password",
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscureRepassword = !_obscureRepassword;
                                });
                              },
                              icon: const Icon(Icons.remove_red_eye_rounded)),
                        ),
                      ),
                      const Gap()
                    ],
                  ),
                ),
                const Gap(height: 20),
                PrimaryButton(
                    text: "Sign Up",
                    padding: 12,
                    height: 60,
                    spacing: MainAxisAlignment.center,
                    onTap: () {
                      Messenger.showLoader(context);
                      _onSave();
                    },
                    hideTrailingButton: true,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    )),
                const Gap(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(color: textColor),
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, AuthPage.routeName);
                        },
                        child: Text(
                          "Sign in",
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
                      "Or sign up with",
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
                            Messenger.showSnackBar("Signed in.", context,
                                success: true);
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
                    // Container(
                    //   height: 40,
                    //   width: 40,
                    //   padding: const EdgeInsets.all(8),
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(8),
                    //     color: Colors.white,
                    //   ),
                    //   child: Image.network(
                    //     "https://img.icons8.com/color/48/facebook-new.png",
                    //     height: 24,
                    //     fit: BoxFit.cover,
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
