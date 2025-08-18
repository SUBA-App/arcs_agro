import 'dart:io';

import 'package:camera/camera.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/api/response/invoice_response.dart';
import 'package:sales_app/screen/report/choose_customer_screen.dart';
import 'package:sales_app/screen/report/choose_invoice_screen.dart';
import 'package:sales_app/screen/report/report_provider.dart';
import 'package:sales_app/util.dart';

import '../../currency_formatter.dart';
import '../../font_color.dart';
import '../absensi/take_picture_absensi_screen2.dart';

class AddLaporanScreen extends StatefulWidget {
  const AddLaporanScreen({super.key});

  @override
  State<AddLaporanScreen> createState() => _AddLaporanScreenState();
}

class _AddLaporanScreenState extends State<AddLaporanScreen> {
  Future<void> startDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
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
          ),
          child: child!,
        );
      },
      context: context,
      locale: const Locale("id"),
      currentDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 100)),
    );
    if (picked != null) {
      setState(() {
        final format = DateFormat('dd MMMM yyyy').format(picked);
        Provider.of<ReportProvider>(
          context,
          listen: false,
        ).setGiroDate(format, picked.millisecondsSinceEpoch);
      });
    }
  }

  Future<void> payDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
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
          ),
          child: child!,
        );
      },
      context: context,
      locale: const Locale("id"),
      firstDate: DateTime(2024, 1),
      lastDate: DateTime(2100, 1),
    );
    if (picked != null) {
      setState(() {
        final format = DateFormat('dd MMMM yyyy').format(picked);
        Provider.of<ReportProvider>(
          context,
          listen: false,
        ).setPayDate(format, picked.millisecondsSinceEpoch);
      });
    }
  }

  late CameraDescription cameraDescription;

  @override
  void initState() {
    ReportProvider.initController();
    availableCameras().then((e) {
      cameraDescription = e.first;
    });
    WidgetsBinding.instance.addPostFrameCallback((e) {
      Provider.of<ReportProvider>(context, listen: false).loadBanks(context);
      final dateTime = DateTime.now();
      final format = DateFormat('dd MMMM yyyy').format(dateTime);
      Provider.of<ReportProvider>(
        context,
        listen: false,
      ).setPayDate(format, dateTime.millisecondsSinceEpoch);
      Provider.of<ReportProvider>(context, listen: false).clearData();
    });

    super.initState();
  }

  @override
  void dispose() {
    ReportProvider.ket.dispose();
    ReportProvider.amount.dispose();
    ReportProvider.giroDate.dispose();
    ReportProvider.noGiro.dispose();
    super.dispose();
  }

  bool isKet = false;

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
            fontFamily: FontColor.fontPoppins,
            color: FontColor.black,
            fontSize: 16,
          ),
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
                    InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () {
                        payDate(context);
                      },
                      child: Card(
                        color: Colors.white,
                        shadowColor: Colors.white,
                        surfaceTintColor: Colors.grey,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/images/daily-calendar.png',
                                    width: 16,
                                    height: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Tanggal Pembayaran',
                                    style: TextStyle(
                                      fontFamily: FontColor.fontPoppins,
                                      color: Colors.black54,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                provider.selectedPayDate,
                                style: TextStyle(
                                  fontFamily: FontColor.fontPoppins,
                                  color: FontColor.black,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChooseCustomerScreen(),
                          ),
                        );
                        if (result != null) {
                          if (context.mounted) {
                            Provider.of<ReportProvider>(
                              context,
                              listen: false,
                            ).setKios(result['name'], result['id']);
                          }
                        }
                      },
                      child: Card(
                        color: Colors.white,
                        shadowColor: Colors.white,
                        surfaceTintColor: Colors.grey,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/images/store-alt.png',
                                    width: 16,
                                    height: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Nama Kios',
                                    style: TextStyle(
                                      fontFamily: FontColor.fontPoppins,
                                      color: Colors.black54,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                provider.selectedKios,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: FontColor.fontPoppins,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => ChooseInvoiceScreen(
                                  customerId:
                                      provider.selectedKiosId.toString(),
                                  customerName: provider.selectedKios,
                                ),
                          ),
                        );
                        if (result != null) {
                          if (context.mounted) {
                            Provider.of<ReportProvider>(
                              context,
                              listen: false,
                            ).setInvoice(result['selecteds'] as List<InvoiceData>);
                          }
                        }
                      },
                      child: Card(
                        color: Colors.white,
                        shadowColor: Colors.white,
                        surfaceTintColor: Colors.grey,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/images/receipt.png',
                                    width: 16,
                                    height: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Invoice',
                                    style: TextStyle(
                                      fontFamily: FontColor.fontPoppins,
                                      color: Colors.black54,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              provider.selectedInvoices.isEmpty
                                  ? Text(
                                    'Pilih Invoice',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: FontColor.fontPoppins,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                  : ListView.builder(
                                shrinkWrap: true,
                                itemCount: provider.selectedInvoices.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: const EdgeInsets.symmetric(vertical: 4),
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10)
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              provider.selectedInvoices[index].number,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: FontColor.fontPoppins,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            const SizedBox(height: 4,),
                                            Text(
                                              'Rp ${Util.convertToIdr(provider.selectedInvoices[index].piutang, 0)}',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: FontColor.fontPoppins,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField(
                      dropdownColor: Colors.white,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: FontColor.fontPoppins,
                        fontWeight: FontWeight.w400,
                      ),
                      value: provider.selectedMethod,
                      items:
                          provider.methods.map((e) {
                            return DropdownMenuItem(
                              value: e,
                              child: Text(
                                e.name,
                                style: TextStyle(
                                  fontFamily: FontColor.fontPoppins,
                                  fontWeight: FontWeight.w400,
                                  color: FontColor.black,
                                ),
                              ),
                            );
                          }).toList(),
                      hint: Text(
                        "Pilih Metode Pembayaran",
                        style: TextStyle(
                          fontFamily: FontColor.fontPoppins,
                          fontWeight: FontWeight.w400,
                          color: FontColor.black,
                        ),
                      ),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: (value) {
                        Provider.of<ReportProvider>(
                          context,
                          listen: false,
                        ).setMethod(value!);
                      },
                    ),
                    const SizedBox(height: 8),
                    provider.selectedMethod?.id == 3
                        ? Column(
                          children: [
                            TextField(
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: FontColor.fontPoppins,
                                fontWeight: FontWeight.w400,
                              ),
                              controller: ReportProvider.noGiro,
                              cursorColor: FontColor.black,
                              decoration: InputDecoration(
                                labelText: "Masukkan Nomor Cek/Giro",
                                labelStyle: TextStyle(
                                  fontFamily: FontColor.fontPoppins,
                                  fontWeight: FontWeight.w400,
                                  color: FontColor.black.withValues(alpha: 0.7),
                                  fontSize: 14,
                                ),
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
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: FontColor.fontPoppins,
                                fontWeight: FontWeight.w400,
                              ),
                              cursorColor: FontColor.black,
                              readOnly: true,
                              controller: ReportProvider.giroDate,
                              decoration: InputDecoration(
                                suffixIcon: const Icon(
                                  Icons.calendar_month_rounded,
                                ),
                                hintText: "Pilih Tanggal Jatuh Tempo",
                                hintStyle: TextStyle(
                                  fontFamily: FontColor.fontPoppins,
                                  fontWeight: FontWeight.w400,
                                  color: FontColor.black.withValues(alpha: 0.7),
                                ),
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
                                  ),
                                ),
                              ),
                              onTap: () {
                                startDate(context);
                              },
                            ),
                            const SizedBox(height: 16),
                          ],
                        )
                        : const SizedBox.shrink(),
                    provider.selectedMethod?.id == 2 ||
                            provider.selectedMethod?.id == 3
                        ? GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.white,
                              builder: (context) {
                                final provider2 = Provider.of<ReportProvider>(
                                  context,
                                );
                                return Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Pilih Bank",
                                        style: TextStyle(
                                          fontFamily: FontColor.fontPoppins,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      SearchBar(
                                        backgroundColor:
                                            const WidgetStatePropertyAll(
                                              Color(0xFFf0f0f0),
                                            ),
                                        elevation: const WidgetStatePropertyAll(
                                          0,
                                        ),
                                        padding: const WidgetStatePropertyAll(
                                          EdgeInsets.all(8),
                                        ),
                                        hintText: "Cari Nama Bank",
                                        hintStyle: WidgetStatePropertyAll(
                                          TextStyle(
                                            fontFamily: FontColor.fontPoppins,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        shape: WidgetStatePropertyAll(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                        leading: const Icon(
                                          Icons.search,
                                          color: Colors.grey,
                                        ),
                                        onChanged: (e) {
                                          Provider.of<ReportProvider>(
                                            context,
                                            listen: false,
                                          ).searchBank(e);
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: provider2.banks.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                                Provider.of<ReportProvider>(
                                                  context,
                                                  listen: false,
                                                ).setBank(
                                                  provider.banks[index],
                                                );
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 16,
                                                    ),
                                                decoration: const BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                      color: Colors.black12,
                                                    ),
                                                  ),
                                                ),
                                                child: Text(
                                                  provider2.banks[index].name,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        FontColor.fontPoppins,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  provider.selectedBank == null
                                      ? "Pilih Bank"
                                      : provider.selectedBank!.name,
                                  style: TextStyle(
                                    fontFamily: FontColor.fontPoppins,
                                    fontSize: 14,
                                    color:
                                        provider.selectedBank == null
                                            ? FontColor.black.withValues(
                                              alpha: 0.7,
                                            )
                                            : FontColor.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black54,
                                ),
                              ],
                            ),
                          ),
                        )
                        : const SizedBox(),
                    const SizedBox(height: 16),
                    provider.selectedMethod != null
                        ? TextField(
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: FontColor.fontPoppins,
                            fontWeight: FontWeight.w400,
                          ),
                          cursorColor: FontColor.black,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            CurrencyInputFormatter(),
                          ],
                          controller: ReportProvider.amount,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Masukkan Nominal",
                            labelStyle: TextStyle(
                              fontFamily: FontColor.fontPoppins,
                              fontWeight: FontWeight.w400,
                              color: FontColor.black.withValues(alpha: 0.7),
                              fontSize: 14,
                            ),
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
                              ),
                            ),
                          ),
                        )
                        : const SizedBox.shrink(),
                    const SizedBox(height: 8),
                    Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Checkbox(
                                value: isKet,
                                onChanged: (v) {
                                  setState(() {
                                    isKet = v!;
                                  });
                                  ReportProvider.ket.clear();
                                },
                                activeColor: FontColor.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                            Text(
                              "Tambah Keterangan",
                              style: TextStyle(
                                fontFamily: FontColor.fontPoppins,
                                fontWeight: FontWeight.w400,
                                color: FontColor.black,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        isKet
                            ? TextField(
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: FontColor.fontPoppins,
                                fontWeight: FontWeight.w400,
                              ),
                              cursorColor: FontColor.black,
                              controller: ReportProvider.ket,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: InputDecoration(
                                labelText: "Keterangan",
                                labelStyle: TextStyle(
                                  fontFamily: FontColor.fontPoppins,
                                  fontWeight: FontWeight.w400,
                                  color: FontColor.black.withValues(alpha: 0.7),
                                  fontSize: 14,
                                ),
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
                                  ),
                                ),
                              ),
                            )
                            : const SizedBox(),
                      ],
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextButton(
                                    onPressed: () async {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) =>
                                                  TakePictureAbsensiScreen2(
                                                    camera: cameraDescription,
                                                    mode: 2,
                                                  ),
                                        ),
                                      );
                                      if (result != null) {
                                        if (context.mounted) {
                                          Navigator.pop(context);
                                          Provider.of<ReportProvider>(
                                            context,
                                            listen: false,
                                          ).setImage(result);
                                        }
                                      }
                                    },
                                    child: Text(
                                      'Kamera',
                                      style: TextStyle(
                                        fontFamily: FontColor.fontPoppins,
                                        fontSize: 14,
                                        color: FontColor.black,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      List<File> files = [];
                                      final picker = await ImagePicker()
                                          .pickMultiImage(
                                            maxWidth: 1080,
                                            maxHeight: 1920,
                                          );
                                      if (picker.isNotEmpty) {
                                        for (var i in picker) {
                                          files.add(File(i.path));
                                        }
                                        if (context.mounted) {
                                          Navigator.pop(context);
                                          Provider.of<ReportProvider>(
                                            context,
                                            listen: false,
                                          ).setImage(files);
                                        }
                                      }
                                    },
                                    child: Text(
                                      'Galeri',
                                      style: TextStyle(
                                        fontFamily: FontColor.fontPoppins,
                                        fontSize: 14,
                                        color: FontColor.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFFfcfcfc),
                          border: Border.all(color: Colors.black26),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tambah Foto',
                              style: TextStyle(
                                fontFamily: FontColor.fontPoppins,
                                fontSize: 14,
                                color: FontColor.black,
                              ),
                            ),
                            Image.asset(
                              'assets/images/add-image.png',
                              width: 16,
                              height: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: provider.selectedListImage.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 200,
                              margin: const EdgeInsets.only(top: 8),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black12),
                              ),
                              child: Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    provider.selectedListImage[index],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 16,
                              right: 8,
                              child: SizedBox(
                                width: 25,
                                height: 25,
                                child: IconButton(
                                  onPressed: () {
                                    Provider.of<ReportProvider>(
                                      context,
                                      listen: false,
                                    ).removeImage(
                                      Provider.of<ReportProvider>(
                                        context,
                                        listen: false,
                                      ).selectedListImage[index],
                                    );
                                  },
                                  style: const ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                      Colors.red,
                                    ),
                                    padding: WidgetStatePropertyAll(
                                      EdgeInsets.zero,
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.clear,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await Provider.of<ReportProvider>(
                    context,
                    listen: false,
                  ).addReport(context);
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
                  "Submit",
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
      ),
    );
  }
}
