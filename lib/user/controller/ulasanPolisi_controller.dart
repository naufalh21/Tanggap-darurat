import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tanggap_darurat/user/models/ulasan_polisi_model.dart';
import 'dart:convert';

import 'package:tanggap_darurat/utils/baseurl.dart';


class UlasanPolisiController extends GetxController {
  var ulasanList = <UlasanPolisi>[].obs;
  var isLoading = true.obs;

  void fetchUlasan(String idPolisi) async {
    try {
      isLoading(true);
      var response = await http.get(Uri.parse(baseurl +'ambil_ulasan_polisi.php?id_polisi=$idPolisi'));
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          var ulasanData = jsonResponse['data'] as List;
          ulasanList.value = ulasanData.map((ulasan) => UlasanPolisi.fromJson(ulasan)).toList();
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
