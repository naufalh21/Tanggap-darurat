import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tanggap_darurat/user/controller/polisi_controller.dart';
import 'package:tanggap_darurat/utils/custom_snackbar.dart';

class EditPolisiPage extends StatelessWidget {
  final PolisiController polisiController =
      Get.find(); // Using Get.find() to get the initialized instance
  final String idPolisi; // The ID of the polisi being edited

  EditPolisiPage(
      {required this.idPolisi}); // Constructor to accept the ID

  @override
  Widget build(BuildContext context) {
    // Fetch polisi detail when page is loaded
    polisiController.fetchPolisiDetail(idPolisi);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Polisi'),
        backgroundColor: const Color(0xff95D2B3),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildTextField(
                        controller: polisiController.namaPolisiController,
                        labelText: 'Nama Kepolisian',
                      ),
                      SizedBox(height: 10),
                      _buildTextField(
                        controller: polisiController.noHpController,
                        labelText: 'No HP',
                        keyboardType: TextInputType.phone, // Set keyboard type to phone
                      ),
                      SizedBox(height: 10),
                      _buildTextField(
                        controller: polisiController.alamatController,
                        labelText: 'Alamat',
                      ),
                      SizedBox(height: 10),
                      _buildTextField(
                        controller: polisiController.linkMapsController,
                        labelText: 'Link Maps',
                      ),
                      SizedBox(height: 10),
                      _buildTextField(
                        controller: polisiController.catatanController,
                        labelText: 'Catatan',
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Ketuk pada gambar untuk mengganti gambar', style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 5,),
                  GestureDetector(
                    onTap: () {
                      polisiController.pickImage();
                    },
                    child: Container(
                      width: double.infinity,
                      height: 180,
                      color: Colors.grey[200],
                      child: Obx(() {
                        if (polisiController.selectedImagePath.value != '') {
                          return Image.file(
                            File(polisiController.selectedImagePath.value),
                            fit: BoxFit.cover,
                          );
                        } else if (polisiController.selectedImageBase64.value !=
                            '') {
                          return Image.memory(
                            base64Decode(
                                polisiController.selectedImageBase64.value),
                            fit: BoxFit.cover,
                          );
                        } else {
                          return Center(
                            child: Text('Tap to select an image'),
                          );
                        }
                      }),
                    ),
                  ),
                ],
              ),
              Obx(() {
                if (polisiController.selectedImageSize.value > 0) {
                  double imageSizeInKB =
                      polisiController.selectedImageSize.value / 1024;
                  return Text(
                      'Ukuran gambar: ${imageSizeInKB.toStringAsFixed(2)} KB', style: TextStyle(color: Colors.grey));
                } else {
                  return Container();
                }
              }),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _showConfirmationDialog(context);
                },
                child: Text('Edit Polisi'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }

    void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi'),
          content: Text('Apakah Anda yakin ingin mengedit data Kepolisian ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('Tidak'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, foregroundColor: Colors.white),
            ),
            TextButton(
              onPressed: () {
                if (polisiController.validateLinkMaps()) {
                  polisiController.updatePolisi(idPolisi);
                  Get.back();
                } else {
                  Get.back();
                  customSnackbar("Error",
                      "Link Maps harus berisi link yang valid", "error");
                }
              },
              child: Text('Ya'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, foregroundColor: Colors.white),
            ),
          ],
        );
      },
    );
  }
}
