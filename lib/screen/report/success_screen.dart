import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sales_app/screen/print/print_screen.dart';

import '../../font_color.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key, required this.template, required this.count});

  final List<int> template;
  final int count;

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: FontColor.yellow72,
        iconTheme: const IconThemeData(color: FontColor.black),
        title: Text(
          "Tambah Laporan",
          style: TextStyle(
            fontFamily: FontColor.fontPoppins,
            color: FontColor.black,
            fontSize: 16,
          ),
        ),
      ),
      body: SafeArea(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/accept.png', width: 120,height: 120,),
                SizedBox(height: 16,),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PrintScreen(template: widget.template, count: widget.count,)));
                    },
                    style: ButtonStyle(
                      backgroundColor: const WidgetStatePropertyAll(Colors.black),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    child: Text(
                      "Print Tanda Terima",
                      style: TextStyle(
                        fontFamily: FontColor.fontPoppins,
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      )),
    );
  }
}
