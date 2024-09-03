import 'package:flutter/material.dart';
import 'package:tanggap_darurat/user/screens/menu/home_screen.dart';
import 'package:tanggap_darurat/user/screens/menu/profile_screen.dart';


class BaseScreen extends StatefulWidget {
  const BaseScreen({Key? key}) : super(key: key);

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int selectedIndex = 0;

  // List widgetOptions diubah menjadi List<Widget Function()> agar lazily loaded
  static List<Widget Function()> widgetOptions = [
    () => HomeScreen(),
    () => ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widgetOptions.elementAt(selectedIndex)(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0XFF79889F),
        unselectedItemColor: Colors.grey[500],
        backgroundColor: Colors.white,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
        currentIndex: selectedIndex,
        onTap: (int index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}
