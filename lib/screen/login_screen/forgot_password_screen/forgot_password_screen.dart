
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:arcs_agro/screen/login_screen/forgot_password_screen/forgot_provider.dart';

import '../../../font_color.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(onPressed: () {
            Navigator.pop(context);
          }, icon: const Icon(Icons.arrow_back_outlined)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Lupa Katasandi', style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontFamily: FontColor.fontPoppins,
                    color: FontColor.black
                  ),),
                  const SizedBox(height: 32,),
                  TextField(
                    controller: emailC,
                    cursorColor: FontColor.black,
                    style: TextStyle(
                        fontFamily: FontColor.fontPoppins,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: FontColor.black
                    ),
                    decoration: InputDecoration(
                        labelText: "Masukkan Email Anda",
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
                          ),

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
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(onPressed: () async {
                      await Provider.of<ForgotProvider>(context, listen: false).checkEmail(context, emailC.text);
                    },style: ButtonStyle(
                        backgroundColor: const WidgetStatePropertyAll(FontColor.yellow72),
                        shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)
                            )
                        )
                    ), child: Text("Submit", style: TextStyle(
                        color: Colors.white,
                        fontFamily: FontColor.fontPoppins
                    ),)),
                  )
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
