import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tanggap_darurat/admin/detail%20screen/detail_ambulanceAdmin.dart';
import 'package:tanggap_darurat/admin/screens/add_ambulance.dart';
import 'package:tanggap_darurat/admin/screens/update_ambulance.dart';
import 'package:tanggap_darurat/admin/widgetsAdmin/custom_cardAdmin.dart';
import 'package:tanggap_darurat/user/controller/ambulance_controller.dart';
import 'package:tanggap_darurat/user/models/ambulance_model.dart';

class MenuAmbulanceAdmin extends StatelessWidget {
  final AmbulanceController ambulanceController = Get
      .find(); // Menggunakan Get.find() untuk mendapatkan instansi yang sudah di-inisialisasi

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Ambulance'),
        backgroundColor: const Color(0xff95D2B3)
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            // child: CustomSearch(controller: ambulanceController.searchController),
          ),
          Expanded(
            child: Obx(() {
              if (ambulanceController.ambulanceList.isEmpty) {
                return Center(child: Text('Tidak ada data ambulance.'));
              } else {
                return ListView.builder(
                  itemCount: ambulanceController.ambulanceList.length,
                  itemBuilder: (context, index) {
                    final Ambulance ambulance =
                        ambulanceController.ambulanceList[index];
                    return CustomCardAdmin(
                      imageUrl: ambulance.logo,
                      title: ambulance.namaAmbulance,
                      subtitle: ambulance.alamat,
                      onPressed: () {
                        // Action when card is tapped
                        Get.to(
                            () => DetailAmbulanceAdmin(ambulance: ambulance));
                      },
                      onEditPressed: () {
                        // Navigate to edit page
                        Get.to(() => EditAmbulancePage(
                            idAmbulance: ambulance
                                .idAmbulance)); // Pass idAmbulance to EditAmbulancePage
                      },
                      onDeletePressed: () {
                        _confirmDelete(context, ambulance.idAmbulance);
                      },
                    );
                  },
                );
              }
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(AddAmbulancePage());
          ambulanceController.clearTextControllers();
          print('Floating Action Button Pressed');
        },
        child: Icon(Icons.add),
        tooltip: 'Add Ambulance',
      ),
    );
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hapus Ambulance'),
        content: Text('Apakah kamu yakin ingin menghapus data Ambulance ini ?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Tidak'),
            style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, foregroundColor: Colors.white),
          ),
          TextButton(
            onPressed: () {
              ambulanceController.deleteAmbulance(id);
              Get.back();
            },
            child: Text('Ya'),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, foregroundColor: Colors.white),
          ),
        ],
      ),
    );
  }
}
