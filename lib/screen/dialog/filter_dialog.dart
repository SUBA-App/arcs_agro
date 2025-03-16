

import 'package:flutter/material.dart';
import 'package:sales_app/font_color.dart';
import '../widget/date_view.dart';

class FilterDialog extends StatelessWidget {
  const FilterDialog({super.key, required this.applyTap, required this.start, required this.end, required this.startTap, required this.endTap, required this.sort, required this.sortChange, required this.clear});

  final VoidCallback applyTap;
  final VoidCallback clear;
  final String start;
  final String end;
  final VoidCallback startTap;
  final VoidCallback endTap;

  final String sort;
  final Function(String e) sortChange;

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Filter', style: TextStyle(
                fontFamily: FontColor.fontPoppins,
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: FontColor.black
              ),),
              IconButton(onPressed: () {
                Navigator.pop(context);
              }, icon: Image.asset('assets/images/close.png', width: 24,height: 24,))
            ],
          ),
          const SizedBox(height: 16,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                  child: DateView(top: 'Start', value: start.isEmpty ? 'Pilih tanggal' : start, onTap: startTap,)
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24, left: 8, right: 8),
                child: Image.asset('assets/images/arrow-alt-right.png', width: 15,height: 15,),
              ),
              Expanded(
                child: DateView(top: 'End', value: end.isEmpty ? 'Pilih tanggal' : end, onTap: endTap,),
              )
            ],
          ),
          const SizedBox(height: 16,),
          DropdownButtonFormField(
              style: TextStyle(
                fontSize: 14,
                fontFamily: FontColor.fontPoppins,
                fontWeight: FontWeight.w400,
              ),
              value: sort,
              items: ['ASC', 'DESC'].map((e) {
                return DropdownMenuItem(
                    value: e,
                    child: Text(
                      e,
                      style: TextStyle(
                          fontFamily: FontColor.fontPoppins,
                          fontWeight: FontWeight.w400,
                          color: FontColor.black),
                    ));
              }).toList(),
              hint: Text(
                "",
                style: TextStyle(
                    fontFamily: FontColor.fontPoppins,
                    fontWeight: FontWeight.w400,
                    color: FontColor.black),
              ),
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10))),
              onChanged: (value) {
                sortChange.call(value!);
              }),

        TextButton(onPressed: clear,style: const ButtonStyle(
          padding: WidgetStatePropertyAll(
            EdgeInsets.only(top: 8, right: 8, bottom: 8)
          )
        ), child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.clear),
            Text('Clear', style: TextStyle(
              fontFamily: FontColor.fontPoppins,
              fontWeight: FontWeight.w500,
              color: FontColor.black,
              fontSize: 14
            ),),

          ],
        )),
          const SizedBox(height: 32,),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
              onPressed: applyTap,
              style: ButtonStyle(
                  backgroundColor:
                  const WidgetStatePropertyAll(FontColor.yellow72),
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)))),
              child: Text(
                "Submit",
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: FontColor.fontPoppins),
              )),
        ),

        ],
      ),
    );
  }
}
