import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../../controllers/home_controller.dart';
import '../../../../core/constant/color.dart';

class AppbarTitle extends StatelessWidget {
  const AppbarTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeControllerImp>(
      builder: (appBarController) => Text(
        appBarController.currentDirectory == '/storage/emulated/0'
            ? 'Device Storage'
            : appBarController.currentDirectory,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColor.blackColor,
        ),
      ),
    );
  }
}
