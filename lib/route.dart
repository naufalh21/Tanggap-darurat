import 'package:get/get.dart';
import 'package:tanggap_darurat/admin/screens/admin_ambulance.dart';
import 'package:tanggap_darurat/admin/screens/admin_damkar.dart';
import 'package:tanggap_darurat/admin/screens/admin_polisi.dart';
import 'package:tanggap_darurat/admin/screens/menu_admin.dart';
import 'package:tanggap_darurat/user/screens/auth/login_screen.dart';
import 'package:tanggap_darurat/user/screens/auth/forgetPassword_screen.dart';
import 'package:tanggap_darurat/user/screens/auth/signup_screen.dart';
import 'package:tanggap_darurat/user/screens/menu/base_screen.dart';
import 'package:tanggap_darurat/user/screens/menu/introscreen.dart';
import 'package:tanggap_darurat/user/screens/menu/menu_ambulance.dart';
import 'package:tanggap_darurat/user/screens/menu/menu_damkar.dart';
import 'package:tanggap_darurat/user/screens/menu/menu_polisi.dart';
import 'package:tanggap_darurat/user/screens/menu/tentang.dart';

class GetRoutes {
  static String intro = '/intro';
  static String login = '/login';
  static String signup = '/signup';
  static String home = '/home';
  static String homeA = '/home_admin';
  static String tentang = '/tentang';
  static String resetPassword = '/reset_pass';

  //Route Menu
  static String menuAmbulance = '/menu_ambulance';
  static String menuDamkar = '/menu_damkar';
  static String menuPolisi = '/menu_polisi';

  //admin
  static String adminAmbulance = '/admin_ambulance';
  static String adminDamkar = '/admin_damkar';
  static String adminPolisi = '/admin_polisi';
}

final getPages = [
  GetPage(
    name: GetRoutes.intro,
    page: () => const IntroScreen(),
  ),
  GetPage(
    name: GetRoutes.login,
    page: () => LoginScreen(),
  ),
  GetPage(
    name: GetRoutes.signup,
    page: () => SignupScreen(),
  ),
  GetPage(
    name: GetRoutes.home,
    page: () => const BaseScreen(),
  ),
  GetPage(
    name: GetRoutes.homeA,
    page: () => const HomeScreenAdmin(),
  ),
  GetPage(
    name: GetRoutes.menuAmbulance,
    page: () => MenuAmbulance(),
  ),
  GetPage(
    name: GetRoutes.menuDamkar,
    page: () => MenuDamkar(),
  ),
  GetPage(
    name: GetRoutes.menuPolisi,
    page: () => MenuPolisi(),
  ),
  GetPage(
    name: GetRoutes.tentang,
    page: () => const Tentang(),
  ),
  GetPage(
    name: GetRoutes.adminAmbulance,
    page: () => const AdminScreenAmbulance(),
  ),
  GetPage(
    name: GetRoutes.adminDamkar,
    page: () => const AdminScreenDamkar(),
  ),
  GetPage(
    name: GetRoutes.adminPolisi,
    page: () => const AdminScreenPolisi(),
  ),
  GetPage(
    name: GetRoutes.resetPassword,
    page: () => ForgotPasswordScreen(),
  ),

];
