import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tanggap_darurat/user/controller/user_controller.dart';

class ProfileAdmin extends StatelessWidget {
  ProfileAdmin({Key? key}) : super(key: key);

  final profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color(0xff95D2B3),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _showConfirmationDialog(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          return SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: profileController.foto.value.isNotEmpty
                              ? MemoryImage(base64Decode(profileController.foto.value))
                              : AssetImage('images/default_profile.png') as ImageProvider,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          profileController.username.value,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Selamat Datang di Profil anda!',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () => _pickImage(context),
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Upload Photo'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff95D2B3),
                            minimumSize: Size(double.infinity, 50),
                            padding: EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text('Apakah Anda yakin ingin Keluar?'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Tidak'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, 
                foregroundColor: Colors.white,
              ),
            ),
            TextButton(
              onPressed: () {
                profileController.logout();
                Get.back();
              },
              child: const Text('Ya'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, 
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  void _updateUsernameDialog(BuildContext context) {
    TextEditingController usernameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Username'),
          content: TextField(
            controller: usernameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter new username',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                profileController.updateUsername(usernameController.text);
                Get.back();
              },
              child: const Text('Update'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Cancel'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      _showPhotoConfirmationDialog(context, File(image.path));
    }
  }

  void _showPhotoConfirmationDialog(BuildContext context, File imageFile) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Foto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(imageFile, height: 150, fit: BoxFit.cover),
              ),
              const SizedBox(height: 10),
              const Text('Apakah Anda yakin ingin memilih foto ini?'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                profileController.uploadPhoto(imageFile);
                Get.back();
              },
              child: const Text('Ya'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, 
                foregroundColor: Colors.white,
              ),
            ),
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Tidak'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, 
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }
}
