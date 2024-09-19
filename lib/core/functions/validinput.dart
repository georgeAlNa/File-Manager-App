import 'package:get/get.dart';

validInput(String val, int min, int max, String type) {
  if (type == 'username') {
    if (!GetUtils.isUsername(val)) {
      return '49'.tr;
    }
  }
  if (type == 'email') {
    if (!GetUtils.isEmail(val)) {
      return '50'.tr;
    }
  }

  if (type == 'phone') {
    if (!GetUtils.isPhoneNumber(val)) {
      return '51'.tr;
    }
  }

  // if (type == 'video') {
  //   if (!GetUtils.isVideo(val)) {
  //     return 'Must  be a video file';
  //   }
  // }

  if (val.isEmpty) {
    return '52'.tr;
  }

  if (val.length < min) {
    return '53 $min'.tr;
  }

  if (val.length > max) {
    return '54 $max'.tr;
  }
}
