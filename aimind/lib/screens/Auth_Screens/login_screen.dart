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
          //Back Container
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
              )),
              child: Container(
                padding: EdgeInsets.only(top: 90, left: 20),
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
          buildBottomHalfContainer(true),
          // Form Container
          Positioned(
            top: 200,
            child: Container(
              height: 402,
              padding: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width - 40,
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
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
                                  color: !isSignupScreen
                                      ? Palette.activeColor
                                      : Palette.textColor1),
                            ),
                            if (!isSignupScreen)
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
                                  color: isSignupScreen
                                      ? Palette.activeColor
                                      : Palette.textColor1),
                            ),
                            if (isSignupScreen)
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
                    child: Column(children: [
                      CustomTextField(
                        hintText: 'Usuario',
                        prefixIcon: Icons.person,
                        keyboardType: TextInputType.text,
                      ),
                      CustomTextField(
                          hintText: 'Correo',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress),
                      CustomTextField(
                        hintText: 'Contraseña',
                        prefixIcon: Icons.lock_outline,
                        isPassword: true,
                        keyboardType: TextInputType.text,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isMale = true;
                                });
                              },
                              child: Row(
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    margin: EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                        color: isMale
                                            ? Palette.textColor2
                                            : Colors.transparent,
                                        border: Border.all(
                                            width: 1,
                                            color: isMale
                                                ? Colors.transparent
                                                : Palette.textColor1),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Icon(
                                      Icons.person_2_outlined,
                                      color: isMale
                                          ? Colors.white
                                          : Palette.iconColor,
                                    ),
                                  ),
                                  Text(
                                    "Hombre",
                                    style: TextStyle(color: Palette.textColor1),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(width: 29),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isMale = false;
                                });
                              },
                              child: Row(
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    margin: EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                        color: isMale
                                            ? Colors.transparent
                                            : Palette.textColor2,
                                        border: Border.all(
                                            width: 1,
                                            color: isMale
                                                ? Palette.textColor1
                                                : Colors.transparent),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Icon(
                                      Icons.person_2_outlined,
                                      color: isMale
                                          ? Palette.iconColor
                                          : Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "Mujer",
                                    style: TextStyle(color: Palette.textColor1),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 200,
                        margin: EdgeInsets.only(top: 20),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              text:
                                  'Presionando el botón de registro, aceptas nuestros ',
                              style: TextStyle(color: Palette.textColor2),
                              children: [
                                TextSpan(
                                    text: 'términos y condiciones',
                                    style: TextStyle(color: Colors.orange))
                              ]),
                        ),
                      ),
                    ]),
                  )
                ],
              ),
            ),
          ),
          //Button Container
          buildBottomHalfContainer(false),
          Positioned(
            top: MediaQuery.of(context).size.height - 240,
            right: 0,
            left: 0,
            child: Column(
              children: [
                Text("O inicia sesión con"),
                SizedBox(height: 40),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LoginButton(
                          icon: Icons.facebook,
                          text: "Facebook",
                          backgroundColor: Color(0xFF3B5999),
                          iconColor: Colors.white,
                          textColor: Colors.white,
                          voidCallback: () {},
                        ),
                        SizedBox(width: 10),
                        LoginButtonWithImage(
                          imagePath: 'assets/images/google_logo.png',
                          text: "Google",
                          backgroundColor: Colors.white,
                          textColor: Colors.black87,
                          voidCallback: () {},
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LoginButton(
                          icon: Icons.apple,
                          text: "Apple",
                          backgroundColor: Colors.black,
                          iconColor: Colors.white,
                          textColor: Colors.white,
                          voidCallback: () {},
                        ),
                        SizedBox(width: 10),
                        LoginButtonWithImage(
                          imagePath: 'assets/images/x_logo.png',
                          text: "",
                          backgroundColor: Colors.black,
                          voidCallback: () {},
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Positioned buildBottomHalfContainer(bool showShadow) {
    return Positioned(
      top: 555,
      right: 0,
      left: 0,
      child: Center(
        child: Container(
          height: 90,
          width: 90,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                if (showShadow)
                  BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 1.5,
                      blurRadius: 10,
                      offset: Offset(0, 1))
              ]),
          child: !showShadow
              ? Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.orange[200]!, Colors.red[400]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: Offset(0, 1))
                      ]),
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                )
              : Center(),
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final Color? iconColor;
  final Color? textColor;
  final IconData icon;
  final VoidCallback voidCallback;
  final String text;
  final Color backgroundColor;
  const LoginButton({
    super.key,
    required this.icon,
    required this.text,
    required this.backgroundColor,
    required this.voidCallback,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: voidCallback,
        style: TextButton.styleFrom(
          minimumSize: Size(155, 40),
          shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.circular(20)),
          backgroundColor: backgroundColor,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor,
            ),
            SizedBox(width: 5),
            Text(text, style: TextStyle(color: textColor))
          ],
        ));
  }
}

class LoginButtonWithImage extends StatelessWidget {
  final String imagePath;
  final Color? textColor;
  final VoidCallback voidCallback;
  final String text;
  final Color backgroundColor;

  const LoginButtonWithImage({
    super.key,
    required this.imagePath,
    required this.text,
    required this.backgroundColor,
    required this.voidCallback,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: voidCallback,
        style: TextButton.styleFrom(
          minimumSize: Size(155, 40),
          shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.circular(20)),
          backgroundColor: backgroundColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 24,
              width: 24,
            ),
            SizedBox(width: 8),
            Text(text, style: TextStyle(color: textColor))
          ],
        ));
  }
}
