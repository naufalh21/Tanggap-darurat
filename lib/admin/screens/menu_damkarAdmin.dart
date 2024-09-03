import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tanggap_darurat/admin/detail%20screen/detail_damkarAdmin.dart';
import 'package:tanggap_darurat/admin/screens/add_damkar.dart';
import 'package:tanggap_darurat/admin/screens/update_damkar.dart';
import 'package:tanggap_darurat/admin/widgetsAdmin/custom_cardAdmin.dart';
import 'package:tanggap_darurat/user/controller/damkar_controller.dart';
import 'package:tanggap_darurat/user/models/damkar_model.dart';

class MenuDamkarAdmin extends StatelessWidget {
  final DamkarController damkarController = Get
      .find(); // Menggunakan Get.find() untuk mendapatkan instansi yang sudah di-inisialisasi

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Damkar'),
        backgroundColor: const Color(0xff95D2B3)
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            // child: CustomSearch(controller: damkarController.searchController),
          ),
          Expanded(
            child: Obx(() {
              if (damkarController.damkarList.isEmpty) {
                return Center(child: Text('Tidak ada data damkar.'));
              } else {
                return ListView.builder(
                  itemCount: damkarController.damkarList.length,
                  itemBuilder: (context, index) {
                    final Damkar damkar = damkarController.damkarList[index];
                    return CustomCardAdmin(
                      imageUrl: damkar.logo,
                      title: damkar.namaDamkar,
                      subtitle: damkar.alamat,
                      onPressed: () {
                        // Action when card is tapped
                        Get.to(() => DetailDamkarAdmin(damkar: damkar));
                      },
                      onEditPressed: () {
                        // Navigate to edit page
                        Get.to(() => EditDamkarPage(
                            idDamkar: damkar
                                .idDamkar)); // Pass idPolisi to EditAmbulancePage
                      },
                      onDeletePressed: () {
                        _confirmDelete(context, damkar.idDamkar);
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
          Get.to(AddDamkarPage());
          damkarController.clearTextControllers();
          print('Floating Action Button Pressed');
        },
        child: Icon(Icons.add),
        tooltip: 'Add Damkar',
      ),
    );
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hapus Damkar'),
        content: Text('Apakah kamu yakin ingin menghapus data Damkar ini ?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Tidak'),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, foregroundColor: Colors.white),
          ),
          TextButton(
            onPressed: () {
              damkarController.deleteDamkar(id);
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
