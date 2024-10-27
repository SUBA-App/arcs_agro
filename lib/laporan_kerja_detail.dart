import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sales_app/font_color.dart';
import 'package:sales_app/view_pic_screen.dart';

class LaporanKerjaDetail extends StatefulWidget {
  const LaporanKerjaDetail({super.key});

  @override
  State<LaporanKerjaDetail> createState() => _LaporanKerjaDetailState();
}

class _LaporanKerjaDetailState extends State<LaporanKerjaDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: FontColor.yellow72,
        iconTheme: IconThemeData(
          color: FontColor.black
        ),
        title: Text("Detail Laporan Kerja", style: TextStyle(
          fontFamily: FontColor.fontPoppins,
          color: FontColor.black,
        ),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Nama Kios : Warung Ayu", style: TextStyle(
                        fontFamily: FontColor.fontPoppins,
                        color: FontColor.black,
                      ),),
                      Text("Invoice : 5465812-564812", style: TextStyle(
                        fontFamily: FontColor.fontPoppins,
                        color: FontColor.black,
                      ),),
                      Text("Tanggal : 22-06-2024", style: TextStyle(
                        fontFamily: FontColor.fontPoppins,
                        color: FontColor.black,
                      ),),
                      Text("Jam : 22:18", style: TextStyle(
                        fontFamily: FontColor.fontPoppins,
                        color: FontColor.black,
                      ),),

                      Row(
                        children: [
                          Text("Metode Pembayaran : ", style: TextStyle(
                            fontFamily: FontColor.fontPoppins,
                            color: FontColor.black,
                          ),),
                          Container(
                            alignment: Alignment.center,
                            height: 30,
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.red
                            ),
                            child: Text("Cek/Giro", style: TextStyle(
                                fontFamily: FontColor.fontPoppins,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.white
                            ),),
                          )
                        ],
                      ),
                      Text("Nomor : 548421", style: TextStyle(
                        fontFamily: FontColor.fontPoppins,
                        color: FontColor.black,
                      ),),
                      Text("Jatuh Tempo : 22-06-2023", style: TextStyle(
                        fontFamily: FontColor.fontPoppins,
                        color: FontColor.black,
                      ),),
                      Text("Nominal : 22-06-2023", style: TextStyle(
                        fontFamily: FontColor.fontPoppins,
                        color: FontColor.black,
                      ),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            height: 30,
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.orange
                            ),
                            child: Text("Sedang Pengecekan", style: TextStyle(
                                fontFamily: FontColor.fontPoppins,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.white
                            ),),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Foto Cek/Giro", style: TextStyle(
                fontFamily: FontColor.fontPoppins,
                color: FontColor.black,
                fontWeight: FontWeight.w500,
                fontSize: 15
              ),),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ViewPicScreen()));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                    image: DecorationImage(image: NetworkImage('https://et2o98r3gkt.exactdn.com/wp-content/uploads/2021/05/bilyet-giro.jpg?strip=all&lossy=1&quality=92&webp=92&ssl=1&fit=656%2C365'), fit: BoxFit.fill)
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
