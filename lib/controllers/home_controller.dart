import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../data/models/file_model.dart';

abstract class HomeController extends GetxController {
  Future<void> requestPermissions();
  Future<void> loadInitialDirectory();
  void loadFiles(String path);
  void sortFile();
  void setSortOption(SortOptions newOption);
  void navigateToFolder(FileModel folder);
  void goBack();
  Future<void> createFolder(String folderName);
  Future<void> deleteFileOrFolder(FileModel item);
}

enum SortOptions { name, size, date }

class HomeControllerImp extends HomeController {
  String currentDirectory = '';
  List<FileModel> files = [];
  var sortOption = SortOptions.name;
  final GlobalKey<FormState> formState = GlobalKey<FormState>();
  String notValidInput = "'[<>:\"/\\|?*]'";

  @override
  void onInit() {
    super.onInit();
    requestPermissions();
  }

  @override
  requestPermissions() async {
    var status = await Permission.storage.status;

    if (!status.isGranted) {
      await Permission.storage.request();
      if (kDebugMode) {
        print('Permission stattus : $status');
      }
    }

    if (await Permission.storage.isGranted) {
      loadInitialDirectory();
      update();
      if (kDebugMode) {
        print('Permission stattus : $status');
      }
    } else {
      Get.snackbar(
          'Permission Denied', 'Storage access is required to use this app.');
    }
  }

  @override
  Future<void> loadInitialDirectory() async {
    Directory? dir = Directory('/storage/emulated/0');
    if (dir.existsSync()) {
      currentDirectory = dir.path;
      loadFiles(dir.path);
      update();
      if (kDebugMode) {
        print('Dir Path : ${dir.path}');
      }
    } else {
      Get.snackbar('Error', 'External storage not found.');
    }
  }

  @override
  loadFiles(path) {
    try {
      var dir = Directory(path);
      List<FileSystemEntity> entities = dir.listSync();
      files = entities.map((e) => FileModel.fromFileSystemEntity(e)).toList();
      sortFile();
      update();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load files. Error: $e');
    }
  }

  @override
  void sortFile() {
    switch (sortOption) {
      case SortOptions.name:
        files.sort((a, b) => a.name.compareTo(b.name));
        break;

      case SortOptions.size:
        files.sort((a, b) => (a.size ?? 0).compareTo(b.size ?? 0));
        break;

      case SortOptions.date:
        files.sort((a, b) => (a.lastModified ?? DateTime.now())
            .compareTo(b.lastModified ?? DateTime.now()));
        break;
    }
  }

  @override
  void setSortOption(newOption) {
    sortOption = newOption;
    sortFile();
    update();
  }

  @override
  navigateToFolder(folder) {
    if (folder.isFolder) {
      currentDirectory = folder.path;
      if (kDebugMode) {
        print('Folder Path : ${folder.path}');
      }
      loadFiles(folder.path);
      update();
    }
  }

  @override
  goBack() {
    Directory dir = Directory(currentDirectory);
    var parentDir = dir.parent;
    currentDirectory = parentDir.path;
    if (kDebugMode) {
      print('Parent Path : ${parentDir.path}');
    }
    loadFiles(parentDir.path);
    update();
  }

  @override
  createFolder(folderName) async {
    var newFolderPath = Directory('$currentDirectory/$folderName');
    if (!newFolderPath.existsSync()) {
      await newFolderPath.create();
      if (kDebugMode) {
        print('New Folder Path : $newFolderPath');
      }
      loadFiles(currentDirectory);
      update();
    } else {
      Get.snackbar('Error', 'Folder already exists.');
    }
  }

  @override
  deleteFileOrFolder(item) async {
    try {
      if (item.isFolder) {
        Directory(item.path).deleteSync(recursive: true);
        if (kDebugMode) {
          print('Item Path : ${item.path}');
        }
      } else {
        File(item.path).deleteSync();
        if (kDebugMode) {
          print('Item Path : ${item.path}');
        }
      }
      loadFiles(currentDirectory);
      update();
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete. Error: $e');
    }
  }
}
