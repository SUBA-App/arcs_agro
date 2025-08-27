import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../font_color.dart';

class HomeMenu extends StatelessWidget {
  const HomeMenu({
    super.key,
    required this.onTap,
    required this.text,
    required this.isActive, required this.image,
  });

  final VoidCallback onTap;
  final String text;
  final bool isActive;
  final String image;

  @override
  Widget build(BuildContext context) {
    Widget menuContent = Container(
      width: 130,
      height: 130,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: FontColor.yellow72,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SvgPicture.asset(
            image,
            width: 30,
            height: 30,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          Text(
            text, // Menggunakan variabel text
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: FontColor.fontPoppins,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white),
          ),
        ],
      ),
    );

    return GestureDetector(
      onTap: isActive ? onTap : null,
      child: isActive
          ? menuContent
          : ColorFiltered(
        colorFilter: const ColorFilter.matrix(<double>[

          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0,      0,      0,      1, 0,
        ]),
        child: menuContent,
      ),
    );
  }
}