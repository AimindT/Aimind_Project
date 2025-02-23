import 'dart:io';

import 'package:aimind/config/palette.dart';
import 'package:aimind/screens/Auth_Screens/test.dart';
import 'package:aimind/widgets/custom_text_field.dart';
import 'package:aimind/widgets/login_button.dart';
import 'package:aimind/widgets/login_button_with_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
                color: Color(0xFF3B5999).withValues(alpha: .85),
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
                              text: isSignupScreen ? " Aimind" : " Back",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.yellow[700],
                              ))
                        ])),
                    SizedBox(height: 5),
                    Text(
                      isSignupScreen
                          ? 'Singup to Continue'
                          : "Signin to Continue",
                      style: TextStyle(letterSpacing: 1, color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
          ),
          // Form Container
          AnimatedPositioned(
            duration: Duration(milliseconds: 700),
            curve: Curves.bounceInOut,
            // Posición top responsiva basada en porcentaje de altura de pantalla
            top: MediaQuery.of(context).size.height *
                (isSignupScreen ? 0.20 : 0.25),
            // Posición horizontal responsiva
            left: MediaQuery.of(context).size.width * 0.03,
            right: MediaQuery.of(context).size.width * 0.03,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 700),
              curve: Curves.bounceInOut,
              // Altura responsiva basada en porcentaje de pantalla
              height: MediaQuery.of(context).size.height *
                  (isSignupScreen ? 0.45 : 0.25),
              // Padding responsivo
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
              width: MediaQuery.of(context).size.width *
                  0.9, // 90% del ancho de pantalla
              margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .3),
                    blurRadius: 15,
                    spreadRadius: 5,
                  )
                ],
              ),
              child: SingleChildScrollView(
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
                                  // Tamaño de fuente responsivo
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                  fontWeight: FontWeight.bold,
                                  color: !isSignupScreen
                                      ? Palette.activeColor
                                      : Palette.textColor1,
                                ),
                              ),
                              if (!isSignupScreen)
                                Container(
                                  // Altura de línea responsiva
                                  height: MediaQuery.of(context).size.height *
                                      0.003,
                                  margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.004,
                                  ),
                                  // Ancho de línea responsivo
                                  width:
                                      MediaQuery.of(context).size.width * 0.15,
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
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                  fontWeight: FontWeight.bold,
                                  color: isSignupScreen
                                      ? Palette.activeColor
                                      : Palette.textColor1,
                                ),
                              ),
                              if (isSignupScreen)
                                Container(
                                  height: MediaQuery.of(context).size.height *
                                      0.003,
                                  margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.004,
                                  ),
                                  width:
                                      MediaQuery.of(context).size.width * 0.15,
                                  color: Colors.orange,
                                )
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (isSignupScreen) buildSingupSection(),
                    if (!isSignupScreen) buildSignInSection()
                  ],
                ),
              ),
            ),
          ), //Button Container
          Positioned(
            top: MediaQuery.of(context).size.height - 240,
            right: 0,
            left: 0,
            child: Column(
              children: [
                Text(!isSignupScreen
                    ? "O inicia sesión con"
                    : "O registrate con"),
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
                          voidCallback: () async {
                            if (!kIsWeb &&
                                (Platform.isAndroid || Platform.isIOS)) {
                              await signInNativeGoogle(context);
                            } else {
                              Supabase.instance.client.auth
                                  .signInWithOAuth(OAuthProvider.google);
                            }
                          },
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

  Future<void> signInNativeGoogle(BuildContext context) async {
    /// Web Client ID that you registered with Google Cloud.
    const webClientId =
        '320672119432-b8c3ftduhpaptp8hjj885qbiqus0o7b7.apps.googleusercontent.com';

    /// iOS Client ID that you registered with Google Cloud.
    const iosClientId =
        '320672119432-63knv9j9kan3e3og8c48vglfs6hi0fa9.apps.googleusercontent.com';

    // Google sign in on Android will work without providing the Android
    // Client ID registered on Google Cloud.

    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: webClientId,
    );
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }

    await Supabase.instance.client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
    Navigator.push(context, MaterialPageRoute(builder: (context) => Test()));
  }

  Container buildSignInSection() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          CustomTextField(
              hintText: 'Correo',
              prefixIcon: Icons.email,
              keyboardType: TextInputType.emailAddress),
          CustomTextField(
            hintText: 'Contraseña',
            prefixIcon: Icons.lock,
            isPassword: true,
            keyboardType: TextInputType.text,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Checkbox(
                  value: isRememberMe,
                  activeColor: Palette.textColor2,
                  onChanged: (value) {
                    setState(() {
                      isRememberMe = !isRememberMe;
                    });
                  }),
              Text(
                'Remember me',
                style: TextStyle(fontSize: 12, color: Palette.textColor1),
              ),
              TextButton(
                  onPressed: () {},
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(fontSize: 12, color: Palette.textColor1),
                  ))
            ],
          ),
        ],
      ),
    );
  }

  Container buildSingupSection() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(children: [
        CustomTextField(
          hintText: 'Nombre',
          prefixIcon: Icons.person,
          keyboardType: TextInputType.text,
        ),
        CustomTextField(
          hintText: 'Usuario',
          prefixIcon: Icons.supervised_user_circle_sharp,
          keyboardType: TextInputType.text,
        ),
        CustomTextField(
            hintText: 'Correo',
            prefixIcon: Icons.email,
            keyboardType: TextInputType.emailAddress),
        CustomTextField(
          hintText: 'Contraseña',
          prefixIcon: Icons.lock,
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
                          color:
                              isMale ? Palette.textColor2 : Colors.transparent,
                          border: Border.all(
                              width: 1,
                              color: isMale
                                  ? Colors.transparent
                                  : Palette.textColor1),
                          borderRadius: BorderRadius.circular(15)),
                      child: Icon(
                        Icons.person_2_outlined,
                        color: isMale ? Colors.white : Palette.iconColor,
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
                          color:
                              isMale ? Colors.transparent : Palette.textColor2,
                          border: Border.all(
                              width: 1,
                              color: isMale
                                  ? Palette.textColor1
                                  : Colors.transparent),
                          borderRadius: BorderRadius.circular(15)),
                      child: Icon(
                        Icons.person_2_outlined,
                        color: isMale ? Palette.iconColor : Colors.white,
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
                text: 'Presionando el botón de registro, aceptas nuestros ',
                style: TextStyle(color: Palette.textColor2),
                children: [
                  TextSpan(
                      text: 'términos y condiciones',
                      style: TextStyle(color: Colors.orange))
                ]),
          ),
        ),
      ]),
    );
  }
}
