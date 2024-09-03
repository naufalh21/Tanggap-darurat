import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tanggap_darurat/user/models/ambulance_model.dart';
import 'package:tanggap_darurat/user/screens/menu/ulasan_ambulan.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

class DetailAmbulanceAdmin extends StatelessWidget {
  final Ambulance ambulance;

  DetailAmbulanceAdmin({required this.ambulance});

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
            SizedBox(height: 20,),
            ElevatedButton(
                onPressed: () => Get.to(
                    UlasanAmbulanceScreen(idAmbulance: ambulance.idAmbulance)),
                child: Text('Lihat ulasan'),
                style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                    ),
                ),
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _openMaps(ambulance.linkMaps),
                    child: Center(child: Text('Lihat Lokasi di Maps')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _openCall(ambulance.noHp),
                    child: Text('Buka Telepon'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
            Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
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
}
