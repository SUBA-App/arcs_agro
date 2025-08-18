import 'dart:io';

import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:sales_app/refresh_controller.dart';
import 'package:sales_app/util.dart';

import '../../font_color.dart';

class PrintScreen extends StatefulWidget {
  const PrintScreen({super.key, required this.template, required this.count});

  final List<int> template;
  final int count;

  @override
  State<PrintScreen> createState() => _PrintScreenState();
}

class _PrintScreenState extends State<PrintScreen> {
  bool isLoading = false;
  bool isEmpty = true;

  List<BluetoothInfo> _devices = [];

  Future<void> _scan() async {
    await requestBluetoothPermissions();
    bool active = await PrintBluetoothThermal.bluetoothEnabled;

    if (active) {
      setState(() {
        isLoading = true;
      });
      final List<BluetoothInfo> result =
          await PrintBluetoothThermal.pairedBluetooths;
      setState(() {
        isLoading = false;
        _devices.clear();
        _devices = result;
      });
    } else {
      if (Platform.isAndroid) {
        await enableBluetoothIfNeeded();
        setState(() {
          isLoading = true;
        });
        final List<BluetoothInfo> result =
            await PrintBluetoothThermal.pairedBluetooths;
        setState(() {
          isLoading = false;
          _devices.clear();
          _devices = result;
        });
      } else {
        //For IOS
      }
    }
  }

  Future<void> enableBluetoothIfNeeded() async {
    var state = await FlutterBluePlus.adapterState.first;
    if (state != BluetoothAdapterState.on) {
      await FlutterBluePlus.turnOn();
    }
  }

  Future<void> _connect(String macAddress, BuildContext context) async {
    Util.showLoading(context);
    bool isConnected = await PrintBluetoothThermal.connectionStatus;
    if (isConnected) {
      await PrintBluetoothThermal.disconnect;
    }
    bool connected = await PrintBluetoothThermal.connect(
      macPrinterAddress: macAddress,
    );
    if (connected) {
      if (!context.mounted) return;
      for (int i = 1; i <= widget.count; i++) {
        await printStruk(context, i);
      }
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghubungkan ke printer ($macAddress)')),
      );
    }
    if (!context.mounted) return;
    Navigator.pop(context);
  }

  Future<void> printStruk(BuildContext context, int currentCount) async {
    bool isConnected = await PrintBluetoothThermal.connectionStatus;
    if (!isConnected) {
      if (kDebugMode) {
        print("Printer belum terhubung");
      }
      return;
    }
    // Kirim ke printer
    await PrintBluetoothThermal.writeBytes(widget.template);

    if (!context.mounted) return;
    if (currentCount == widget.count) {
      RefreshController.refresh();
      Navigator.pop(context);
    }
  }

  Future<void> requestBluetoothPermissions() async {
    if (Platform.isAndroid) {
      if (await Permission.bluetoothScan.isDenied) {
        await Permission.bluetoothScan.request();
      }
      if (await Permission.bluetoothConnect.isDenied) {
        await Permission.bluetoothConnect.request();
      }
      if (await Permission.bluetoothAdvertise.isDenied) {
        await Permission.bluetoothAdvertise.request();
      }

      if (await Permission.locationWhenInUse.isDenied) {
        await Permission.locationWhenInUse.request();
      }
    } else if (Platform.isIOS) {
      if (await Permission.bluetooth.isDenied) {
        await Permission.bluetooth.request();
      }
    }
  }

  List<PaperSize> papers = [PaperSize.mm58, PaperSize.mm72, PaperSize.mm80];

  @override
  void initState() {
    _scan();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: FontColor.yellow72,
        iconTheme: const IconThemeData(color: FontColor.black),
        title: Text(
          "Pilih Device",
          style: TextStyle(
            fontFamily: FontColor.fontPoppins,
            color: FontColor.black,
            fontSize: 16,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              _scan();
            },
            icon: const Icon(Icons.refresh, color: Colors.black54),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ukuran',
                    style: TextStyle(
                      fontFamily: FontColor.fontPoppins,
                      color: FontColor.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 4),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2<PaperSize>(
                      style: TextStyle(
                        fontFamily: FontColor.fontPoppins,
                        color: FontColor.black
                      ),
                      buttonStyleData: ButtonStyleData(
                        height: 40,
                        width: 160,
                        padding: const EdgeInsets.only(left: 14, right: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.black26),
                          color: Colors.white,
                        ),
                        elevation: 0,
                      ),
                      iconStyleData: const IconStyleData(
                        icon: Icon(Icons.keyboard_arrow_down_rounded),
                        iconSize: 14,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        maxHeight: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Colors.white,
                        ),
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        height: 40,
                        padding: EdgeInsets.only(left: 14, right: 14),
                      ),
                      items:
                          papers.map((e) {
                            return DropdownMenuItem(
                              value: e,
                              child: Text(
                                e == PaperSize.mm58
                                    ? "58mm"
                                    : e == PaperSize.mm72
                                    ? "72mm"
                                    : "80mm",
                              ),
                            );
                          }).toList(),
                      value: _selectedPaperSize,
                      onChanged: (value) {},
                    ),
                  ),
                ],
              ),
            ),

             */
            isLoading
                ? const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(color: FontColor.black),
                  ),
                )
                : _devices.isEmpty
                ? Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        "Tidak ada perangkat yang terhubung. Silakan pairing printer di pengaturan Bluetooth.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: FontColor.fontPoppins,
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: FontColor.black,
                        ),
                      ),
                    ),
                  ),
                )
                : Expanded(
                  child: ListView.builder(
                    itemCount: _devices.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () async {
                          await _connect(_devices[index].macAdress, context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          margin: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withAlpha(15),
                                spreadRadius: 1,
                                blurRadius: 0,
                                offset: const Offset(
                                  0,
                                  1,
                                ), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.print_rounded,
                                    color: FontColor.black,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _devices[index].name,
                                    style: TextStyle(
                                      fontFamily: FontColor.fontPoppins,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
