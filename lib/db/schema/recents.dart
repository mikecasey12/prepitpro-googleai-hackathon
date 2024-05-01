import "package:isar/isar.dart";
import "package:prepitpro/db/schema/subjects.dart";

part "recents.g.dart";

@collection
class Recent {
  Id? id = Isar.autoIncrement;
  int? createdAt = DateTime.now().millisecondsSinceEpoch;

  final subject = IsarLink<Subject>();
}
