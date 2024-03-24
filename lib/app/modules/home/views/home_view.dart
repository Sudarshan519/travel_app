import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:gogotravel/app/core/localization/l10n/strings.dart';
import 'package:gogotravel/app/data/color_extension.dart';
import 'package:gogotravel/app/modules/home/models/home_model.dart';
import 'package:gogotravel/app/routes/app_pages.dart';
import 'package:gogotravel/resources/resources.dart';

import '../controllers/home_controller.dart';

class AppColors {
  static TextStyle grey = GoogleFonts.rubik().copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: HexColor.fromHex("#242424").withOpacity(.5));
  static Color darkGrey = HexColor.fromHex("222222");
  static Color red = HexColor.fromHex("#FF678B");
}

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
          title: Text(strings.gogo, style: GoogleFonts.rubik(fontSize: 34)),
          centerTitle: false,
          actions: [
            IconButton(
                onPressed: () {},
                icon: Image.asset(AppIcons.map, height: 24, width: 24))
          ]),
      bottomNavigationBar: BottomNav(controller: controller),
      body: RefreshIndicator(
        onRefresh: () async => controller.getPopular(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: controller.obx(
              (state) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ChooseAnotherText(),
                      const SizedBox(height: 18),
                      SearchField(
                          searchController: searchController,
                          controller: controller),
                      const SizedBox(height: 18),
                      TitleWidget(
                        title: strings.category,
                      ),
                      const SizedBox(height: 12),
                      const CategoriesWidget(),
                      const SizedBox(height: 20),
                      TitleWidget(title: strings.popular),
                      const SizedBox(height: 12),
                      Obx(() => Popular(
                            state: controller.getDataByCategory ?? [],
                          )),
                    ],
                  ),

              /// TODO:// replace with custom loader
              onLoading: const Center(child: CircularProgressIndicator()),

              /// TODO:/// replace with error loader
              onError: (error) => Text(error ?? "Something went wrong")),
        ),
      ),
    );
  }
}

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        scrollDirection: Axis.horizontal,
        children: const [
          CategoryItem(
            icon: AppIcons.top30,
            label: "Top 30 places",
          ),
          CategoryItem(
            icon: AppIcons.nature,
            label: "Nature",
          ),
          CategoryItem(
            icon: AppIcons.food,
            label: "Food",
          ),
        ],
      ),
    );
  }
}

class TitleWidget extends StatelessWidget {
  const TitleWidget({
    super.key,
    required this.title,
  });
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(title,
          style: GoogleFonts.rubik(fontSize: 18, fontWeight: FontWeight.w500)),
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.searchController,
    required this.controller,
  });

  final TextEditingController searchController;
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: TypeAheadField<String>(
          hideOnEmpty: true,
          controller: searchController,
          emptyBuilder: (_) => const ListTile(
              title:
                  Text("No Previous search found with label.Click on search.")),
          builder: (_, controll, node) => TextField(
            focusNode: node,
            controller: controll,
            onChanged: (data) {
              controller.searchKey(data);
            },
            style: AppColors.grey.copyWith(fontSize: 15),
            decoration: InputDecoration(
              filled: true,
              hintStyle: AppColors.grey.copyWith(fontSize: 15),
              hintText: "Enter name or category ",
              fillColor: HexColor.fromHex("#F8F8F8"),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              suffixIconConstraints:
                  const BoxConstraints(maxHeight: 20, maxWidth: 40),
              suffixIcon: GestureDetector(
                onTap: () {
                  var searchplaces = controller.search();
                  Get.to(SearchPage(
                    results: searchplaces,
                    searchKey: controller.searchKey.value,
                  ));
                },
                child: Image.asset(
                  AppIcons.search,
                  height: 20,
                  width: 40,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent)),
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent)),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
            ),
          ),
          itemBuilder: (BuildContext context, value) {
            return ListTile(
              onTap: () {
                /// set key
                controller.searchKey(value);
                var searchplaces = controller.search();
                ///
                Get.to(SearchPage(
                  results: searchplaces,
                  searchKey: controller.searchKey.value,
                ));
              },
              title: Text(
                value,
              ),
            );
          },
          onSelected: (Object? value) {},
          suggestionsCallback: (String search) {
            /// search results in list
            return controller.getSuggestion(search);
         },
        ));
  }
}

