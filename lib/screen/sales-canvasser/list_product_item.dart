import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../font_color.dart';
import '../../api/response/receipts_response.dart';
import '../../currency_formatter.dart';

class ListProductItem extends StatelessWidget {
  const ListProductItem({super.key, required this.listProduct, this.onMin, this.onPlus, this.onTap, this.onChanged});
  final ListProduct listProduct;
  final VoidCallback? onMin;
  final VoidCallback? onPlus;
  final VoidCallback? onTap;
  final Function(String value)? onChanged;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                        'Sisa : ${listProduct.remainingQuantity}',
                        style: TextStyle(
                          fontFamily: FontColor.fontPoppins,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                onMin == null ?  Row(
                  children: [
                    listProduct.checked ?
                    const Icon(Icons.check, color: Colors.green,) : const SizedBox.shrink()
                  ],
                ) : Row(
                  children: [
                    GestureDetector(
                      onTap: onMin,
                      child: Container(
                        padding: const EdgeInsets.all(7.0),
                        decoration: BoxDecoration(
                          color: FontColor.yellow72,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.remove,size: 12, color: FontColor.black,),
                      ),
                    ),
                    const SizedBox(width: 8,),
                    Text(
                      '${listProduct.qty}',
                      style: TextStyle(
                        fontFamily: FontColor.fontPoppins,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8,),
                    GestureDetector(
                      onTap: onPlus,
                      child: Container(
                        padding: const EdgeInsets.all(7.0),
                        decoration: BoxDecoration(
                          color: FontColor.yellow72,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.add,size: 12, color: FontColor.black,),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            onMin == null ? SizedBox() : const SizedBox(height: 8,),
            onMin == null ? SizedBox() : Container(
              width: double.infinity,
              height: 1,
              color: const Color(0xffeaeaea),
            ),
            onMin == null ? SizedBox() : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4,),
                Text('Masukan Harga', style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  fontFamily: FontColor.fontPoppins
                ),),
                SizedBox(height: 4,),
                SizedBox(
                  width: 200,
                  height: 35,
                  child: TextField(
                    cursorColor: FontColor.black,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CurrencyInputFormatter(),
                    ],
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                        fontFamily: FontColor.fontPoppins,
                        fontWeight: FontWeight.w400,
                        color: FontColor.black,
                        fontSize: 12
                    ),
                    decoration: InputDecoration(
                        hintText: "Harga",
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
                            )
                        ),
                        contentPadding: const EdgeInsets.all(8)
                    ),
                    onChanged: onChanged,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



