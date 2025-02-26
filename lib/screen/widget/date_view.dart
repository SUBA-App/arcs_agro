
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sales_app/font_color.dart';

class DateView extends StatelessWidget {
  const DateView({super.key, required this.top, required this.value, required this.onTap});

  final String top;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap.call();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(top, style: TextStyle(
            fontSize: 14,
            fontFamily: FontColor.fontPoppins,
            fontWeight: FontWeight.w500,
            color: FontColor.black
          ),),
          SizedBox(height: 8,),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black45)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(value, style: TextStyle(
                    fontSize: 12,
                    fontFamily: FontColor.fontPoppins,
                    fontWeight: FontWeight.w500,
                    color: FontColor.black
                ),),
                SizedBox(width: 8,),
                Image.asset('assets/images/calendar.png', width: 20,height: 20,)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
