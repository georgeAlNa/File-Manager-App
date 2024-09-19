import 'package:file_manager/presentation/screens/home_screen.dart';
import 'package:file_manager/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FileManagerApp());
}

class FileManagerApp extends StatelessWidget {
  const FileManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
      getPages: routes,
      theme: ThemeData.dark(),
    );
  }
}
