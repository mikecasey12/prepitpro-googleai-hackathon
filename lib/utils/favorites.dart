import 'package:flutter/material.dart';
import 'package:prepitpro/db/schema/subjects.dart' as local_db;
import 'package:prepitpro/helpers/db_init.dart';
import 'package:prepitpro/models/favorites.dart';
// import 'package:prepitpro/models/subject.dart';

class FavoritesManager with ChangeNotifier {
  List<Favorites> _favorites = [];

  List<Favorites> get favorites => _favorites;

  bool _isFavoriteSubject = false;
  bool get isFavoriteSubject => _isFavoriteSubject;

  Future<void> retrieveUserFavorites(String userId, int classId) async {
    try {
      final List<Favorites> favList = [];
      final List<Map<String, dynamic>> response = await DBInit.supabase
          .from("favorites")
          .select("*")
          .eq("user_id", userId)
          .eq("class_id", classId);

      for (final userFav in response) {
        final fav = Favorites(
            class_id: userFav["class_id"].toString(),
            id: userFav["id"].toString(),
            subject_id: userFav["subject_id"],
            subject_name: userFav["subject_name"],
            subject_image: userFav["subject_image"],
            color: userFav["subject_color"]);
        favList.add(fav);
      }
      _favorites = favList;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addFavorite(
      String userId, local_db.Subject subject, int classId) async {
    await DBInit.supabase.from("favorites").upsert({
      "subject_id": subject.id,
      "class_id": classId,
      "subject_name": subject.name,
      "subject_image": subject.coverImage,
      "subject_color": subject.color
    }, onConflict: "user_id,subject_id");
    await retrieveUserFavorites(userId, classId);
    isFavorite(subject.id!);
  }

  Future<void> removeFavorite(
      String userId, local_db.Subject subject, int classId) async {
    await DBInit.supabase
        .from("favorites")
        .delete()
        .eq('user_id', userId)
        .eq("subject_id", subject.id!);
    await retrieveUserFavorites(userId, classId);
    isFavorite(subject.id!);
  }

  void isFavorite(int subjectId) {
    final value = _favorites.any((favSub) => favSub.subject_id == subjectId);
    _isFavoriteSubject = value;
    notifyListeners();
  }
}
