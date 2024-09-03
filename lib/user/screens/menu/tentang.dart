import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Tentang extends StatelessWidget {
  const Tentang({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang Aplikasi'),
        backgroundColor: const Color(0xff95D2B3),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.1),
                      blurRadius: 4.0,
                      spreadRadius: .05,
                    )
                  ],
                ),
                child: const Center(
                  child: Text(
                    "Tentang Aplikasi Tanggap Darurat",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xff81A263).withOpacity(.7),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.1),
                      blurRadius: 4.0,
                      spreadRadius: .05,
                    )
                  ],
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Di era modern ini, kesibukan dan mobilitas tinggi membuat kita rentan terhadap berbagai situasi darurat. "
                      "Kebakaran, kecelakaan, tindak kriminal, dan berbagai kejadian tak terduga lainnya dapat terjadi kapan saja dan di mana saja. "
                      "Mempersiapkan diri dengan pengetahuan dan akses informasi yang tepat menjadi kunci utama dalam menghadapi situasi darurat.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w300,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Aplikasi Tanggap Darurat hadir sebagai solusi inovatif untuk membantu Anda dalam situasi darurat. "
                      "Aplikasi ini menggabungkan layanan pemadam kebakaran, kepolisian, dan ambulans ke dalam satu platform yang mudah digunakan. "
                      "Dengan aplikasi ini, Anda dapat melaporkan berbagai macam keadaan darurat dengan cepat dan mudah, bahkan saat panik.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w300,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Dengan aplikasi ini, Anda dapat mencari berbagai macam informasi ketika keadaan darurat dengan cepat dan mudah, bahkan saat panik. "
                      "plikasi ini dirancang untuk memberikan informasi yang cepat dan efektif, sehingga Anda bisa mendapatkan bantuan yang diperlukan tepat waktu. "
                      "elain itu, fitur-fitur canggih yang disediakan memastikan bahwa setiap laporan darurat ditangani dengan segera dan akurat, meningkatkan keselamatan dan keamanan pengguna.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w300,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
