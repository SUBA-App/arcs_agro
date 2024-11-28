import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/screen/report/choose_customer_screen.dart';
import 'package:sales_app/screen/report/choose_invoice_screen.dart';
import 'package:sales_app/screen/report/report_provider.dart';

import '../../currency_formatter.dart';
import '../../font_color.dart';

class AddLaporanScreen extends StatefulWidget {
  const AddLaporanScreen({super.key});

  @override
  State<AddLaporanScreen> createState() => _AddLaporanScreenState();
}

class _AddLaporanScreenState extends State<AddLaporanScreen> {

  Future<void> startDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      builder: (context, child) {
        return Theme(data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
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
        final format = DateFormat('dd MMMM yyyy').format(picked);
        Provider.of<ReportProvider>(context, listen: false).setGiroDate(format);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ReportProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: FontColor.yellow72,
        iconTheme: const IconThemeData(color: FontColor.black),
        title: Text(
          "Tambah Laporan",
          style: TextStyle(
              fontFamily: FontColor.fontPoppins, color: FontColor.black, fontSize: 16),
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
                    GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const ChooseCustomerScreen()));
                        if (result != null) {
                          Provider.of<ReportProvider>(context, listen: false).setKios(result['name'], result['id']);
                        }
                      },
                      child: Card(
                        color: Colors.white,
                        child: Container(
                          height: 45,
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(provider.selectedKios, style: TextStyle(
                                fontSize: 14,
                                fontFamily: FontColor.fontPoppins,
                                fontWeight: FontWeight.w400,
                              ),),
                              const Icon(Icons.keyboard_arrow_right, color: Colors.black54,)
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => ChooseInvoiceScreen(customerId: provider.selectedKiosId.toString())));
                        if (result != null) {
                          Provider.of<ReportProvider>(context, listen: false).setInvoice(result['id']);
                        }
                      },
                      child: Card(
                        color: Colors.white,
                        child: Container(
                          height: 45,
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(provider.selectedInvoiceId == 0 ? 'Pilih Invoice' : provider.selectedInvoiceId.toString(), style: TextStyle(
                                fontSize: 14,
                                fontFamily: FontColor.fontPoppins,
                                fontWeight: FontWeight.w400,
                              ),),
                              const Icon(Icons.keyboard_arrow_right, color: Colors.black54,)
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    DropdownButtonFormField(
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: FontColor.fontPoppins,
                          fontWeight: FontWeight.w400,
                        ),
                        value: provider.selectedMethod,
                        items: provider.methods.map((e) {
                          return DropdownMenuItem(
                              value: e,
                              child: Text(
                                e.name,
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
                                borderSide: const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10))),
                        onChanged: (value) {
                         Provider.of<ReportProvider>(context, listen: false).setMethod(value!);
                        }),
                    const SizedBox(
                      height: 16,
                    ),
                    provider.selectedMethod?.id == 3
                        ? Column(
                      children: [
                        TextField(
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: FontColor.fontPoppins,
                            fontWeight: FontWeight.w400,
                          ),
                          controller: provider.noGiro,
                          cursorColor: FontColor.black,
                          decoration: InputDecoration(
                              labelText: "Masukkan Nomor Cek/Giro",
                              labelStyle: TextStyle(
                                  fontFamily: FontColor.fontPoppins,
                                  fontWeight: FontWeight.w400,
                                  color: FontColor.black, fontSize: 14),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.black26,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: FontColor.yellow72,
                                  ))),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextField(
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: FontColor.fontPoppins,
                            fontWeight: FontWeight.w400,
                          ),
                          cursorColor: FontColor.black,
                          readOnly: true,
                          controller: provider.giroDate,
                          decoration: InputDecoration(
                              suffixIcon: const Icon(Icons.calendar_month_rounded),
                              hintText: "Pilih Tanggal Jatuh Tempo",
                              hintStyle: TextStyle(
                                  fontFamily: FontColor.fontPoppins,
                                  fontWeight: FontWeight.w400,
                                  color: FontColor.black),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.black26,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: FontColor.yellow72,
                                  ))),
                          onTap: () {
                            startDate(context);
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    )
                        : const SizedBox.shrink(),
                    provider.selectedMethod?.id == 2 ? TextField(
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: FontColor.fontPoppins,
                        fontWeight: FontWeight.w400,
                      ),
                      cursorColor: FontColor.black,
                      controller: provider.bankName,
                      decoration: InputDecoration(
                          hintText: "Nama Bank",
                          hintStyle: TextStyle(
                              fontFamily: FontColor.fontPoppins,
                              fontWeight: FontWeight.w400,
                              color: FontColor.black),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.black26,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: FontColor.yellow72,
                              ))),
                    ) : const SizedBox(),
                    const SizedBox(height: 16,),
                    provider.selectedMethod != null ? TextField(
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: FontColor.fontPoppins,
                        fontWeight: FontWeight.w400,
                      ),
                      cursorColor: FontColor.black,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CurrencyInputFormatter()
                      ],
                      controller: provider.amount,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: "Masukkan Nominal",
                          labelStyle: TextStyle(
                              fontFamily: FontColor.fontPoppins,
                              fontWeight: FontWeight.w400,
                              color: FontColor.black, fontSize: 14),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.black26,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: FontColor.yellow72,
                              ))),
                    ) :const SizedBox.shrink(),
                    const SizedBox(
                      height: 16,
                    ),
                    provider.selectedMethod?.id == 2 || provider.selectedMethod?.id == 3 ? GestureDetector(
                      onTap: () async {
                        final picker = await ImagePicker().pickImage(source: ImageSource.gallery);
                        if (picker != null) {
                          final file = File(picker.path);
                          Provider.of<ReportProvider>(context, listen: false).setImage(file);
                        }
                      },
                      child: SizedBox(
                        width: double.infinity,
                        height: 200,
                        child: DottedBorder(
                            color: Colors.grey,
                            radius: const Radius.circular(10),
                            strokeWidth: 1,
                            child: Center(child: provider.selectedImage == null ? Image.asset('assets/images/new.png', width: 50,height: 50,) : Image.file(provider.selectedImage!))),
                      ),
                    ) : const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: () async {
                await Provider.of<ReportProvider>(context, listen: false).addReport(context);
              },
                  style: ButtonStyle(
                    backgroundColor: const WidgetStatePropertyAll(Colors.black),
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    ))
                  ),
                  child: Text("Submit", style: TextStyle(
                fontFamily: FontColor.fontPoppins,
                color: Colors.white,
                fontSize: 14
              ),)),
            )
            
          ],
        ),
      ),
    );
  }
}
