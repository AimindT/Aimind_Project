import 'package:aimind/theme/theme_provider.dart';
import 'package:aimind/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditAccountScreen2 extends StatefulWidget {
  final bool isDarkMode;
  const EditAccountScreen2({super.key, required this.isDarkMode});

  @override
  State<EditAccountScreen2> createState() => _EditAccountScreen2State();
}

class _EditAccountScreen2State extends State<EditAccountScreen2> {
  final String url =
      'https://static.wikia.nocookie.net/mokeys-show/images/4/43/Screenshot_2025-01-10_212625.png/revision/latest?cb=20250112022914';

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeData.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text(
          'Editar Perfil',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              SizedBox(height: 50),
              Center(
                child: Stack(
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.black,
                            width: 3.0,
                          ),
                        ),
                        child: ClipOval(
                          child: Container(
                            color: Colors.white,
                            child: Image.network(
                              url,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.black,
                        ),
                        child: Icon(Icons.camera_alt_outlined,
                            color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 50),
                child: Column(
                  children: [
                    SizedBox(
                      height: 90,
                      width: 350,
                      child: CustomTextField(
                        hintText: 'Nombre',
                        prefixIcon: Icons.person,
                        keyboardType: TextInputType.text,
                        maxLegth: 100,
                      ),
                    ),
                    SizedBox(
                      height: 90,
                      width: 350,
                      child: CustomTextField(
                        hintText: 'Usuario',
                        prefixIcon: Icons.supervised_user_circle_sharp,
                        keyboardType: TextInputType.text,
                        maxLegth: 50,
                      ),
                    ),
                    SizedBox(
                      height: 90,
                      width: 350,
                      child: CustomTextField(
                        hintText: 'Correo',
                        prefixIcon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        maxLegth: 255,
                      ),
                    ),
                    SizedBox(
                      height: 100,
                      width: 350,
                      child: CustomTextField(
                        hintText: 'Contraseña',
                        prefixIcon: Icons.lock,
                        isPassword: true,
                        keyboardType: TextInputType.text,
                        maxLegth: 100,
                      ),
                    ),
                    SizedBox(height: 50),
                    SizedBox(
                      width: 350,
                      height: 70,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text('Guardar Cambios',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          side: BorderSide.none,
                          shape: StadiumBorder(),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
