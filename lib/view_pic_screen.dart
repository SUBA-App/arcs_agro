import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sales_app/configuration.dart';


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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(onPressed: () {
              Navigator.pop(context);
            }, icon: const Icon(Icons.arrow_back, color: Colors.white,)),
            Expanded(
              child: PhotoView(
                  imageProvider: NetworkImage(
              '${Configuration.imageUrlPayment}${widget.url}'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
