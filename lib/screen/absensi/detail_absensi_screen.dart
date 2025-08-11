import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/api/response/absen_response.dart';
import 'package:sales_app/screen/absensi/absensi_provider.dart';

import '../../font_color.dart';
import '../../view_pic_screen.dart';

class DetailAbsensiScreen extends StatefulWidget {
  const DetailAbsensiScreen({super.key, required this.result});

  final AbsenData? result;

  @override
  State<DetailAbsensiScreen> createState() => _DetailAbsensiScreenState();
}

class _DetailAbsensiScreenState extends State<DetailAbsensiScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AbsensiProvider>(context, listen: false)
          .getDetailAbsensi(widget.result?.id ?? '', context);
    });
    super.initState();
  }

  int selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AbsensiProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: FontColor.yellow72,
        iconTheme: const IconThemeData(color: FontColor.black),
        title: Text(
          "Detail Absensi",
          style: TextStyle(
              fontFamily: FontColor.fontPoppins,
              color: FontColor.black,
              fontSize: 16),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: provider.isLoadingDetail
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "${provider.absenResult?.storeName}",
                              style: TextStyle(
                                  fontFamily: FontColor.fontPoppins,
                                  color: FontColor.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "Check In",
                              style: TextStyle(
                                  fontFamily: FontColor.fontPoppins,
                                  color: FontColor.black,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "${provider.absenResult?.checkIn ?? ''} - ${provider.absenResult?.checkInTime ?? ''}",
                              style: TextStyle(
                                fontFamily: FontColor.fontPoppins,
                                color: FontColor.black.withValues(alpha: 0.8),
                              ),
                            ),
                            Text(
                              "Check Out",
                              style: TextStyle(
                                  fontFamily: FontColor.fontPoppins,
                                  color: FontColor.black,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "${provider.absenResult?.checkOut ?? ''} - ${provider.absenResult?.checkOutTime ?? ''}",
                              style: TextStyle(
                                fontFamily: FontColor.fontPoppins,
                                color: FontColor.black.withValues(alpha: 0.8),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: 100,
                              height: 30,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: provider.absenResult?.status == 1
                                      ? Colors.green
                                      : Colors.red),
                              child: Text(
                                provider.absenResult?.status == 1
                                    ? 'Check In'
                                    : 'Check Out',
                                style: TextStyle(
                                    fontFamily: FontColor.fontPoppins,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8,),
                  widget.result!.note.isNotEmpty ?  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      "Keterangan",
                      style: TextStyle(
                          fontFamily: FontColor.fontPoppins,
                          color: Colors.red,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  ) : const SizedBox(),
                  widget.result!.note.isNotEmpty ? Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      widget.result!.note,
                      style: TextStyle(
                        fontFamily: FontColor.fontPoppins,
                        color: FontColor.black,
                      ),
                    ),
                  ) : const SizedBox(),
                  SizedBox(height: 8,),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Foto Absensi",
                            style: TextStyle(
                                fontFamily: FontColor.fontPoppins,
                                color: FontColor.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Expanded(
                            child: MasonryGridView.count(
                              itemCount: provider.absenResult?.pictures.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ViewPicScreen(
                                              url: provider.absenResult?.pictures[index] ?? '' ,
                                            )));
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          '${provider.absenResult?.pictures[index]}',
                                      placeholder: (_,__) => Image.asset('assets/images/placeholder.jpg',fit: BoxFit.fill,),
                                      errorWidget: (_,__,___) => Image.asset('assets/images/placeholder.jpg', fit: BoxFit.fill,),
                                      height: 200,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                );
                              },
                              crossAxisCount: 3,
                              crossAxisSpacing: 4,
                              mainAxisSpacing: 4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  provider.absenResult?.status == 1
                      ? ElevatedButton(
                          onPressed: () async {
                            await Provider.of<AbsensiProvider>(context,
                                    listen: false)
                                .checkOut(context, widget.result!.id);
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  const WidgetStatePropertyAll(Colors.red),
                              shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)))),
                          child: Text(
                            "Check Out",
                            style: TextStyle(
                                fontFamily: FontColor.fontPoppins,
                                color: Colors.white,
                                fontSize: 14),
                          ))
                      : const SizedBox()
                ],
              ),
      )),
    );
  }
}
