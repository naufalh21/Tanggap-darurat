import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tanggap_darurat/utils/baseurl.dart';
import 'package:tanggap_darurat/utils/custom_snackbar.dart';
import 'package:tanggap_darurat/widgets/loader.dart';

class LoginController extends GetxController {
  late TextEditingController usernameController, passwordController;
  var isPasswordHidden = true.obs;

  @override
  void onInit() {
    super.onInit();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void onClose() {
    super.onClose();
    usernameController.dispose();
    passwordController.dispose();
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  checkLogin() {
    if (usernameController.text.isEmpty) {
      customSnackbar("Error", "Username perlu diisi", "error");
    } else if (passwordController.text.isEmpty) {
      customSnackbar("Error", "Password perlu diisi", "error");
    } else {
      Get.showOverlay(asyncFunction: () => _login(), loadingWidget: const loader());
    }
  }

  _login() async {
    try {
      print('Starting login process');
      print('Username: ${usernameController.text}');
      print('Password: ${passwordController.text}');

      var response = await http.post(Uri.parse(baseurl + 'login.php'),
          body: {
            "username": usernameController.text,
            "password": passwordController.text,
          });

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        print('Decoded response: $res');

        if (res['success']) {
          String level = res['level']; // Ambil nilai level dari respons
          String? username = res['username']; // Ambil username dari respons
          int? idUser = res['id_user']; // Ambil id_user dari respons

          if (username != null && idUser != null) {
            // Simpan id_user dan username di Shared Preferences
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('id_user', idUser.toString());
            await prefs.setString('username', username);

            print('ID User saved to SharedPreferences: $idUser');
            print('Username saved to SharedPreferences: $username');

            if (level == 'admin') {
              customSnackbar("Success", "Login berhasil sebagai Admin", "success");
              Get.offAllNamed('home_admin');
            } else if (level == 'adminAmbulance') {
              customSnackbar("Success", "Login berhasil sebagai Admin Ambulance", "success");
              Get.offAllNamed('admin_ambulance');
            } else if (level == 'adminDamkar') {
              customSnackbar("Success", "Login berhasil sebagai Admin Damkar", "success");
              Get.offAllNamed('admin_damkar');
            } else if (level == 'adminPolisi') {
              customSnackbar("Success", "Login berhasil sebagai Admin Polisi", "success");
              Get.offAllNamed('admin_polisi');
            } else if (level == 'user') {
              customSnackbar("Success", "Login berhasil sebagai User", "success");
              Get.offAllNamed('home');
            } else {
              customSnackbar("Error", "Level tidak valid", 'error');
            }
          } else {
            print('Error: Username or ID User is null');
            customSnackbar("Error", "Username tidak ditemukan", 'error');
          }
        } else {
          customSnackbar("Error", res['message'], 'error');
        }
      } else {
        customSnackbar("Error", "Server tidak merespon, coba lagi nanti", 'error');
      }
    } catch (e) {
      print('Exception caught: $e');
      customSnackbar("Error", "Tidak dapat terhubung ke server, periksa koneksi internet Anda", 'error');
    }
  }
}
