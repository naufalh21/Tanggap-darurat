import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tanggap_darurat/user/models/ulasan_ambulance_model.dart';
import 'package:tanggap_darurat/utils/baseurl.dart';


class UlasanAmbulanceController extends GetxController {
  var ulasanList = <UlasanAmbulance>[].obs;
  var isLoading = true.obs;

  void fetchUlasan(String idAmbulance) async {
    try {
      isLoading(true);
      var response = await http.get(Uri.parse(baseurl +'ambil_ulasan_ambulance.php?id_ambulance=$idAmbulance'));
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          var ulasanData = jsonResponse['data'] as List;
          ulasanList.value = ulasanData.map((ulasan) => UlasanAmbulance.fromJson(ulasan)).toList();
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
