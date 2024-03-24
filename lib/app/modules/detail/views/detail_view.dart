import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:gogotravel/app/data/color_extension.dart';
import 'package:gogotravel/app/modules/home/controllers/home_controller.dart';
import 'package:gogotravel/app/modules/home/views/home_view.dart';
import 'package:gogotravel/resources/resources.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/detail_controller.dart';

class DetailView extends GetView<DetailController> {
  const DetailView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find();
    return Scaffold(
        body: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImagPreview(controller: controller),
          FavouriteButton(
              homeController: homeController, controller: controller),
          TitleWidet(controller: controller),
          const SizedBox(height: 18),
          DescriptionWidget(controller: controller),
          ReadMoreButton(controller: controller),
          const SizedBox(height: 18),
          ServicesWidget(controller: controller),
          const SizedBox(
            height: 18,
          ),
          const BuyButton()
        ],
      ),
    ));
  }
}

class BuyButton extends StatelessWidget {
  const BuyButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: HexColor.fromHex("#FF678B")),
        onPressed: () {},
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text("Buy a tour", style: TextStyle(color: Colors.white)),
          const SizedBox(width: 4),
          Image.asset(
            AppIcons.arrow,
            width: 20,
          )
        ]),
      ),
    );
  }
}

class ServicesWidget extends StatelessWidget {
  const ServicesWidget({
    super.key,
    required this.controller,
  });

  final DetailController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: controller.places.services!
            .map((item) => InfoDetail(
                  image: item.image ?? Images.ellipse2,
                  label: item.label ?? "",
                ))
            .toList(),
      ),
    );
  }
}

class ReadMoreButton extends StatelessWidget {
  const ReadMoreButton({
    super.key,
    required this.controller,
  });

  final DetailController controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.readMore(!controller.readMore.value);
      },
      child: Obx(
        () => Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(
            !controller.readMore.value ? "Read more" : "Read Less",
            style: GoogleFonts.rubik().copyWith(
              fontSize: 15,
              color: AppColors.red,
              fontWeight: FontWeight.w400,
            ),
          ),
          Icon(
            !controller.readMore.value
                ? Icons.expand_more
                : Icons.expand_less,
            size: 20,
            color: AppColors.red,
          )
        ]),
      ),
    );
  }
}

class DescriptionWidget extends StatelessWidget {
  const DescriptionWidget({
    super.key,
    required this.controller,
  });

  final DetailController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => !controller.readMore.value
          ? Text(
              controller.places.desc ?? "",
              textAlign: TextAlign.justify,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.rubik().copyWith(
                fontSize: 15,
                color: AppColors.darkGrey,
                fontWeight: FontWeight.w400,
              ),
            )
          : Text(
              controller.places.desc ?? "",
              textAlign: TextAlign.justify,
              style: GoogleFonts.rubik().copyWith(
                fontSize: 15,
                color: AppColors.darkGrey,
                fontWeight: FontWeight.w400,
              ),
            ),
    );
  }
}

class TitleWidet extends StatelessWidget {
  const TitleWidet({
    super.key,
    required this.controller,
  });

  final DetailController controller;

  @override
  Widget build(BuildContext context) {
    return Text(controller.places.name ?? "",
        style: GoogleFonts.rubik(fontSize: 18, fontWeight: FontWeight.w500));
  }
}

class FavouriteButton extends StatelessWidget {
  const FavouriteButton({
    super.key,
    required this.homeController,
    required this.controller,
  });

  final HomeController homeController;
  final DetailController controller;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(Get.width - 90, -16),
      child: Container(
          height: 32,
          width: 32,
          decoration: const BoxDecoration(
              boxShadow: [BoxShadow(color: Colors.grey)],
              shape: BoxShape.circle,
              color: Colors.white),
          child: InkWell(
            onTap: () {
              if (homeController.isPlaceFavourite(controller.places)) {
                homeController.favourites
                    .removeWhere((item) => controller.places.name == item.name);
              } else {
                homeController.favourites.add(controller.places);
              }
            },
            child: Obx(
              () => Icon(
                homeController.isPlaceFavourite(controller.places)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: homeController.isPlaceFavourite(controller.places)
                    ? AppColors.red
                    : Colors.grey,
                size: 20,
              ),
            ),
          )),
    );
  }
}

class ImagPreview extends StatelessWidget {
  const ImagPreview({
    super.key,
    required this.controller,
  });

  final DetailController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 397,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(34),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Hero(
          tag: controller.places.image ??

              /// placeholder
              Images.shulgaTashcave,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(34),
            child: Stack(
              children: [
                Image.asset(
                  controller.places.image ?? Images.shulgaTashcave,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 397,
                ),
                Positioned(
                    top: 18,
                    left: 18,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => Get.back(),
                        child: Image.asset(
                          AppIcons.back,
                          height: 32,
                          width: 32,
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ));
  }
}

class InfoDetail extends StatelessWidget {
  final String image;
  final String label;
  const InfoDetail({
    super.key,
    required this.image,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92,
      width: 80,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: HexColor.fromHex("#F8F8F8"),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            image,
            height: 36,
          ),
          Text(label,
              style: GoogleFonts.rubik().copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: HexColor.fromHex("#222222").withOpacity(.5)))
        ],
      ),
    );
  }
}
