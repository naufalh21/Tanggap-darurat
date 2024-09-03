import 'package:flutter/material.dart';

class CustomSearch extends StatelessWidget {
  CustomSearch({Key? key, required this.controller}) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x29000000),
            offset: Offset(0, 3),
            blurRadius: 12,
          )
        ],
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Search",
          hintStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
