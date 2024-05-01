import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:prepitpro/components/action_button.dart';
import 'package:prepitpro/components/gap.dart';
import 'package:prepitpro/components/primary_button.dart';
import 'package:prepitpro/helpers/messenger.dart';
import 'package:prepitpro/models/custom_exception.dart';
import 'package:prepitpro/pages/generated_questions.dart';
import 'package:prepitpro/theme/theme.dart';
import 'package:prepitpro/utils/pip_ai.dart';
import 'package:typeset/typeset.dart';

class CustomizeTestPage extends StatefulWidget {
  const CustomizeTestPage({super.key});
  static const routeName = "/customize-test";

  @override
  State<CustomizeTestPage> createState() => _CustomizeTestPageState();
}

class _CustomizeTestPageState extends State<CustomizeTestPage> {
  final TextEditingController _topicTextController = TextEditingController();
  final TextEditingController _passageTextController = TextEditingController();
  String? filename;
  String? fileContent;
  int questionsNumber = 10;

  final _questions = [
    {"id": 1, "text": 10},
    {"id": 2, "text": 15},
    {"id": 3, "text": 20},
    {"id": 4, "text": 25},
  ];

  @override
  void dispose() {
    _passageTextController.dispose();
    _topicTextController.dispose();
    super.dispose();
  }

