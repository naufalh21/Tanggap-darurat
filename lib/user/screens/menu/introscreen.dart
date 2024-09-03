import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:get/get.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      globalBackgroundColor: Colors.grey.shade300,
      dotsContainerDecorator: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [
                0.2,
                0.5
              ],
              colors: [
                Color(0xffD8EFD3),
                Color(0xff95D2B3),
              ])
      ),
      pages: [
        PageViewModel(
          title: "Tanggap Daruat App",
          body: "Selamat Datang di Aplikasi Tanggap Darurat.",
          image: Center(
            child: Image.asset('images/logo.png'),
          ),
        ),
        PageViewModel(
          title: "Tanggap Daruat App",
          body: "Tanggap Darurat untuk kebaikan bersama. Satu kebaikan untuk beribu pahala",
          image: Center(
            child: Image.asset('images/logo.png'),
          ),
        )
      ],
      showNextButton: true,
      next: const Text("Next >>"),
      done: const Text("Login"),
      onDone: () {
        Get.offAllNamed('login');
      },
    );
  }
}
