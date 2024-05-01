import 'dart:io';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:prepitpro/db/local_db.dart';
import 'package:prepitpro/db/schema/subjects.dart' as local_db;
import 'package:prepitpro/helpers/db_init.dart';
import 'package:prepitpro/models/questions.dart';
import 'package:prepitpro/utils/auth.dart';
import 'package:provider/provider.dart';

class ClassSubjects with ChangeNotifier {
  List<local_db.Subject> _subject = [];

  List<local_db.Subject> get subject => _subject;

  List<Questions> _questions = [];

  List<Questions> get questions => _questions;

  Future<void> retrieveSubjectList(int classId) async {
    final List<local_db.Subject> subjectList = [];
    try {
      final isar = LocalDbController.instance;
      final response = await DBInit.supabase
          .from('Classes_subjects')
          .select('subject_id, Subjects(id, subject_name, color, cover_image)')
          .eq('class_id', classId);

      await isar.writeTxn(() async {
        for (final subject in response) {
          // final sub = Subject(
          //     id: subject["Subjects"]["id"],
          //     name: subject["Subjects"]["subject_name"],
          //     coverImage: subject["Subjects"]["cover_image"] ??
          //         "https://cdn-icons-png.freepik.com/256/1205/1205526.png",
          //     color: subject["Subjects"]["color"] as int?);

          //Add to Local Db
          final subldb = local_db.Subject()
            ..color = subject["Subjects"]["color"] as int?
            ..coverImage = subject["Subjects"]["cover_image"] ??
                "https://cdn-icons-png.freepik.com/256/1205/1205526.png"
            ..id = subject["Subjects"]["id"]
            ..name = subject["Subjects"]["subject_name"];

          await isar.subjects.put(subldb);

          subjectList.add(subldb);
        }
      });

      _subject = subjectList;
      notifyListeners();
    } on SocketException catch (_) {
      //Read from db incase of no network
      Future.microtask(() async {
        final subjectList = await retrieveSubjectFromDb();
        _subject = subjectList;
        notifyListeners();
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<List<local_db.Subject>> retrieveSubjectFromDb() async {
    final isar = LocalDbController.instance;
    final subject = isar.subjects;
    final sub = await subject.where().findAll();
    return sub;
  }

  Future<List<Questions>> retrieveQuestionBySubject(
      BuildContext context, int subjectId) async {
    try {
      final user = context.read<CurrentUser>().user;
      final List<Questions> questionsList = [];
      final response = await DBInit.supabase
          .from("Questions")
          .select("*")
          .eq("class_id", user.userClass!)
          .eq("subject_id", subjectId);

      for (final question in response) {
        final quest = Questions(
            id: question["id"],
            term: question["term_id"],
            question: question["question"],
            option_a: question["option_a"],
            option_b: question["option_b"],
            option_c: question["option_c"],
            option_d: question["option_d"],
            answer: question["answer"]);
        questionsList.add(quest);
      }
      _questions = questionsList;
      notifyListeners();
      return _questions;
    } catch (e) {
      rethrow;
    }
  }
}
