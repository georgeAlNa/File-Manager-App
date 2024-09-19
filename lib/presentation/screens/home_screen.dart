import 'package:file_manager/core/constant/color.dart';
import 'package:file_manager/core/constant/imageasset.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';
import '../../data/models/file_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeControllerImp fileController = Get.put(HomeControllerImp());

    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(fileController),
    );
  }
}

AppBar _buildAppBar(BuildContext context) {
  return AppBar(
    title: GetBuilder<HomeControllerImp>(
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
    ),
    backgroundColor: AppColor.orangeFolder,
    actions: [
      GetBuilder<HomeControllerImp>(
        builder: (dropDownController) {
          return _buildDropDownMenu(dropDownController);
        },
      ),
      GetBuilder<HomeControllerImp>(
        builder: (con) {
          return con.currentDirectory == '/storage/emulated/0'
              ? Container()
              : IconButton(
                  icon: const Icon(Icons.post_add_sharp),
                  onPressed: () => _createNewFolderDialog(context, con),
                  color: AppColor.blackColor,
                );
        },
      ),
    ],
  );
}

Widget _buildDropDownMenu(HomeControllerImp dropDownController) {
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

Widget _buildBody() {
  return GetBuilder<HomeControllerImp>(
    builder: (controller) {
      return controller.files.isEmpty
          ? _noElementsFound()
          : _buildListViweBuilder(controller);
    },
  );
}

Widget _buildFloatingActionButton(HomeControllerImp controller) {
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
    itemCount: controller.files.length,
    itemBuilder: (context, index) {
      final file = controller.files[index];
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
  final TextEditingController folderNameController = TextEditingController();

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
            controller: folderNameController,
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
                controller.createFolder(folderNameController.text);
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
