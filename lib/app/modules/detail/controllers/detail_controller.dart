import 'package:get/get.dart';
import 'package:gogotravel/app/modules/home/models/home_model.dart';

class DetailController extends GetxController {
  final PopularPlaces places = Get.arguments;

  var readMore = false.obs;
}
