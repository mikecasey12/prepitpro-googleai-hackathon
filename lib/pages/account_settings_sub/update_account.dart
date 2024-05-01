import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:prepitpro/components/gap.dart';
import 'package:prepitpro/components/input_field.dart';
import 'package:prepitpro/components/primary_button.dart';
import 'package:prepitpro/db/static_data.dart';
import 'package:prepitpro/helpers/messenger.dart';
import 'package:prepitpro/pages/account_settings_sub/update_user_password.dart';
import 'package:prepitpro/utils/auth.dart';
import 'package:prepitpro/utils/helpers.dart';
import 'package:provider/provider.dart';

class UpdateAccount extends StatefulWidget {
  const UpdateAccount({super.key});

  @override
  State<UpdateAccount> createState() => _UpdateAccountState();
}

class _UpdateAccountState extends State<UpdateAccount> {
  final Map<String, dynamic> formdata = {
    "fname": "",
    "lname": "",
    "phonenum": "",
    "userClass": "",
    "avatar": "",
  };
  String filepath = "";

  Map<String, dynamic> removeEmptyValues(Map<String, dynamic> data) {
    final filtereddata = data;
    data.removeWhere((key, value) => value == null || value == "");
    return filtereddata;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = context.read<CurrentUser>().user;
    const userClassList = StaticData.userClass;
    final textStyle =
        TextStyle(color: Theme.of(context).textTheme.bodySmall?.color);
    return SizedBox(
      height: size.height * 0.8,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          Row(
            children: [
              CircleAvatar(
                foregroundImage:
                    filepath != "" ? FileImage(File(filepath)) : null,
                backgroundImage: filepath == ""
                    ? NetworkImage(user.avatar != null ? user.avatar! : "")
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
                  child:
                      const Text("Remove", style: TextStyle(color: Colors.red)),
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
              formdata["fname"] = value.trim();
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
              formdata["lname"] = value.trim();
            },
          ),
          const Gap(),
          Text(
            "Phone Number",
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
              formdata["phonenum"] = value.trim();
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
              contentPadding: const EdgeInsets.all(16),
              hintText: user.userClass != null
                  ? userClassList.firstWhere(
                      (userclass) => userclass["id"] == user.userClass)["text"]
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
              formdata["userClass"] = value;
            },
          ),
          const Gap(height: 24),
          const Divider(color: Colors.black54),
          Row(
            children: [
              Text(
                "Password:",
                style: textStyle,
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.popAndPushNamed(context, ChangePassword.routeName);
                },
                child: SizedBox(
                    width: size.width * 0.5,
                    child: const AutoSizeText("Change password")),
              )
            ],
          ),
          const Gap(height: 16),
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
                Messenger.showLoader(context);
                if (filepath != "") {
                  formdata["avatar"] =
                      await ImageManager.uploadPicture(filepath);
                  formdata["updatedImage"] =
                      DateTime.timestamp().toIso8601String();
                }
                final data = removeEmptyValues(formdata);
                if (context.mounted) {
                  if (data.isEmpty) {
                    Navigator.pop(context);
                    return;
                  }
                  try {
                    await context.read<CurrentUser>().updateUser(data);
                    if (context.mounted) {
                      Navigator.pop(context);
                      Messenger.showSnackBar("Profile updated", context,
                          success: true);
                      Navigator.pop(context);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      Navigator.pop(context);
                      Messenger.showSnackBar("$e", context, isError: true);
                    }
                  }
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
