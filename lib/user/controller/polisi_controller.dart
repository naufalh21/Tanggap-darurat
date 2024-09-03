import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:tanggap_darurat/user/models/polisi_model.dart';
import 'package:tanggap_darurat/utils/baseurl.dart';
import 'package:tanggap_darurat/utils/custom_snackbar.dart';

class PolisiController extends GetxController {
  var polisiList = <Polisi>[].obs;
  var filteredPolisis = <Polisi>[].obs; // For filtered list

  final picker = ImagePicker();
  var selectedImagePath = ''.obs;
  var selectedImageBase64 = ''.obs;
  var selectedImageSize = 0.obs; // Added to store image size

  var idPolisiController = TextEditingController();
  var namaPolisiController = TextEditingController();
  var noHpController = TextEditingController();
  var alamatController = TextEditingController();
  var linkMapsController = TextEditingController();
  var catatanController = TextEditingController();
  var searchController = TextEditingController(); // Search controller

  @override
  void onInit() {
    super.onInit();
    fetchPolisis();
    searchController.addListener(() {
      filterPolisis(searchController.text);
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

  Future<void> addPolisi() async {
    if (!validateLinkMaps()) {
      return;
    }
    final newPolisi = Polisi(
      idPolisi: '0', // Assume new polisi ID is '0' or generate a new ID
      namaPolisi: namaPolisiController.text,
      noHp: noHpController.text,
      alamat: alamatController.text,
      linkMaps: linkMapsController.text,
      logo: selectedImageBase64.value,
      catatan: catatanController.text,
    );

    try {
      final response = await http.post(
        Uri.parse(baseurl + 'add_polisi.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(newPolisi.toJson()),
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
          fetchPolisis(); // Refresh the list of ambulances
          print(
              'Added Polisi with ID: ${newPolisi.idPolisi}'); // Debugging output
          // Clear controllers
          clearTextControllers();

          customSnackbar("Success", "Polisi berhasil ditambahkan", "success");
        } else {
          customSnackbar(
              "Error", result['message'] ?? "Failed to add polisi", "error");
          print('Failed to add polisi: ${result['message']}');
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

  void fetchPolisis() async {
    try {
      final response = await http.get(Uri.parse(baseurl + 'read_polisi.php'));

      if (response.statusCode == 200) {
        // Check if the response body starts with '<' (indicating HTML content)
        if (response.body.startsWith('<')) {
          // Handle cases where server returns HTML instead of JSON
          print('Received HTML instead of JSON');
          // Show error message or handle accordingly
          return;
        }

        // Proceed with JSON decoding
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          List<dynamic> polisis = data['data'];
          polisiList.assignAll(polisis.map((polisi) {
            try {
              return Polisi.fromJson(polisi);
            } catch (e) {
              print('Error parsing polisi data: $e');
              return Polisi(
                idPolisi: 'Unknown',
                namaPolisi: 'Unknown',
                noHp: 'Unknown',
                alamat: 'Unknown',
                linkMaps: 'Unknown',
                logo: 'Unknown',
                catatan: 'Unknown',
              );
            }
          }).toList());
          // print('Polisis fetched successfully');
          filteredPolisis.assignAll(polisiList); // Initialize filtered list
          // customSnackbar("Success", "Polisi berhasil diperbarui", "success");
        } else {
          print('Failed to fetch polisi: ${data['message']}');
        }
      } else {
        print('Failed to fetch polisis: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching polisis: $e');
    }
  }

  Future<void> fetchPolisiDetail(String idPolisi) async {
    try {
      final response = await http.post(
        Uri.parse(baseurl + 'detail_polisi.php'),
        body: {'id_polisi': idPolisi},
      );

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        if (result['status'] == 'success') {
          var polisiData = result['data'];
          namaPolisiController.text = polisiData['nama_polisi'];
          noHpController.text = polisiData['no_hp'];
          alamatController.text = polisiData['alamat'];
          linkMapsController.text = polisiData['link_maps'];
          catatanController.text = polisiData['catatan'];

          // If logo exists, set selectedImagePath and selectedImageBase64
          if (polisiData.containsKey('logo')) {
            selectedImagePath.value = ''; // Clear previous selected image path
            selectedImageBase64.value = polisiData['logo'];
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
      print('Error fetching polisi detail: $e');
    }
  }

  void filterPolisis(String query) {
    if (query.isEmpty) {
      filteredPolisis.assignAll(polisiList);
    } else {
      filteredPolisis.assignAll(
        polisiList.where((polisi) =>
            polisi.namaPolisi.toLowerCase().contains(query.toLowerCase())),
      );
    }
  }

  Future<void> updatePolisi(String idPolisi) async {
    if (!validateLinkMaps()) {
      return;
    }
    try {
      var uri = Uri.parse(baseurl + 'update_polisi.php');
      var request = http.MultipartRequest('POST', uri);
      request.fields['id_polisi'] = idPolisi;
      request.fields['nama_polisi'] = namaPolisiController.text;
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

        // Fetch polisis again to update the list
        fetchPolisis();
        // Optionally navigate back or show success message
        customSnackbar("Success", "Berhasil update polisi", "success");
      } else {
        print('Failed to update polisi');
        // print(responseData); // Print detailed error message from PHP
        // Handle failure (e.g., show error message)
        Get.snackbar('Error', 'Failed to update polisi');
      }
    } catch (e) {
      print('Error updating polisi: $e');
      // Handle error
      Get.snackbar('Error', 'Error updating polisi: $e');
    }
  }

  void deletePolisi(String id) async {
    // print('Attempting to delete polisi with id: $id');

    try {
      final response = await http.post(
        Uri.parse('${baseurl}delete_polisi.php'),
        body: {'id_polisi': id},
      );

      // print('Response status code: ${response.statusCode}');
      // print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['message'] == 'data berhasil di hapus') {
          // Sesuaikan dengan respons dari server
          print('Successfully deleted polisi with id: $id');
          polisiList.removeWhere(
              (polisi) => polisi.idPolisi == id); // Hapus dari list lokal
          fetchPolisis();
          customSnackbar("Success", "Polisi berhasil ditambahkan", "success");
        } else {
          customSnackbar("Error", "Polisi gagal ditambahkan", "error");
          // print('Failed to delete polisi: ${data['message']}');
        }
      } else {
        print('Failed to delete polisi: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while deleting polisi: $e');
    }
  }

  void clearTextControllers() {
    namaPolisiController.clear();
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
    namaPolisiController.dispose();
    noHpController.dispose();
    alamatController.dispose();
    linkMapsController.dispose();
    catatanController.dispose();
    super.dispose();
  }
}
