// import 'dart:io';
import 'package:aimind/config/palette.dart';
import 'package:aimind/screens/dashboard/dashboard_screen.dart';
import 'package:aimind/services/auth_services.dart';
import 'package:aimind/widgets/animated_submit_button.dart';
import 'package:aimind/widgets/custom_text_field.dart';
// import 'package:aimind/widgets/login_button.dart';
// import 'package:aimind/widgets/login_button_with_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController userController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController singInemailController = TextEditingController();
  final TextEditingController singInpasswordController =
      TextEditingController();
  final TextEditingController confirmpasswordController =
      TextEditingController();
  String gender = '';

  final authservice = AuthService();

  bool isMale = true;
  bool isSignupScreen = true;
  bool isRememberMe = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    userController.dispose();
    emailController.dispose();
    passwordController.dispose();
    singInemailController.dispose();
    singInpasswordController.dispose();
    confirmpasswordController.dispose();
    super.dispose();
  }

  // Utilidad para obtener tamaños responsivos
  double getResponsiveSize(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.width * percentage;
  }

  double getResponsiveHeight(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.height * percentage;
  }

  // Función para determinar si estamos en un dispositivo pequeño
  bool isSmallDevice(BuildContext context) {
    return MediaQuery.of(context).size.height < 700;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = isSmallDevice(context);

    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      // Envolvemos todo en un SafeArea para manejar notches y áreas seguras
      body: SafeArea(
        child: Stack(
          children: [
            // Fondo
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Container(
                height: getResponsiveHeight(context, 0.25),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/background.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.only(
                    top: getResponsiveHeight(context, 0.03),
                    left: getResponsiveSize(context, 0.05),
                  ),
                  color: Color(0xFF3B5999).withValues(alpha: 0.85),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: "Bienvenid@",
                          style: TextStyle(
                            fontSize: isSmall ? 20 : 25,
                            letterSpacing: 2,
                            color: Colors.yellow[700],
                          ),
                          children: [
                            TextSpan(
                              text: isSignupScreen ? "A Aimind" : " De Vuelta",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.yellow[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        isSignupScreen
                            ? 'Registrate Para Continuar'
                            : "Incia Sesion Para Continuar",
                        style: TextStyle(
                          letterSpacing: 1,
                          color: Colors.white,
                          fontSize: isSmall ? 12 : 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Formulario principal
            AnimatedPositioned(
              duration: Duration(milliseconds: 700),
              curve: Curves.bounceInOut,
              top: getResponsiveHeight(
                context,
                isSignupScreen ? 0.11 : 0.22,
              ),
              left: 0,
              right: 0,
              child: Center(
                child: SingleChildScrollView(
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 700),
                    curve: Curves.bounceInOut,
                    width: size.width * 0.9,
                    constraints: BoxConstraints(
                      maxHeight: isSignupScreen
                          ? size.height * 0.65
                          : size.height * 0.4,
                    ),
                    padding: EdgeInsets.all(getResponsiveSize(context, 0.05)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .3),
                          blurRadius: 15,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
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
                                        fontSize:
                                            getResponsiveSize(context, 0.04),
                                        fontWeight: FontWeight.bold,
                                        color: !isSignupScreen
                                            ? Palette.activeColor
                                            : Palette.textColor1,
                                      ),
                                    ),
                                    if (!isSignupScreen)
                                      Container(
                                        height:
                                            getResponsiveHeight(context, 0.003),
                                        margin: EdgeInsets.only(
                                          top: getResponsiveHeight(
                                              context, 0.004),
                                        ),
                                        width: getResponsiveSize(context, 0.15),
                                        color: Colors.orange,
                                      ),
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
                                            getResponsiveSize(context, 0.04),
                                        fontWeight: FontWeight.bold,
                                        color: isSignupScreen
                                            ? Palette.activeColor
                                            : Palette.textColor1,
                                      ),
                                    ),
                                    if (isSignupScreen)
                                      Container(
                                        height:
                                            getResponsiveHeight(context, 0.003),
                                        margin: EdgeInsets.only(
                                          top: getResponsiveHeight(
                                              context, 0.004),
                                        ),
                                        width: getResponsiveSize(context, 0.15),
                                        color: Colors.orange,
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if (isSignupScreen) buildSingupSection(),
                          if (!isSignupScreen) buildSignInSection(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
                // Positioned(
                //   bottom: 0,
                //   left: 0,
                //   right: 0,
                //   child: Container(
                //     padding: isSignupScreen
                //         ? EdgeInsets.symmetric(vertical: 0.5)
                //         : EdgeInsets.symmetric(vertical: 10),
                //     child: Column(
                //       children: [
                //         Text(
                //           isSignupScreen
                //               ? "O inicia sesión con"
                //               : "O registrate con",
                //           style: TextStyle(fontSize: isSmall ? 16 : 18),
                //         ),
                //         SizedBox(height: isSmall ? 10 : 20),
                //         Column(
                //           children: [
                //             Row(
                //               mainAxisAlignment: MainAxisAlignment.center,
                //               children: [
                //                 LoginButton(
                //                   icon: Icons.facebook,
                //                   text: "Facebook",
                //                   backgroundColor: Color.fromARGB(255, 31, 33, 37),
                //                   iconColor: Colors.white,
                //                   textColor: Colors.white,
                //                   voidCallback: () {
                //                     signInWithFacebook();
                //                   },
                //                 ),
                //                 SizedBox(width: 10),
                //                 LoginButtonWithImage(
                //                   imagePath: 'assets/images/google_logo.png',
                //                   text: "Google",
                //                   backgroundColor: Colors.white,
                //                   textColor: Colors.black87,
                //                   voidCallback: () async {
                //                     if (!kIsWeb &&
                //                         (Platform.isAndroid || Platform.isIOS)) {
                //                       await signInWithGoogle(context);
                //                     } else {
                //                       Supabase.instance.client.auth
                //                           .signInWithOAuth(OAuthProvider.google);
                //                     }
                //                   },
                //                 ),
                //               ],
                //             ),
                //             SizedBox(height: 10),
                //             Row(
                //               mainAxisAlignment: MainAxisAlignment.center,
                //               children: [
                //                 LoginButtonWithImage(
                //                   imagePath: 'assets/images/x_logo.png',
                //                   text: "",
                //                   backgroundColor: Colors.black,
                //                   voidCallback: () {
                //                     signInWithTwitter();
                //                   },
                //                 ),
                //               ],
                //             ),
                //           ],
                //         ),
                //       ],
                //     ),
                //   ),
                // )
          ],
        ),
      ),
    );
  }

  Future<void> signInWithGoogle(BuildContext context) async {
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
  }

  Future<void> signInWithFacebook() async {
    try {
      await Supabase.instance.client.auth.signInWithOAuth(
        OAuthProvider.facebook,
        redirectTo: kIsWeb ? null : 'com.aimind.app://login-callback/',
        authScreenLaunchMode: LaunchMode.externalApplication,
      );
    } catch (e) {
      debugPrint('Error during Facebook sign in: $e');
    }
  }

  Future<void> signInWithTwitter() async {
    await Supabase.instance.client.auth.signInWithOAuth(
      OAuthProvider.twitter,
      redirectTo: kIsWeb ? null : 'my.scheme://my-host',
      authScreenLaunchMode:
          kIsWeb ? LaunchMode.platformDefault : LaunchMode.externalApplication,
    );
  }

  Widget buildSignInSection() {
    final isSmall = isSmallDevice(context);

    return Container(
      margin: EdgeInsets.only(top: isSmall ? 10 : 20),
      child: Column(children: [
        CustomTextField(
          hintText: 'Correo',
          prefixIcon: Icons.email,
          keyboardType: TextInputType.emailAddress,
          maxLegth: 255,
          controller: singInemailController,
        ),
        CustomTextField(
          hintText: 'Contraseña',
          prefixIcon: Icons.lock,
          isPassword: true,
          keyboardType: TextInputType.text,
          maxLegth: 100,
          controller: singInpasswordController,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () {},
                child: Text(
                  '¿Olvidaste tu contraseña?',
                  style: TextStyle(
                      fontSize: isSmall ? 14 : 16, color: Palette.textColor1),
                ))
          ],
        ),
        AnimatedSubmitButton(
          isLoading: isLoading,
          onPressed: login,
          buttonText: 'Iniciar Sesión',
          buttonColor: Colors.blue,
          width: getResponsiveSize(context, 0.6),
          height: getResponsiveHeight(context, 0.06),
          loadingColor: Colors.amber,
        )
      ]),
    );
  }

  Widget buildSingupSection() {
    final isSmall = isSmallDevice(context);

    return Container(
      margin: EdgeInsets.only(top: isSmall ? 10 : 20),
      child: Column(children: [
        CustomTextField(
          hintText: 'Nombre',
          prefixIcon: Icons.person,
          controller: nameController,
          keyboardType: TextInputType.text,
          maxLegth: 100,
        ),
        CustomTextField(
          hintText: 'Usuario',
          prefixIcon: Icons.supervised_user_circle_sharp,
          controller: userController,
          keyboardType: TextInputType.text,
          maxLegth: 50,
        ),
        CustomTextField(
          hintText: 'Correo',
          prefixIcon: Icons.email,
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          maxLegth: 255,
        ),
        CustomTextField(
          hintText: 'Contraseña',
          prefixIcon: Icons.lock,
          controller: passwordController,
          isPassword: true,
          keyboardType: TextInputType.text,
          maxLegth: 100,
        ),
        CustomTextField(
          hintText: 'Confirma Contraseña',
          prefixIcon: Icons.lock,
          controller: confirmpasswordController,
          isPassword: true,
          keyboardType: TextInputType.text,
          maxLegth: 100,
        ),
        Padding(
          padding:
              EdgeInsets.only(top: isSmall ? 5 : 10, left: isSmall ? 5 : 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isMale = true;
                    gender = "Male";
                  });
                },
                child: Row(
                  children: [
                    Container(
                      width: isSmall ? 25 : 30,
                      height: isSmall ? 25 : 30,
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
                        size: isSmall ? 16 : 20,
                      ),
                    ),
                    Text(
                      "Hombre",
                      style: TextStyle(
                        color: Palette.textColor1,
                        fontSize: isSmall ? 12 : 14,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(width: isSmall ? 20 : 29),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isMale = false;
                    gender = "Female";
                  });
                },
                child: Row(
                  children: [
                    Container(
                      width: isSmall ? 25 : 30,
                      height: isSmall ? 25 : 30,
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
                        size: isSmall ? 16 : 20,
                      ),
                    ),
                    Text(
                      "Mujer",
                      style: TextStyle(
                        color: Palette.textColor1,
                        fontSize: isSmall ? 12 : 14,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        Container(
          width: getResponsiveSize(context, 0.6),
          margin: EdgeInsets.only(top: isSmall ? 10 : 20),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: 'Presionando el botón de registro, aceptas nuestros ',
                style: TextStyle(
                  color: Palette.textColor2,
                  fontSize: isSmall ? 10 : 12,
                ),
                children: [
                  TextSpan(
                    text: 'términos y condiciones',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: isSmall ? 10 : 12,
                    ),
                  )
                ]),
          ),
        ),
        SizedBox(height: isSmall ? 5 : 10),
        AnimatedSubmitButton(
          isLoading: isLoading,
          onPressed: signUp,
          buttonText: 'Registrarse',
          buttonColor: Colors.blue,
          width: getResponsiveSize(context, 0.6),
          height: getResponsiveHeight(context, 0.06),
          loadingColor: Colors.amber,
        )
      ]),
    );
  }

  void signUp() async {
    final name = nameController.text.trim();
    final user = userController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmpasswordController.text.trim();

    if (name.isEmpty ||
        user.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
        text: 'Por favor, complete todos los campos.',
      );
      return;
    }

    if (password.length < 6 || confirmPassword.length < 6) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
        text: 'La contraseña debe tener al menos 6 caracteres.',
      );
      return;
    }

    if (password != confirmPassword) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
        text: 'Las contraseñas no coinciden.',
      );
      return;
    }

    if (!isValidEmail(email)) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
        text: 'Por favor, ingrese un correo electrónico válido.',
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );

      final userId = response.user?.id;
      if (userId != null) {
        await Supabase.instance.client.from('profiles').insert({
          'id': userId,
          'nombre': name,
          'usuario': user,
          'correo': email,
        });
      }

      setState(() {
        isLoading = false;
      });

      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: 'Éxito',
        text: 'Registro completado. Por favor verifica tu correo.',
      );
    } on AuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
        text: 'Error al registrar: ${e.message}',
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });

      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
        text: 'Error inesperado: $e',
      );
    }
  }

  void login() async {
    final email = singInemailController.text.trim();
    final password = singInpasswordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
        text: 'Por favor, complete todos los campos.',
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    // Mostrar el QuickAlert de carga
    QuickAlert.show(
      context: context,
      type: QuickAlertType.loading,
      title: 'Cargando',
      text: 'Iniciando sesión',
      barrierDismissible: false, // Prevents dismiss on tap outside
    );

    try {
      await authservice.signInWithEmailPassword(email, password);

      // Cerrar el QuickAlert de carga
      Navigator.of(context).pop();

      setState(() {
        isLoading = false;
      });

      // Navegar a DashboardScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );

      // Mostrar el QuickAlert de éxito después de la navegación
      QuickAlert.show(
        context: context,
        title: 'Exito',
        type: QuickAlertType.success,
        text: 'Sesión iniciada con éxito!',
        barrierDismissible: false,
      );
    } on AuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();
      if (e.statusCode == '400') {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Error',
          text: 'Correo o contraseña incorrectos.',
        );
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Error',
          text: 'Error al iniciar sesión: ${e.message}',
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop(); // Cerrar el QuickAlert de carga
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
        text: 'Error al iniciar sesión: $e',
      );
    }
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
}
