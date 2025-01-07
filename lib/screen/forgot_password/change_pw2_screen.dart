
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/screen/main/main_provider.dart';

import '../../font_color.dart';


class ChangePw2Screen extends StatefulWidget {
  const ChangePw2Screen({super.key, required this.email});

  final String email;

  @override
  State<ChangePw2Screen> createState() => _ChangePwScreenState();
}

class _ChangePwScreenState extends State<ChangePw2Screen> {

  TextEditingController password = TextEditingController();
  TextEditingController passwordC = TextEditingController();

  bool obscureC = true;
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: FontColor.yellow72,
        iconTheme: const IconThemeData(color: FontColor.black),
        title: Text(
          "Ganti Sandi",
          style: TextStyle(
              fontFamily: FontColor.fontPoppins,
              color: FontColor.black,
              fontSize: 16),
        ),
      ),
      body: Padding(padding: const EdgeInsets.all(16), child: Column(
        children: [
          TextField(
            controller: password,
            cursorColor: FontColor.black,
            obscureText: obscure,
            keyboardType: TextInputType.visiblePassword,
            style: TextStyle(
                fontFamily: FontColor.fontPoppins,
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: FontColor.black
            ),
            decoration: InputDecoration(
                suffixIcon: IconButton(onPressed: () {
                  obscure = !obscure;
                  setState(() {

                  });
                }, icon: Icon(obscure ? Icons.visibility_off : Icons.visibility)),

                labelText: "Masukkan Kata Sandi Baru",
                labelStyle: TextStyle(
                    fontFamily: FontColor.fontPoppins,
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: FontColor.black
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black26,
                    )
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: FontColor.yellow72,
                    )
                )
            ),
          ),
          const SizedBox(height: 16,),
          TextField(
            controller: passwordC,
            cursorColor: FontColor.black,
            obscureText: obscureC,
            keyboardType: TextInputType.visiblePassword,
            style: TextStyle(
                fontFamily: FontColor.fontPoppins,
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: FontColor.black
            ),
            decoration: InputDecoration(
                suffixIcon: IconButton(onPressed: () {
                  obscureC = !obscureC;
                  setState(() {

                  });
                }, icon: Icon(obscureC ? Icons.visibility_off : Icons.visibility)),

                labelText: "Konfirmasi Kata Sandi Baru",
                labelStyle: TextStyle(
                    fontFamily: FontColor.fontPoppins,
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: FontColor.black
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black26,
                    )
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: FontColor.yellow72,
                    )
                )
            ),
          ),
          const Spacer(),
          SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () async {
                    if (passwordC.text != password.text) {
                      Fluttertoast.showToast(msg: 'Kata sandi tidak sama');
                    } else if (password.text.isEmpty || passwordC
                    .text.isEmpty) {
                      Fluttertoast.showToast(msg: 'Data Masih Kosong');
                    }else {
                      await Provider.of<MainProvider>(context, listen: false).changePw2(context, password.text, widget.email);
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor:
                      const WidgetStatePropertyAll(FontColor.black),
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)))),
                  child: Text(
                    "Simpan",
                    style: TextStyle(
                        color: Colors.white, fontFamily: FontColor.fontPoppins),
                  ))),
        ],
      ),),
    );
  }
}
