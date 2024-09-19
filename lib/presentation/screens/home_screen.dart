import 'package:file_manager/core/constant/color.dart';
import 'package:file_manager/core/constant/imageasset.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';
import '../../data/models/file_model.dart';
import '../widgets/home_widgets/appbar/appbar_title.dart';
import '../widgets/home_widgets/appbar/drop_down_menu.dart';
import '../widgets/home_widgets/appbar/searchbar.dart';
import '../widgets/home_widgets/floating_action_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeControllerImp fileController = Get.put(HomeControllerImp());

    return Scaffold(
      appBar: AppBar(
        title: GetBuilder<HomeControllerImp>(
          builder: (appBarControl) {
            return appBarControl.isSearching
                ? const BuildSearchBar()
                : const AppbarTitle();
          },
        ),
        backgroundColor: AppColor.orangeFolder,
        actions: _buildAppBarActions(context),
      ),
      body: _buildBody(),
      floatingActionButton:
          BuildFloatingActionButton(controller: fileController),
    );
  }
}

List<Widget> _buildAppBarActions(BuildContext context) {
  return [
    GetBuilder<HomeControllerImp>(
      builder: (appBarActionController) {
        return appBarActionController.isSearching
            ? IconButton(
                onPressed: () {
                  appBarActionController.isSearching = false;
                  appBarActionController.searchEditingController.clear();
                  appBarActionController.update();
                },
                icon: const Icon(
                  Icons.close,
                  color: AppColor.blackColor,
                ),
              )
            : Row(
                children: [
                  IconButton(
                    onPressed: () {
                      appBarActionController.isSearching = true;
                      appBarActionController.update();
                    },
                    icon: const Icon(
                      Icons.search,
                      color: AppColor.blackColor,
                    ),
                  ),
                  BuildDropDownMenu(dropDownController: appBarActionController),
                  appBarActionController.currentDirectory ==
                          '/storage/emulated/0'
                      ? Container()
                      : IconButton(
                          icon: const Icon(Icons.post_add_sharp),
                          onPressed: () => _createNewFolderDialog(
                              context, appBarActionController),
                          color: AppColor.blackColor,
                        ),
                ],
              );
      },
    ),
  ];
}

Widget _buildBody() {
  return GetBuilder<HomeControllerImp>(
    builder: (controller) {
      return controller.files.isEmpty
          ? _noElementsFound()
          : _buildListViweBuilder(controller);
    },
  );
}

Widget _noElementsFound() {
  return const Center(
    child: Text(
      'No Elements Found !',
      style: TextStyle(
        color: AppColor.orangeFolder,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget _buildListViweBuilder(HomeControllerImp controller) {
  return ListView.builder(
    itemCount: controller.resultOfSearchList.isEmpty
        ? controller.files.length
        : controller.resultOfSearchList.length,
    itemBuilder: (context, index) {
      final file = controller.resultOfSearchList.isEmpty
          ? controller.files[index]
          : controller.resultOfSearchList[index];
      return _buildListTile(
        subTitle: '${file.lastModified}\n${file.size! * 0.000001} MB',
        isFolder: file.isFolder,
        file: file.fileType,
        title: file.name,
        onTap: () {
          file.isFolder ? controller.navigateToFolder(file) : _openFile(file);
        },
        onPressedDelete: () {
          _deleteFileOrFolder(file, controller);
          Get.back();
        },
      );
    },
  );
}

Widget _buildListTile({
  required String subTitle,
  required String title,
  required void Function() onTap,
  required void Function() onPressedDelete,
  required bool isFolder,
  required dynamic file,
}) {
  return Container(
    decoration: const BoxDecoration(
      border: Border(
        bottom: BorderSide(
          width: 0.2,
          color: AppColor.greyColor,
        ),
      ),
    ),
    child: ListTile(
      subtitle: Text(
        subTitle,
        style: const TextStyle(
          fontSize: 12,
        ),
      ),
      leading: isFolder
          ? Image.asset(
              AppImageAsset.folderImage,
              height: 40,
              width: 40,
            )
          : Image.asset(
              _getFileType(file),
              height: 40,
              width: 40,
            ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: onTap,
      trailing: GestureDetector(
        onTap: () {
          Get.defaultDialog(
            title: 'Delete',
            middleText: 'Sure Want Delete ?',
            confirm: ElevatedButton(
              onPressed: onPressedDelete,
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: AppColor.redColor,
                ),
              ),
            ),
          );
        },
        child: Image.asset(
          AppImageAsset.deleteImage,
          height: 25,
          width: 25,
        ),
      ),
    ),
  );
}

void _createNewFolderDialog(
    BuildContext context, HomeControllerImp controller) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Create New Folder'),
        content: Form(
          key: controller.formState,
          child: TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Cant Be Empty';
              }
              if (value.contains(RegExp('[<>:"/\\|?*]'))) {
                return "Cant Have a Character like this :\n ${controller.notValidInput}";
              }
              return 'Not Valid Input';
            },
            controller: controller.folderNameController,
            decoration: const InputDecoration(
              focusColor: AppColor.greenColor,
              hintText: "Folder Name",
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: AppColor.orangeFolder,
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: AppColor.white10,
                ),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (controller.formState.currentState!.validate()) {
                controller.createFolder(controller.folderNameController.text);
                Navigator.of(context).pop();
              }
            },
            child: const Text(
              'Create',
              style: TextStyle(
                color: AppColor.greenColor,
              ),
            ),
          ),
        ],
      );
    },
  );
}

void _deleteFileOrFolder(FileModel file, HomeControllerImp controller) {
  controller.deleteFileOrFolder(file);
}

void _openFile(FileModel file) {
  Get.snackbar('Info', 'Opening ${file.name}');
}

String _getFileType(MyFileType fileType) {
  switch (fileType) {
    case MyFileType.image:
      return AppImageAsset.pictureImage;
    case MyFileType.pdf:
      return AppImageAsset.fileImage;
    case MyFileType.other:
      return AppImageAsset.folderImage;
    case MyFileType.video:
      return AppImageAsset.videoImage;
  }
}
