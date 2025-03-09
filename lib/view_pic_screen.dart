import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import 'font_color.dart';


class ViewPicScreen extends StatefulWidget {
  const ViewPicScreen({super.key, required this.url});

  final String url;

  @override
  State<ViewPicScreen> createState() => _ViewPicScreenState();
}

class _ViewPicScreenState extends State<ViewPicScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Foto",
          style: TextStyle(
              fontFamily: FontColor.fontPoppins,
              color: Colors.white,
              fontSize: 16),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: PhotoView(
                  imageProvider: NetworkImage(
              widget.url),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
