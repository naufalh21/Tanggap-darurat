import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';

import 'package:tanggap_darurat/user/controller/user_controller.dart';
import 'package:tanggap_darurat/user/models/ambulance_model.dart';
import 'package:tanggap_darurat/user/screens/menu/ulasan_ambulan.dart';
import 'package:tanggap_darurat/utils/baseurl.dart';
import 'package:tanggap_darurat/utils/custom_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class DetailMenuAmbulance extends StatelessWidget {
  final Ambulance ambulance;
  final profileController = Get.put(ProfileController());

  DetailMenuAmbulance({required this.ambulance});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Ambulance'),
        backgroundColor: const Color(0xff95D2B3),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.1),
                    blurRadius: 4.0,
                    spreadRadius: .05,
                  ),
                ],
              ),
              child: _buildImage(ambulance.logo),
            ),
            SizedBox(height: 15),
            Text(
              ambulance.namaAmbulance,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildDetailRow('No HP:', ambulance.noHp),
            _buildDetailRow('Alamat:', ambulance.alamat),
            _buildDetailRow('Catatan:', ambulance.catatan),
            SizedBox(height: 20),
            Text(
              'Ulasan Pengguna',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () => Get.to(
                    UlasanAmbulanceScreen(idAmbulance: ambulance.idAmbulance)),
                child: Text('Lihat ulasan'),
                style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.black
                    ),
                ),
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.menu_open, // ganti jangan add tapi menu kalo ga arrow up
        activeIcon: Icons.close,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 8.0,
        children: [
          SpeedDialChild(
            child: Icon(Icons.map),
            backgroundColor: Colors.blue,
            label: 'Lihat Lokasi di Maps',
            labelStyle: TextStyle(fontSize: 16.0),
            onTap: () => _openMaps(ambulance.linkMaps),
          ),
          SpeedDialChild(
            child: Icon(Icons.phone),
            backgroundColor: Colors.green,
            label: 'Buka Telepon',
            labelStyle: TextStyle(fontSize: 16.0),
            onTap: () => _openCall(ambulance.noHp),
          ),
          SpeedDialChild(
            child: Icon(Icons.star),
            backgroundColor: Colors.orange,
            label: 'Beri Ulasan',
            labelStyle: TextStyle(fontSize: 16.0),
            onTap: () => _showReviewFormDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String base64String) {
    try {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.memory(
          base64Decode(base64String),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    } catch (e) {
      print('Error decoding base64 string: $e');
      return Image.asset(
        'assets/images/default_image.png',
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }
  }

  Widget _buildDetailRow(String label, String value) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  void _openMaps(String linkMaps) async {
    final Uri mapUri = Uri.parse(linkMaps);
    if (await canLaunchUrl(mapUri)) {
      await launchUrl(mapUri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $mapUri';
    }
  }

  void _openCall(String noHp) async {
    final Uri telUri = Uri(scheme: 'tel', path: noHp);
    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $telUri';
    }
  }

  void _showReviewFormDialog(BuildContext context) {
    TextEditingController reviewController = TextEditingController();
    double rating = 0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Beri Ulasan'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: reviewController,
                decoration: InputDecoration(
                  labelText: 'Ulasan',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.done,
              ),
              SizedBox(height: 10),
              RatingBar.builder(
                initialRating: rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemSize: 30.0,
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (newRating) {
                  rating = newRating;
                },
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(
                          context); // Close the dialog without submitting
                    },
                    child: Text('Batal'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      String review = reviewController.text.trim();
                      if (review.isNotEmpty) {
                        _submitReview(
                            review, rating); // Pass rating to _submitReview
                        Navigator.pop(context); // Close the dialog
                      } else {
                        customSnackbar(
                            "Error", "Ulasan tidak boleh kosong", "error");
                      }
                    },
                    child: Text('Kirim'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitReview(String review, double rating) async {
    var url = baseurl + 'ulasan_ambulance.php';

    var data = {
      'id_ambulance': ambulance.idAmbulance,
      'id_user': profileController.idUser.value,
      'ulasan': review,
      'rating': rating.toString(), // Upload rating to database
    };

    try {
      var response = await http.post(
        Uri.parse(url),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );
      print('Data yang dikirimkan: $data');
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success']) {
          // Show success message or handle accordingly
          print('Ulasan berhasil disimpan');
          // Optionally, update UI or fetch reviews again
          customSnackbar("Success", "Ulasan berhasil disimpan", "success");
          // fetchUlasanAmbulance(ambulance.idAmbulance);
        } else {
          // Show error message or handle accordingly
          print('Gagal menyimpan ulasan: ${jsonResponse['message']}');
        }
      } else {
        // Handle HTTP error
        print('HTTP Error ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      // Handle other errors
      print('Error: $e');
    }
  }
}
