import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';

import 'package:tanggap_darurat/user/controller/user_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppBarWidget(),
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
                  Get.toNamed('menu_ambulance');
                },
                child: Container(
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
                        'images/ambulance.png',
                        height: 120,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        'Ambulance',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  Get.toNamed('menu_damkar');
                },
                child: Container(
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
                        'images/damkar.png',
                        height: 120,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        'Damkar',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  Get.toNamed('menu_polisi');
                },
                child: Container(
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
                        'images/polisi.png',
                        height: 120,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        'Polisi',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  Get.toNamed('tentang');
                },
                child: Container(
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
                        'images/tentang.png',
                        height: 120,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        'Tentang',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AppBarWidget extends StatelessWidget {
  AppBarWidget({super.key});

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
                CircleAvatar(
                  radius: 40,
                  backgroundImage: profileController.foto.value.isNotEmpty
                      ? MemoryImage(base64Decode(profileController.foto.value))
                      : AssetImage('images/default_profile.png')
                          as ImageProvider,
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
