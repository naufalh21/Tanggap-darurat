import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tanggap_darurat/user/controller/signup_controller.dart';
import 'package:tanggap_darurat/widgets/custom_button.dart';
import 'package:get/get.dart';
import 'package:tanggap_darurat/widgets/custom_textfiled.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final signupController = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: GetBuilder<SignupController>(
            builder: (controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 100),
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          const Text(
                            'Selamat Datang di Tanggap Darurat',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 20),
                          CustomTextField(
                            hint: 'Username',
                            icon: Icons.person,
                            controller: controller.usernameController,
                          ),
                          const SizedBox(height: 15),
                          CustomTextField(
                            hint: 'Email',
                            icon: Icons.email,
                            controller: controller.emailController,
                          ),
                          const SizedBox(height: 15),
                          Obx(
                            () => CustomTextField(
                              hint: 'Password',
                              icon: Icons.lock,
                              obscureText: controller.isPasswordHidden.value,
                              controller: controller.passwordController,
                              suffixIcon: IconButton(
                                icon: Icon(controller.isPasswordHidden.value
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: () {
                                  controller.togglePasswordVisibility();
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          CustomButton(
                            label: 'Sign up',
                            onPressed: () {
                              controller.checkSignup();
                            },
                          ),
                          const SizedBox(height: 40),
                          Text.rich(
                            TextSpan(
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                color: Colors.black45,
                              ),
                              children: [
                                const TextSpan(
                                  text: 'Sudah memiliki akun? ',
                                ),
                                TextSpan(
                                  text: 'Login',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Get.toNamed('login');
                                    },
                                  style: const TextStyle(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
