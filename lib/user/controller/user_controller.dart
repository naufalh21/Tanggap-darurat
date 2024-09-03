import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:tanggap_darurat/utils/baseurl.dart';

class ProfileController extends GetxController {
  var username = ''.obs;
  var idUser = ''.obs;
  var foto = ''.obs; // Variable to hold the profile picture

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  void loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username.value = prefs.getString('username') ?? 'Guest';
    idUser.value = prefs.getString('id_user') ?? '1';
    
    // Fetch user data from the server
    var response = await http.post(
      Uri.parse(baseurl + 'ambil_user_data.php'),
      body: {
        'id_user': idUser.value,
      },
    );

    var result = json.decode(response.body);
    if (result['status'] == 'success') {
      foto.value = result['foto'] ?? '';
      await prefs.setString('foto', foto.value);
    }
  }

  Future<void> updateUsername(String newUsername) async {
    var response = await http.post(
      Uri.parse(baseurl + 'update_username.php'),
      body: {
        'id_user': idUser.value,
        'username': newUsername,
      },
    );

    var result = json.decode(response.body);
    if (result['status'] == 'success') {
      username.value = newUsername;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', newUsername);
      Get.snackbar('Success', 'Username updated successfully');
    } else {
      Get.snackbar('Error', result['message']);
    }
  }

  Future<void> uploadPhoto(File photoFile) async {
    String base64Photo = base64Encode(await photoFile.readAsBytes());
    
    var response = await http.post(
      Uri.parse(baseurl + 'upload_foto.php'),
      body: {
        'id_user': idUser.value,
        'foto': base64Photo,
      },
    );

    var result = json.decode(response.body);
    if (result['status'] == 'success') {
      foto.value = base64Photo;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('foto', base64Photo);
      Get.snackbar('Success', 'Profile photo uploaded successfully');
    } else {
      Get.snackbar('Error', result['message']);
    }
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAllNamed('login');
  }
}
