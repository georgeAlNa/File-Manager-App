import 'package:file_manager/presentation/screens/home_screen.dart';
import 'package:get/get.dart';
import 'core/constant/routes_name.dart';

List<GetPage<dynamic>>? routes = [
  GetPage(
    name: AppRoutes.home,
    page: () => const HomeScreen(),
  ),
];
