import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:tanggap_darurat/user/models/ambulance_model.dart';
import 'package:tanggap_darurat/utils/baseurl.dart';
import 'package:tanggap_darurat/utils/custom_snackbar.dart';

class AmbulanceController extends GetxController {
  var ambulanceList = <Ambulance>[].obs;
  var filteredAmbulances = <Ambulance>[].obs; // For filtered list

  final picker = ImagePicker();
  var selectedImagePath = ''.obs;
  var selectedImageBase64 = ''.obs;
  var selectedImageSize = 0.obs; // Added to store image size

  var idAmbulanceController = TextEditingController();
  var namaAmbulanceController = TextEditingController();
  var noHpController = TextEditingController();
  var alamatController = TextEditingController();
  var linkMapsController = TextEditingController();
  var catatanController = TextEditingController();
  var searchController = TextEditingController(); // Search controller

  @override
  void onInit() {
    super.onInit();
    fetchAmbulances();
    searchController.addListener(() {
      filterAmbulances(searchController.text);
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
          base64Encode(await file.readAsBytes());
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

  Future<void> addAmbulance() async {
    if (!validateLinkMaps()) {
      return;
    }
    final newAmbulance = Ambulance(
      idAmbulance: '0', // Assume new ambulance ID is '0' or generate a new ID
      namaAmbulance: namaAmbulanceController.text,
      noHp: noHpController.text,
      alamat: alamatController.text,
      linkMaps: linkMapsController.text,
      logo: selectedImageBase64.value,
      catatan: catatanController.text,
    );

    try {
      final response = await http.post(
        Uri.parse(baseurl + 'add_ambulance.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(newAmbulance.toJson()),
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
          fetchAmbulances(); // Refresh the list of ambulances
          print(
              'Added ambulance with ID: ${newAmbulance.idAmbulance}'); // Debugging output
          // Clear controllers
          clearTextControllers();

          customSnackbar("Success", "Ambulance berhasil diubah", "success");
        } else {
          customSnackbar(
              "Error", result['message'] ?? "Failed to add ambulance", "error");
          print('Failed to add ambulance: ${result['message']}');
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

  void fetchAmbulances() async {
    try {
      final response =
          await http.get(Uri.parse(baseurl + 'read_ambulance.php'));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          List<dynamic> ambulances = data['data'];
          ambulanceList.assignAll(ambulances.map((ambulance) {
            try {
              return Ambulance.fromJson(ambulance);
            } catch (e) {
              print('Error parsing ambulance data: $e');
              return Ambulance(
                idAmbulance: 'Unknown',
                namaAmbulance: 'Unknown',
                noHp: 'Unknown',
                alamat: 'Unknown',
                linkMaps: 'Unknown',
                logo: 'Unknown',
                catatan: 'Unknown',
              );
            }
          }).toList());
          // print('Ambulances fetched successfully');
          filteredAmbulances
              .assignAll(ambulanceList); // Initialize filtered list
          // customSnackbar("Success", "Ambulance berhasil diperbarui", "success");
        } else {
          print('Failed to fetch ambulances: ${data['message']}');
        }
      } else {
        print('Failed to fetch ambulances');
      }
    } catch (e) {
      print('Error fetching ambulances: $e');
    }
  }

  Future<void> fetchAmbulanceDetail(String idAmbulance) async {
    try {
      final response = await http.post(
        Uri.parse(baseurl + 'detail_ambulance.php'),
        body: {'id_ambulance': idAmbulance},
      );

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        if (result['status'] == 'success') {
          var ambulanceData = result['data'];
          namaAmbulanceController.text = ambulanceData['nama_ambulance'];
          noHpController.text = ambulanceData['no_hp'];
          alamatController.text = ambulanceData['alamat'];
          linkMapsController.text = ambulanceData['link_maps'];
          catatanController.text = ambulanceData['catatan'];

          // If logo exists, set selectedImagePath and selectedImageBase64
          if (ambulanceData.containsKey('logo')) {
            selectedImagePath.value = ''; // Clear previous selected image path
            selectedImageBase64.value = ambulanceData['logo'];
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
      print('Error fetching ambulance detail: $e');
    }
  }

  void filterAmbulances(String query) {
    if (query.isEmpty) {
      filteredAmbulances.assignAll(ambulanceList);
    } else {
      filteredAmbulances.assignAll(
        ambulanceList.where((ambulance) => ambulance.namaAmbulance
            .toLowerCase()
            .contains(query.toLowerCase())),
      );
    }
  }

  Future<void> updateAmbulance(String idAmbulance) async {
    if (!validateLinkMaps()) {
      return;
    }
    try {
      var uri = Uri.parse(baseurl + 'update_ambulance.php');
      var request = http.MultipartRequest('POST', uri);
      request.fields['id_ambulance'] = idAmbulance;
      request.fields['nama_ambulance'] = namaAmbulanceController.text;
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

        // Fetch ambulances again to update the list
        fetchAmbulances();
        // Optionally navigate back or show success message
        customSnackbar("Success", "Berhasil update ambulance", "success");
      } else {
        print('Failed to update ambulance');
        // print(responseData); // Print detailed error message from PHP
        // Handle failure (e.g., show error message)
        Get.snackbar('Error', 'Failed to update ambulance');
      }
    } catch (e) {
      print('Error updating ambulance: $e');
      // Handle error
      Get.snackbar('Error', 'Error updating ambulance: $e');
    }
  }

  void deleteAmbulance(String id) async {
    // print('Attempting to delete ambulance with id: $id');

    try {
      final response = await http.post(
        Uri.parse('${baseurl}delete_ambulance.php'),
        body: {'id_ambulance': id},
      );

      // print('Response status code: ${response.statusCode}');
      // print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['message'] == 'data berhasil di hapus') {
          // Sesuaikan dengan respons dari server
          print('Successfully deleted ambulance with id: $id');
          ambulanceList.removeWhere((ambulance) =>
              ambulance.idAmbulance == id); // Hapus dari list lokal
          fetchAmbulances();
          customSnackbar(
              "Success", "Ambulance berhasil ditambahkan", "success");
        } else {
          customSnackbar("Error", "Ambulance gagal ditambahkan", "error");
          // print('Failed to delete ambulance: ${data['message']}');
        }
      } else {
        print('Failed to delete ambulance: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while deleting ambulance: $e');
    }
  }

  void clearTextControllers() {
    namaAmbulanceController.clear();
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
    namaAmbulanceController.dispose();
    noHpController.dispose();
    alamatController.dispose();
    linkMapsController.dispose();
    catatanController.dispose();
    super.dispose();
  }
}
