import 'package:flutter/material.dart';

import '../../../../controllers/home_controller.dart';
import '../../../../core/constant/color.dart';

class BuildDropDownMenu extends StatelessWidget {
  const BuildDropDownMenu({super.key, required this.dropDownController});
  final HomeControllerImp dropDownController;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<SortOptions>(
      dropdownColor: AppColor.orangeAddToCartColor,
      value: dropDownController.sortOption,
      padding: const EdgeInsets.all(8),
      icon: const Icon(
        Icons.arrow_drop_down,
        color: AppColor.blackColor,
      ),
      items: const [
        DropdownMenuItem<SortOptions>(
          value: SortOptions.name,
          child: Text(
            'Name',
            style: TextStyle(
              fontSize: 12,
              color: AppColor.blackColor,
            ),
          ),
        ),
        DropdownMenuItem<SortOptions>(
          value: SortOptions.size,
          child: Text(
            'Size',
            style: TextStyle(
              fontSize: 12,
              color: AppColor.blackColor,
            ),
          ),
        ),
        DropdownMenuItem<SortOptions>(
          value: SortOptions.date,
          child: Text(
            'Date',
            style: TextStyle(
              fontSize: 12,
              color: AppColor.blackColor,
            ),
          ),
        ),
      ],
      onChanged: (SortOptions? value) {
        if (value != null) {
          dropDownController.setSortOption(value);
        }
      },
    );
  }
}
