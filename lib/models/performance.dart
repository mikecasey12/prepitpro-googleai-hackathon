// ignore_for_file: non_constant_identifier_names

class UserPerformance {
  final int? id;
  final String? user_id;
  final Object? active_periods;
  final int? total_questions;
  final int? questions_passed;
  final int? questions_failed;
  final int? subject_id;

  const UserPerformance(
      {this.id,
      this.user_id,
      this.subject_id,
      this.active_periods,
      this.questions_failed = 0,
      this.questions_passed = 0,
      this.total_questions = 0});

  @override
  String toString() {
    return 'UserPerformance(id: $id, user_id: $user_id, subject_id: $subject_id, active_periods: $active_periods, questions_failed: $questions_failed, questions_passed: $questions_passed, total_questions: $total_questions)';
  }
}
