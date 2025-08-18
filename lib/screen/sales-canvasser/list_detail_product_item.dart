import 'package:flutter/material.dart';
import '../../../font_color.dart';
import '../../api/response/receipts_response.dart';
import '../../util.dart';

class ListDetailProductItem extends StatelessWidget {
  const ListDetailProductItem({super.key, required this.listProduct});
  final ListProduct listProduct;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            blurRadius: 0.1,
            spreadRadius: 0.1,
            color: Color(0xffeaeaea),
          ),
        ],
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        border: Border.all(color: const Color(0xffeaeaea)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      listProduct.productName,
                      style: TextStyle(
                        fontFamily: FontColor.fontPoppins,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: FontColor.black,
                      ),
                    ),
                    Text(
                      '${listProduct.productQuantity} x ${Util.convertToIdr(int.parse(listProduct.productPrice), 0)}',
                      style: TextStyle(
                        fontFamily: FontColor.fontPoppins,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'Rp. ${Util.convertToIdr(listProduct.productQuantity*int.parse(listProduct.productPrice), 0)}',
                      style: TextStyle(
                        fontFamily: FontColor.fontPoppins,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}



