import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ViewPicScreen extends StatefulWidget {
  const ViewPicScreen({super.key});

  @override
  State<ViewPicScreen> createState() => _ViewPicScreenState();
}

class _ViewPicScreenState extends State<ViewPicScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(onPressed: () {
              Navigator.pop(context);
            }, icon: Icon(Icons.arrow_back, color: Colors.white,)),
            Expanded(
              child: PhotoView(
                  imageProvider: NetworkImage(
                      'https://et2o98r3gkt.exactdn.com/wp-content/uploads/2021/05/bilyet-giro.jpg?strip=all&lossy=1&quality=92&webp=92&ssl=1&fit=656%2C365'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
