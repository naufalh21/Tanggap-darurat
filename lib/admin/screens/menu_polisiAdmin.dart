import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tanggap_darurat/admin/detail%20screen/detail_polisiAdmin.dart';
import 'package:tanggap_darurat/admin/screens/add_polisi.dart';
import 'package:tanggap_darurat/admin/screens/update_polisi.dart';
import 'package:tanggap_darurat/admin/widgetsAdmin/custom_cardAdmin.dart';
import 'package:tanggap_darurat/user/controller/polisi_controller.dart';
import 'package:tanggap_darurat/user/models/polisi_model.dart';


class MenuPolisiAdmin extends StatelessWidget {
  final PolisiController polisiController = Get.find(); // Menggunakan Get.find() untuk mendapatkan instansi yang sudah di-inisialisasi

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Kepolisian'),
        backgroundColor: const Color(0xff95D2B3)
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            // child: CustomSearch(controller: polisiController.searchController),
          ),
          Expanded(
            child: Obx(() {
              if (polisiController.polisiList.isEmpty) {
                return Center(child: Text('Tidak ada Kepolisian.'));
              } else {
                return ListView.builder(
                  itemCount: polisiController.polisiList.length,
                  itemBuilder: (context, index) {
                    final Polisi polisi = polisiController.polisiList[index];
                    return CustomCardAdmin(
                      imageUrl: polisi.logo,
                      title: polisi.namaPolisi,
                      subtitle: polisi.alamat,
                      onPressed: () {
                        // Action when card is tapped
                        Get.to(() => DetailPolisiAdmin(polisi: polisi));
                      },
                      onEditPressed: () {
                        // Navigate to edit page
                        Get.to(() => EditPolisiPage(idPolisi: polisi.idPolisi)); // Pass idPolisi to EditAmbulancePage
                      },
                      onDeletePressed: () {
                        _confirmDelete(context, polisi.idPolisi);
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
          Get.to(AddPolisiPage());
          polisiController.clearTextControllers();
          print('Floating Action Button Pressed');
        },
        child: Icon(Icons.add),
        tooltip: 'Add Polisi',
      ),
    );
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hapus Polisi'),
        content: Text('Apakah kamu yakin ingin menghapus data Kepolisian ini ?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, foregroundColor: Colors.white),
          ),
          TextButton(
            onPressed: () {
              polisiController.deletePolisi(id);
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
