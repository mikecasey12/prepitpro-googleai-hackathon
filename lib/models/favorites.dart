// ignore_for_file: non_constant_identifier_names

class Favorites {
  final String? id;
  final int? subject_id;
  final String? class_id;
  final String? subject_image;
  final String? subject_name;
  final int? color;

  const Favorites(
      {required this.class_id,
      required this.id,
      required this.subject_id,
      required this.subject_name,
      required this.subject_image,
      this.color});
}
