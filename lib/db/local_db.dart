import "package:path_provider/path_provider.dart";
import 'package:isar/isar.dart';
import 'package:prepitpro/db/schema/recents.dart' as recent;
import 'package:prepitpro/db/schema/subjects.dart';

class LocalDbController {
  static late Isar _instance;
  static Isar get instance => _instance;
  static Future<void> localDBInit() async {
    final dir = await getApplicationDocumentsDirectory();
    final isar = await Isar.open(
      [SubjectSchema, recent.RecentSchema],
      directory: dir.path,
    );
    _instance = isar;
  }
}
