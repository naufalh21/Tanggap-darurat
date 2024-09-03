import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tanggap_darurat/user/controller/ambulance_controller.dart';
import 'package:tanggap_darurat/user/models/ambulance_model.dart';
import 'package:tanggap_darurat/user/screens/menu/detail_menuAmbulance.dart';
import 'package:tanggap_darurat/widgets/custom_card.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuAmbulance extends StatelessWidget {
  final AmbulanceController ambulanceController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Ambulances'),
        backgroundColor: const Color(0xff95D2B3),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (ambulanceController.ambulanceList.isEmpty) {
                return Center(child: Text('No ambulances found.'));
              } else {
                return ListView.builder(
                  itemCount: ambulanceController.ambulanceList.length,
                  itemBuilder: (context, index) {
                    final Ambulance ambulance = ambulanceController.ambulanceList[index];
                    return CustomCard(
                      imageUrl: ambulance.logo,
                      title: ambulance.namaAmbulance,
                      subtitle: ambulance.alamat,
                      onPressed: () {
                        Get.to(DetailMenuAmbulance(ambulance: ambulance));
                      },
                    );
                  },
                );
              }
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: (){
        _searchNearbyAmbulance();
      }, label: Text('Ambulance terdekat'), icon: Icon(Icons.location_on),) ,
    );
  }



  Future<void> _searchNearbyAmbulance() async {
    final Uri googleMapsUri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=ambulance+terdekat',
    );

    if (await canLaunchUrl(googleMapsUri)) {
      await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $googleMapsUri';
    }
  }
}
