import 'package:flutter/material.dart';
import 'dart:convert';

class CustomCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final Function onPressed;

  CustomCard({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPressed();
      },
      child: Center(
        child: Card(
          // Set the shape of the card using a rounded rectangle border with a 8 pixel radius
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          // Set the clip behavior of the card
          clipBehavior: Clip.antiAliasWithSaveLayer,
          // Define the child widgets of the card
          color: Color(0xffF7F9F2).withOpacity(.7),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: _imageFromBase64String(imageUrl),
                ),
                title: Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                subtitle: Text(subtitle),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ImageProvider _imageFromBase64String(String base64String) {
    try {
      return MemoryImage(base64Decode(base64String));
    } catch (e) {
      // Handle the case where the base64 string is invalid
      print('Error decoding base64 string: $e');
      return AssetImage(
          'assets/images/default_image.png'); // Provide a default image
    }
  }
}
