import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:gogotravel/app/modules/home/models/home_model.dart';
import 'package:gogotravel/app/modules/home/models/providers/home_remote_provider.dart';
import 'package:mocktail/mocktail.dart';
void main() {

  /// initiliaze mocks
  /// TODO: initialize mocks
  late HomeProvider provider;

   /// TODO: inject depencency
void  setupDepencency(){
  provider=HomeProvider();
}

/// setup 
setUpAll(() {
  setupDepencency()
;});

/// test api fetch data
  group('getPopularPlaces', () { 

    test('get popular should return [PopularPlaces] list on apiSuccess', () {

    /// TODO: write real use cases with mocking/real api data
    var result=  provider.getPopular();
     expect(result, isA<Future<Either<Failure, List<PopularPlaces>?>>>());
    });
  });

  ///
}

class MockClient extends Mock implements GetConnect {}