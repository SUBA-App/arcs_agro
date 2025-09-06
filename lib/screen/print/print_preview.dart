import 'package:arcs_agro/api/response/report_response.dart';
import 'package:arcs_agro/screen/print/print_screen.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/material.dart';
import 'package:arcs_agro/api/response/receipts_response.dart';

import 'package:arcs_agro/font_color.dart';
import 'package:arcs_agro/util.dart';

class PrintPreview extends StatefulWidget {
  const PrintPreview({super.key, this.receiptsData, this.reportData});

  final ReceiptsData? receiptsData;
  final ReportData? reportData;

  @override
  State<PrintPreview> createState() => _PrintPreviewState();
}

class _PrintPreviewState extends State<PrintPreview> {
  PaperSize _selectedPaperSize = PaperSize.mm80;
  List<PaperSize> papers = [PaperSize.mm58, PaperSize.mm72, PaperSize.mm80];

  @override
  void initState() {
    super.initState();
  }

  double mmToPixel(BuildContext context, double mm) {
    double dpi = 160 * MediaQuery.of(context).devicePixelRatio;
    return mm * dpi / 25.4;
  }

  Widget receiptPreview(ReceiptsData data, {double paperWidthMm = 80}) {
    int total = data.listProducts.fold(
      0,
      (sum, i) => sum + int.parse(i.productPrice) * i.productQuantity,
    );

    return Center(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  data.user.companyLetter,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const Center(
                child: Text('Distributor Pestisida & Alat Pertanian'),
              ),
              const Center(child: Text('0812-1234 5678')),
              const Divider(),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(data.no ?? ""),
                  Text('Salesman: ${data.user.name}'),
                ],
              ),
              Text('${data.dateAt} ${data.timeAt}'),
              Text('Nama Kios: ${data.storeName}'),
              const Divider(),

              const SizedBox(height: 8),

              ...data.listProducts.map((i) {
                int subtotal = int.parse(i.productPrice) * i.productQuantity;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      i.productName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${i.productQuantity} x Rp. ${Util.convertToIdr(int.parse(i.productPrice), 0)}',
                        ),
                        Text('Rp. ${Util.convertToIdr(subtotal, 0)}'),
                      ],
                    ),
                  ],
                );
              }).toList(),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'TOTAL',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Rp. ${Util.convertToIdr(total, 0)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Divider(),
              SizedBox(height: 80),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Divider(),
                        Center(child: Text('Nama & Stempel Kios')),
                      ],
                    ),
                  ),
                  SizedBox(width: 32),
                  Expanded(
                    child: Column(
                      children: [Divider(), Center(child: Text('Salesman'))],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Catatan
              const Center(
                child: Text(
                  'BUKTI INI HANYA TANDA TERIMA,\nBUKAN INVOICE!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(height: 8),
              // Kode unik
              const Center(
                child: Text(
                  'Kode Unik',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Center(
                child: Text(data.uniqueCode ?? '', textAlign: TextAlign.center),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget reportPreview(ReportData data) {
    return Center(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Center(
                child: Text(
                  data.salesCompanyLetter,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const Center(
                child: Text('Distributor Pestisida & Alat Pertanian'),
              ),
              Center(child: Text(data.salesCompanyTelephone ?? '')),
              const Divider(),

              // Info transaksi
              _buildRowLabelValue('No', data.no ?? ''),
              _buildRowLabelValue('Salesman', data.salesName ?? ''),
              _buildRowLabelValue('Nama Kios', data.storeName ?? ''),
              _buildRowLabelValue('Tgl & Jam', data.createdAt),
              const SizedBox(height: 8),

              // Payment info
              _buildRowLabelValue(
                'Nominal Pembayaran',
                'Rp. ${Util.convertToIdr(data.payment.amount, 0)}',
              ),
              _buildRowLabelValue(
                'Metode Pembayaran',
                data.payment.method == 1
                    ? 'TUNAI'
                    : data.payment.method == 2
                    ? 'TRANSFER'
                    : 'CEK/GIRO',
              ),
              if (data.payment.method == 2 || data.payment.method == 3)
                _buildRowLabelValue('Bank', data.payment.bankName ?? ''),
              if (data.payment.method == 3)
                _buildRowLabelValue('Nomor Giro', data.payment.noGiro ?? ''),
              _buildRowLabelValue(
                'Keterangan',
                data.note.isEmpty ? '-' : data.note,
              ),
              const SizedBox(height: 8),

              const Divider(),

              data.invoices.isNotEmpty
                  ? Column(
                    children: [
                      Row(
                        children: const [
                          Expanded(
                            child: Text(
                              'No Inv',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Tanggal',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Jumlah',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      ...data.invoices.map(
                        (i) => Row(
                          children: [
                            Expanded(
                              child: Text(
                                i.number,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                i.taxDateView,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Rp. ${Util.convertToIdr(i.totalAmount, 0)}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                  : Text(data.invoice),

              const Divider(),

              // Signature
              const SizedBox(height: 84),
              const Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Divider(),
                        Center(child: Text('Nama & Stempel Kios')),
                      ],
                    ),
                  ),
                  SizedBox(width: 32),
                  Expanded(
                    child: Column(
                      children: [Divider(), Center(child: Text('Salesman'))],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Kode unik
              const Center(
                child: Text(
                  'Kode Unik',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Center(
                child: Text(data.uniqueCode ?? '', textAlign: TextAlign.center),
              ),

              const SizedBox(height: 24),

              // Catatan
              const Center(
                child: Text(
                  'BUKTI INI HANYA TANDA TERIMA,\nBUKAN INVOICE!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRowLabelValue(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(label)),
          const Text(': '),
          Expanded(flex: 7, child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FontColor.blackF9,
      appBar: AppBar(
        backgroundColor: FontColor.yellow72,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Detail Tanda Terima",
          style: TextStyle(
            fontFamily: FontColor.fontPoppins,
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
      body: Column(
        children: [
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
                      color: FontColor.black,
                    ),
                    buttonStyleData: ButtonStyleData(
                      height: 40,
                      width: double.infinity,
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
                    onChanged: (value) {
                      setState(() {
                        _selectedPaperSize = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          widget.reportData == null
              ? Expanded(
                child: SingleChildScrollView(
                  child: receiptPreview(widget.receiptsData!),
                ),
              )
              : Expanded(
                child: SingleChildScrollView(
                  child: reportPreview(widget.reportData!),
                ),
              ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final templateC =
                      widget.reportData == null
                          ? await Util.templateReceipt(
                            widget.receiptsData!,
                            _selectedPaperSize,
                            'Sales Copy',
                          )
                          : await Util.templatePrintReport(
                            widget.reportData!,
                            _selectedPaperSize,
                            'Sales Copy',
                          );
                  final templateS =
                      widget.reportData == null
                          ? await Util.templateReceipt(
                            widget.receiptsData!,
                            _selectedPaperSize,
                            'Kios Copy',
                          )
                          : await Util.templatePrintReport(
                            widget.reportData!,
                            _selectedPaperSize,
                            'Kios Copy',
                          );
                  if (!context.mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => PrintScreen(
                            templateKios: templateS,
                            templateSales: templateC,
                            count: 1,
                          ),
                    ),
                  );
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
          ),
        ],
      ),
    );
  }
}
