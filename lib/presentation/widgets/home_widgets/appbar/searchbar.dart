import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/home_controller.dart';
import '../../../../core/constant/color.dart';

class BuildSearchBar extends StatelessWidget {
  const BuildSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeControllerImp>(
      builder: (searchController) {
        return Wrap(
          children: [
            TextField(
              onChanged: (searchValue) {
                searchController.addSearchForFileToSearchList(searchValue);
              },
              controller: searchController.searchEditingController,
              decoration: const InputDecoration(
                labelText: "Search",
                labelStyle: TextStyle(
                  color: AppColor.black54Color,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
