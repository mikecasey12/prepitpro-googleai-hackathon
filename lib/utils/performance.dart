import 'package:flutter/material.dart';
import 'package:prepitpro/helpers/db_init.dart';
import 'package:prepitpro/models/performance.dart';

class PerformanceManager with ChangeNotifier {
  //User Performance for all subjects
  List<UserPerformance> _allUserPerformance = const [];

  List<UserPerformance> get allUserPerformance => _allUserPerformance;

  //User Performance per subjects
  UserPerformance _userPerformance = const UserPerformance();

  UserPerformance get userPerformance => _userPerformance;

  int _totalQuestions = 0;
  int get totalQuestions => _totalQuestions;

  int _questionsPassed = 0;
  int get qeustionsPassed => _questionsPassed;

  int _questionsFailed = 0;
  int get questionsFailed => _questionsFailed;

  int _totalSubjects = 0;
  int get totalSubjects => _totalSubjects;

  Future<void> getUserPerformance(String userId, int classId) async {
    try {
      List<UserPerformance> up = [];
      _totalQuestions = 0;
      _questionsPassed = 0;
      _questionsFailed = 0;

      final response = await DBInit.supabase
          .from("performance")
          .select()
          .eq("user_id", userId)
          .eq("class_id", classId);
      for (final userPerformance in response) {
        up.add(
          UserPerformance(
              id: userPerformance["id"],
              user_id: userPerformance["user_id"],
              subject_id: userPerformance["subject_id"],
              total_questions: userPerformance["total_questions"],
              questions_passed: userPerformance["questions_passed"],
              questions_failed: userPerformance["questions_failed"]),
        );

        _totalQuestions += userPerformance["total_questions"] as int;
        _questionsPassed += userPerformance["questions_passed"] as int;
        _questionsFailed += userPerformance["questions_failed"] as int;
      }
      _totalSubjects = response.length;
      _allUserPerformance = up;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getUserPerformancePerSubject(String userId,
      {int? subjectId = 1, int? classId}) async {
    try {
      final response = await DBInit.supabase
          .from("performance")
          .select()
          .eq("user_id", userId)
          .eq("subject_id", subjectId!)
          .eq("class_id", classId!);

      final resdata = response.isEmpty ? {} : response[0];
      if (resdata.isNotEmpty) {
        final up = UserPerformance(
            id: resdata["id"],
            user_id: resdata["user_id"],
            subject_id: subjectId,
            total_questions: resdata["total_questions"],
            questions_passed: resdata["questions_passed"],
            questions_failed: resdata["questions_failed"]);

        _userPerformance = up;
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> upsertUserPerformance({
    required String userId,
    required int subjectId,
    required int classId,
    required int totalQuestions,
    required int passedQuestions,
    required int failedQuestions,
  }) async {
    try {
      await DBInit.supabase
          .from("performance")
          .upsert({
            "user_id": userId,
            "subject_id": subjectId,
            "class_id": classId,
            "active_periods": {"date": DateTime.timestamp().toIso8601String()},
            "total_questions": _userPerformance.total_questions != null
                ? _userPerformance.total_questions! + totalQuestions
                : 0 + totalQuestions,
            "questions_passed": _userPerformance.questions_passed != null
                ? _userPerformance.questions_passed! + passedQuestions
                : 0 + passedQuestions,
            "questions_failed": _userPerformance.questions_failed != null
                ? _userPerformance.questions_failed! + failedQuestions
                : 0 + failedQuestions,
          }, onConflict: "user_id,subject_id")
          .eq("user_id", userId)
          .eq("subject_id", subjectId)
          .eq("class_id", classId);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
