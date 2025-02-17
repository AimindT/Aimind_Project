import 'package:aimind/config/palette.dart';
import 'package:aimind/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
 bool isMale = true;
 bool isSignupScreen = true;
 bool isRememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage('images/background.png'),
              )),
              child: Container(
                padding: EdgeInsets.only(top: 90, left: 20),
                // ignore: deprecated_member_use
                color: Color(0xFF3B5999).withOpacity(.85),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                        text: TextSpan(
                            text: "Welcome to",
                            style: TextStyle(
                                fontSize: 25,
                                letterSpacing: 2,
                                color: Colors.yellow[700]),
                            children: [
                          TextSpan(
                              text: " Aimind",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.yellow[700],
                              ))
                        ])),
                    SizedBox(height: 5),
                    Text(
                      'Singup to Continue',
                      style: TextStyle(letterSpacing: 1, color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 200,
            child: Container(
              height: 380,
              padding: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width - 40,
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 5)
                  ]),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isSignupScreen = false;
                          });
                        },
                        child: Column(
                          children: [
                            Text(
                              'LOGIN',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: !isSignupScreen? Palette.activeColor : Palette.textColor1),
                            ),
                            if(!isSignupScreen)
                            Container(
                              height: 2,
                              margin: EdgeInsets.only(top: 3),
                              width: 55,
                              color: Colors.orange,
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isSignupScreen = true;
                          });
                        },
                        child: Column(
                          children: [
                            Text(
                              'SIGNUP',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isSignupScreen? Palette.activeColor : Palette.textColor1),
                            ),
                            if(isSignupScreen)
                            Container(
                              height: 2,
                              margin: EdgeInsets.only(top: 3),
                              width: 55,
                              color: Colors.orange,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                      CustomTextField(hintText: 'Usuario',prefixIcon: Icons.person,keyboardType: TextInputType.text,),
                      CustomTextField(hintText: 'Correo',prefixIcon: Icons.email_outlined,keyboardType: TextInputType.emailAddress),
                      CustomTextField(hintText: 'Contraseña', prefixIcon: Icons.lock_outline, isPassword: true, keyboardType: TextInputType.text,)
                      ,Padding(
                        padding: const EdgeInsets.only(top: 10,left: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isMale = true;
                                });
                              },
                              child: Row(children: [
                                Container(
                                  width: 30,
                                  height: 30,
                                  margin: EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    color: isMale ? Palette.textColor2 : Colors.transparent,
                                    border: Border.all(
                                      width: 1, color: isMale ? Colors.transparent : Palette.textColor1
                                    ),
                                    borderRadius: BorderRadius.circular(15)
                                  ),
                                  child:  Icon(
                                    Icons.person_2_outlined,
                                    color: isMale ? Colors.white : Palette.iconColor,
                                  ),
                                )
                                ,Text("Hombre", style: TextStyle(color: Palette.textColor1),)
                              ],),
                            ),
                            SizedBox(width: 30),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isMale = false;
                                });
                              },
                              child: Row(children: [
                                Container(
                                  width: 30,
                                  height: 30,
                                  margin: EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    color: isMale ? Colors.transparent : Palette.textColor2,
                                    border: Border.all(
                                      width: 1, color: isMale ? Palette.textColor1 : Colors.transparent
                                    ),
                                    borderRadius: BorderRadius.circular(15)
                                  ),
                                  child:  Icon(
                                    Icons.person_2_outlined,
                                    color: isMale? Palette.iconColor : Colors.white,
                                  ),
                                )
                                ,Text("Mujer", style: TextStyle(color: Palette.textColor1),)
                              ],),
                            )
                          ],
                        ),
                      )
                      ]
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
