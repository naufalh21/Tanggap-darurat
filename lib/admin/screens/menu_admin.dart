import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';

import 'package:tanggap_darurat/admin/screens/menu_ambulanceAdmin.dart';
import 'package:tanggap_darurat/admin/screens/menu_damkarAdmin.dart';
import 'package:tanggap_darurat/admin/screens/menu_polisiAdmin.dart';
import 'package:tanggap_darurat/admin/screens/profile_admin.dart';
import 'package:tanggap_darurat/user/controller/user_controller.dart';

class HomeScreenAdmin extends StatelessWidget {
  const HomeScreenAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppBarWidgetAdmin(),
            const SizedBox(height: 40,),
            const Body(),
          ],
        ),
      ),
    );
  }
}

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(MenuAmbulanceAdmin());
                },
                child: CustomContainer(
                  imagePath: 'images/ambulance.png',
                  label: 'Ambulance',
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  Get.to(MenuDamkarAdmin());
                },
                child: CustomContainer(
                  imagePath: 'images/damkar.png',
                  label: 'Damkar',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(MenuPolisiAdmin());
                },
                child: CustomContainer(
                  imagePath: 'images/polisi.png',
                  label: 'Polisi',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomContainer extends StatelessWidget {
  final String imagePath;
  final String label;

  const CustomContainer({
    required this.imagePath,
    required this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xffC8CFA0).withOpacity(.5),
            blurRadius: 4.0,
            spreadRadius: .05,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            height: 120,
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class AppBarWidgetAdmin extends StatelessWidget {
  AppBarWidgetAdmin({super.key});

  final profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
      height: 200,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.1, 0.5],
          colors: [Color(0xffD8EFD3), Color(0xff95D2B3)],
        ),
      ),
      child: Obx(() {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Halo, ${profileController.username.value}\nSelamat Datang',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    Get.to(ProfileAdmin());
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: profileController.foto.value.isNotEmpty
                        ? MemoryImage(base64Decode(profileController.foto.value))
                        : AssetImage('images/default_profile.png')
                            as ImageProvider,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        );
      }),
    );
  }
}
