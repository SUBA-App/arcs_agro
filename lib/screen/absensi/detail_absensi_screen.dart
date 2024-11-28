import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/api/api_service.dart';
import 'package:sales_app/api/response/absen_response.dart';
import 'package:sales_app/screen/absensi/absensi_provider.dart';

import '../../font_color.dart';

class DetailAbsensiScreen extends StatefulWidget {
  const DetailAbsensiScreen({super.key, required this.result});

  final AbsenResult? result;

  @override
  State<DetailAbsensiScreen> createState() => _DetailAbsensiScreenState();
}

class _DetailAbsensiScreenState extends State<DetailAbsensiScreen> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      Provider.of<AbsensiProvider>(context, listen: false).getDetailAbsensi(widget.result?.id ?? '');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AbsensiProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: FontColor.yellow72,
        iconTheme: const IconThemeData(
            color: FontColor.black
        ),
        title: Text("Detail Absensi",style: TextStyle(
            fontFamily: FontColor.fontPoppins,
            color: FontColor.black,
          fontSize: 16
        ),),
      ),
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: provider.isLoadingDetail ? Center(child: const CircularProgressIndicator()) :  Column(

          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 100,
                        height: 150,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network('${ApiService.imageUrl}${provider.absenResult?.picture ?? ''}', fit: BoxFit.fill,),
                        ),
                      ),
                      const SizedBox(width: 16,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Check In", style: TextStyle(
                              fontFamily: FontColor.fontPoppins,
                              color: FontColor.black,
                              fontWeight: FontWeight.w500
                            ),),
                            Text("${provider.absenResult?.checkIn ?? ''} - ${provider.absenResult?.checkInTime?? ''}", style: TextStyle(
                              fontFamily: FontColor.fontPoppins,
                              color: FontColor.black.withOpacity(0.8),
                            ),),
                            Text("Check Out", style: TextStyle(
                              fontFamily: FontColor.fontPoppins,
                              color: FontColor.black,
                                fontWeight: FontWeight.w500
                            ),),
                            Text("${provider.absenResult?.checkOut ?? ''} - ${provider.absenResult?.checkOutTime ?? ''}", style: TextStyle(
                              fontFamily: FontColor.fontPoppins,
                              color: FontColor.black.withOpacity(0.8),
                            ),),
                            const SizedBox(height: 8,),
                            Container(
                              alignment: Alignment.center,
                              width: 100,
                              height: 30,
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: provider.absenResult?.status == 1 ? Colors.green : Colors.red
                              ),
                              child: Text(provider.absenResult?.status == 1 ? 'Check In' : 'Check Out', style: TextStyle(
                                  fontFamily: FontColor.fontPoppins,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white
                              ),),
                            )
                          ],
                        ),
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
                  const SizedBox(height: 16,),
                  Text("List Koordinat Saya", style: TextStyle(
                      fontFamily: FontColor.fontPoppins,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: FontColor.black
                  ),),
                  const SizedBox(height: 16,),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: provider.absenResult?.coordinates.length ?? 0,
                      itemBuilder: (context,index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Image.asset(provider.absenResult?.coordinates[index].status == 0 ?'assets/images/map-marker-check.png' :'assets/images/location-exclamation.png', width: 20,height: 20,),
                              const SizedBox(width: 8,),
                              Text(provider.absenResult?.coordinates[index].coordinate ?? '', style: TextStyle(
                                  fontFamily: FontColor.fontPoppins,
                                  fontSize: 14,
                                  color: FontColor.black
                              ),),
                            ],
                          ),
                        );
                      })
                ],
              ),
            ),
            const SizedBox(height: 16,),
            provider.absenResult?.status == 1 ?
            ElevatedButton(onPressed: () async {
              await Provider.of<AbsensiProvider>(context, listen: false).checkOut(context, widget.result!.id);
            },
                style: ButtonStyle(
                    backgroundColor: const WidgetStatePropertyAll(Colors.red),
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)
                    ))
                ),
                child: Text("Check Out", style: TextStyle(
                    fontFamily: FontColor.fontPoppins,
                    color: Colors.white,
                    fontSize: 14
                ),)) :SizedBox()
          ],
        ),
      )),
    );
  }
}
