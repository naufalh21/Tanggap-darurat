import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:tanggap_darurat/user/models/damkar_model.dart';

import 'package:tanggap_darurat/utils/baseurl.dart';
import 'package:tanggap_darurat/utils/custom_snackbar.dart';

class DamkarController extends GetxController {
  var damkarList = <Damkar>[].obs;
  var filteredDamkar = <Damkar>[].obs; // For filtered list

  final picker = ImagePicker();
  var selectedImagePath = ''.obs;
  var selectedImageBase64 = ''.obs;
  var selectedImageSize = 0.obs; // Added to store image size

  var idDamkarController = TextEditingController();
  var namaDamkarController = TextEditingController();
  var noHpController = TextEditingController();
  var alamatController = TextEditingController();
  var linkMapsController = TextEditingController();
  var catatanController = TextEditingController();
  var searchController = TextEditingController(); // Search controller

  @override
  void onInit() {
    super.onInit();
    fetchDamkars();
    searchController.addListener(() {
      filterDamkars(searchController.text);
    });
  }

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final fileSize = await file.length();

      if (fileSize > 819200) { // 800 KB
        customSnackbar("Error", "Ukuran gambar harus kurang dari 800 KB", "error");
        return;
      }

      selectedImagePath.value = pickedFile.path;
      selectedImageSize.value = fileSize; // Update the selected image size
      selectedImagePath.value = pickedFile.path;
      selectedImageBase64.value =
          base64Encode(await File(pickedFile.path).readAsBytes());
    } else {
      customSnackbar("Error", "Image belum dipilih", "error");
      print('No image selected.');
    }
  }

  bool validateLinkMaps() {
    final linkMaps = linkMapsController.text;
    if (!linkMaps.startsWith('https://maps.app.goo.gl/')) {
      customSnackbar(
          "Error", "Link Maps harus berisi link yang valid", "error");
      return false;
    }
    return true;
  }

  Future<void> addDamkar() async {
    if (!validateLinkMaps()) {
      return;
    }
    final newDamkar = Damkar(
      idDamkar: '0', // Assume new ambulance ID is '0' or generate a new ID
      namaDamkar: namaDamkarController.text,
      noHp: noHpController.text,
      alamat: alamatController.text,
      linkMaps: linkMapsController.text,
      logo: selectedImageBase64.value,
      catatan: catatanController.text,
    );

    try {
      final response = await http.post(
        Uri.parse(baseurl + 'add_damkar.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(newDamkar.toJson()),
      );

      if (response.statusCode == 200) {
        var result;
        try {
          result = jsonDecode(response.body);
        } catch (e) {
          // print('Error decoding response body: ${response.body}');
          customSnackbar("Error", "Respon invalid dari server", "error");
          throw FormatException('Invalid JSON: ${response.body}');
        }

        if (result['status'] == 'success') {
          fetchDamkars(); // Refresh the list of Damkar
          print(
              'Added damkar with ID: ${newDamkar.idDamkar}'); // Debugging output
          // Clear controllers
          clearTextControllers();

          customSnackbar("Success", "Damkar berhasil ditambahkan", "success");
        } else {
          customSnackbar(
              "Error", result['message'] ?? "Failed to add ambulance", "error");
          print('Failed to add damkar: ${result['message']}');
        }
      } else {
        customSnackbar(
            "Error", "Server error: ${response.statusCode}", "error");
        print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      customSnackbar("Error", "Error occurred: $e", "error");
      print('Error occurred: $e');
    }
  }

  void fetchDamkars() async {
    try {
      final response = await http.get(Uri.parse(baseurl + 'read_damkar.php'));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          List<dynamic> damkars = data['data'];
          damkarList.assignAll(damkars.map((damkar) {
            try {
              return Damkar.fromJson(damkar);
            } catch (e) {
              print('Error parsing damkar data: $e');
              return Damkar(
                idDamkar: 'Unknown',
                namaDamkar: 'Unknown',
                noHp: 'Unknown',
                alamat: 'Unknown',
                linkMaps: 'Unknown',
                logo: 'Unknown',
                catatan: 'Unknown',
              );
            }
          }).toList());
          // print('Ambulances fetched successfully');
          filteredDamkar.assignAll(damkarList); // Initialize filtered list
          // customSnackbar("Success", "Damkar berhasil diperbarui", "success");
        } else {
          print('Failed to fetch Damkar: ${data['message']}');
        }
      } else {
        print('Failed to fetch Damkar');
      }
    } catch (e) {
      print('Error fetching Damkar: $e');
    }
  }

  Future<void> fetchDamkarDetail(String idDamkar) async {
    try {
      final response = await http.post(
        Uri.parse(baseurl + 'detail_damkar.php'),
        body: {'id_damkar': idDamkar},
      );

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        if (result['status'] == 'success') {
          var damkarData = result['data'];
          namaDamkarController.text = damkarData['nama_damkar'];
          noHpController.text = damkarData['no_hp'];
          alamatController.text = damkarData['alamat'];
          linkMapsController.text = damkarData['link_maps'];
          catatanController.text = damkarData['catatan'];

          // If logo exists, set selectedImagePath and selectedImageBase64
          if (damkarData.containsKey('logo')) {
            selectedImagePath.value = ''; // Clear previous selected image path
            selectedImageBase64.value = damkarData['logo'];
          } else {
            selectedImagePath.value = ''; // Clear previous selected image path
            selectedImageBase64.value = '';
          }
        } else {
          customSnackbar("Error", "Gagal menampilkan data terbaru", "error");
        }
      } else {
        customSnackbar(
            "Error", "Server error: ${response.statusCode}", "error");
      }
    } catch (e) {
      customSnackbar("Error", "Error occurred: $e", "error");
      print('Error fetching damkar detail: $e');
    }
  }

  void filterDamkars(String query) {
    if (query.isEmpty) {
      filteredDamkar.assignAll(damkarList);
    } else {
      filteredDamkar.assignAll(
        damkarList.where((damkar) =>
            damkar.namaDamkar.toLowerCase().contains(query.toLowerCase())),
      );
    }
  }

  Future<void> updateDamkar(String idDamkar) async {
    if (!validateLinkMaps()) {
      return;
    }
    try {
      var uri = Uri.parse(baseurl + 'update_damkar.php');
      var request = http.MultipartRequest('POST', uri);
      request.fields['id_damkar'] = idDamkar;
      request.fields['nama_damkar'] = namaDamkarController.text;
      request.fields['no_hp'] = noHpController.text;
      request.fields['alamat'] = alamatController.text;
      request.fields['link_maps'] = linkMapsController.text;
      request.fields['catatan'] = catatanController.text;

      if (selectedImageBase64.value.isNotEmpty) {
        // Add base64 encoded image to request
        request.fields['logo'] = selectedImageBase64.value;
      }

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(responseData);
        print(jsonResponse['respon']); // Print response from PHP

        // Fetch Damkaragain to update the list
        fetchDamkars();
        // Optionally navigate back or show success message
        customSnackbar("Success", "Berhasil update damkar", "success");
      } else {
        print('Failed to update damkar');
        // print(responseData); // Print detailed error message from PHP
        // Handle failure (e.g., show error message)
        Get.snackbar('Error', 'Failed to update damkar');
      }
    } catch (e) {
      print('Error updating damkar: $e');
      // Handle error
      Get.snackbar('Error', 'Error updating damkar: $e');
    }
  }

  void deleteDamkar(String id) async {
    // print('Attempting to delete damkar with id: $id');

    try {
      final response = await http.post(
        Uri.parse('${baseurl}delete_damkar.php'),
        body: {'id_damkar': id},
      );

      // print('Response status code: ${response.statusCode}');
      // print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['message'] == 'data berhasil di hapus') {
          // Sesuaikan dengan respons dari server
          print('Successfully deleted damkar with id: $id');
          damkarList.removeWhere(
              (damkar) => damkar.idDamkar == id); // Hapus dari list lokal
          fetchDamkars();
          customSnackbar("Success", "Damkar berhasil ditambahkan", "success");
        } else {
          customSnackbar("Error", "Damkar gagal ditambahkan", "error");
          // print('Failed to delete damkar: ${data['message']}');
        }
      } else {
        print('Failed to delete damkar: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while deleting damkar: $e');
    }
  }

  //   // Fetch comments
  // Future<void> fetchUlasanAmbulance(int idAmbulance) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse(baseurl + 'ambil_ulasan_ambulance.php'),
  //       body: {'id_ambulance': idAmbulance.toString()},
  //     );

  //     if (response.statusCode == 200) {
  //       var result = jsonDecode(response.body);
  //       if (result['success']) {
  //         List<dynamic> ulasan = result['ulasan'];
  //         ulasanList.assignAll(ulasan.map((ulasan) => Ulasan.fromJson(ulasan)).toList());
  //       } else {
  //         print('Failed to fetch comments: ${result['message']}');
  //       }
  //     } else {
  //       print('Failed to fetch comments: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error fetching comments: $e');
  //   }
  // }

  // Add comment
  Future<void> addUlasanAmbulance(
      int idDamkar, int idUser, String ulasan) async {
    try {
      final response = await http.post(
        Uri.parse(baseurl + 'ulasan_damkar.php'),
        body: jsonEncode({
          'id_ambulance': idDamkar,
          'id_user': idUser,
          'ulasan': ulasan,
        }),
      );

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        if (result['success']) {
          // fetchUlasanAmbulance(idAmbulance); // Refresh comments after adding
          print('Comment added successfully');
        } else {
          print('Failed to add comment: ${result['message']}');
        }
      } else {
        print('Failed to add comment: ${response.statusCode}');
      }
    } catch (e) {
      print('Error adding comment: $e');
    }
  }

  void clearTextControllers() {
    namaDamkarController.clear();
    noHpController.clear();
    alamatController.clear();
    linkMapsController.clear();
    catatanController.clear();
    selectedImagePath.value = '';
    selectedImageBase64.value = '';
  }

  @override
  void dispose() {
    // Clean up controllers
    namaDamkarController.dispose();
    noHpController.dispose();
    alamatController.dispose();
    linkMapsController.dispose();
    catatanController.dispose();
    super.dispose();
  }
}
