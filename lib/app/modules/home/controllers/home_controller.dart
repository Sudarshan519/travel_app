import 'dart:convert';

import 'package:get/get.dart';
import 'package:gogotravel/app/modules/home/models/home_model.dart';
import 'package:gogotravel/app/modules/home/models/providers/home_remote_provider.dart';
import 'package:gogotravel/app/modules/home/models/providers/local_data_proivder.dart';

class HomeController extends GetxController
    with StateMixin<List<PopularPlaces>> {
  /// provider
  final HomeProvider provider = Get.find();

  /// local data source
  final LocalDataProvider localDataProvider = Get.find();

  /// navigation index
  final _selectedIndex = 0.obs;

  /// getter for navigation
  int get selectedIndex => _selectedIndex.value;

  /// setter for navigation
  set selectedIndex(int value) => _selectedIndex(value);

  /// CHECK IF ITEMS ON LAST PAGE
  var isLast = false;

  /// MAX ITEMS TO RETURN IF CONTENT AVAILABLE
  /// SHOULD RETURN 3 ITEMS FOR PAGINATION
  var maxItemCount = 3;
  var page = 1;

  /// isSearching
  var isSearching = false.obs;
  var favourites = <PopularPlaces>[].obs;

  /// search controller
  var searchKey = "".obs;
  var searchData = <PopularPlaces>[].obs;
  var previousSearches = <String>[].obs;
  /// selected catgory
  var selectedCategory="Top 30 places".obs;
  List<PopularPlaces> get getDataByCategory=>state?.where((element) => element.category==selectedCategory.value).toList()??[];
  @override
  void onInit() {
    super.onInit();

    /// fetch api on init
    getPopular();
  }

  /// get popular items
  void getPopular() async {
    provider.getPopular().then(
      (data) {
        data.fold(

            /// on error
            (l) => change(null, status: RxStatus.error(l.error)),

            /// on success
            (r) => change(
                  r,
                  status: RxStatus.success(),
                ));
      },
    );
    await LocalDataProvider.localStorage.ready.then((value) {
      favourites(popularPlacesFromString(
          Get.find<LocalDataProvider>().getFavourites()));

      favourites.listen((favourites) {
        Get.find<LocalDataProvider>()
            .saveFavourite(popularPlacesListToJson(favourites));
      });
    });

    ///
    previousSearches(List<String>.from(
        jsonDecode(localDataProvider.getSearches()).map((e) => e.toString())));
  }

  /// favourites contains item
  bool isPlaceFavourite(place) {
    for (var element in favourites) {
      if (element.name == place.name) return true;
    }
    return false;
  }

  /// fetch more products
  void getMorePopular() {
    if (isLast) return;

    /// increment page number
    page = page + 1;
    change(state, status: RxStatus.loadingMore());
   
    provider.getMorePopular(page).then((data) {
      if (data!.length < maxItemCount) {
        isLast = true;
      }
      if (data.isNotEmpty == true) {
       state!.addAll(data);
        
          change(state, status: RxStatus.success());
      }
    });
  }



  void increment() => _selectedIndex.value++;
/// searching on loaded data
/// TODO: implement searching on api
  List<PopularPlaces> search() {
    if (!previousSearches.contains(searchKey.value)) {
      if (previousSearches.isNotEmpty && previousSearches.length > 3) {
        previousSearches.removeAt(0);
      }
      previousSearches.add(searchKey.value);
    }
    localDataProvider.saveSearch(jsonEncode(previousSearches));
    // return state!;
    return searchData(state!
        .where((PopularPlaces element) =>
            element.name!
                .toLowerCase()
                .contains(searchKey.value.toLowerCase()) ||
            (element.category?.toLowerCase() ?? "")
                .contains(searchKey.value.toLowerCase()))
        .toList());
  }

  List<String>? getSuggestion(String search) {
  return  previousSearches

                                  /// filter search results
                                  .where((element) => element
                                      .toLowerCase()
                                      .startsWith(search.toLowerCase()))
                                  .toList();
  }
}
