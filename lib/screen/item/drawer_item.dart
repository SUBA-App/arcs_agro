import 'package:flutter/material.dart';

import '../../font_color.dart';

class DrawerItem extends StatelessWidget {
  const DrawerItem({
    super.key,
    required this.onTap,
    required this.text,
    required this.image,
    this.isActive = true,
  });

  final VoidCallback onTap;
  final String text;
  final String image;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final Color iconColor = isActive ? FontColor.black : Colors.grey.shade400;
    final Color textColor = isActive ? FontColor.black : Colors.grey.shade600;
    final VoidCallback? effectiveOnTap = isActive ? onTap : null;

    return ListTile(
      leading: Image.asset(
        image,
        width: 20,
        height: 20,
        color: iconColor,
      ),
      title: Text(
        text,
        style: TextStyle(
            fontFamily: FontColor.fontPoppins,
            fontWeight: FontWeight.w400,
            color: textColor,
            fontSize: 14),
      ),
      onTap: effectiveOnTap,
    );
  }
}