import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tanggap_darurat/user/controller/damkar_controller.dart';
import 'package:tanggap_darurat/user/models/damkar_model.dart';
import 'package:tanggap_darurat/user/screens/menu/detail_menuDamkar.dart';
import 'package:tanggap_darurat/widgets/custom_card.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuDamkar extends StatelessWidget {
  final DamkarController damkarController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Damkar'),
        backgroundColor: const Color(0xff95D2B3),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (damkarController.damkarList.isEmpty) {
                return Center(child: Text('No ambulances found.'));
              } else {
                return ListView.builder(
                  itemCount: damkarController.damkarList.length,
                  itemBuilder: (context, index) {
                    final Damkar damkar = damkarController.damkarList[index];
                    return CustomCard(
                      imageUrl: damkar.logo,
                      title: damkar.namaDamkar,
                      subtitle: damkar.alamat,
                      onPressed: () {
                        Get.to(DetailMenuDamkar(damkar: damkar));
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
      }, label: Text('Damkar terdekat'), icon: Icon(Icons.location_on),) ,
    );
  }



  Future<void> _searchNearbyAmbulance() async {
    final Uri googleMapsUri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=damkar+terdekat',
    );

    if (await canLaunchUrl(googleMapsUri)) {
      await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $googleMapsUri';
    }
  }
}
