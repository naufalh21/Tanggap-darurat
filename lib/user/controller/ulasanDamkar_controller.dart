import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tanggap_darurat/user/models/ulasan_damkar_model.dart';
import 'dart:convert';

import 'package:tanggap_darurat/utils/baseurl.dart';


class UlasanDamkarController extends GetxController {
  var ulasanList = <UlasanDamkar>[].obs;
  var isLoading = true.obs;

  void fetchUlasan(String idDamkar) async {
    try {
      isLoading(true);
      var response = await http.get(Uri.parse(baseurl +'ambil_ulasan_damkar.php?id_damkar=$idDamkar'));
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          var ulasanData = jsonResponse['data'] as List;
          ulasanList.value = ulasanData.map((ulasan) => UlasanDamkar.fromJson(ulasan)).toList();
        } else {
          Get.snackbar('Error', jsonResponse['message']);
        }
      } else {
        Get.snackbar('Error', 'Failed to fetch data');
      }
    } finally {
      isLoading(false);
    }
  }
}
