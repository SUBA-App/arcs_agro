import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:arcs_agro/api/response/receipts_response.dart';
import 'package:arcs_agro/screen/sales-canvasser/choose_list_product_screen.dart';
import 'package:arcs_agro/screen/sales-canvasser/list_product_item.dart';
import 'package:arcs_agro/screen/sales-canvasser/receipts_provider.dart';

import '../../font_color.dart';
import '../../refresh_controller.dart';
import '../../util.dart';
import '../report/choose_customer_screen.dart';

class AddReceiptScreen extends StatefulWidget {
  const AddReceiptScreen({super.key});

  @override
  State<AddReceiptScreen> createState() => _AddReceiptScreenState();
}

class _AddReceiptScreenState extends State<AddReceiptScreen> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((e) {
      Provider.of<ReceiptsProvider>(context, listen: false).clearData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ReceiptsProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: FontColor.yellow72,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Tambah Tanda Terima",
          style: TextStyle(
            fontFamily: FontColor.fontPoppins,
            color: Colors.white,
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
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChooseCustomerScreen(),
                          ),
                        );
                        if (result != null) {
                          if (context.mounted) {
                            Provider.of<ReceiptsProvider>(
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
                                (context) => const ChooseListProductScreen(
                            ),
                          ),
                        );
                        if (result != null) {
                          if (context.mounted) {
                            Provider.of<ReceiptsProvider>(
                              context,
                              listen: false,
                            ).setListProducts(result['selecteds'] as List<ListProduct>, result['id']);
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
                                    'Barang',
                                    style: TextStyle(
                                      fontFamily: FontColor.fontPoppins,
                                      color: Colors.black54,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              provider.selectedProduct.isEmpty
                                  ? Text(
                                'Pilih Barang',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: FontColor.fontPoppins,
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                                  : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: provider.selectedProduct.length,
                                itemBuilder: (context, index) {
                                  return ListProductItem(listProduct: provider.selectedProduct[index], onMin: () {
                                    Provider.of<ReceiptsProvider>(context, listen: false).qtyMin(index);
                                  },onPlus: (){
                                    Provider.of<ReceiptsProvider>(context, listen: false).qtyPlus(index);
                                  },onChanged: (e) {
                                    Provider.of<ReceiptsProvider>(context, listen: false).setPrice(index, e.isEmpty ? "0" : e);
                                  },);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await Provider.of<ReceiptsProvider>(
                    context,
                    listen: false,
                  ).addReceipt(context);
                  RefreshController.refresh();
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
