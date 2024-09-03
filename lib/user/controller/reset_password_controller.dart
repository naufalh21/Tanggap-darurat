import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tanggap_darurat/utils/baseurl.dart';

class ResetPasswordController extends GetxController {
  final token = ''.obs;
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Future<void> resetPassword(String token, String newPassword) async {
    final response = await http.post(
      Uri.parse(baseurl + 'reset_password.php'),
      body: {
        'token': token,
        'new_password': newPassword,
      },
    );

    if (response.statusCode == 200) {
      Get.snackbar('Success', 'Password has been reset successfully.', snackPosition: SnackPosition.BOTTOM);
      Get.offNamed('/login');
    } else {
      Get.snackbar('Error', 'Failed to reset password.', snackPosition: SnackPosition.BOTTOM);
    }
  }
}
