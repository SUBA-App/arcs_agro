import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/screen/absensi/absensi_provider.dart';

import '../../font_color.dart';

class NextAbsensiScreen extends StatefulWidget {
  const NextAbsensiScreen({super.key, required this.path});

  final String path;

  @override
  State<NextAbsensiScreen> createState() => _NextAbsensiScreenState();
}

class _NextAbsensiScreenState extends State<NextAbsensiScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: FontColor.yellow72,
        iconTheme: IconThemeData(color: FontColor.black),
        title: Text(
          "Check In Absensi",
          style: TextStyle(
              fontFamily: FontColor.fontPoppins, color: FontColor.black, fontSize: 16),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                color: Colors.white,
                child: Image.file(File(widget.path)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () async {
                      await Provider.of<AbsensiProvider>(context, listen: false).addAbsen(context, File(widget.path));
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            const WidgetStatePropertyAll(FontColor.yellow72),
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)))),
                    child: Text(
                      "Check In",
                      style: TextStyle(
                          color: Colors.black, fontFamily: FontColor.fontPoppins),
                    ))),
          )
        ],
      ),
    );
  }
}
