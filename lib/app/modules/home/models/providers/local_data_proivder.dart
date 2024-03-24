import 'dart:convert';

import 'package:localstorage/localstorage.dart';

abstract class LocalDataSource {
  void saveFavourite(String key);
  String getFavourites();
  void saveSearch(String key);
  String getSearches();
}

class LocalDataProvider implements LocalDataSource {
  static LocalStorage localStorage = LocalStorage('db.json');

  @override
  String getFavourites() => localStorage.getItem("favourite") ?? jsonEncode([]);

  @override
  void saveFavourite(String data) => localStorage.setItem("favourite", data);

  @override
  String getSearches() => localStorage.getItem("searches") ?? jsonEncode([]);

  @override
  void saveSearch(String data) => localStorage.setItem("searches", data);
}
