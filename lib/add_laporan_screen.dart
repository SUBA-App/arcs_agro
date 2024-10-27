import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'font_color.dart';

class AddLaporanScreen extends StatefulWidget {
  const AddLaporanScreen({super.key});

  @override
  State<AddLaporanScreen> createState() => _AddLaporanScreenState();
}

class _AddLaporanScreenState extends State<AddLaporanScreen> {
  List<String> metode = ['Tunai', 'Cek/Giro', 'Transfer'];
  String? selectedMetode = null;
  String selectedDate = '';
  File? selectedImage = null;
  final dateController = TextEditingController();

  Future<void> startDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      builder: (context, child) {
        return Theme(data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: FontColor.yellow72, // header background color
            onPrimary: Colors.black, // header text color
            onSurface: FontColor.black, // body text color
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: FontColor.black, // button text color
            ),
          ),
        ), child: child!);
      },
        context: context,
        locale: const Locale("id"),
        firstDate: DateTime(2024, 1),
        lastDate: DateTime.now());
    if (picked != null) {
      setState(() {
        selectedDate = picked.toIso8601String();
        dateController.text = selectedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: FontColor.yellow72,
        iconTheme: IconThemeData(color: FontColor.black),
        title: Text(
          "Tambah Laporan",
          style: TextStyle(
              fontFamily: FontColor.fontPoppins, color: FontColor.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    DropdownButtonFormField(
                        value: null,
                        items: ['Warung Ayu'].map((e) {
                          return DropdownMenuItem(
                              value: e,
                              child: Text(
                                e,
                                style: TextStyle(
                                    fontFamily: FontColor.fontPoppins,
                                    fontWeight: FontWeight.w400,
                                    color: FontColor.black),
                              ));
                        }).toList(),
                        hint: Text(
                          "Pilih Nama Kios",
                          style: TextStyle(
                              fontFamily: FontColor.fontPoppins,
                              fontWeight: FontWeight.w400,
                              color: FontColor.black),
                        ),
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10))),
                        onChanged: (value) {}),
                    SizedBox(
                      height: 16,
                    ),
                    DropdownButtonFormField(
                        value: null,
                        items: ['Invoice-454867'].map((e) {
                          return DropdownMenuItem(
                              value: e,
                              child: Text(
                                e,
                                style: TextStyle(
                                    fontFamily: FontColor.fontPoppins,
                                    fontWeight: FontWeight.w400,
                                    color: FontColor.black),
                              ));
                        }).toList(),
                        hint: Text(
                          "Pilih Invoice",
                          style: TextStyle(
                              fontFamily: FontColor.fontPoppins,
                              fontWeight: FontWeight.w400,
                              color: FontColor.black),
                        ),
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10))),
                        onChanged: (value) {}),
                    SizedBox(
                      height: 16,
                    ),
                    DropdownButtonFormField(
                        value: selectedMetode,
                        items: metode.map((e) {
                          return DropdownMenuItem(
                              value: e,
                              child: Text(
                                e,
                                style: TextStyle(
                                    fontFamily: FontColor.fontPoppins,
                                    fontWeight: FontWeight.w400,
                                    color: FontColor.black),
                              ));
                        }).toList(),
                        hint: Text(
                          "Pilih Metode Pembayaran",
                          style: TextStyle(
                              fontFamily: FontColor.fontPoppins,
                              fontWeight: FontWeight.w400,
                              color: FontColor.black),
                        ),
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10))),
                        onChanged: (value) {
                          selectedMetode = value;
                          setState(() {});
                        }),
                    SizedBox(
                      height: 16,
                    ),
                    selectedMetode == 'Cek/Giro'
                        ? Column(
                      children: [
                        TextField(
                          cursorColor: FontColor.black,
                          decoration: InputDecoration(
                              labelText: "Masukkan Nomor Cek/Giro",
                              labelStyle: TextStyle(
                                  fontFamily: FontColor.fontPoppins,
                                  fontWeight: FontWeight.w400,
                                  color: FontColor.black),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.black26,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: FontColor.yellow72,
                                  ))),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        TextField(
                          cursorColor: FontColor.black,
                          readOnly: true,
                          controller: dateController,
                          decoration: InputDecoration(
                              suffixIcon: Icon(Icons.calendar_month_rounded),
                              hintText: "Pilih Tanggal Jatuh Tempo",
                              hintStyle: TextStyle(
                                  fontFamily: FontColor.fontPoppins,
                                  fontWeight: FontWeight.w400,
                                  color: FontColor.black),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.black26,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: FontColor.yellow72,
                                  ))),
                          onTap: () {
                            startDate(context);
                          },
                        ),
                        SizedBox(
                          height: 16,
                        ),
                      ],
                    )
                        : SizedBox.shrink(),
                    selectedMetode == 'Transfer' ? DropdownButtonFormField(
                        value: null,
                        items: ['BNI'].map((e) {
                          return DropdownMenuItem(
                              value: e,

                              child: Text(
                                e,
                                style: TextStyle(
                                    fontFamily: FontColor.fontPoppins,
                                    fontWeight: FontWeight.w400,
                                    color: FontColor.black),
                              ));
                        }).toList(),
                        hint: Text(
                          "Pilih Bank",
                          style: TextStyle(
                              fontFamily: FontColor.fontPoppins,
                              fontWeight: FontWeight.w400,
                              color: FontColor.black),
                        ),
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10))),
                        onChanged: (value) {
                          selectedMetode = value;
                          setState(() {});
                        }) : SizedBox(),
                    SizedBox(height: 16,),
                    selectedMetode != null ? TextField(
                      cursorColor: FontColor.black,
                      decoration: InputDecoration(
                          labelText: "Masukkan Nominal",
                          labelStyle: TextStyle(
                              fontFamily: FontColor.fontPoppins,
                              fontWeight: FontWeight.w400,
                              color: FontColor.black),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.black26,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: FontColor.yellow72,
                              ))),
                    ) :SizedBox.shrink(),
                    SizedBox(
                      height: 16,
                    ),
                    selectedMetode != null ? GestureDetector(
                      onTap: () async {
                        final picker = await ImagePicker().pickImage(source: ImageSource.gallery);
                        if (picker != null) {
                          final file = File(picker.path);
                          selectedImage = file;
                          setState(() {
              
                          });
                        }
                      },
                      child: SizedBox(
                        width: double.infinity,
                        height: 200,
                        child: DottedBorder(
                            color: Colors.grey,
                            radius: Radius.circular(10),
                            strokeWidth: 1,
                            child: Center(child: selectedImage == null ? Image.asset('assets/images/new.png', width: 50,height: 50,) : Image.file(selectedImage!))),
                      ),
                    ) : SizedBox.shrink(),
                  ],
                ),
              ),
            ),
            ElevatedButton(onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.green),
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)
                  ))
                ),
                child: Text("Submit", style: TextStyle(
              fontFamily: FontColor.fontPoppins,
              color: Colors.white,
              fontSize: 14
            ),))
            
          ],
        ),
      ),
    );
  }
}
