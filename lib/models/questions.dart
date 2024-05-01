// ignore_for_file: non_constant_identifier_names

class Questions {
  final int? id;
  final String? subject;
  final int? term;
  final String? question;
  final String? option_a;
  final String? option_b;
  final String? option_c;
  final String? option_d;
  final String? answer;

  const Questions(
      {this.answer,
      this.id,
      this.option_a,
      this.option_b,
      this.option_c,
      this.option_d,
      this.question,
      this.subject,
      this.term});
}
