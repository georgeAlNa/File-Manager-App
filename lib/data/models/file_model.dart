import 'dart:io';

enum MyFileType { image, pdf, video, other }

class FileModel {
  final String name;
  final String path;
  final bool isFolder;
  final int? size;
  final DateTime? lastModified;
  final MyFileType fileType;

  FileModel({
    required this.name,
    required this.path,
    required this.isFolder,
    this.size,
    this.lastModified,
    required this.fileType,
  });

  static MyFileType getFileType(String fileName) {
    if (fileName.endsWith('.jpg') ||
        fileName.endsWith('.jpeg') ||
        fileName.endsWith('.png') ||
        fileName.endsWith('.gif')) {
      return MyFileType.image;
    } else if (fileName.endsWith('.pdf')) {
      return MyFileType.pdf;
    } else if (fileName.endsWith('.mp4') ||
        fileName.endsWith('.m4p') ||
        fileName.endsWith('.mov') ||
        fileName.endsWith('.webm') ||
        fileName.endsWith('.mkv') ||
        fileName.endsWith('.gif')) {
      return MyFileType.video;
    } else {
      return MyFileType.other;
    }
  }

  static FileModel fromFileSystemEntity(FileSystemEntity entity) {
    var stat = entity.statSync();
    var fileName = entity.path.split('/').last;
    return FileModel(
      name: fileName,
      path: entity.path,
      isFolder: entity is Directory,
      size: stat.size,
      lastModified: stat.modified,
      fileType: entity is File ? getFileType(fileName) : MyFileType.other,
    );
  }
}
