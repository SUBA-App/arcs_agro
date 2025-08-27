
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:arcs_agro/font_color.dart';
import 'package:arcs_agro/screen/main/otp_screen/otp_provider.dart';


import '../../../util.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.mode, required this.email});

  final int mode;
  final String email;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late final TextEditingController pinController;
  late final FocusNode focusNode;

  final focusedBorderColor = const Color.fromRGBO(23, 171, 144, 1);
  final fillColor = const Color.fromRGBO(243, 246, 249, 0);
  final borderColor = const Color.fromRGBO(23, 171, 144, 0.4);
  late OtpProvider provi;
  @override
  void initState() {
    super.initState();
    pinController = TextEditingController();
    focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((e) {
      provi = Provider.of<OtpProvider>(context, listen: false);

      Provider.of<OtpProvider>(context, listen: false).sendOtpEmail(context, widget.email);
    });
  }

  @override
  void didChangeDependencies() {
    provi = Provider.of<OtpProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    provi.stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const borderColor = FontColor.yellow72;

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
        fontFamily: FontColor.fontPoppins,
        fontSize: 22,
        color: FontColor.black,
      ),
      decoration: const BoxDecoration(),
    );

    final cursor = Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 56,
          height: 2,
          decoration: BoxDecoration(
            color: borderColor,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );
    final preFilledWidget = Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 56,
          height: 2,
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );
    final provider = Provider.of<OtpProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      IconButton(onPressed: () {
                        Navigator.pop(context);
                      }, icon: const Icon(Icons.arrow_back_outlined)),
                    ],
                  ),
                  const SizedBox(height: 25,),
                  Text('Verifikasi', style: TextStyle(
                    fontFamily: FontColor.fontPoppins,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: FontColor.black
                  ),),
                  const SizedBox(height: 16,),
                  Text('Masukkan kode verifikasi yang dikirim ke email', style: TextStyle(
                      fontFamily: FontColor.fontPoppins,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey
                  ),),
                  const SizedBox(height: 16,),
                  Text(widget.email, style: TextStyle(
                      fontFamily: FontColor.fontPoppins,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: FontColor.black
                  ),),
                ],
              ),
              const SizedBox(height: 50,),
              Pinput(
                length: 6,
                pinAnimationType: PinAnimationType.slide,
                controller: pinController,
                focusNode: focusNode,
                defaultPinTheme: defaultPinTheme,
                showCursor: true,
                cursor: cursor,
                preFilledWidget: preFilledWidget,
                onCompleted: (e) {
                  Provider.of<OtpProvider>(context, listen: false).verifyOtp(context, e, widget.email, widget.mode);
                },
              ),
              const SizedBox(height: 40,),
              Text('Belum menerima kode OTP ?', style: TextStyle(
                  fontFamily: FontColor.fontPoppins,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: FontColor.black
              ),),
              const SizedBox(height: 16,),
              provider.otpTime != 0 ? Text(Util.formatMMSS(provider.otpTime ~/ 1000), style: TextStyle(
                  fontFamily: FontColor.fontPoppins,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: FontColor.black
              ),) :const SizedBox(),
              provider.otpTime == 0 ? TextButton(onPressed: (){
                Provider.of<OtpProvider>(context, listen: false).sendOtpEmail(context, widget.email);
              }, child: Text('Kirim Ulang', style: TextStyle(
                  fontFamily: FontColor.fontPoppins,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: FontColor.black
              ),)) : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
