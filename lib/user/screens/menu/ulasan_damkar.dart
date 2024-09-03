import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:tanggap_darurat/user/controller/ulasanDamkar_controller.dart';
import 'package:tanggap_darurat/user/models/ulasan_damkar_model.dart';

class UlasanDamkarScreen extends StatelessWidget {
  final String idDamkar;
  UlasanDamkarScreen({required this.idDamkar});

  @override
  Widget build(BuildContext context) {
    final UlasanDamkarController ulasanController = Get.put(UlasanDamkarController());

    ulasanController.fetchUlasan(idDamkar.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text('Ulasan Pengguna'),
      ),
      body: Obx(() {
        if (ulasanController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (ulasanController.ulasanList.isEmpty) {
          return Center(child: Text('Tidak ada ulasan.'));
        } else {
          return ListView.builder(
            itemCount: ulasanController.ulasanList.length,
            itemBuilder: (context, index) {
              UlasanDamkar ulasan = ulasanController.ulasanList[index];

              // Membuat username anonim
              String anonimUsername = ulasan.username.length > 3 
                ? ulasan.username.substring(0, 3) + '***' 
                : ulasan.username + '***';

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        anonimUsername,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                      SizedBox(height: 5),
                      Text(
                        ulasan.ulasan,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          RatingBarIndicator(
                            rating: double.tryParse(ulasan.rating) ?? 0.0,
                            itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 20.0,
                            direction: Axis.horizontal,
                          ),
                          Spacer(),
                          Text(
                            ulasan.tglUlasan,
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      }),
    );
  }
}
