import 'dart:convert';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:prepitpro/env/env.dart';

final _model = GenerativeModel(
  model: "gemini-1.0-pro-latest",
  apiKey: Env.AI_API_KEY,
  safetySettings: [
    SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.high)
  ],
);

// RegExp _regExp = RegExp(r'{(?:[^\\{}]|\\.)*}');
RegExp _r = RegExp(r'\{(?:[^{}]|(?<=\\)\")*\}');

abstract class PIPAI {
  static Future<String?> generateQuestions(
      {String? topic, String? notes, int questionsNumber = 10}) async {
    final content = [
      Content.text('''$topic.
      $notes.
Adhere to these instructions strictly. Give me $questionsNumber questions from the text. All questions should come from the text. Arrange them in this schema format. 
{"id": "" (e.g. "1"), "subject": "" (subject should be gotten from the topic e.g English), "term": number (from 1-3 only), "question": "text" (properly escape characters like ""), "option_a": "text" (properly escape characters like ""), "option_b": "text" (properly escape characters like ""), "option_c": "text" (properly escape characters like ""), "option_d": "text" (properly escape characters like ""), "answer": "text" (answer should have the correct option. e.g. "option_a") }''')
    ];
    try {
      final response = await _model.generateContent(content);
      if (response.text == null) {
        return "Try again.";
      }
      return response.text;
    } catch (e) {
      rethrow;
    }
  }

  static Future<String?> generateQuestionsFromUploadedNotes(
      {String? notes, int questionsNumber = 20}) async {
    final content = [
      Content.text('''
      $notes.
Adhere to these instructions strictly. Give me $questionsNumber questions from the text. All questions should come from the text. Arrange them in this schema format. 
{"id": "" (e.g. "1"), "subject": "" (subject should be generated from the notes. Subject short be short and concise.), "term": number (from 1-3 only), "question": "text" (properly escape characters like ""), "option_a": "text" (properly escape characters like ""), "option_b": "text" (properly escape characters like ""), "option_c": "text" (properly escape characters like ""), "option_d": "text" (properly escape characters like ""), "answer": "text" (answer should have the correct option. e.g. "option_a") }''')
    ];
    try {
      final response = await _model.generateContent(content);
      if (response.text == null) {
        return "Try again.";
      }
      return response.text;
    } catch (e) {
      rethrow;
    }
  }

  static Future<String?> generateSubjectQuestions(
      {String? subject, int questionsNumber = 20, String? userClass}) async {
    final content = [
      Content.text(
          ''' Adhere to these instructions strictly. Give me $questionsNumber questions for the subject $subject. Questions are for class $userClass. Use the Nigerian education style. Questions should not be more or less than $questionsNumber. Mix in questions from different syllables in the subject and all syllables should be for class $userClass. Question answer should be correct and among the options. Arrange them in this schema format.
{"id": "" (e.g. "1"), "subject": "" (subject should be gotten from the topic e.g English), "term": number (from 1-3 only), "question": "text" (properly escape characters like ""), "option_a": "text" (properly escape characters like ""), "option_b": "text" (properly escape characters like ""), "option_c": "text" (properly escape characters like ""), "option_d": "text" (properly escape characters like ""), "answer": "text" (e.g. "option_a") }''')
    ];
    try {
      final response = await _model.generateContent(content);
      if (response.text == null) {
        return 'Try again.';
      }
      // print(response.text);
      return response.text;
    } catch (e) {
      rethrow;
    }
  }

  static Future<String?> explainAnswer(
      {String? subject, String? question, String? answer}) async {
    final content = [
      Content.text(
          '''Explain why $answer is the answer to $question. Not more than 500 words. Voice tone should be for teenagers between 11 - 17 years. Do not use ambigious words. Do not use ambigious analogy. Explanation should be clear and concise.''')
    ];
    try {
      final response = await _model.generateContent(content);
      if (response.text == null) {
        return response.text;
      }

      return response.text;
    } catch (e) {
      rethrow;
    }
  }

  static void formatQuestions(
      {String? questions, List<Map<String, dynamic>>? jsonArray}) {
    // try {
    //   if (questions == null || questions == "" || jsonArray == null) {
    //     return;
    //   }
    //   List<String> matches =
    //       _r.allMatches(questions).map((m) => m.group(0)!).toList();
    //   for (String match in matches) {
    //     jsonArray.add(jsonDecode(match));
    //   }
    // } on FormatException catch (_) {
    //   rethrow;
    // } catch (e) {
    //   rethrow;
    // }

    try {
      if (questions == null || questions.isEmpty || jsonArray == null) {
        return;
      }
      List<String> matches =
          _r.allMatches(questions).map((m) => m.group(0)!).toList();
      for (String match in matches) {
        try {
          var decodedJson = jsonDecode(match);
          if (decodedJson is Map<String, dynamic>) {
            jsonArray.add(decodedJson);
          } else {
            // Handle invalid JSON format
            print("Invalid JSON format: $match");
          }
        } on FormatException catch (_) {
          print("Invalid JSON formatt: $match");
        } catch (e) {
          rethrow;
        }
      }
    } catch (e) {
      rethrow;
    }
  }
}
