import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prepitpro/db/static_data.dart';
import 'package:prepitpro/helpers/db_init.dart';
import 'package:prepitpro/utils/subjects.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract final class ImageManager {
  static Future<String?> selectImage() async {
    try {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(source: ImageSource.gallery);
      if (pickedImage == null) {
        return null;
      }
      final filePath = pickedImage.path;
      return filePath;
    } catch (e) {
      rethrow;
    }
  }

  static Future<String> uploadPicture(
    String filePath,
  ) async {
    try {
      final user = DBInit.supabase.auth.currentUser!;
      final timestamp = DateTime.timestamp();
      File image = File(filePath);
      final imageUrl = await DBInit.supabase.storage.from("avatars").upload(
          "${user.id}/avatar.png", image,
          fileOptions: const FileOptions(
              cacheControl: "3600", upsert: true, contentType: "image/*"));
      final publicUrl =
          "https://fklxpasxcxkrkyhsiche.supabase.co/storage/v1/object/public/$imageUrl?timestamp$timestamp";
      return publicUrl;
    } catch (e) {
      rethrow;
    }
  }

  static Future<String> getImageUrl() async {
    try {
      final user = DBInit.supabase.auth.currentUser!;
      final imageUrl = DBInit.supabase.storage
          .from("avatars")
          .getPublicUrl("${user.id}/avatar.png");
      return imageUrl;
    } catch (e) {
      rethrow;
    }
  }
}

abstract final class UtilsFunctions {
  static String getUserClassFromID(int? classId) {
    if (classId == null) {
      return StaticData.userClass[0]["text"];
    }
    final userClass =
        StaticData.userClass.firstWhere((uc) => uc["id"] == classId);

    return userClass["text"];
  }

  static String getSubjectFromID(BuildContext context, int? subjectId) {
    final subject = context
        .read<ClassSubjects>()
        .subject
        .firstWhere((sub) => sub.id == subjectId);

    return subject.name!;
  }
}
