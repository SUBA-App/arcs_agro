import 'package:enhanced_paginated_view/enhanced_paginated_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:arcs_agro/screen/product/product_item.dart';
import 'package:arcs_agro/screen/product/product_provider.dart';

import '../../font_color.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key, required this.drawer});

  final bool drawer;

  @override
  State<ProductScreen> createState() => _LaporanKerjaScreenState();
}

class _LaporanKerjaScreenState extends State<ProductScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false)
          .getProducts(context, 1);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: widget.drawer
          ? null
          : AppBar(
              backgroundColor: FontColor.yellow72,
              iconTheme: const IconThemeData(color: Colors.white),
              title: Text(
                "Produk",
                style: TextStyle(
                    fontFamily: FontColor.fontPoppins,
                    color: Colors.white,
                    fontSize: 16),
              ),
            ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: provider.searchC,
                cursorColor: FontColor.black,
                textInputAction: TextInputAction.search,
                style: TextStyle(
                    fontFamily: FontColor.fontPoppins,
                    fontWeight: FontWeight.w400,
                    color: FontColor.black,
                    fontSize: 14),
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    labelText: "Pencarian",
                    labelStyle: TextStyle(
                        fontFamily: FontColor.fontPoppins,
                        fontWeight: FontWeight.w400,
                        color: FontColor.black,
                        fontSize: 14),
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
                        )),
                    contentPadding: const EdgeInsets.all(8)),
                onSubmitted: (e) {
                  if (e.isNotEmpty) {
                    Provider.of<ProductProvider>(context, listen: false)
                        .searchFirst(context, 1, e);
                    Provider.of<ProductProvider>(context, listen: false)
                        .setMode(true);
                  }
                },
                onChanged: (e) {
                  if (e.isEmpty) {

                    Provider.of<ProductProvider>(context, listen: false)
                        .setMode(false);
                  }
                },
              ),
            ),
            provider.searchLoading
                ? const Expanded(
                    child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  ))
                : !provider.inSearch
                    ? Expanded(
                        child: EnhancedPaginatedView(
                          builder: (items, physics, reverse, shrinkWrap) {
                            return ListView.builder(
                              physics: physics,
                              shrinkWrap: shrinkWrap,
                              itemCount: items.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ProductItem(result: items[index]);
                              },
                            );
                          },
                          itemsPerPage: 20,
                          onLoadMore: (e) {
                            if (e > 1) {
                              Provider.of<ProductProvider>(context,
                                      listen: false)
                                  .loadMoreCust(context, e);
                            }
                          },
                          hasReachedMax: provider.isMaxReached,
                          delegate: EnhancedDelegate(
                            listOfData: provider.products,
                            status: provider.enhancedStatus,
                            header: Container(),
                          ),
                        ),
                      )
                    : Expanded(
                        child: EnhancedPaginatedView(
                          builder: (items, physics, reverse, shrinkWrap) {
                            return ListView.builder(
                              physics: physics,
                              shrinkWrap: shrinkWrap,
                              itemCount: items.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ProductItem(result: items[index]);
                              },
                            );
                          },
                          itemsPerPage: 20,
                          onLoadMore: (e) {
                            if (e > 1) {
                              Provider.of<ProductProvider>(context,
                                      listen: false)
                                  .search(context, e, provider.searchC.text);
                            }
                          },
                          hasReachedMax: provider.isMaxReached,
                          delegate: EnhancedDelegate(
                            listOfData: provider.products2,
                            status: provider.enhancedStatus,
                            header: Container(),
                          ),
                        ),
                      )
          ],
        ),
      ),
    );
  }
}
