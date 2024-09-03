import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tanggap_darurat/user/controller/polisi_controller.dart';
import 'package:tanggap_darurat/user/models/polisi_model.dart';
import 'package:tanggap_darurat/user/screens/menu/detail_menuPolisi.dart';
import 'package:tanggap_darurat/widgets/custom_card.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuPolisi extends StatelessWidget {
  final PolisiController polisiController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Polisi'),
        backgroundColor: const Color(0xff95D2B3),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (polisiController.polisiList.isEmpty) {
                return Center(child: Text('No ambulances found.'));
              } else {
                return ListView.builder(
                  itemCount: polisiController.polisiList.length,
                  itemBuilder: (context, index) {
                    final Polisi polisi = polisiController.polisiList[index];
                    return CustomCard(
                      imageUrl: polisi.logo,
                      title: polisi.namaPolisi,
                      subtitle: polisi.alamat,
                      onPressed: () {
                        Get.to(DetailMenuPolisi(polisi: polisi));
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
      }, label: Text('Polisi terdekat'), icon: Icon(Icons.location_on),) ,
    );
  }



  Future<void> _searchNearbyAmbulance() async {
    final Uri googleMapsUri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=polisi+terdekat',
    );

    if (await canLaunchUrl(googleMapsUri)) {
      await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $googleMapsUri';
    }
  }
}
