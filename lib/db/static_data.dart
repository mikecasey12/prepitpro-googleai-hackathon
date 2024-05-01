import 'package:flutter/material.dart';

abstract final class StaticData {
  static const List<Map<String, dynamic>> userClass = [
    {"id": 6, "text": "JSS1"},
    {"id": 5, "text": "JSS2"},
    {"id": 4, "text": "JSS3"},
    {"id": 3, "text": "SS1"},
    {"id": 2, "text": "SS2"},
    {"id": 1, "text": "SS3"},
  ];

  static const List<Map<String, Object>> settingsOptions = [
    {
      "id": "1",
      "icon": Icons.menu_book_outlined,
      "link": "/test",
      "name": "Practice - Test",
    },
    {
      "id": "2",
      "icon": Icons.menu_book_outlined,
      "link": "/all-subjects",
      "name": "Subjects",
    },
    {
      "id": "3",
      "icon": Icons.percent,
      "link": "/performance",
      "name": "Performance",
    },
    {
      "id": "4",
      "icon": Icons.favorite,
      "link": "/favorites",
      "name": "Favorites",
    },
  ];

  static String defaultImage =
      "https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-website-design-mobile-app-no-photo-available_87543-11093.jpg";
}
