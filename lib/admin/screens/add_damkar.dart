import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tanggap_darurat/user/controller/damkar_controller.dart';
import 'package:tanggap_darurat/utils/custom_snackbar.dart';

class AddDamkarPage extends StatelessWidget {
  final DamkarController damkarController = Get
      .find(); // Menggunakan Get.find() untuk mendapatkan instansi yang sudah di-inisialisasi

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Damkar'),
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
                        controller: damkarController.namaDamkarController,
                        labelText: 'Nama Damkar',
                      ),
                      SizedBox(height: 10),
                      _buildTextField(
                        controller: damkarController.noHpController,
                        labelText: 'No HP',
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(height: 10),
                      _buildTextField(
                        controller: damkarController.alamatController,
                        labelText: 'Alamat',
                      ),
                      SizedBox(height: 10),
                      _buildTextField(
                        controller: damkarController.linkMapsController,
                        labelText: 'Link Maps',
                      ),
                      SizedBox(height: 10),
                      _buildTextField(
                        controller: damkarController.catatanController,
                        labelText: 'Catatan',
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Obx(() {
                return Column(
                  children: [
                    if (damkarController.selectedImagePath.value != '')
                      Image.file(
                        File(damkarController.selectedImagePath.value),
                        height: 150,
                        width: 100,
                      )
                    else
                      Text("No image selected"),
                    if (damkarController.selectedImageSize.value > 0)
                      Text(
                        "Ukuran gambar: ${(damkarController.selectedImageSize.value / 1024).toStringAsFixed(2)} KB",
                        style: TextStyle(color: Colors.grey),
                      ),
                  ],
                );
              }),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  damkarController.pickImage();
                },
                icon: Icon(Icons.upload),
                label: Text('Unggah Gambar'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _showConfirmationDialog(context);
                },
                child: Text('Tambah Damkar'),
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
        hintText: labelText == 'Link Maps' ? 'https://maps.app.goo.gl/' : '',
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
          content: Text('Apakah Anda yakin ingin menambah data damkar ini?'),
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
                if (damkarController.validateLinkMaps()) {
                  damkarController.addDamkar();
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
