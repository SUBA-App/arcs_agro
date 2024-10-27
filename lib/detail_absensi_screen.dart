import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'font_color.dart';

class DetailAbsensiScreen extends StatefulWidget {
  const DetailAbsensiScreen({super.key});

  @override
  State<DetailAbsensiScreen> createState() => _DetailAbsensiScreenState();
}

class _DetailAbsensiScreenState extends State<DetailAbsensiScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: FontColor.yellow72,
        iconTheme: IconThemeData(
            color: FontColor.black
        ),
        title: Text("Detail Absensi",style: TextStyle(
            fontFamily: FontColor.fontPoppins,
            color: FontColor.black
        ),),
      ),
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 100,
                        height: 150,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network('https://images.pexels.com/photos/433989/pexels-photo-433989.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', fit: BoxFit.fill,),
                        ),
                      ),
                      SizedBox(width: 16,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Tanggal : 22-06-2024", style: TextStyle(
                            fontFamily: FontColor.fontPoppins,
                            color: FontColor.black,
                          ),),
                          Text("Jam : 22:18", style: TextStyle(
                            fontFamily: FontColor.fontPoppins,
                            color: FontColor.black,
                          ),),
                          SizedBox(height: 8,),
                          Container(
                            alignment: Alignment.center,
                            height: 30,
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.orange
                            ),
                            child: Text("Check In", style: TextStyle(
                                fontFamily: FontColor.fontPoppins,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.white
                            ),),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16,),
                  Text("List Koordinat Saya", style: TextStyle(
                      fontFamily: FontColor.fontPoppins,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: FontColor.black
                  ),),
                  SizedBox(height: 16,),
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: 20,
                        itemBuilder: (context,index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                Image.asset('assets/images/location-exclamation.png', width: 20,height: 20,),
                                SizedBox(width: 8,),
                                Text("0.8378388,103.7234661", style: TextStyle(
                                    fontFamily: FontColor.fontPoppins,
                                    fontSize: 14,
                                    color: FontColor.black
                                ),),
                              ],
                            ),
                          );
                        }),
                  )
                ],
              ),
            ),
            SizedBox(height: 16,),
            ElevatedButton(onPressed: () {},
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.green),
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)
                    ))
                ),
                child: Text("Check Out", style: TextStyle(
                    fontFamily: FontColor.fontPoppins,
                    color: Colors.white,
                    fontSize: 14
                ),))
          ],
        ),
      )),
    );
  }
}