class ChooseAnotherText extends StatelessWidget {
  const ChooseAnotherText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Text(
          strings.chose_another,
          style: AppColors.grey,
        ));
  }
}

class BottomNav extends StatelessWidget {
  const BottomNav({
    super.key,
    required this.controller,
  });

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: HexColor.fromHex("#F8F8F8"),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          NavItem(
            icon: AppIcons.main,
            controller: controller,
          ),
          NavItem(
            icon: AppIcons.liked,
            controller: controller,
          ),
          NavItem(
            icon: AppIcons.chat,
            controller: controller,
          ),
          NavItem(
            icon: AppIcons.settings,
            controller: controller,
          )
        ],
      ),
    );
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({
    super.key,
    required this.results,
    required this.searchKey,
  });
  final List<PopularPlaces> results;
  final String searchKey;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Search Result For $searchKey"),
        ),
        body: ListView.builder(
          itemBuilder: (_, i) => Text(results[i].name ?? ""),
          itemCount: results.length,
        ));
  }
}

class Popular extends StatefulWidget {
  const Popular({
    super.key,
    required this.state,
  });
  final List<PopularPlaces> state;

  @override
  State<Popular> createState() => _PopularState();
}

class _PopularState extends State<Popular> {
  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    final HomeController homeController = Get.find();

    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        homeController.getMorePopular();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();
    return SizedBox(
      height: 280,
      child: ListView.builder(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        scrollDirection: Axis.horizontal,
        itemCount: controller.status.isLoadingMore
            ? widget.state.length + 1
            : widget.state.length,
        itemBuilder: (context, index) => (widget.state.length == index)
            ?const Center(child: CircularProgressIndicator())
            : PopularItem(place: widget.state[index]),
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  const NavItem({
    super.key,
    required this.controller,
    required this.icon,
  });
  final String icon;

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    var index = 0;
    switch (icon) {
      case AppIcons.main:
        index = 0;

        break;
      case AppIcons.liked:
        index = 1;
        break;
      case AppIcons.chat:
        index = 2;
        break;
      case AppIcons.settings:
        index = 3;
        break;
      default:
    }
    return InkWell(
      onTap: () {
        controller.selectedIndex = index;
      },
      child: Obx(
        () => Container(
          height: 40,
          width: 40,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: controller.selectedIndex == index
                  ? HexColor.fromHex("#EB5757")
                  : Colors.transparent),
          child: Image.asset(
            icon,
            height: 24,
            width: 24,
            color: controller.selectedIndex == index
                ? Colors.white
                : Colors.grey.shade800,
          ),
        ),
      ),
    );
  }
}

class PopularItem extends StatelessWidget {
  const PopularItem({super.key, required this.place});
  final PopularPlaces place;
  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();

    return Hero(
      tag: place.image ?? "hero",
      child: Container(
        width: 212,
        height: 280,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
              image: AssetImage(place.image ?? "hero"), fit: BoxFit.cover),
        ),
        child: ClipRRect(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () {
                Get.toNamed(Routes.DETAIL, arguments: place);
              },
              child: Stack(children: [
                Positioned(
                  top: 12,
                  right: 12,
                  child: InkWell(
                    onTap: () {
                      if (controller.isPlaceFavourite(place)) {
                        controller.favourites
                            .removeWhere((item) => place.name == item.name);
                      } else {
                        controller.favourites.add(place);
                      }
                    },
                    child: Container(
                      height: 32,
                      width: 32,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                      child: Obx(
                        () => Icon(
                          controller.isPlaceFavourite(place)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: controller.isPlaceFavourite(place)
                              ? AppColors.red
                              : Colors.grey,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      width: 212,
                      height: 80,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            place.name ?? "NA",
                            style: GoogleFonts.rubik().copyWith(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            decoration: BoxDecoration(
                                color:
                                    HexColor.fromHex("#FFFFFF").withOpacity(.1),
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 13,
                                  color: Colors.orangeAccent,
                                ),
                                Text(
                                  place.rating ?? "",
                                  style: GoogleFonts.rubik().copyWith(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String label;
  final String icon;
  const CategoryItem({
    super.key,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();
    return InkWell(
      onTap: () {
        controller.selectedCategory(label);
      },
      child: Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: HexColor.fromHex("#F8F8F8"),
          ),
          child: Row(
            children: [
              Image.asset(icon, height: 36),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  label,
                  style: GoogleFonts.rubik().copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            ],
          )),
    );
  }
}
