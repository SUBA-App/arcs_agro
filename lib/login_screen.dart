import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sales_app/font_color.dart';
import 'package:sales_app/main_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,


      body: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/bg.jpg'), fit: BoxFit.fill)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Image.asset('', width: 200,height: 200,),
            SizedBox(height: 50,),
            Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      cursorColor: FontColor.black,
                      decoration: InputDecoration(
                         labelText: "Masukkan Email Anda",
                          labelStyle: TextStyle(
                              fontFamily: FontColor.fontPoppins,
                              fontWeight: FontWeight.w400,
                            color: FontColor.black
                          ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.black26,
                          ),

                        ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: FontColor.yellow72,
                              )
                          )
                      ),
                    ),
                    SizedBox(height: 16,),
                    TextField(
                      cursorColor: FontColor.black,
                      obscureText: obscure,
                      keyboardType: TextInputType.visiblePassword,
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
                              color: FontColor.black
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.black26,
                              )
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: FontColor.yellow72,
                              )
                          )
                      ),
                    ),
                    SizedBox(height: 16,),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage()));
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
    );
  }
}
