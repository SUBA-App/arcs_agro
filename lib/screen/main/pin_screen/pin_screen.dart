import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/font_color.dart';
import 'package:sales_app/screen/main/otp_screen/otp_screen.dart';
import 'package:sales_app/screen/main/pin_screen/pin_provider.dart';
import 'package:sales_app/util/preferences.dart';

import '../main_provider.dart';

class PinScreen extends StatefulWidget {
  const PinScreen({super.key, required this.mode, this.pin});

  final int mode;
  final List<int>? pin;

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MainProvider>(context, listen: false).checkStatus(context);
    });
    super.initState();
  }

  List<int> pin = [];

  bool error = false;

  Future<void> action(int number) async {
    error = false;
    if (pin.length < 6) {
      setState(() {
        pin.add(number);
      });

      if (pin.length == 6) {

        if (widget.mode == 1) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => PinScreen(mode: 2, pin: pin,)));
        } else if (widget.mode == 2) {
          if (widget.pin?.join('') == pin.join('')) {
           await Provider.of<PinProvider>(context, listen: false).createPin(context, pin.join(''));
          } else {
            setState(() {
              error = true;
            });
          }
        } else {
         await Provider.of<PinProvider>(context, listen: false).verifyPin(context, pin.join(''));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PinProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              widget.mode == 2 ?
              Row(
                children: [
                  IconButton(onPressed: () {
                    Navigator.pop(context);
                  }, icon: const Icon(Icons.arrow_back_outlined)),
                ],
              ):const SizedBox(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      widget.mode == 1 ? 'Buat PIN Anda' : widget.mode == 2 ? 'Konfirmasi PIN Anda' : 'Masukkan PIN Anda',
                      style: TextStyle(
                          fontFamily: FontColor.fontPoppins,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: FontColor.black),
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 15,
                              width: 15,
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: pin.isNotEmpty
                                      ? FontColor.yellow72
                                      : Colors.black12),
                            ),
                            Container(
                              height: 15,
                              width: 15,
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: pin.length > 1
                                      ? FontColor.yellow72
                                      : Colors.black12),
                            ),
                            Container(
                              height: 15,
                              width: 15,
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: pin.length > 2
                                      ? FontColor.yellow72
                                      : Colors.black12),
                            ),
                            Container(
                              height: 15,
                              width: 15,
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: pin.length > 3
                                      ? FontColor.yellow72
                                      : Colors.black12),
                            ),
                            Container(
                              height: 15,
                              width: 15,
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: pin.length > 4
                                      ? FontColor.yellow72
                                      : Colors.black12),
                            ),
                            Container(
                              height: 15,
                              width: 15,
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: pin.length > 5
                                      ? FontColor.yellow72
                                      : Colors.black12),
                            )
                          ],
                        ),
                        error ? const Text('PIN yang dimasukkan salah', style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.red,
                        ),) : const SizedBox()
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                    onPressed: () async {
                                        await action(1);
                                    },
                                    style: const ButtonStyle(
                                      overlayColor:
                                      WidgetStatePropertyAll(Colors.black12),
                                    ),
                                    child: Text(
                                      '1',
                                      style: TextStyle(
                                          fontFamily: FontColor.fontPoppins,
                                          fontSize: 26,
                                          fontWeight: FontWeight.w500,
                                          color: FontColor.black),
                                    )),
                                TextButton(
                                    onPressed: () async {

                                       await action(2);

                                    },
                                    style: const ButtonStyle(
                                        overlayColor:
                                        WidgetStatePropertyAll(Colors.black12)),
                                    child: Text(
                                      '2',
                                      style: TextStyle(
                                          fontFamily: FontColor.fontPoppins,
                                          fontSize: 26,
                                          fontWeight: FontWeight.w500,
                                          color: FontColor.black),
                                    )),
                                TextButton(
                                    onPressed: ()async {

                                        await action(3);

                                    },
                                    style: const ButtonStyle(
                                        overlayColor:
                                        WidgetStatePropertyAll(Colors.black12)),
                                    child: Text(
                                      '3',
                                      style: TextStyle(
                                          fontFamily: FontColor.fontPoppins,
                                          fontSize: 26,
                                          fontWeight: FontWeight.w500,
                                          color: FontColor.black),
                                    )),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                    onPressed: () async {

                                        await action(4);

                                    },
                                    style: const ButtonStyle(
                                        overlayColor:
                                        WidgetStatePropertyAll(Colors.black12)),
                                    child: Text(
                                      '4',
                                      style: TextStyle(
                                          fontFamily: FontColor.fontPoppins,
                                          fontSize: 26,
                                          fontWeight: FontWeight.w500,
                                          color: FontColor.black),
                                    )),
                                TextButton(
                                    onPressed: () async {

                                        await action(5);

                                    },
                                    style: const ButtonStyle(
                                        overlayColor:
                                        WidgetStatePropertyAll(Colors.black12)),
                                    child: Text(
                                      '5',
                                      style: TextStyle(
                                          fontFamily: FontColor.fontPoppins,
                                          fontSize: 26,
                                          fontWeight: FontWeight.w500,
                                          color: FontColor.black),
                                    )),
                                TextButton(
                                    onPressed: () async {

                                        await action(6);

                                    },
                                    style: const ButtonStyle(
                                        overlayColor:
                                        WidgetStatePropertyAll(Colors.black12)),
                                    child: Text(
                                      '6',
                                      style: TextStyle(
                                          fontFamily: FontColor.fontPoppins,
                                          fontSize: 26,
                                          fontWeight: FontWeight.w500,
                                          color: FontColor.black),
                                    )),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                    onPressed: () async {

                                        await action(7);

                                    },
                                    style: const ButtonStyle(
                                        overlayColor:
                                        WidgetStatePropertyAll(Colors.black12)),
                                    child: Text(
                                      '7',
                                      style: TextStyle(
                                          fontFamily: FontColor.fontPoppins,
                                          fontSize: 26,
                                          fontWeight: FontWeight.w500,
                                          color: FontColor.black),
                                    )),
                                TextButton(
                                    onPressed: () async {

                                       await action(8);

                                    },
                                    style: const ButtonStyle(
                                        overlayColor:
                                        WidgetStatePropertyAll(Colors.black12)),
                                    child: Text(
                                      '8',
                                      style: TextStyle(
                                          fontFamily: FontColor.fontPoppins,
                                          fontSize: 26,
                                          fontWeight: FontWeight.w500,
                                          color: FontColor.black),
                                    )),
                                TextButton(
                                    onPressed: () async {

                                        await action(9);

                                    },
                                    style: const ButtonStyle(
                                        overlayColor:
                                        WidgetStatePropertyAll(Colors.black12)),
                                    child: Text(
                                      '9',
                                      style: TextStyle(
                                          fontFamily: FontColor.fontPoppins,
                                          fontSize: 26,
                                          fontWeight: FontWeight.w500,
                                          color: FontColor.black),
                                    )),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                    onPressed: null,
                                    style: const ButtonStyle(
                                        overlayColor:
                                        WidgetStatePropertyAll(Colors.black12)),
                                    child: Text(
                                      '',
                                      style: TextStyle(
                                          fontFamily: FontColor.fontPoppins,
                                          fontSize: 26,
                                          fontWeight: FontWeight.w500,
                                          color: FontColor.black),
                                    )),
                                TextButton(
                                    onPressed: () async {

                                        await action(0);

                                    },
                                    style: const ButtonStyle(
                                        overlayColor:
                                        WidgetStatePropertyAll(Colors.black12)),
                                    child: Text(
                                      '0',
                                      style: TextStyle(
                                          fontFamily: FontColor.fontPoppins,
                                          fontSize: 26,
                                          fontWeight: FontWeight.w500,
                                          color: FontColor.black),
                                    )),
                                TextButton(
                                    onPressed: () {
                                      setState(() {
                                        if (pin.isNotEmpty) {
                                          error = false;
                                          pin.removeLast();
                                        }
                                      });
                                    },
                                    style: const ButtonStyle(
                                        overlayColor:
                                        WidgetStatePropertyAll(Colors.black12)),
                                    child: const Icon(
                                      Icons.backspace,
                                      color: FontColor.black,
                                    ))
                              ],
                            ),
                          ),

                          widget.mode == 3 ?
                          TextButton(onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>  OtpScreen(mode: 1, email: Preferences.getUser()!.email,)));
                          }, child: const Text('Lupa PIN', style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: FontColor.yellow72,
                          ),)) : const SizedBox()
                        ],
                      ),
                    )
                  ],
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}
