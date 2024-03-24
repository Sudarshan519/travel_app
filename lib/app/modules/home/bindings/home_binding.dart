import 'package:get/get.dart';
import 'package:gogotravel/app/modules/home/models/providers/home_remote_provider.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeProvider());
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    
  }
}
