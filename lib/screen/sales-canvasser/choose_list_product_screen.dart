import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:arcs_agro/api/response/receipts_response.dart';
import 'package:arcs_agro/screen/sales-canvasser/list_product_item.dart';
import 'package:arcs_agro/screen/sales-canvasser/receipts_provider.dart';

import '../../font_color.dart';

class ChooseListProductScreen extends StatefulWidget {
  const ChooseListProductScreen({
    super.key,
  });

  @override
  State<ChooseListProductScreen> createState() => _ChooseCustomerScreenState();
}

class _ChooseCustomerScreenState extends State<ChooseListProductScreen> {
  String currentSearch = '';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReceiptsProvider>(
        context,
        listen: false,
      ).listBarang(context, '');
    });
    super.initState();
  }

  bool onCheck(ReceiptsProvider provider) {
    for (var i in provider.listProduct) {
      if (i.checked) {
        return true;
      }
    }
    return false;
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
          "Pilih Barang",
          style: TextStyle(
            fontFamily: FontColor.fontPoppins,
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        actions: [
          onCheck(provider)
              ? IconButton(
                icon: const Icon(
                  Icons.check_circle_sharp,
                  size: 28,
                  color: FontColor.black,
                ),
                onPressed: () {
                  List<ListProduct> selecteds = [];
                  for (var i in Provider.of<ReceiptsProvider>(context, listen: false).listProduct) {
                    if (i.checked) {
                      selecteds.add(i);
                    }
                  }
                  Navigator.pop(context,{'selecteds': selecteds, 'id':Provider.of<ReceiptsProvider>(context, listen: false).responseListProductId});
                },
              )
              : const SizedBox(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              cursorColor: FontColor.black,
              textInputAction: TextInputAction.search,
              style: TextStyle(
                fontFamily: FontColor.fontPoppins,
                fontWeight: FontWeight.w400,
                color: FontColor.black,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                labelText: "Pencarian",
                labelStyle: TextStyle(
                  fontFamily: FontColor.fontPoppins,
                  fontWeight: FontWeight.w400,
                  color: FontColor.black,
                  fontSize: 14,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black26),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: FontColor.yellow72),
                ),
                contentPadding: const EdgeInsets.all(8),
              ),
              onSubmitted: (e) {
                if (e.isNotEmpty) {
                  currentSearch = e;
                  Provider.of<ReceiptsProvider>(
                    context,
                    listen: false,
                  ).listBarang(context, currentSearch);
                }
              },
              onChanged: (e) {
                if (e.isEmpty) {
                  currentSearch = '';
                  Provider.of<ReceiptsProvider>(
                    context,
                    listen: false,
                  ).listBarang(context, currentSearch);
                }
              },
            ),
            const SizedBox(height: 16),
            provider.isListProductLoading
                ? const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(color: FontColor.black),
                  ),
                )
                : Expanded(child: ListView.builder(
              itemCount: provider.listProduct.length,
                itemBuilder: (context, index) {
                  return ListProductItem(listProduct: provider.listProduct[index], onTap: () {
                    Provider.of<ReceiptsProvider>(context, listen: false).checkProduct(index);

                  },);
            }),),

          ],
        ),
      ),
    );
  }
}
