
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:arcs_agro/font_color.dart';
import 'package:arcs_agro/screen/login_screen/forgot_password_screen/forgot_password_screen.dart';
import 'package:arcs_agro/screen/login_screen/login_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool obscure = true;

  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/bg.jpg'), fit: BoxFit.fill)
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Image.asset('assets/images/main_logo.png', height: 100,),
                        const SizedBox(height: 24,),
                        Text("ARCS Agro+",style: TextStyle(
                            fontFamily: FontColor.fontPoppins,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: FontColor.black
                        ),),
                        Text("Silahkan Login",style: TextStyle(
                            fontFamily: FontColor.fontPoppins,
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: FontColor.s5b5b5b
                        ),),
                        const SizedBox(height: 24,),
                        Container(

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withAlpha(50),
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: const Offset(0, 2), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                TextField(
                                  controller: passwordC,
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

                                      labelText: "Masukkan Kata sandi",
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

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()));
                                    }, child: Text('Lupa Sandi', style: TextStyle(
                                        color: FontColor.black,
                                        fontFamily: FontColor.fontPoppins,fontSize: 12
                                    ),)),
                                  ],
                                ),
                                const SizedBox(height: 16,),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(onPressed: () async {
                                    await Provider.of<LoginProvider>(context, listen: false).login(context, emailC.text, passwordC.text);
                                  },style: ButtonStyle(
                                      backgroundColor: const WidgetStatePropertyAll(FontColor.yellow72),
                                      shape: WidgetStatePropertyAll(
                                          RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5)
                                          )
                                      )
                                  ), child: Text("Login", style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: FontColor.fontPoppins
                                  ),)),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
