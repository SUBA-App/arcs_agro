import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerN extends StatelessWidget {
  const ShimmerN({super.key, required this.enabled});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(enabled: enabled,
        baseColor:const Color(0xFFf8f8f8),
        highlightColor: Colors.black12, child: Container(width: 100,height: 13,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color:  Colors.black12,
          ),),);
  }
}
