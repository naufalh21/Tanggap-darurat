import 'package:flutter/material.dart';
import 'dart:convert';

class CustomCardAdmin extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final VoidCallback onPressed;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;

  CustomCardAdmin({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.onPressed,
    required this.onEditPressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Center(
        child: Card(
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                subtitle: Text(subtitle),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    child: const Text('UBAH'),
                    onPressed: onEditPressed,
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    child: const Text('HAPUS'),
                    onPressed: onDeletePressed,
                  ),
                  const SizedBox(width: 8),
                ],
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
      return AssetImage('images/default_image.png'); // Provide a default image
    }
  }
}
