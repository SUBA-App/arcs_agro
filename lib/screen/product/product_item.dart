import 'package:flutter/material.dart';

import 'package:sales_app/api/response/product_response.dart';

import '../../font_color.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key, required this.result});

  final ProductData result;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(result.productName, style: TextStyle(
                        fontFamily: FontColor.fontPoppins,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: FontColor.black
                    ),),
                    Row(
                      children: [
                        Text('Isi ${result.qty.isEmpty ? '-' : result.qty}', style: TextStyle(
                            fontFamily: FontColor.fontPoppins,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: FontColor.black
                        ),),
                        const SizedBox(width: 8,),
                        Text('Ukuran ${result.size}', style: TextStyle(
                            fontFamily: FontColor.fontPoppins,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: FontColor.black
                        ),),
                      ],
                    ),
                    Text(result.composition.isEmpty ? '-' : result.composition, style: TextStyle(
                        fontFamily: FontColor.fontPoppins,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: FontColor.black
                    ),),
                    Text('No ${result.productNo}', style: TextStyle(
                        fontFamily: FontColor.fontPoppins,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: FontColor.black.withOpacity(0.7)
                    ),),
                  ],
                ),
              ),
              result.show == 1 ?
              Text('16.000', style: TextStyle(
                  fontFamily: FontColor.fontPoppins,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: FontColor.black
              ),) : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
