import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:get/get.dart';

import 'package:gogotravel/app/data/mock_data.dart';

import '../home_model.dart';

class Failure {
  int code;
  String error;
  Failure({
    required this.code,
    required this.error,
  });
}

class HomeProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return PopularPlaces.fromJson(map);
      if (map is List) {
        return map.map((item) => PopularPlaces.fromJson(item)).toList();
      }
    };
    /// TODO:
    httpClient.baseUrl = 'https://YOUR-API-URL';
  }

  /// api mock with error codes
  Future<Either<Failure, List<PopularPlaces>?>> getHome(int id) async {
    final response = await get('home/$id');
    if (response.statusCode == 200) {
      return Right(response.body);
    }

    /// check cases for socket exception and provide custom message
    else if (response.statusCode == null) {
      return Left(Failure(
          code: 422, error: response.statusText ?? "Something went wrong"));
    }

    /// handle error codes
    else {
      return Left(Failure(
          code: response.statusCode ?? 422,
          error: response.bodyString ?? "Something went wrong"));
    }
  }

  /// get popular items
  Future<Either<Failure, List<PopularPlaces>?>> getPopular() async {
    await Future.delayed(3.seconds);

    return Right(
        popularItems.map((item) => PopularPlaces.fromJson(item)).toList());
  }

  /// get more popular items
  Future<List<PopularPlaces>?> getMorePopular(page) async {
    await Future.delayed(3.seconds);
     return (
        popularItems.map((item) => PopularPlaces.fromJson(item)).toList());
    final response = await File("test/data/more_popular.json").readAsString();
    
    return List<PopularPlaces>.from(jsonDecode(response)
        .map((item) => PopularPlaces.fromJson(item))
        .toList());
  }

  /// get popular items
  Future<Either<Failure, List<PopularPlaces>?>> searchPopularPlace(data) async {
    await Future.delayed(3.seconds);

    return Right(
        popularItems.map((item) => PopularPlaces.fromJson(item)).toList());
  }

  Future<Response<PopularPlaces>> postHome(PopularPlaces home) async =>
      await post('home', home);
  Future<Response> deleteHome(int id) async => await delete('home/$id');
}
