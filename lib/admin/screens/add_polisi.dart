import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tanggap_darurat/user/controller/polisi_controller.dart';
import 'package:tanggap_darurat/utils/custom_snackbar.dart';

class AddPolisiPage extends StatelessWidget {
  final PolisiController polisiController = Get
      .find(); // Menggunakan Get.find() untuk mendapatkan instansi yang sudah di-inisialisasi

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Polisi'),
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
                        labelText: 'Nama Polisi',
                      ),
                      SizedBox(height: 10),
                      _buildTextField(
                        controller: polisiController.noHpController,
                        labelText: 'No HP',
                        keyboardType: TextInputType.phone,
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
              Obx(() {
                return Column(
                  children: [
                    if (polisiController.selectedImagePath.value != '')
                      Image.file(
                        File(polisiController.selectedImagePath.value),
                        height: 150,
                        width: 100,
                      )
                    else
                      Text("No image selected"),
                    if (polisiController.selectedImageSize.value > 0)
                      Text(
                        "Ukuran gambar: ${(polisiController.selectedImageSize.value / 1024).toStringAsFixed(2)} KB",
                        style: TextStyle(color: Colors.grey),
                      ),
                  ],
                );
              }),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  polisiController.pickImage();
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
                child: Text('Tambah Polisi'),
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
          content:
              Text('Apakah Anda yakin ingin menambah data kepolisian ini?'),
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
                  polisiController.addPolisi();
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
