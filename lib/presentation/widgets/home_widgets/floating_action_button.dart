import 'package:file_manager/controllers/home_controller.dart';
import 'package:flutter/material.dart';

import '../../../core/constant/color.dart';

class BuildFloatingActionButton extends StatelessWidget {
  const BuildFloatingActionButton({super.key, required this.controller});
  final HomeControllerImp controller;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        if (controller.currentDirectory != '/') {
          controller.goBack();
        }
      },
      backgroundColor: AppColor.orangeFolder,
      child: const Icon(
        Icons.arrow_back,
        color: AppColor.blackColor,
      ),
    );
  }
}
