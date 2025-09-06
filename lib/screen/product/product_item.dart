import 'package:flutter/material.dart';
import 'package:arcs_agro/api/response/product_response.dart';
import 'package:arcs_agro/util.dart';
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
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nama produk
              Text(
                result.productName,
                style: TextStyle(
                  fontFamily: FontColor.fontPoppins,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: FontColor.black,
                ),
              ),
              const SizedBox(height: 6),
              // Qty dan ukuran
              Row(
                children: [
                  Text(
                    'Isi: ${result.qty.isEmpty ? '-' : result.qty}',
                    style: TextStyle(
                      fontFamily: FontColor.fontPoppins,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: FontColor.black,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Ukuran: ${result.size}',
                    style: TextStyle(
                      fontFamily: FontColor.fontPoppins,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: FontColor.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              // Komposisi
              Text(
                result.composition.isEmpty ? '-' : result.composition,
                style: TextStyle(
                  fontFamily: FontColor.fontPoppins,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: FontColor.black,
                ),
              ),
              const SizedBox(height: 2),
              // Nomor produk
              Text(
                'No: ${result.productNo}',
                style: TextStyle(
                  fontFamily: FontColor.fontPoppins,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: FontColor.black.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 8),
              // Harga
              if (result.show == 1)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (result.price != 0 || result.priceR2 != 0)
                      Text(
                        'Harga',
                        style: TextStyle(
                          fontFamily: FontColor.fontPoppins,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: FontColor.black,
                        ),
                      ),
                    if (result.price != 0)
                      Text(
                        'R1: ${Util.convertToIdr(result.price, 0)}',
                        style: TextStyle(
                          fontFamily: FontColor.fontPoppins,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: FontColor.black,
                        ),
                      ),
                    if (result.priceR2 != 0)
                      Text(
                        'R2: ${Util.convertToIdr(result.priceR2, 0)}',
                        style: TextStyle(
                          fontFamily: FontColor.fontPoppins,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: FontColor.black,
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
