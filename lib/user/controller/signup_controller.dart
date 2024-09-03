import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tanggap_darurat/utils/baseurl.dart';
import 'package:tanggap_darurat/utils/custom_snackbar.dart';
import 'package:tanggap_darurat/widgets/loader.dart';
import 'package:http/http.dart' as http;

class SignupController extends GetxController {
  late TextEditingController usernameController,
      emailController,
      passwordController;
      var isPasswordHidden = true.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    usernameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  checkSignup() {
    if (usernameController.text.isEmpty) {
      customSnackbar("Error", "Username perlu diisi", "error");
    } else if (emailController.text.isEmpty ||
        GetUtils.isEmail(emailController.text) == false) {
      customSnackbar("Error", "Diperlukan Email yang benar", "error");
    } else if (passwordController.text.isEmpty) {
      customSnackbar("Error", "Password perlu diisi", "error");
    } else {
      Get.showOverlay(
          asyncFunction: () => _signup(), loadingWidget: const loader());
    }
  }

  _signup() async {
    try {
      var response = await http.post(Uri.parse(baseurl + 'signup.php'), body: {
        "username": usernameController.text,
        "email": emailController.text,
        "password": passwordController.text,
      });

      if (response.statusCode == 200) {
        var res = await jsonDecode(response.body);

        if (res['success']) {
          customSnackbar("Success", res['message'], "success");
          Get.toNamed('login');
        } else {
          customSnackbar("Error", res['message'], 'error');
        }
      } else {
        customSnackbar(
            "Error", "Server tidak merespon, coba lagi nanti", 'error');
      }
    } catch (e) {
      customSnackbar(
          "Error",
          "Tidak dapat terhubung ke server, periksa koneksi internet Anda",
          'error');
    }
  }
}
