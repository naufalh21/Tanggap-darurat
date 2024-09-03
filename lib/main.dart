import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tanggap_darurat/route.dart';
import 'package:tanggap_darurat/user/controller/ambulance_controller.dart';
import 'package:tanggap_darurat/user/controller/damkar_controller.dart';
import 'package:tanggap_darurat/user/controller/polisi_controller.dart';



void main() {
  Get.put(AmbulanceController()); // Inisialisasi AmbulanceController di sini
  Get.put(DamkarController()); // Inisialisasi AmbulanceController di sini
  Get.put(PolisiController()); // Inisialisasi AmbulanceController di sini
  // Get.put(ProfileController()); // Inisialisasi AmbulanceController di sini
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: "Poppins",
      ),
      // home: SignupScreen(),
      debugShowCheckedModeBanner: false,
      initialRoute: GetRoutes.intro,
      getPages: getPages,
    );
  }
}
