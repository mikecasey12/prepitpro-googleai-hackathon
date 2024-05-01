import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:prepitpro/db/local_db.dart';
import 'package:prepitpro/db/schema/recents.dart';
import 'package:prepitpro/db/schema/subjects.dart' as local_db;
// import 'package:prepitpro/models/subject.dart';

class Recents with ChangeNotifier {
  final List<local_db.Subject> _recents = [];

  List<local_db.Subject> get recents => _recents.reversed.toList();

  // void addToRecents(Subject subject) {
  //   if (_recents.any((recentSubject) => recentSubject.id == subject.id)) {
  //     final subjectIndex = _recents.indexWhere((sub) => sub.id == subject.id);
  //     _recents.removeAt(subjectIndex);
  //     _recents.add(subject);
  //     notifyListeners();
  //     return;
  //   }
  //   _recents.add(subject);
  //   notifyListeners();
  // }

  void addToRecentsDb(local_db.Subject subject) async {
    final isar = LocalDbController.instance;
    final recents = isar.collection<Recent>();
    final recent = Recent()
      ..id = subject.id
      ..subject.value = subject;

    if (_recents.any((recentSubject) => recentSubject.id == subject.id)) {
      final subjectIndex = _recents.indexWhere((sub) => sub.id == subject.id);
      _recents.removeAt(subjectIndex);
      await isar.writeTxn(() async {
        await recents.delete(subject.id!);
      });
      await isar.writeTxn(() async {
        await recents.put(recent);
        await recent.subject.save();
      });
      _recents.add(recent.subject.value!);
      notifyListeners();
      return;
    }

    await isar.writeTxn(() async {
      await recents.put(recent);
      await recent.subject.save();
    });
    _recents.add(recent.subject.value!);

    notifyListeners();
  }

  Future<void> retrieveRecentsFromDb() async {
    final isar = LocalDbController.instance;
    final recents = isar.collection<Recent>();

    final recentList = await recents.buildQuery(sortBy: const [
      SortProperty(property: "createdAt", sort: Sort.asc)
    ]).findAll();
    for (final recentSubject in recentList) {
      _recents.add(recentSubject.subject.value!);
    }
    notifyListeners();
  }

  void reset() async {
    final isar = LocalDbController.instance;
    final recents = isar.collection<Recent>();
    _recents.clear();
    await isar.writeTxn(() async {
      await recents.clear();
    });

    notifyListeners();
  }
}
