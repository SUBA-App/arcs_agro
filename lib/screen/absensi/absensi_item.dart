import 'package:flutter/material.dart';
import 'package:arcs_agro/api/response/absen_response.dart';

import 'detail_absensi_screen.dart';
import '../../font_color.dart';

class AbsensiItem extends StatelessWidget {
  const AbsensiItem({super.key, required this.result});

  final AbsenData? result;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: const WidgetStatePropertyAll(Colors.white),
            shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )
            ),
            padding: const WidgetStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 8)
            )
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) =>  DetailAbsensiScreen(result: result,)));
        },
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(result?.storeName ?? "", style: TextStyle(
                        fontFamily: FontColor.fontPoppins,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: FontColor.black
                    ),),
                    Text(result?.status == 1 ? result?.checkIn ?? '' : result?.checkOut ?? '', style: TextStyle(
                        fontFamily: FontColor.fontPoppins,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: FontColor.black.withValues(alpha: 0.5)
                    ),),
                    Text(result?.status == 1 ? result?.checkInTime ?? '' : result?.checkOutTime ?? '', style: TextStyle(
                        fontFamily: FontColor.fontPoppins,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: FontColor.black.withValues(alpha: 0.5)
                    ),),
                  ],
                ),
              ),
              const SizedBox(width: 8,),
              Container(
                alignment: Alignment.center,
                height: 30,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: result?.status == 1 ? Colors.green : Colors.red
                ),
                child: Text(result?.status == 1 ? "Check In" : "Check Out", style: TextStyle(
                    fontFamily: FontColor.fontPoppins,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white
                ),),
              )
            ],
          ),
        ),
      ),
    );
  }
}