  Future<String?> selectNote() async {
    try {
      final filePath = await FilePicker.platform.pickFiles(
          allowMultiple: false,
          type: FileType.custom,
          allowedExtensions: ["txt"],
          dialogTitle: "Select your note.");
      if (filePath == null) {
        return null;
      }
      PlatformFile pickedFile = filePath.files.first;
      // Open the file
      setState(() {
        filename = pickedFile.name;
      });
      File file = File(pickedFile.path!);

      // Read the content as a list of lines
      List<String> lines = file.readAsLinesSync();

      // Join the lines into a single string
      String content = lines.join('\n');

      if (content.length > 20000) {
        throw CustomException("The content is above 20000 character limit.");
      }

      return content;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeController.isDark.value;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("Customize Test"),
        leading: null,
        automaticallyImplyLeading: false,
        actions: [
          ActionButton(
            icon: Icons.close,
            size: 40,
            onTap: () => Navigator.pop(context),
          ),
          const Gap()
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        children: [
          Text(
            "You can add or upload notes to get questions generated from the topic.",
            style: TextStyle(
                fontSize: 20,
                color: isDark
                    ? Theme.of(context).colorScheme.primary
                    : Colors.amber),
          ),
          const Gap(),
          Row(
            children: [
              const Icon(
                Icons.library_books_outlined,
                size: 16,
              ),
              const Gap(width: 2),
              Text(
                "Topic",
                style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              ),
            ],
          ),
          const Gap(height: 2),
          TextField(
            controller: _topicTextController,
            decoration: InputDecoration(
                label: const Text("Topic"),
                labelStyle: TextStyle(color: Colors.grey.shade400),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                filled: true,
                fillColor: isDark
                    ? Theme.of(context).colorScheme.background
                    : const Color(0x00F3FFEA).withOpacity(1),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(width: 1))),
          ),
          const Gap(height: 16),
          Row(
            children: [
              const Icon(
                Icons.question_mark,
                size: 16,
              ),
              const Gap(width: 2),
              Text(
                "Number of questions",
                style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              ),
            ],
          ),
          const Gap(height: 2),
          DropdownButtonFormField(
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                fillColor: isDark
                    ? Theme.of(context).colorScheme.background
                    : const Color(0x00F3FFEA).withOpacity(1),
                filled: true,
                contentPadding: const EdgeInsets.all(14),
                hintText: "Default 10"),
            items: [
              ..._questions.map(
                (e) {
                  return DropdownMenuItem(
                    key: ValueKey(e["id"]),
                    value: e["text"],
                    child: Text(
                      "${e["text"]}",
                      style: TextStyle(
                          color: isDark
                              ? Theme.of(context).colorScheme.primary
                              : Colors.black87),
                    ),
                  );
                },
              ),
            ],
            onChanged: (value) {
              questionsNumber = value!;
            },
          ),
          const Gap(height: 16),
          Row(
            children: [
              const Icon(
                Icons.notes,
                size: 16,
              ),
              const Gap(width: 2),
              Text(
                "Notes",
                style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              ),
            ],
          ),
          const Gap(height: 2),
          TextField(
            controller: _passageTextController,
            maxLines: 10,
            maxLength: 20000,
            buildCounter: (context,
                    {required currentLength,
                    required isFocused,
                    required maxLength}) =>
                Text(
              "$currentLength/$maxLength",
              style: TextStyle(
                  color: isDark ? Colors.grey.shade500 : Colors.black87),
            ),
            decoration: InputDecoration(
                labelText: "Paste topic notes and text",
                labelStyle: TextStyle(color: Colors.grey.shade500),
                hintMaxLines: 2000,
                helperMaxLines: 2000,
                alignLabelWithHint: true,
                filled: true,
                fillColor: isDark
                    ? Theme.of(context).colorScheme.background
                    : const Color(0x00F3FFEA).withOpacity(1),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(width: 1))),
          ),
          const Gap(),
          const Divider(),
          const Gap(),
          TypeSet(
            "Upload Document _.txt_",
            textAlign: TextAlign.center,
            style: TextStyle(color: isDark ? Colors.white : Colors.black87),
          ),
          if (filename != "" && filename != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Row(
                children: [
                  Text(
                    "$filename was selected.",
                    style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87),
                  ),
                  const Gap(),
                  InkWell(
                      onTap: () {
                        setState(() {
                          fileContent = "";
                          filename = "";
                        });
                      },
                      child: const Text(
                        "Remove",
                        style: TextStyle(color: Colors.red),
                      ))
                ],
              ),
            ),
          PrimaryButton(
            text: "Upload",
            textStyle: const TextStyle(fontWeight: FontWeight.w500),
            spacing: MainAxisAlignment.center,
            margin: const EdgeInsets.only(top: 4),
            padding: 12,
            icon: Icons.add,
            onTap: () async {
              try {
                final content = await selectNote();
                setState(() {
                  fileContent = content;
                });
              } catch (e) {
                if (context.mounted) {
                  Messenger.showSnackBar("An error occured", context);
                }
              }
            },
          ),
          const Gap(),
          const Divider(),
          const Gap(),
          Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: isDark
                      ? Theme.of(context).colorScheme.primary
                      : Colors.amber),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Generate Questions",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  PrimaryButton(
                    text: "Go",
                    textStyle: TextStyle(
                        color: isDark ? Colors.white : Colors.black87),
                    padding: 8,
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                    onTap: () async {
                      String? response = "";
                      if (fileContent == "" || fileContent == null) {
                        if (_passageTextController.text.trim().length > 20000) {
                          Messenger.showSnackBar(
                              "Notes too long. Try reducing it.", context);
                          return;
                        }
                        if (_topicTextController.text.trim().length > 1000) {
                          Messenger.showSnackBar(
                              "Topic too long. Try reducing it.", context);
                        }
                        if (_topicTextController.text.trim() == "" ||
                            _passageTextController.text.trim() == "" ||
                            _passageTextController.text.trim().length < 150) {
                          Messenger.showSnackBar(
                              "Topic cannot be empty. Notes cannot be less than 150 characters",
                              context);

                          return;
                        }
                      }
                      try {
                        Messenger.showLoader(
                            text: "Generating questions...", context);
                        if (fileContent == '' || fileContent == null) {
                          response = await PIPAI.generateQuestions(
                              topic: _topicTextController.text,
                              notes: _passageTextController.text,
                              questionsNumber: questionsNumber);
                        } else {
                          response =
                              await PIPAI.generateQuestionsFromUploadedNotes(
                                  notes: fileContent);
                        }

                        if (context.mounted) {
                          Navigator.pop(context);
                          Navigator.pushNamed(
                              context, GeneratedQuestionsPage.routeName,
                              arguments: response);
                        }
                      } catch (e) {
                        if (context.mounted) {
                          Navigator.pop(context);
                          Messenger.showSnackBar("$e", context);
                        }
                      }

                      // Navigator.pushNamed(context, CustomizeTestPage.routeName);
                    },
                  ),
                ],
              )),
          const Gap(height: 48)
        ],
      ),
    ));
  }
}
