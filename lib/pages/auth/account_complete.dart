import 'dart:io';
import 'package:flutter/material.dart';
import 'package:prepitpro/components/gap.dart';
import 'package:prepitpro/components/input_field.dart';
import 'package:prepitpro/components/primary_button.dart';
import 'package:prepitpro/db/static_data.dart';
import 'package:prepitpro/helpers/function.dart';
import 'package:prepitpro/helpers/messenger.dart';
import 'package:prepitpro/pages/homepage.dart';
import 'package:prepitpro/utils/auth.dart';
import 'package:prepitpro/utils/helpers.dart';
import 'package:provider/provider.dart';

class AccountComplete extends StatefulWidget {
  const AccountComplete({super.key});
  static const routeName = "/account-complete";

  @override
  State<AccountComplete> createState() => _AccountCompleteState();
}

class _AccountCompleteState extends State<AccountComplete> {
  final Map<String, dynamic> _formdata = {
    "fname": "",
    "lname": "",
    "phonenum": "",
    "gender": "",
    "userClass": 1,
    "avatar": "",
  };
  String filepath = "";

  Map<String, dynamic> removeEmptyValues(Map<String, dynamic> data) {
    final filtereddata = data;
    data.removeWhere((key, value) => value == null || value == "");
    return filtereddata;
  }

  Future<void> _onSave() async {
    //check for empty values
    if (_formdata["lname"] == "" || _formdata["fname"] == "") {
      Messenger.showSnackBar(
        "First name and Last name cannot be empty.",
        context,
      );
      return;
    }
    if (_formdata["gender"] == "") {
      Messenger.showSnackBar(
        "Select gender",
        context,
      );
      return;
    }
    if (_formdata["lname"].length < 2 || _formdata["fname"].length < 2) {
      Messenger.showSnackBar(
        "Name too short.",
        context,
      );
      return;
    }
    final username =
        FunctionHelper.usernameGen(_formdata["fname"], _formdata["lname"]);
    _formdata["username"] = username;
    _formdata["accountCompleted"] = true;
    _formdata["points"] = 10;
    Messenger.showLoader(context);
    if (filepath != "") {
      _formdata["avatar"] = await ImageManager.uploadPicture(filepath);
      _formdata["updatedImage"] = DateTime.timestamp().toIso8601String();
    }
    final data = removeEmptyValues(_formdata);
    if (mounted) {
      if (data.isEmpty) {
        Navigator.pop(context);
        return;
      }
      try {
        await context.read<CurrentUser>().updateUser(data);
        if (mounted) {
          Navigator.pop(context);
          Messenger.showSnackBar("Profile updated", context, success: true);
          Navigator.pushReplacementNamed(context, HomePage.routeName);
        }
      } catch (e) {
        if (mounted) {
          Navigator.pop(context);
          Messenger.showSnackBar("$e", context, isError: true);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    final user = context.read<CurrentUser>().user;
    const userClassList = StaticData.userClass;
    final textStyle =
        TextStyle(color: Theme.of(context).textTheme.bodySmall?.color);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Complete Account"),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            Row(
              children: [
                CircleAvatar(
                  foregroundImage:
                      filepath != "" ? FileImage(File(filepath)) : null,
                  backgroundImage: filepath == ""
                      ? NetworkImage(user.avatar != null
                          ? user.avatar!
                          : StaticData.defaultImage)
                      : null,
                  radius: 50,
                  onForegroundImageError: filepath != ""
                      ? (exception, stackTrace) {
                          Messenger.showSnackBar(
                              "failed loading avatar", context);
                        }
                      : null,
                ),
                MaterialButton(
                  onPressed: () async {
                    final filePath = await ImageManager.selectImage();
                    setState(() {
                      filepath = filePath!;
                    });
                  },
                  child: const Text("Upload picture"),
                ),
                if (filepath != "")
                  MaterialButton(
                    onPressed: () {
                      setState(() {
                        filepath = "";
                      });
                    },
                    child: const Text("Remove",
                        style: TextStyle(color: Colors.red)),
                  ),
              ],
            ),
            const Gap(),
            Text(
              "First Name",
              style: textStyle,
            ),
            InputField(
              filled: false,
              border: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1),
                  borderRadius: BorderRadius.circular(999)),
              label: user.fname,
              onChanged: (value) {
                _formdata["fname"] = value.trim();
              },
            ),
            const Gap(),
            Text(
              "Last Name",
              style: textStyle,
            ),
            InputField(
              filled: false,
              border: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1),
                  borderRadius: BorderRadius.circular(999)),
              label: user.lname,
              onChanged: (value) {
                _formdata["lname"] = value.trim();
              },
            ),
            const Gap(),
            Text(
              "Phone Number (optional)",
              style: textStyle,
            ),
            InputField(
              filled: false,
              keyboardType: TextInputType.phone,
              border: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1),
                  borderRadius: BorderRadius.circular(999)),
              label: user.phonenum ?? "Not set",
              onChanged: (value) {
                _formdata["phonenum"] = value.trim();
              },
            ),
            const Gap(),
            Text(
              "Gender",
              style: textStyle,
            ),
            DropdownButtonFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1),
                  borderRadius: BorderRadius.circular(999),
                ),
                contentPadding: const EdgeInsets.all(14),
                hintText: "Gender",
              ),
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
              onChanged: (value) {
                _formdata["gender"] = value;
              },
            ),
            const Gap(),
            Text(
              "Class",
              style: textStyle,
            ),
            DropdownButtonFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1),
                  borderRadius: BorderRadius.circular(999),
                ),
                contentPadding: const EdgeInsets.all(14),
                hintText: user.userClass != null
                    ? userClassList.firstWhere((userclass) =>
                        userclass["id"] == user.userClass)["text"]
                    : "Class",
              ),
              items: [
                ...userClassList.map(
                  (e) {
                    return DropdownMenuItem(
                      key: ValueKey(e["id"]),
                      value: e["id"],
                      child: Text("${e["text"]}"),
                    );
                  },
                ),
              ],
              onChanged: (value) {
                _formdata["userClass"] = value;
              },
            ),
            const Gap(height: 24),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: PrimaryButton(
                mainPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                spacing: MainAxisAlignment.spaceBetween,
                backgroundColor: Theme.of(context).colorScheme.secondary,
                text: "Save Changes",
                textStyle:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                onTap: () async {
                  await _onSave();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
